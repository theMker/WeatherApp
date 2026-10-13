import Foundation

/// Drives the small weather summary (icon + temperature) shown in a saved-city list row.
@MainActor
final class CityRowViewModel: ObservableObject {
    @Published private(set) var current: CurrentConditions?
    @Published private(set) var isLoading = false

    private let weatherService: WeatherService

    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }

    func load(city: City) async {
        isLoading = true
        do {
            let weather = try await weatherService.fetchWeather(latitude: city.latitude, longitude: city.longitude)
            current = weather.current
        } catch {
            current = nil
        }
        isLoading = false
    }
}
