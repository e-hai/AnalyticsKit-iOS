import Foundation
import os

/// Unified analytics entry point for application code.
///
/// Usage:
/// ```swift
/// Analytics.initialize(config: AnalyticsConfig(
///     providers: [LoggingAnalyticsProvider(), FirebaseAnalyticsProvider()],
///     debug: true
/// ))
///
/// Analytics.logEvent("button_click") {
///     $0.param("screen", "home")
///       .param("action", "checkout")
/// }
/// ```
public final class Analytics: @unchecked Sendable {
    private static let lock = NSLock()
    private static var isInitializedState = false
    private static var isEnabledState = true
    private static var isDebugState = false
    private static var provider: AnalyticsProvider = NoOpAnalyticsProvider.shared

    private static let screenViewEvent = "screen_view"
    private static let screenNameParam = "screen_name"
    private static let screenClassParam = "screen_class"

    private init() {}

    /// Initialize the global analytics instance once.
    /// Subsequent calls are safely ignored.
    public static func initialize(config: AnalyticsConfig = AnalyticsConfig()) {
        lock.lock()
        if isInitializedState {
            let debug = isDebugState
            lock.unlock()
            if debug {
                logDebug("Analytics.initialize() called more than once; ignoring")
            }
            return
        }

        isEnabledState = config.enabled
        isDebugState = config.debug
        let selectedProvider: AnalyticsProvider = {
            switch config.providers.count {
            case 0:
                return NoOpAnalyticsProvider.shared
            case 1:
                return config.providers[0]
            default:
                return CompositeAnalyticsProvider(providers: config.providers, debug: config.debug)
            }
        }()
        provider = selectedProvider
        isInitializedState = true
        lock.unlock()

        selectedProvider.initialize()
    }

    /// Whether `Analytics.initialize(config:)` has been called.
    public static var isInitialized: Bool {
        lock.lock()
        defer { lock.unlock() }
        return isInitializedState
    }

    /// Master collection status.
    public static var isEnabled: Bool {
        lock.lock()
        defer { lock.unlock() }
        return isEnabledState
    }

    /// Toggle analytics data collection.
    public static func setEnabled(_ enabled: Bool) {
        lock.lock()
        isEnabledState = enabled
        let targetProvider = provider
        let initialized = isInitializedState
        lock.unlock()

        guard initialized else { return }
        targetProvider.setAnalyticsCollectionEnabled(enabled)
    }

    /// Log an event with a pre-built dictionary of `AnalyticsValue`.
    public static func logEvent(_ name: String, params: [String: AnalyticsValue] = [:]) {
        dispatch { currentProvider in
            currentProvider.logEvent(AnalyticsEvent(name: name, params: params))
        }
    }

    /// Log an event using builder closure DSL.
    public static func logEvent(_ name: String, builder: (AnalyticsParamsBuilder) -> Void) {
        let paramsBuilder = AnalyticsParamsBuilder()
        builder(paramsBuilder)
        logEvent(name, params: paramsBuilder.build())
    }

    /// Track a screen / view appearance.
    public static func logScreenView(screenName: String, screenClass: String? = nil) {
        logEvent(screenViewEvent) {
            $0.param(screenNameParam, screenName)
            if let screenClass = screenClass {
                $0.param(screenClassParam, screenClass)
            }
        }
    }

    /// Associate user identity across events.
    public static func setUserId(_ userId: String?) {
        dispatch { $0.setUserId(userId) }
    }

    /// Set a user attribute / property.
    public static func setUserProperty(name: String, value: String?) {
        dispatch { $0.setUserProperty(name: name, value: value) }
    }

    /// Clear persisted identity and data on user logout.
    public static func reset() {
        dispatch { $0.resetAnalyticsData() }
    }

    // MARK: - Internal Dispatch

    private static func dispatch(_ action: (AnalyticsProvider) -> Void) {
        lock.lock()
        let initialized = isInitializedState
        let enabled = isEnabledState
        let debug = isDebugState
        let currentProvider = provider
        lock.unlock()

        guard initialized else {
            if debug {
                logDebug("Analytics call before initialize(); ignored")
            }
            return
        }

        guard enabled else { return }
        action(currentProvider)
    }

    private static func logDebug(_ message: String) {
        print("[AnalyticsKit] \(message)")
    }

    /// Reset internal state for testing only.
    internal static func resetForTesting() {
        lock.lock()
        defer { lock.unlock() }
        isInitializedState = false
        isEnabledState = true
        isDebugState = false
        provider = NoOpAnalyticsProvider.shared
    }
}
