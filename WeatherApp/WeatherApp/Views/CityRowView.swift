import SwiftUI

struct CityRowView: View {
    let city: City
    @StateObject private var viewModel = CityRowViewModel()

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                if !city.subtitle.isEmpty {
                    Text(city.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if let current = viewModel.current {
                HStack(spacing: 8) {
                    Image(systemName: WeatherCode.symbolName(code: current.weatherCode, isDay: current.isDay))
                        .foregroundStyle(.orange)
                    Text(TemperatureFormatter.dualLabel(current.temperatureC))
                        .font(.subheadline)
                        .monospacedDigit()
                }
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.load(city: city)
        }
    }
}
