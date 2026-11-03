# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project purpose

AnalyticsKit-iOS is an iOS Swift multi-product package that wraps analytics SDKs
(Firebase Analytics first; more providers later) behind a single unified API.

Apps depend on Kit targets and call `Analytics.*`. They must not talk to
Firebase / other SDKs directly for event tracking.

## Module / Target map

| Target | Role |
|--------|------|
| `Analytics` | Core API, facade, provider protocol, NoOp / Logging / Composite |
| `AnalyticsFirebase` | `FirebaseAnalyticsProvider` + `firebase-ios-sdk` integration |
| `Sample` | Demo SwiftUI App; Logging + Firebase usage |

Do **not** add Firebase (or other vendor SDKs) to the `Analytics` core target.
New vendors get their own targets, e.g. `AnalyticsAppsFlyer`.

## Architecture rules

```
App code → Analytics (facade) → AnalyticsProvider(s) → Vendor SDK
```

- Public app-facing API lives in the `Analytics` module (`Analytics`, `AnalyticsConfig`,
  `AnalyticsEvent`, `AnalyticsValue`, `AnalyticsParamsBuilder`).
- Vendor adapters implement `AnalyticsProvider`.
- Multiple providers are wrapped by `CompositeAnalyticsProvider` inside
  `Analytics.initialize` when more than one is configured.
- Typed params use `AnalyticsValue` (String / Int64 / Double / Bool). Do not
  introduce untyped `[String: Any]` for public event params.
- Fail-soft principle: failures in one provider must not crash or block others.

## Swift / SPM conventions

- Use Swift Package Manager (`Package.swift`).
- Minimum deployment targets: iOS 13+, macOS 12+, tvOS 13+, watchOS 6+.
- Core target `Analytics` must remain zero external dependencies.
- Keep concurrency safety in mind (`Sendable`, thread-safe facade).
