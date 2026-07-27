import Foundation

/// Current-day conditions for a city, in Celsius (converted for display as needed).
struct CurrentConditions {
    let date: Date
    let temperatureC: Double
    let apparentTemperatureC: Double
    let humidity: Int
    let weatherCode: Int
    let windSpeedKmh: Double
    let isDay: Bool
}

/// One day of the 14-day outlook.
struct DailyForecast: Identifiable {
    let id: String
    let date: Date
    let weatherCode: Int
    let minTemperatureC: Double
    let maxTemperatureC: Double
    let precipitationProbability: Int?
    let sunrise: Date
    let sunset: Date
    let maxWindSpeedKmh: Double
}

/// Full forecast payload for a city: today's detail plus the 14-day outlook.
struct CityWeather {
    let timezoneIdentifier: String
    let current: CurrentConditions
    let dailyForecasts: [DailyForecast]
}

extension CityWeather {
    /// Maps the raw API response into the domain model used by the views.
    init(response: WeatherResponse) {
        self.timezoneIdentifier = response.timezone
        let dateTimeFormatter = DateFormatting.dateTimeFormatter(timeZoneIdentifier: response.timezone)

        let current = response.current
        self.current = CurrentConditions(
            date: dateTimeFormatter.date(from: current.time) ?? Date(),
            temperatureC: current.temperature2m,
            apparentTemperatureC: current.apparentTemperature,
            humidity: current.relativeHumidity2m,
            weatherCode: current.weatherCode,
            windSpeedKmh: current.windSpeed10m,
            isDay: current.isDay == 1
        )

        // Every field below is indexed against `daily.time`, but each comes from its own JSON
        // array, so a malformed or partial API response could make them different lengths.
        // Fall back to a safe default per-field rather than trapping on an out-of-range index.
        let daily = response.daily
        self.dailyForecasts = daily.time.indices.map { index in
            let dayStart = dateTimeFormatter.date(from: daily.time[index] + "T00:00") ?? Date()
            return DailyForecast(
                id: daily.time[index],
                date: dayStart,
                weatherCode: daily.weatherCode[safe: index] ?? 0,
                minTemperatureC: daily.temperature2mMin[safe: index] ?? 0,
                maxTemperatureC: daily.temperature2mMax[safe: index] ?? 0,
                precipitationProbability: daily.precipitationProbabilityMax?[safe: index],
                sunrise: daily.sunrise[safe: index].flatMap { dateTimeFormatter.date(from: $0) } ?? dayStart,
                sunset: daily.sunset[safe: index].flatMap { dateTimeFormatter.date(from: $0) } ?? dayStart,
                maxWindSpeedKmh: daily.windSpeed10mMax[safe: index] ?? 0
            )
        }
    }
}
