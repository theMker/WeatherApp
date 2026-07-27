import Foundation

/// Raw response shape from the Open-Meteo forecast API.
struct WeatherResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentWeatherDTO
    let daily: DailyWeatherDTO
}

struct CurrentWeatherDTO: Decodable {
    let time: String
    let temperature2m: Double
    let apparentTemperature: Double
    let relativeHumidity2m: Int
    let weatherCode: Int
    let windSpeed10m: Double
    let isDay: Int

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case relativeHumidity2m = "relative_humidity_2m"
        case weatherCode = "weather_code"
        case windSpeed10m = "wind_speed_10m"
        case isDay = "is_day"
    }
}

struct DailyWeatherDTO: Decodable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let precipitationProbabilityMax: [Int]?
    let sunrise: [String]
    let sunset: [String]
    let windSpeed10mMax: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case sunrise
        case sunset
        case windSpeed10mMax = "wind_speed_10m_max"
    }
}
