import Foundation

/// Typed event / property values aligned with common analytics SDK constraints.
/// Prevents untyped or unsupported dictionaries from being passed downstream.
public enum AnalyticsValue: Equatable, Hashable, Sendable {
    case string(String)
    case int(Int64)
    case double(Double)
    case bool(Bool)

    public static func of(_ value: String) -> AnalyticsValue {
        .string(value)
    }

    public static func of(_ value: Int64) -> AnalyticsValue {
        .int(value)
    }

    public static func of(_ value: Int) -> AnalyticsValue {
        .int(Int64(value))
    }

    public static func of(_ value: Double) -> AnalyticsValue {
        .double(value)
    }

    public static func of(_ value: Float) -> AnalyticsValue {
        .double(Double(value))
    }

    public static func of(_ value: Bool) -> AnalyticsValue {
        .bool(value)
    }

    /// Extracted raw primitive representation, useful for generic dictionary serialization.
    public var rawValue: Any {
        switch self {
        case .string(let str): return str
        case .int(let num): return num
        case .double(let dbl): return dbl
        case .bool(let b): return b
        }
    }
}

// MARK: - ExpressibleBy Literals

extension AnalyticsValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension AnalyticsValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
        self = .int(value)
    }
}

extension AnalyticsValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension AnalyticsValue: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

// MARK: - CustomStringConvertible

extension AnalyticsValue: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .string(let v): return "\"\(v)\""
        case .int(let v): return "\(v)"
        case .double(let v): return "\(v)"
        case .bool(let v): return "\(v)"
        }
    }

    public var debugDescription: String {
        description
    }
}
