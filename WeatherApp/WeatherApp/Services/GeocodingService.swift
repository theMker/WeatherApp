import Foundation

enum GeocodingServiceError: Error, LocalizedError {
    case invalidURL
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Could not build the search request."
        case .invalidResponse:
            return "The search service returned an unexpected response."
        }
    }
}

/// Looks up cities by name using the free Open-Meteo geocoding API.
struct GeocodingService {
    private let baseURL = "https://geocoding-api.open-meteo.com/v1/search"

    func search(query: String) async throws -> [GeocodingResult] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "name", value: query),
            URLQueryItem(name: "count", value: "15"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components?.url else {
            throw GeocodingServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GeocodingServiceError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(GeocodingResponse.self, from: data)
        return decoded.results ?? []
    }
}
