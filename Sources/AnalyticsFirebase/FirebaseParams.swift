import Foundation
import Analytics

extension Dictionary where Key == String, Value == AnalyticsValue {
    /// Converts Kit typed parameters to a dictionary compatible with Firebase Analytics.
    ///
    /// Values supported by Firebase Analytics parameters are NSString and NSNumber.
    public func toFirebaseParameters() -> [String: Any] {
        guard !isEmpty else { return [:] }
        var result = [String: Any](minimumCapacity: count)
        for (key, value) in self {
            switch value {
            case .string(let str):
                result[key] = str
            case .int(let num):
                result[key] = NSNumber(value: num)
            case .double(let dbl):
                result[key] = NSNumber(value: dbl)
            case .bool(let b):
                // Firebase Analytics on iOS accepts NSNumber for booleans, or "true"/"false" string.
                // We provide NSNumber(value: Bool) which integrates with Firebase SDK reporting.
                result[key] = NSNumber(value: b)
            }
        }
        return result
    }
}
