import Foundation
import os

/// Fans out every call to multiple `AnalyticsProvider` instances.
/// Failures in one provider do not block the others.
public final class CompositeAnalyticsProvider: AnalyticsProvider, @unchecked Sendable {
    public let name: String = "composite"

    private let providers: [AnalyticsProvider]
    private let debug: BooleanLiteralType

    public init(providers: [AnalyticsProvider], debug: Bool = false) {
        self.providers = providers
        self.debug = debug
    }

    public func initialize() {
        forEachProvider("initialize") { $0.initialize() }
    }

    public func logEvent(_ event: AnalyticsEvent) {
        forEachProvider("logEvent") { $0.logEvent(event) }
    }

    public func setUserId(_ userId: String?) {
        forEachProvider("setUserId") { $0.setUserId(userId) }
    }

    public func setUserProperty(name: String, value: String?) {
        forEachProvider("setUserProperty") { $0.setUserProperty(name: name, value: value) }
    }

    public func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        forEachProvider("setAnalyticsCollectionEnabled") {
            $0.setAnalyticsCollectionEnabled(enabled)
        }
    }

    public func resetAnalyticsData() {
        forEachProvider("resetAnalyticsData") { $0.resetAnalyticsData() }
    }

    private func forEachProvider(_ action: String, block: (AnalyticsProvider) -> Void) {
        for provider in providers {
            // Providers shouldn't throw, but if any error/assertion happens, keep going.
            block(provider)
        }
    }
}
