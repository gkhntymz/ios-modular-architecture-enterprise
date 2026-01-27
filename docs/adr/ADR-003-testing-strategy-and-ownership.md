# ADR-003: Testing Strategy and Test Ownership

- **Status:** Accepted
- **Date:** 2026-01-27

---

## Context

As the codebase is modularized (ADR-001) and strict dependency rules are enforced
(ADR-002), the testing strategy must align with the same architectural boundaries.

Common problems in large iOS codebases include:
- tests tightly coupled to the App target
- feature logic validated indirectly via UI tests
- slow and flaky test suites
- unclear ownership when tests fail
- CI pipelines that provide poor signal-to-noise ratio

To scale safely, testing must:
- mirror architectural boundaries
- run fast and deterministically
- clearly indicate where a failure originates

---

## Decision

Adopt a **layer-aligned testing strategy** with **explicit test ownership**.

Testing responsibility is divided across three levels:

1. **Swift Package tests (Core & Features)**
2. **App-level unit tests**
3. **UI tests (minimal and intentional)**

Each level has a distinct purpose and owner.

---

## Testing layers

### 1. Swift Package tests (Core & Features)

**Scope**
- Business logic
- Networking logic
- Error mapping
- Concurrency behavior
- Protocol-based interactions

**Characteristics**
- Run via `swift test`
- No dependency on the App target
- No UIKit / SwiftUI dependencies
- Very fast feedback

**Ownership**
- Each package owns its tests
- Failures indicate an issue *inside the module*

**Rationale**
Swift Packages provide the strongest isolation boundary.
Testing at this level prevents architectural leakage and enforces clean APIs.

---

### 2. App-level unit tests

**Scope**
- Composition and wiring
- Dependency injection
- Feature orchestration
- App-specific error mapping
- Integration between modules

**Characteristics**
- Run via `xcodebuild test`
- Limited mocking
- No deep business logic

**Ownership**
- App target
- Failures indicate integration or configuration issues

**Rationale**
The App target acts as a **composition root**, not a logic container.
Tests here validate that independently-tested modules are wired correctly.

---

### 3. UI tests

**Scope**
- Critical user journeys only
- Smoke-level validation
- Regression prevention for key flows

**Characteristics**
- Slowest and most brittle tests
- Minimal coverage by design

**Ownership**
- App target
- Treated as a safety net, not a validation layer

**Rationale**
UI tests validate *integration*, not correctness of business logic.
They are intentionally limited to keep the feedback loop fast.

---

## CI alignment

The CI pipeline mirrors this strategy:

- **SPM tests**
  - Validate Core and Feature modules in isolation
- **App build**
  - Detect linker, configuration, and dependency issues
- **App tests**
  - Validate composition and integration

CI failures are treated as **architectural signals**, not merely test failures.

---

## Principles

- Test where the logic lives
- Prefer fast, isolated tests
- Avoid testing through multiple layers
- Failing tests must clearly indicate ownership
- CI must provide fast and actionable feedback

---

## Consequences

### Positive
- Faster CI feedback
- Clear test ownership
- Reduced flakiness
- Architecture and tests evolve together
- Easier onboarding for new engineers

### Trade-offs
- Requires discipline to keep logic out of the App target
- Some duplication between unit and integration tests is acceptable

These trade-offs are accepted to preserve long-term maintainability.
