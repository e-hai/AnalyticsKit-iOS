import SwiftUI
import Analytics
// When Firebase is integrated into the host project:
// import FirebaseCore
// import AnalyticsFirebase

@main
struct SampleApp: App {
    init() {
        // Optional Firebase Setup:
        // FirebaseApp.configure()

        Analytics.initialize(
            config: AnalyticsConfig(
                providers: [
                    LoggingAnalyticsProvider(name: "console_log"),
                    // FirebaseAnalyticsProvider() // Enable when Firebase is configured
                ],
                enabled: true,
                debug: true
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
