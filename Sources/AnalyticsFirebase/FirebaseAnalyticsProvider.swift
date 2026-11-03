import Foundation
import Analytics
import FirebaseAnalytics

/// `AnalyticsProvider` adapter backed by Google `FirebaseAnalytics`.
///
/// Ensure `FirebaseApp.configure()` is executed in your App lifecycle (e.g. `AppDelegate` or
/// SwiftUI `App.init()`) before or during initialization.
///
/// Usage:
/// ```swift
/// import Analytics
/// import AnalyticsFirebase
///
/// Analytics.initialize(config: AnalyticsConfig(
///     providers: [FirebaseAnalyticsProvider()]
/// ))
/// ```
public final class FirebaseAnalyticsProvider: AnalyticsProvider, @unchecked Sendable {
    public let name: String = "firebase"

    public init() {}

    public func initialize() {
        // Firebase is typically configured via FirebaseApp.configure().
        // No additional configuration needed if FirebaseApp was initialized.
    }

    public func logEvent(_ event: AnalyticsEvent) {
        let params = event.params.toFirebaseParameters()
        FirebaseAnalytics.Analytics.logEvent(
            event.name,
            parameters: params.isEmpty ? nil : params
        )
    }

    public func setUserId(_ userId: String?) {
        FirebaseAnalytics.Analytics.setUserID(userId)
    }

    public func setUserProperty(name: String, value: String?) {
        FirebaseAnalytics.Analytics.setUserProperty(value, forName: name)
    }

    public func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        FirebaseAnalytics.Analytics.setAnalyticsCollectionEnabled(enabled)
    }

    public func resetAnalyticsData() {
        FirebaseAnalytics.Analytics.resetAnalyticsData()
    }
}
