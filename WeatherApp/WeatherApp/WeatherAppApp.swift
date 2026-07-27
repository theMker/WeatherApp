import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var cityStore = CityStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cityStore)
        }
    }
}
