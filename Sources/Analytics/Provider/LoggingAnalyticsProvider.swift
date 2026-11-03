import Foundation
import os

/// Debug provider that logs all analytics interactions to OSLog / Console.
public final class LoggingAnalyticsProvider: AnalyticsProvider, @unchecked Sendable {
    public let name: String

    private let tag: String
    private let logger: Logger?

    public init(name: String = "logging", tag: String = "AnalyticsKit-Logging") {
        self.name = name
        self.tag = tag
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            self.logger = Logger(subsystem: "com.kit.analytics", category: tag)
        } else {
            self.logger = nil
        }
    }

    public func initialize() {
        log("Initialized")
    }

    public func logEvent(_ event: AnalyticsEvent) {
        let paramsString = event.params.isEmpty
            ? "{}"
            : event.params.map { "\($0.key): \($0.value)" }.sorted().joined(separator: ", ")
        log("logEvent '\(event.name)' with params: {\(paramsString)}")
    }

    public func setUserId(_ userId: String?) {
        log("setUserId: \(userId ?? "nil")")
    }

    public func setUserProperty(name: String, value: String?) {
        log("setUserProperty: \(name) = \(value ?? "nil")")
    }

    public func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        log("setAnalyticsCollectionEnabled: \(enabled)")
    }

    public func resetAnalyticsData() {
        log("resetAnalyticsData")
    }

    private func log(_ message: String) {
        let formatted = "[\(tag)] \(message)"
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *), let logger = logger {
            logger.debug("\(formatted, privacy: .public)")
        } else {
            print(formatted)
        }
    }
}
