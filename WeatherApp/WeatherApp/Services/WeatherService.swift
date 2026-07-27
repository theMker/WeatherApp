import Foundation

enum WeatherServiceError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Could not build the weather request."
        case .invalidResponse:
            return "The weather service returned an unexpected response."
        case .decodingFailed:
            return "Could not read the weather data."
        }
    }
}

/// Fetches today's conditions plus a 14-day outlook from the free Open-Meteo forecast API.
struct WeatherService {
    private let baseURL = "https://api.open-meteo.com/v1/forecast"

    func fetchWeather(latitude: Double, longitude: Double) async throws -> CityWeather {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(
                name: "current",
                value: "temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m,is_day"
            ),
            URLQueryItem(
                name: "daily",
                value: "weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,sunrise,sunset,wind_speed_10m_max"
            ),
            URLQueryItem(name: "temperature_unit", value: "celsius"),
            URLQueryItem(name: "wind_speed_unit", value: "kmh"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "14")
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherServiceError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return CityWeather(response: decoded)
        } catch {
            throw WeatherServiceError.decodingFailed
        }
    }
}
