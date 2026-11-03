import Foundation

/// Adapter contract for concrete analytics SDKs (Firebase, AppsFlyer, etc.).
///
/// Implementations must be thread-safe as methods may be called from any thread.
public protocol AnalyticsProvider: AnyObject, Sendable {
    /// Stable identifier used in debug logs, e.g. `"firebase"`, `"logging"`.
    var name: String { get }

    /// One-time setup called during `Analytics.initialize(config:)`.
    func initialize()

    /// Log a business event with strongly-typed parameters.
    func logEvent(_ event: AnalyticsEvent)

    /// Associate user identity with subsequent events.
    func setUserId(_ userId: String?)

    /// Set a user-level attribute/property.
    func setUserProperty(name: String, value: String?)

    /// Toggle data collection dynamically (e.g. for GDPR / ATT consent).
    func setAnalyticsCollectionEnabled(_ enabled: Bool)

    /// Reset identity and cached properties (e.g. on user logout).
    func resetAnalyticsData()
}

public extension AnalyticsProvider {
    func resetAnalyticsData() {
        // Default no-op
    }
}
