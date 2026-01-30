# iOS Modular Architecture (Enterprise)

A portfolio-grade, enterprise-style iOS codebase demonstrating how a
real-world application can be structured for **scale, testability,
and long-term maintainability**.

This repository prioritizes engineering discipline over demo speed.

---

## Why this repository exists

Most sample iOS projects optimize for:
- quick demos
- minimal setup
- single-target architectures

This repository optimizes for:
- maintainability at scale
- explicit architectural trade-offs
- strict dependency boundaries
- predictable and automated testing
- production-ready CI workflows

The goal is to resemble how an iOS codebase evolves inside a mature
engineering organization.

---

## High-level architecture

### Layers

- **App**
  - Composition root
  - Application lifecycle
  - Feature wiring and navigation
  - Owns dependency injection and orchestration

- **Features**
  - Isolated feature modules (Authentication, Profile, etc.)
  - Contain UI, state, and feature-specific logic
  - Do not depend on each other directly

- **Core**
  - Cross-cutting concerns shared across the system
  - Examples: Networking, Logging, Observability
  - Framework-level, reusable abstractions

---

## Architecture Playbook

This repo demonstrates a modular iOS architecture where **features do the work** and the **app orchestrates navigation**.

### Goals

- Keep feature modules independent (no feature-to-feature imports)
- Make flows explicit and testable via Coordinator + Output events
- Centralize policies (baseURL, logging, retry, interceptors) in the App composition root
- Keep Swift Packages **UIKit-free** so `swift test` can run on CI (macOS)

---

## 1) Boundaries: what lives where?

### Feature modules (Swift Packages)
**Own:**
- Use-cases / business rules
- Network calls via abstractions (e.g., `HTTPClient`, `RequestBuilder`)
- Feature public API (protocols) and Output event contracts

**Do not own:**
- Navigation / flow
- App-wide policies (base URL, retry strategy)
- UIKit view controllers (unless the module is explicitly iOS-only and CI is configured accordingly)

### App target (EnterpriseApp)
**Own:**
- Composition roots (wiring concrete implementations + policies)
- Coordinators (navigation and flow)
- Demo / debug UI (e.g., `AuthDemoViewController`, `ProfileDemoViewController`)

---

## 2) Why Coordinator?

Navigation is **not** business logic. It’s a flow concern.

**Coordinator benefits**
- A single place to understand the app flow
- Features stay reusable and independent
- Avoids `import FeatureB` inside FeatureA
- Easier testing: coordinator can be unit-tested with fake outputs

---

## 3) Why Output / Events?

Features should not know “what happens next”.
They should only announce what happened.

Example: Authentication feature exposes:

- `onAuthenticated`
- `onLogout`

The app decides:
- show Profile
- show Auth again
- route to onboarding, etc.

This keeps the **feature boundary** stable while flows evolve.

---

## 4) Why Composition Root?

The app owns concrete choices and policies:
- `baseURL`
- interceptors (logging, metrics, auth header)
- retry policies
- error mapping policy

So feature modules can stay focused on behavior and contracts.

Example:
- `AuthComposition.makeAuthFeature(output:)` wires dependencies and passes `AuthenticationOutput`.

---

## 5) Why keep Swift Packages UIKit-free?

CI runs `swift test` on macOS by default. `UIKit` is not available there.

**Rule:** packages that are intended to be tested with SwiftPM should not import UIKit.

If UI is needed for demo:
- create demo VCs in the app target (EnterpriseApp)
- or create a separate iOS-only module and configure CI accordingly

---

## 6) Common pitfalls

### “Nothing happens when I navigate”
Most common root cause: using a `UINavigationController()` that is not the visible root.
Ensure the app starts with:
- `window.rootViewController = UINavigationController(...)`

### MainActor and UI factories
UI creation should happen on the main actor.
Use `@MainActor` on UI factories if needed.

### Protected `main` branch
This repo enforces:
- changes must go through PR
- required checks must pass

---

### Dependency flow

The dependency graph follows this direction:

App → Features → Core

- App knows about Features and Core
- Features know only Core abstractions
- Core knows only itself

This preserves:
- clear ownership
- replaceable implementations
- testable modules

---

## Module strategy

All non-App modules are implemented using **Swift Package Manager (SPM)**.

SPM is used as an **architectural enforcement tool**, not just a packaging system.

Benefits:
- explicit dependency declarations
- strong isolation between modules
- fast and independent test execution
- portability outside the Xcode project

---

## Testing strategy

Testing mirrors the architectural boundaries of the system.

- **Core & Feature modules**
  - Own their unit tests
  - Executed via `swift test`
  - Fast and isolated

- **App target**
  - Owns composition and integration tests
  - Validates wiring, orchestration, and error mapping
  - Minimal business logic

- **UI tests**
  - Limited to critical user journeys
  - Treated as a safety net, not the primary test layer

Detailed rationale:
- [`docs/adr/ADR-003-testing-strategy-and-ownership.md`](docs/adr/ADR-003-testing-strategy-and-ownership.md)

---

## Continuous Integration

This repository uses a **multi-stage GitHub Actions pipeline** designed to
reflect enterprise iOS workflows.

CI includes:
- Swift Package tests (Core & Features)
- App build verification
- App unit and UI tests on iOS Simulator

All CI checks are required before merging into `main`.

---

## Architecture Decision Records (ADRs)

Significant architectural decisions are documented explicitly to prevent
knowledge loss and architectural drift.

Location:
- `docs/adr/`

Key ADRs:
- [`ADR-001`](docs/adr/ADR-001-why-modular-architecture.md): Why Modular Architecture
- [`ADR-002`](docs/adr/ADR-002-module-dependency-rules.md): Module Dependency Rules
- [`ADR-003`](docs/adr/ADR-003-testing-strategy-and-ownership.md): Testing Strategy & Ownership
- [`ADR-004`](docs/adr/ADR-004-ci-and-branch-protection.md): CI Pipeline & Branch Protection
- [`ADR-005`](docs/adr/ADR-005-swift-package-and-app-test-isolation.md): Swift Package & App Test Isolation
- [`ADR-006`](docs/adr/ADR-006-networking-error-modeling-and-mapping-strategy.md): Networking Error Modeling & Mapping
- [`ADR-007`](docs/adr/ADR-007-logging-and-redaction-strategy.md): Logging & Redaction Strategy
- [`ADR-008`](docs/adr/ADR-008-dependency-injection-and-composition-root.md): Dependency Injection & Composition Root
- [`ADR-009`](docs/adr/ADR-009-feature-communication-and-coordination.md): Feature Communication & Coordination
- [`ADR-010`](docs/adr/ADR-010-preview-demo-app-strategy.md): Preview / Demo App Strategy


---

## How to run

1. Clone the repository
2. Open `EnterpriseApp.xcodeproj`
3. Select a simulator
4. Run the `EnterpriseApp` scheme
5. Run tests via:
   - `⌘U` in Xcode, or
   - `swift test` for package-level tests
