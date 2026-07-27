import SwiftUI

struct DailyForecastRow: View {
    let day: DailyForecast
    let isToday: Bool
    let timezoneIdentifier: String

    private var range: (celsius: String, fahrenheit: String) {
        TemperatureFormatter.dualRangeLabel(minCelsius: day.minTemperatureC, maxCelsius: day.maxTemperatureC)
    }

    var body: some View {
        HStack {
            Text(DateFormatting.weekdayLabel(for: day.date, timeZoneIdentifier: timezoneIdentifier, isToday: isToday))
                .frame(width: 64, alignment: .leading)
                .fontWeight(isToday ? .semibold : .regular)

            Image(systemName: WeatherCode.symbolName(code: day.weatherCode, isDay: true))
                .foregroundStyle(.orange)
                .frame(width: 28)

            if let precipitation = day.precipitationProbability, precipitation > 0 {
                Text("\(precipitation)%")
                    .font(.caption)
                    .foregroundStyle(.blue)
                    .frame(width: 40, alignment: .leading)
            } else {
                Spacer().frame(width: 40)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(range.celsius)
                    .font(.subheadline)
                    .monospacedDigit()
                Text(range.fahrenheit)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
