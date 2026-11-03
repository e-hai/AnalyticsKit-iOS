// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AnalyticsKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Analytics",
            targets: ["Analytics"]
        ),
        .library(
            name: "AnalyticsFirebase",
            targets: ["AnalyticsFirebase"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            "10.0.0"..<"12.0.0"
        )
    ],
    targets: [
        .target(
            name: "Analytics",
            dependencies: [],
            path: "Sources/Analytics"
        ),
        .target(
            name: "AnalyticsFirebase",
            dependencies: [
                "Analytics",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
            ],
            path: "Sources/AnalyticsFirebase"
        ),
        .testTarget(
            name: "AnalyticsTests",
            dependencies: ["Analytics"],
            path: "Tests/AnalyticsTests"
        )
    ]
)
