import XCTest
@testable import WeatherApp

@MainActor
final class CityStoreTests: XCTestCase {
    private var defaults: UserDefaults!
    private var suiteName: String!

    override func setUp() {
        super.setUp()
        suiteName = "CityStoreTests-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    private func makeCity(id: Int = 1, name: String = "Testville") -> City {
        City(
            id: id,
            name: name,
            country: "Testland",
            admin1: nil,
            latitude: 1.0,
            longitude: 2.0,
            timezoneIdentifier: "UTC"
        )
    }

    func testAddCityPersistsAcrossInstances() {
        let store = CityStore(defaults: defaults)
        store.add(makeCity())

        let reloaded = CityStore(defaults: defaults)
        XCTAssertEqual(reloaded.savedCities.count, 1)
        XCTAssertEqual(reloaded.savedCities.first?.name, "Testville")
    }

    func testAddingSameCityTwiceDoesNotDuplicate() {
        let store = CityStore(defaults: defaults)
        store.add(makeCity())
        store.add(makeCity())
        XCTAssertEqual(store.savedCities.count, 1)
    }

    func testRemoveCity() {
        let store = CityStore(defaults: defaults)
        let city = makeCity()
        store.add(city)
        store.remove(city)
        XCTAssertTrue(store.savedCities.isEmpty)
    }

    func testIsSavedReflectsCurrentState() {
        let store = CityStore(defaults: defaults)
        let city = makeCity()
        XCTAssertFalse(store.isSaved(city))
        store.add(city)
        XCTAssertTrue(store.isSaved(city))
    }
}
