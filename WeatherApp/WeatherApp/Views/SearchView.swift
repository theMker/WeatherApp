import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var cityStore: CityStore
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    MessageView(systemImage: "magnifyingglass", message: "Search for a city to see its forecast.")
                } else if viewModel.isSearching {
                    ProgressView("Searching\u{2026}")
                        .padding(.top, 60)
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorStateView(message: errorMessage) {}
                        .padding(.top, 60)
                } else if viewModel.results.isEmpty {
                    MessageView(systemImage: "questionmark.circle", message: "No matching cities found.")
                } else {
                    List(viewModel.results) { result in
                        NavigationLink(value: result) {
                            SearchResultRow(result: result, isSaved: cityStore.isSaved(City(geocodingResult: result)))
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: GeocodingResult.self) { result in
                CityDetailView(city: City(geocodingResult: result))
            }
            .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "City name")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private struct MessageView: View {
    let systemImage: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 80)
    }
}
