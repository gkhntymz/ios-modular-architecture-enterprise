# ADR-005: Swift Package and App Target Test Isolation

- Status: Accepted
- Date: 2026-01-27

## Context

As the codebase grows with multiple Swift Package modules and an iOS App target,
test reliability and signal quality become critical.

Without clear test ownership and isolation:
- package tests may silently depend on app wiring
- app tests may accidentally test package internals
- CI failures become hard to diagnose
- refactoring becomes risky due to hidden coupling

This repository explicitly separates **package-level correctness**
from **application-level composition**.

---

## Decision

Tests are isolated according to architectural boundaries.

### Test ownership rules

#### Swift Package tests
- Each **Core** and **Feature** module owns its unit tests
- Tests live inside the package (`Tests/` directory)
- Executed using `swift test`
- Must not depend on:
  - App target
  - other feature modules
  - UI frameworks

Purpose:
- Validate business logic and infrastructure in isolation
- Enforce clean module boundaries
- Enable fast feedback in CI

---

#### App target tests
- App-level unit and UI tests live in the Xcode project
- Focus on:
  - composition
  - wiring
  - dependency injection
  - error mapping
- Avoid re-testing business logic already covered in packages

Purpose:
- Validate that modules integrate correctly
- Catch configuration and linker issues
- Ensure runtime behavior matches architectural intent

---

## Rationale

### Why strict isolation?

Swift Package Manager allows technically importing many targets,
but architectural correctness requires **discipline**, not just tooling.

Isolated tests ensure:
- package refactors do not break unrelated features
- app composition can evolve without rewriting core tests
- CI failures clearly indicate *where* the problem lives

---

### Why not test everything at App level?

App-level tests:
- are slower
- are harder to debug
- tend to mix concerns

Business logic belongs in packages and must be testable
**without launching the application**.

---

## CI implications

The CI pipeline reflects this isolation strategy:

- **SPM tests**
  - Run `swift test` per package
  - Fail fast on module-level issues

- **App build**
  - Ensures the application links and builds successfully

- **App tests**
  - Run `xcodebuild test`
  - Validate integration and UI behavior

Each CI failure is treated as an **architectural signal**, not just a test failure.

---

## Consequences

### Positive
- fast and reliable test feedback
- clear ownership of failures
- safer refactoring
- predictable CI behavior

### Trade-offs
- requires discipline when writing tests
- occasional duplication of test setup
- slightly more CI configuration

These trade-offs are accepted to preserve long-term maintainability
and architectural clarity.

---

## Notes

This ADR intentionally avoids prescribing a specific test framework
or pattern (e.g. XCTest vs Quick/Nimble).

Test structure decisions will be documented in future ADRs
if and when they become architectural concerns.
