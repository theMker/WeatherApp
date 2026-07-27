import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = "" {
        didSet { scheduleSearch() }
    }

    @Published private(set) var results: [GeocodingResult] = []
    @Published private(set) var isSearching = false
    @Published private(set) var errorMessage: String?

    private let geocodingService: GeocodingService
    private var searchTask: Task<Void, Never>?

    init(geocodingService: GeocodingService = GeocodingService()) {
        self.geocodingService = geocodingService
    }

    private func scheduleSearch() {
        searchTask?.cancel()

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            results = []
            isSearching = false
            errorMessage = nil
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            await performSearch(for: trimmedQuery)
        }
    }

    private func performSearch(for query: String) async {
        isSearching = true
        errorMessage = nil
        do {
            let searchResults = try await geocodingService.search(query: query)
            guard !Task.isCancelled else { return }
            results = searchResults
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
            results = []
        }
        isSearching = false
    }
}
