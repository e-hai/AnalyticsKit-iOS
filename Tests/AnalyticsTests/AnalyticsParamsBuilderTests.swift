import XCTest
@testable import Analytics

final class AnalyticsParamsBuilderTests: XCTestCase {
    func testBuilderChainingAndTypes() {
        let builder = AnalyticsParamsBuilder()
            .param("str", "value")
            .param("int64", Int64(64))
            .param("int", 32)
            .param("double", 1.23)
            .param("float", Float(4.56))
            .param("bool", true)
            .param("custom", AnalyticsValue.string("custom"))

        let params = builder.build()

        XCTAssertEqual(params["str"], .string("value"))
        XCTAssertEqual(params["int64"], .int(64))
        XCTAssertEqual(params["int"], .int(32))
        XCTAssertEqual(params["double"], .double(1.23))
        XCTAssertEqual(params["float"], .double(Double(Float(4.56))))
        XCTAssertEqual(params["bool"], .bool(true))
        XCTAssertEqual(params["custom"], .string("custom"))
    }

    func testBuilderSubscript() {
        let builder = AnalyticsParamsBuilder()
        builder["key1"] = "val1"
        builder["key2"] = 100

        XCTAssertEqual(builder["key1"], .string("val1"))
        XCTAssertEqual(builder["key2"], .int(100))

        let built = builder.build()
        XCTAssertEqual(built["key1"], .string("val1"))
        XCTAssertEqual(built["key2"], .int(100))
    }
}
