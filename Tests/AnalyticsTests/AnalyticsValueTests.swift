import XCTest
@testable import Analytics

final class AnalyticsValueTests: XCTestCase {
    func testLiteralInitialization() {
        let str: AnalyticsValue = "hello"
        let intVal: AnalyticsValue = 42
        let dblVal: AnalyticsValue = 3.14
        let boolVal: AnalyticsValue = true

        XCTAssertEqual(str, .string("hello"))
        XCTAssertEqual(intVal, .int(42))
        XCTAssertEqual(dblVal, .double(3.14))
        XCTAssertEqual(boolVal, .bool(true))
    }

    func testOfFactories() {
        XCTAssertEqual(AnalyticsValue.of("abc"), .string("abc"))
        XCTAssertEqual(AnalyticsValue.of(Int64(100)), .int(100))
        XCTAssertEqual(AnalyticsValue.of(100), .int(100))
        XCTAssertEqual(AnalyticsValue.of(9.99), .double(9.99))
        XCTAssertEqual(AnalyticsValue.of(Float(1.5)), .double(Double(Float(1.5))))
        XCTAssertEqual(AnalyticsValue.of(false), .bool(false))
    }

    func testRawValueExtraction() {
        XCTAssertEqual(AnalyticsValue.string("str").rawValue as? String, "str")
        XCTAssertEqual(AnalyticsValue.int(123).rawValue as? Int64, 123)
        XCTAssertEqual(AnalyticsValue.double(4.56).rawValue as? Double, 4.56)
        XCTAssertEqual(AnalyticsValue.bool(true).rawValue as? Bool, true)
    }

    func testDescription() {
        XCTAssertEqual(AnalyticsValue.string("test").description, "\"test\"")
        XCTAssertEqual(AnalyticsValue.int(10).description, "10")
        XCTAssertEqual(AnalyticsValue.bool(true).description, "true")
    }
}
