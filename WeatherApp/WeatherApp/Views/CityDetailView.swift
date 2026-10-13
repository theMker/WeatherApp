import SwiftUI

struct CityDetailView: View {
    let city: City
    @StateObject private var viewModel: CityDetailViewModel

    init(city: City) {
        self.city = city
        _viewModel = StateObject(wrappedValue: CityDetailViewModel(city: city))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let weather = viewModel.weather {
                    CurrentConditionsView(weather: weather)
                    forecastSection(for: weather)
                } else if viewModel.isLoading {
                    ProgressView("Loading forecast\u{2026}")
                        .padding(.top, 80)
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorStateView(message: errorMessage) {
                        Task { await viewModel.load() }
                    }
                    .padding(.top, 80)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                SaveToggleButton(city: city)
            }
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
    }

    private func forecastSection(for weather: CityWeather) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("14-Day Forecast")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(Array(weather.dailyForecasts.enumerated()), id: \.element.id) { index, day in
                    DailyForecastRow(day: day, isToday: index == 0, timezoneIdentifier: weather.timezoneIdentifier)
                    if day.id != weather.dailyForecasts.last?.id {
                        Divider().padding(.leading)
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }
}

private struct SaveToggleButton: View {
    let city: City
    @EnvironmentObject private var cityStore: CityStore

    var body: some View {
        Button {
            if cityStore.isSaved(city) {
                cityStore.remove(city)
            } else {
                cityStore.add(city)
            }
        } label: {
            Image(systemName: cityStore.isSaved(city) ? "star.fill" : "star")
        }
        .accessibilityLabel(cityStore.isSaved(city) ? "Remove from Saved Cities" : "Add to Saved Cities")
    }
}
