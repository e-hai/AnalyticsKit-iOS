import XCTest
@testable import Analytics

private final class TestSpyProvider: AnalyticsProvider, @unchecked Sendable {
    let name: String = "spy"
    var initializeCalled = false
    var events: [AnalyticsEvent] = []
    var userId: String?
    var userProperties: [String: String?] = [:]
    var enabled: Bool = true
    var resetCount = 0

    func initialize() {
        initializeCalled = true
    }

    func logEvent(_ event: AnalyticsEvent) {
        events.append(event)
    }

    func setUserId(_ userId: String?) {
        self.userId = userId
    }

    func setUserProperty(name: String, value: String?) {
        userProperties[name] = value
    }

    func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        self.enabled = enabled
    }

    func resetAnalyticsData() {
        resetCount += 1
    }
}

final class AnalyticsFacadeTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Analytics.resetForTesting()
    }

    override func tearDown() {
        Analytics.resetForTesting()
        super.tearDown()
    }

    func testCallBeforeInitializeIsIgnored() {
        Analytics.logEvent("early_bird") { $0.param("k", "v") }
        Analytics.setUserId("early_user")
        Analytics.reset()
        XCTAssertFalse(Analytics.isInitialized)
    }

    func testInitializationAndEventDispatch() {
        let spy = TestSpyProvider()
        Analytics.initialize(config: AnalyticsConfig(
            providers: [spy],
            enabled: true,
            debug: true
        ))

        XCTAssertTrue(Analytics.isInitialized)
        XCTAssertTrue(spy.initializeCalled)

        Analytics.logEvent("purchase") {
            $0.param("item", "book")
              .param("price", 19.9)
        }

        XCTAssertEqual(spy.events.count, 1)
        XCTAssertEqual(spy.events.first?.name, "purchase")
        XCTAssertEqual(spy.events.first?.params["item"], .string("book"))

        Analytics.logScreenView(screenName: "HomeVC", screenClass: "HomeViewController")
        XCTAssertEqual(spy.events.count, 2)
        let screenEvent = spy.events[1]
        XCTAssertEqual(screenEvent.name, "screen_view")
        XCTAssertEqual(screenEvent.params["screen_name"], .string("HomeVC"))
        XCTAssertEqual(screenEvent.params["screen_class"], .string("HomeViewController"))

        Analytics.setUserId("user_99")
        XCTAssertEqual(spy.userId, "user_99")

        Analytics.setUserProperty(name: "vip", value: "true")
        XCTAssertEqual(spy.userProperties["vip"], "true")

        Analytics.reset()
        XCTAssertEqual(spy.resetCount, 1)
    }

    func testDisabledStateBlocksEvents() {
        let spy = TestSpyProvider()
        Analytics.initialize(config: AnalyticsConfig(
            providers: [spy],
            enabled: false,
            debug: true
        ))

        Analytics.logEvent("silent") { $0.param("k", "v") }
        XCTAssertEqual(spy.events.count, 0)

        Analytics.setEnabled(true)
        Analytics.logEvent("now_active")
        XCTAssertEqual(spy.events.count, 1)
        XCTAssertEqual(spy.events.first?.name, "now_active")
    }

    func testMultipleInitializeIsIgnored() {
        let spy1 = TestSpyProvider()
        let spy2 = TestSpyProvider()

        Analytics.initialize(config: AnalyticsConfig(providers: [spy1], debug: true))
        Analytics.initialize(config: AnalyticsConfig(providers: [spy2], debug: true))

        XCTAssertTrue(spy1.initializeCalled)
        XCTAssertFalse(spy2.initializeCalled)
    }
}
