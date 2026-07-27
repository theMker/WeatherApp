import Foundation

/// A city the user has saved to their list, or is currently previewing from search.
struct City: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let name: String
    let country: String?
    let admin1: String?
    let latitude: Double
    let longitude: Double
    let timezoneIdentifier: String?

    init(
        id: Int,
        name: String,
        country: String?,
        admin1: String?,
        latitude: Double,
        longitude: Double,
        timezoneIdentifier: String?
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.admin1 = admin1
        self.latitude = latitude
        self.longitude = longitude
        self.timezoneIdentifier = timezoneIdentifier
    }

    init(geocodingResult: GeocodingResult) {
        self.init(
            id: geocodingResult.id,
            name: geocodingResult.name,
            country: geocodingResult.country,
            admin1: geocodingResult.admin1,
            latitude: geocodingResult.latitude,
            longitude: geocodingResult.longitude,
            timezoneIdentifier: geocodingResult.timezone
        )
    }

    var subtitle: String {
        [admin1, country].compactMap { $0 }.joined(separator: ", ")
    }
}
