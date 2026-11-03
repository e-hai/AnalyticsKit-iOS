import SwiftUI
import Analytics

public struct ContentView: View {
    @State private var eventCount = 0
    @State private var logs: [String] = []
    @State private var userId: String = "ios_user_1024"
    @State private var userCohort: String = "beta_tester"
    @State private var isCollectionEnabled = true

    public init() {}

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [AnalyticsKitTheme.backgroundTop, AnalyticsKitTheme.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    headerView

                    statsCard

                    actionsCard

                    identityCard

                    logsCard
                }
                .padding()
            }
        }
        .onAppear {
            Analytics.logScreenView(screenName: "SampleHome", screenClass: "ContentView")
            appendLog("Screen viewed: SampleHome")
        }
    }

    private var headerView: some View {
        VStack(spacing: 6) {
            Text("AnalyticsKit")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AnalyticsKitTheme.textPrimary)
            Text("Unified Analytics Facade for iOS")
                .font(.subheadline)
                .foregroundColor(AnalyticsKitTheme.textSecondary)
        }
        .padding(.top, 10)
    }

    private var statsCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Tracked Events")
                    .font(.caption)
                    .foregroundColor(AnalyticsKitTheme.textSecondary)
                Text("\(eventCount)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(AnalyticsKitTheme.accent)
            }
            Spacer()
            Toggle("Collection", isOn: $isCollectionEnabled)
                .labelsHidden()
                .onChange(of: isCollectionEnabled) { newValue in
                    Analytics.setEnabled(newValue)
                    appendLog("Analytics.setEnabled(\(newValue))")
                }
        }
        .padding()
        .background(AnalyticsKitTheme.cardBackground)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AnalyticsKitTheme.cardBorder, lineWidth: 1))
    }

    private var actionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Event Tracking")
                .font(.headline)
                .foregroundColor(AnalyticsKitTheme.textPrimary)

            Button(action: firePurchaseEvent) {
                HStack {
                    Image(systemName: "cart.fill")
                    Text("Track Purchase Event")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.white)
                .padding()
                .background(AnalyticsKitTheme.primary)
                .cornerRadius(10)
            }

            Button(action: fireCustomEvent) {
                HStack {
                    Image(systemName: "hand.tap.fill")
                    Text("Track Custom Click")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.12))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(AnalyticsKitTheme.cardBackground)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AnalyticsKitTheme.cardBorder, lineWidth: 1))
    }

    private var identityCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Identity & Properties")
                .font(.headline)
                .foregroundColor(AnalyticsKitTheme.textPrimary)

            Button(action: setIdentity) {
                HStack {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                    Text("Set User (\(userId))")
                    Spacer()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.12))
                .cornerRadius(10)
            }

            Button(action: resetIdentity) {
                HStack {
                    Image(systemName: "arrow.counterclockwise.circle")
                    Text("Reset Analytics Data")
                    Spacer()
                }
                .foregroundColor(.red.opacity(0.9))
                .padding()
                .background(Color.red.opacity(0.15))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(AnalyticsKitTheme.cardBackground)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AnalyticsKitTheme.cardBorder, lineWidth: 1))
    }

    private var logsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                    .foregroundColor(AnalyticsKitTheme.textPrimary)
                Spacer()
                Button("Clear") { logs.removeAll() }
                    .font(.caption)
                    .foregroundColor(AnalyticsKitTheme.accent)
            }

            if logs.isEmpty {
                Text("No activity yet. Tap a button above.")
                    .font(.footnote)
                    .foregroundColor(AnalyticsKitTheme.textSecondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(logs.prefix(5), id: \.self) { log in
                    Text("• \(log)")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(AnalyticsKitTheme.textSecondary)
                        .lineLimit(2)
                }
            }
        }
        .padding()
        .background(AnalyticsKitTheme.cardBackground)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AnalyticsKitTheme.cardBorder, lineWidth: 1))
    }

    // MARK: - Handlers

    private func firePurchaseEvent() {
        eventCount += 1
        Analytics.logEvent("purchase") {
            $0.param("item_id", "sku_swift_pro")
              .param("price", 49.99)
              .param("currency", "USD")
              .param("is_subscription", true)
        }
        appendLog("Event: purchase (sku_swift_pro, $49.99)")
    }

    private func fireCustomEvent() {
        eventCount += 1
        Analytics.logEvent("button_click") {
            $0.param("button_id", "demo_action")
              .param("screen", "SampleHome")
        }
        appendLog("Event: button_click (button_id: demo_action)")
    }

    private func setIdentity() {
        Analytics.setUserId(userId)
        Analytics.setUserProperty(name: "cohort", value: userCohort)
        appendLog("Set userId=\(userId), cohort=\(userCohort)")
    }

    private func resetIdentity() {
        Analytics.reset()
        appendLog("Analytics data reset")
    }

    private func appendLog(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        logs.insert("[\(timestamp)] \(message)", at: 0)
    }
}
