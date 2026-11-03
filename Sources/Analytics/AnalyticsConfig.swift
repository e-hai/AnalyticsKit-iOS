import Foundation

/// Configuration passed once to `Analytics.initialize(config:)`.
public struct AnalyticsConfig: Sendable {
    /// Concrete SDK adapters (Firebase, Logging, etc.). Empty list acts as no-op.
    public var providers: [AnalyticsProvider]

    /// Master collection switch. When false, calls are ignored after initialization.
    public var enabled: Bool

    /// When true, diagnostic messages and provider failures are logged to the console / OSLog.
    public var debug: Bool

    public init(
        providers: [AnalyticsProvider] = [],
        enabled: Bool = true,
        debug: Bool = false
    ) {
        self.providers = providers
        self.enabled = enabled
        self.debug = debug
    }
}
