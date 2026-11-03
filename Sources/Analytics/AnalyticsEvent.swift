import Foundation

/// Represents a single tracked analytics event.
public struct AnalyticsEvent: Equatable, Sendable {
    /// The event identifier / name, e.g. `"button_click"`, `"purchase"`.
    public let name: String

    /// Strongly-typed parameters associated with the event.
    public let params: [String: AnalyticsValue]

    public init(name: String, params: [String: AnalyticsValue] = [:]) {
        self.name = name
        self.params = params
    }
}
