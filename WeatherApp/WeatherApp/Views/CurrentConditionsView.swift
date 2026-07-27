import SwiftUI

struct CurrentConditionsView: View {
    let weather: CityWeather

    private var current: CurrentConditions { weather.current }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: WeatherCode.symbolName(code: current.weatherCode, isDay: current.isDay))
                .font(.system(size: 56))
                .foregroundStyle(.orange)
                .symbolRenderingMode(.multicolor)

            Text(WeatherCode.description(code: current.weatherCode))
                .font(.title3)
                .foregroundStyle(.secondary)

            Text(TemperatureFormatter.dualLabel(current.temperatureC))
                .font(.system(size: 36, weight: .semibold))
                .monospacedDigit()

            Text("Feels like \(TemperatureFormatter.dualLabel(current.apparentTemperatureC))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 32) {
                DetailStat(label: "Humidity", value: "\(current.humidity)%", icon: "humidity.fill")
                DetailStat(label: "Wind", value: "\(Int(current.windSpeedKmh.rounded())) km/h", icon: "wind")
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

private struct DetailStat: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
