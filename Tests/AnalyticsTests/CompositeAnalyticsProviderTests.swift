import XCTest
@testable import Analytics

private final class MockProvider: AnalyticsProvider, @unchecked Sendable {
    let name: String
    var initialized = false
    var loggedEvents: [AnalyticsEvent] = []
    var userId: String?
    var userProperties: [String: String?] = [:]
    var collectionEnabled: Bool?
    var resetCallCount = 0

    init(name: String) {
        self.name = name
    }

    func initialize() {
        initialized = true
    }

    func logEvent(_ event: AnalyticsEvent) {
        loggedEvents.append(event)
    }

    func setUserId(_ userId: String?) {
        self.userId = userId
    }

    func setUserProperty(name: String, value: String?) {
        userProperties[name] = value
    }

    func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        collectionEnabled = enabled
    }

    func resetAnalyticsData() {
        resetCallCount += 1
    }
}

final class CompositeAnalyticsProviderTests: XCTestCase {
    func testDispatchToAllProviders() {
        let p1 = MockProvider(name: "p1")
        let p2 = MockProvider(name: "p2")
        let composite = CompositeAnalyticsProvider(providers: [p1, p2], debug: true)

        composite.initialize()
        XCTAssertTrue(p1.initialized)
        XCTAssertTrue(p2.initialized)

        let event = AnalyticsEvent(name: "test_event", params: ["key": "val"])
        composite.logEvent(event)
        XCTAssertEqual(p1.loggedEvents, [event])
        XCTAssertEqual(p2.loggedEvents, [event])

        composite.setUserId("user_abc")
        XCTAssertEqual(p1.userId, "user_abc")
        XCTAssertEqual(p2.userId, "user_abc")

        composite.setUserProperty(name: "tier", value: "gold")
        XCTAssertEqual(p1.userProperties["tier"], "gold")
        XCTAssertEqual(p2.userProperties["tier"], "gold")

        composite.setAnalyticsCollectionEnabled(false)
        XCTAssertEqual(p1.collectionEnabled, false)
        XCTAssertEqual(p2.collectionEnabled, false)

        composite.resetAnalyticsData()
        XCTAssertEqual(p1.resetCallCount, 1)
        XCTAssertEqual(p2.resetCallCount, 1)
    }
}
