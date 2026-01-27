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
- [`ADR-002`](docs/adr/ADR-002-module-dependency-rules-and-enforcement.md): Module Dependency Rules
- [`ADR-003`](docs/adr/ADR-003-testing-strategy-and-ownership.md): Testing Strategy & Ownership
- [`ADR-004`](docs/adr/ADR-004-ci-pipeline-and-branch-protection.md): CI Pipeline & Branch Protection
- [`ADR-007`](docs/adr/ADR-007-logging-and-redaction-strategy.md): Logging & Redaction Strategy
- [`ADR-008`](docs/adr/ADR-008-dependency-injection-and-composition-root.md): Dependency Injection
- [`ADR-009`](docs/adr/ADR-009-feature-communication-and-coordination.md): Feature Communication
- [`ADR-010`](docs/adr/ADR-010-preview-and-demo-app-strategy.md): Preview / Demo App Strategy

---

## How to run

1. Clone the repository
2. Open `EnterpriseApp.xcodeproj`
3. Select a simulator
4. Run the `EnterpriseApp` scheme
5. Run tests via:
   - `⌘U` in Xcode, or
   - `swift test` for package-level tests
