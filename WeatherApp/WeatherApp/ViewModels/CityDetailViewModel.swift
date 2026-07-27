import Foundation

@MainActor
final class CityDetailViewModel: ObservableObject {
    @Published private(set) var weather: CityWeather?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let city: City
    private let weatherService: WeatherService

    init(city: City, weatherService: WeatherService = WeatherService()) {
        self.city = city
        self.weatherService = weatherService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            weather = try await weatherService.fetchWeather(latitude: city.latitude, longitude: city.longitude)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
