import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var cityStore: CityStore
    @State private var isShowingSearch = false

    var body: some View {
        NavigationStack {
            Group {
                if cityStore.savedCities.isEmpty {
                    EmptyStateView(isShowingSearch: $isShowingSearch)
                } else {
                    List {
                        ForEach(cityStore.savedCities) { city in
                            NavigationLink(value: city) {
                                CityRowView(city: city)
                            }
                        }
                        .onDelete(perform: cityStore.remove)
                        .onMove(perform: cityStore.move)
                    }
                }
            }
            .navigationTitle("Weather")
            .navigationDestination(for: City.self) { city in
                CityDetailView(city: city)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !cityStore.savedCities.isEmpty {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .accessibilityLabel("Search for a city")
                }
            }
            .sheet(isPresented: $isShowingSearch) {
                SearchView()
                    .environmentObject(cityStore)
            }
        }
    }
}
