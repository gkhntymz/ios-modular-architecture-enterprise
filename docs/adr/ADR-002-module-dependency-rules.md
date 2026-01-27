# ADR-002: Module Dependency Rules and Enforcement

- Status: Accepted
- Date: 2026-01-27

## Context

After adopting a modular architecture (ADR-001), the primary risk becomes
**dependency erosion**:

- features starting to depend on each other
- core modules pulling feature or UI logic
- hidden coupling through convenience imports
- architectural drift over time

Without strict rules, modular architectures tend to degrade back into
a distributed monolith.

This ADR defines the **explicit dependency rules** and how they are enforced.

---

## Decision

The dependency graph of the system is intentionally constrained:

### Dependency rules

- `Core` **must not** depend on `Features`
- `Features` **must not** depend on each other
- Communication flows through **protocols and abstractions**

These rules are intentionally strict to keep the dependency graph:
- understandable
- enforceable
- resistant to gradual erosion

---

## Rationale

### Why no Core → Feature dependency?

Core modules provide reusable, cross-cutting capabilities.
Allowing them to depend on features would:
- invert ownership
- introduce UI or domain leakage
- reduce reusability outside the app

---

### Why no Feature → Feature dependency?

Direct feature-to-feature dependencies:
- create hidden coupling
- make features harder to remove or refactor
- complicate ownership and testing

Instead, communication happens via:
- protocols defined in Core or shared interfaces
- dependency inversion
- orchestration at the App (composition root) level

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

## Testing implications

Dependency rules directly influence the testing strategy.

### Swift Package tests

- Each Core and Feature module owns its unit tests
- Tests run independently using `swift test`
- Prevents accidental coupling between modules

### App-level tests

- App target contains unit and UI tests
- Focus on composition, wiring, and integration
- Business logic remains inside feature modules

---

## CI enforcement

The dependency rules are enforced indirectly via CI:

- Swift Package tests run in isolation
- App build step detects linker and configuration issues
- App tests validate integration boundaries

CI failures are treated as architectural signals, not just test failures.

---

## Consequences

### Positive
- predictable and stable dependency graph
- easier refactoring and module extraction
- strong test isolation
- architecture remains understandable over time

### Trade-offs
- some indirection via protocols
- slightly more upfront design work
- stricter boundaries require discipline

These trade-offs are accepted to preserve long-term maintainability.
