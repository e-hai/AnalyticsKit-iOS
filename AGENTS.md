# AGENTS.md

Guidance for AI coding agents and human contributors working in this repository.

## Project Purpose

**AnalyticsKit-iOS** is an iOS / Apple platform Swift multi-product package that wraps analytics SDKs
(Firebase Analytics first; more providers later) behind a unified, strongly-typed API.

Applications depend on Kit targets and call `Analytics.*`. They must not talk to
Firebase or other third-party SDKs directly for event tracking.

## Module / Target Map

| Target | Role | Dependencies |
|:---|:---|:---|
| `Analytics` | Core API, facade, provider protocol, NoOp / Logging / Composite | Zero 3rd-party dependencies |
| `AnalyticsFirebase` | `FirebaseAnalyticsProvider` adapter | `Analytics`, `firebase-ios-sdk` |
| `AnalyticsTests` | Unit tests for Core & Providers | `Analytics`, XCTest |
| `AnalyticsKitDemo` | Demo SwiftUI application (`AnalyticsKitDemo.xcodeproj`) | `Analytics` |

> **Rule**: Do **not** add Firebase (or any vendor SDK) to the `Analytics` core target.
> New vendors get their own dedicated adapter targets, e.g. `AnalyticsAppsFlyer`.

## Architecture Rules & Guidelines

```
App code → Analytics (facade) → AnalyticsProvider(s) → Vendor SDK
```

1. **Facade & Concurrency**:
   - Public app-facing API lives in the `Analytics` module (`Analytics`, `AnalyticsConfig`, `AnalyticsEvent`, `AnalyticsValue`, `AnalyticsParamsBuilder`).
   - `Analytics` facade is thread-safe, protected internally by `NSLock`.
   - Types must conform to `Sendable` where applicable for Swift 6 concurrency interoperability.
2. **Strongly-Typed Parameters**:
   - Typed params strictly use `AnalyticsValue` (`.string`, `.int`, `.double`, `.bool`).
   - Do **not** introduce untyped `[String: Any]` into public event APIs.
3. **Fail-Soft Principle**:
   - `CompositeAnalyticsProvider` must isolate errors from individual providers.
   - Failures in one provider must not crash the host app or disrupt other providers.
4. **Platform Compatibility**:
   - Minimum deployment targets: iOS 13+, macOS 12+, tvOS 13+, watchOS 6+.
   - Demo project (`AnalyticsKitDemo.xcodeproj`) deployment target: iOS 15+.
