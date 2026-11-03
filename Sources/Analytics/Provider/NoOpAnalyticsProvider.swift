import Foundation

/// Safe fallback provider that performs no operations.
public final class NoOpAnalyticsProvider: AnalyticsProvider, @unchecked Sendable {
    public static let shared = NoOpAnalyticsProvider()

    public let name: String = "noop"

    private init() {}

    public func initialize() {}
    public func logEvent(_ event: AnalyticsEvent) {}
    public func setUserId(_ userId: String?) {}
    public func setUserProperty(name: String, value: String?) {}
    public func setAnalyticsCollectionEnabled(_ enabled: Bool) {}
    public func resetAnalyticsData() {}
}
