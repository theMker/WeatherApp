import Foundation

/// Persists the user's saved list of cities to UserDefaults as JSON.
@MainActor
final class CityStore: ObservableObject {
    @Published private(set) var savedCities: [City] = []

    private let defaults: UserDefaults
    private let storageKey = "savedCities"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func isSaved(_ city: City) -> Bool {
        savedCities.contains { $0.id == city.id }
    }

    func add(_ city: City) {
        guard !isSaved(city) else { return }
        savedCities.append(city)
        persist()
    }

    func remove(_ city: City) {
        savedCities.removeAll { $0.id == city.id }
        persist()
    }

    func remove(at offsets: IndexSet) {
        savedCities.remove(atOffsets: offsets)
        persist()
    }

    func move(from source: IndexSet, to destination: Int) {
        savedCities.move(fromOffsets: source, toOffset: destination)
        persist()
    }

    private func load() {
        guard let data = defaults.data(forKey: storageKey) else { return }
        savedCities = (try? JSONDecoder().decode([City].self, from: data)) ?? []
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(savedCities) else { return }
        defaults.set(data, forKey: storageKey)
    }
}
