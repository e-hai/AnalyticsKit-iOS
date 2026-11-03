import Foundation

/// Builder class for constructing strongly-typed event parameters.
///
/// Usage:
/// ```swift
/// Analytics.logEvent("purchase") { builder in
///     builder.param("item_id", "sku_123")
///            .param("price", 9.99)
///            .param("quantity", 2)
///            .param("is_vip", true)
/// }
/// ```
public final class AnalyticsParamsBuilder {
    private var params: [String: AnalyticsValue] = [:]

    public init() {}

    @discardableResult
    public func param(_ key: String, _ value: String) -> Self {
        params[key] = .of(value)
        return self
    }

    @discardableResult
    public func param(_ key: String, _ value: Int64) -> Self {
        params[key] = .of(value)
        return self
    }

    @discardableResult
    public func param(_ key: String, _ value: Int) -> Self {
        params[key] = .of(value)
        return self
    }

    @discardableResult
    public func param(_ key: String, _ value: Double) -> Self {
        params[key] = .of(value)
        return self
    }

    @discardableResult
    public func param(_ key: String, _ value: Float) -> Self {
        params[key] = .of(value)
        return self
    }

    @discardableResult
    public func param(_ key: String, _ value: Bool) -> Self {
        params[key] = .of(value)
        return self
    }

    @discardableResult
    public func param(_ key: String, _ value: AnalyticsValue) -> Self {
        params[key] = value
        return self
    }

    /// Subscript access for setting / reading parameters.
    public subscript(key: String) -> AnalyticsValue? {
        get { params[key] }
        set { params[key] = newValue }
    }

    /// Builds the final parameter dictionary.
    public func build() -> [String: AnalyticsValue] {
        return params
    }
}
