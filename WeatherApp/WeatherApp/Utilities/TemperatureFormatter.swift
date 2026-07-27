import Foundation

enum TemperatureUnit: String {
    case celsius
    case fahrenheit

    var symbol: String {
        self == .celsius ? "\u{00B0}C" : "\u{00B0}F"
    }
}

/// Formats Celsius values (as returned by the weather API) for display in both units.
enum TemperatureFormatter {
    static func celsiusToFahrenheit(_ celsius: Double) -> Double {
        celsius * 9 / 5 + 32
    }

    static func value(_ celsius: Double, in unit: TemperatureUnit) -> Double {
        unit == .celsius ? celsius : celsiusToFahrenheit(celsius)
    }

    static func label(_ celsius: Double, in unit: TemperatureUnit) -> String {
        "\(Int(value(celsius, in: unit).rounded()))\(unit.symbol)"
    }

    /// e.g. "20°C / 68°F"
    static func dualLabel(_ celsius: Double) -> String {
        "\(label(celsius, in: .celsius)) / \(label(celsius, in: .fahrenheit))"
    }

    /// A low-high range formatted separately for each unit, e.g. ("10°–20°C", "50°–68°F").
    static func dualRangeLabel(minCelsius: Double, maxCelsius: Double) -> (celsius: String, fahrenheit: String) {
        let minF = celsiusToFahrenheit(minCelsius)
        let maxF = celsiusToFahrenheit(maxCelsius)
        let celsiusLabel = "\(Int(minCelsius.rounded()))\u{00B0}\u{2013}\(Int(maxCelsius.rounded()))\u{00B0}C"
        let fahrenheitLabel = "\(Int(minF.rounded()))\u{00B0}\u{2013}\(Int(maxF.rounded()))\u{00B0}F"
        return (celsiusLabel, fahrenheitLabel)
    }
}
