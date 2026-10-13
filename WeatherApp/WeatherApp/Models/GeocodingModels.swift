import Foundation

/// Response envelope from the Open-Meteo geocoding search API.
struct GeocodingResponse: Decodable {
    let results: [GeocodingResult]?
}

/// A single city match returned while searching for a place name.
struct GeocodingResult: Decodable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let countryCode: String?
    let admin1: String?
    let timezone: String?

    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, country, admin1, timezone
        case countryCode = "country_code"
    }

    var subtitle: String {
        [admin1, country].compactMap { $0 }.joined(separator: ", ")
    }
}
