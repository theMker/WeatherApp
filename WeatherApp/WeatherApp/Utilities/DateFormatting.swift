import Foundation

/// Open-Meteo returns timestamps local to the city's own timezone (no UTC offset), so every
/// formatter here is anchored to that city's timezone rather than the device's.
enum DateFormatting {
    static func dateTimeFormatter(timeZoneIdentifier: String?) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? "UTC") ?? .gmt
        return formatter
    }

    static func weekdayLabel(for date: Date, timeZoneIdentifier: String, isToday: Bool) -> String {
        if isToday {
            return "Today"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .gmt
        return formatter.string(from: date)
    }

    static func timeLabel(for date: Date, timeZoneIdentifier: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .gmt
        return formatter.string(from: date)
    }
}
