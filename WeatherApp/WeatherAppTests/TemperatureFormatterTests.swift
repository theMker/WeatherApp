import XCTest
@testable import WeatherApp

final class TemperatureFormatterTests: XCTestCase {
    func testCelsiusToFahrenheitFreezing() {
        XCTAssertEqual(TemperatureFormatter.celsiusToFahrenheit(0), 32, accuracy: 0.001)
    }

    func testCelsiusToFahrenheitBoiling() {
        XCTAssertEqual(TemperatureFormatter.celsiusToFahrenheit(100), 212, accuracy: 0.001)
    }

    func testDualLabelFormatsBothUnits() {
        XCTAssertEqual(TemperatureFormatter.dualLabel(20), "20\u{00B0}C / 68\u{00B0}F")
    }

    func testDualRangeLabelFormatsBothUnits() {
        let range = TemperatureFormatter.dualRangeLabel(minCelsius: 10, maxCelsius: 20)
        XCTAssertEqual(range.celsius, "10\u{00B0}\u{2013}20\u{00B0}C")
        XCTAssertEqual(range.fahrenheit, "50\u{00B0}\u{2013}68\u{00B0}F")
    }
}
