import XCTest
@testable import WeatherApp

final class WeatherCodeTests: XCTestCase {
    func testClearSkySymbolDiffersByDayNight() {
        XCTAssertEqual(WeatherCode.symbolName(code: 0, isDay: true), "sun.max.fill")
        XCTAssertEqual(WeatherCode.symbolName(code: 0, isDay: false), "moon.stars.fill")
    }

    func testThunderstormSymbol() {
        XCTAssertEqual(WeatherCode.symbolName(code: 95, isDay: true), "cloud.bolt.rain.fill")
    }

    func testDescriptionForRain() {
        XCTAssertEqual(WeatherCode.description(code: 61), "Rain")
    }

    func testUnknownCodeFallsBackGracefully() {
        XCTAssertEqual(WeatherCode.description(code: 999), "Unknown")
        XCTAssertEqual(WeatherCode.symbolName(code: 999, isDay: true), "cloud.fill")
    }
}
