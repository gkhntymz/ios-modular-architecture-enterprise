# ADR-008: Dependency Injection and Composition Root

- Status: Accepted
- Date: 2026-01-27

## Context

As the system adopts a strict modular architecture (ADR-001, ADR-002),
dependency management becomes a first-class architectural concern.

Without a clear dependency injection (DI) strategy:
- features may create their own concrete dependencies
- Core implementations may leak into feature logic
- testability degrades due to hard-coded dependencies
- object graphs become implicit and hard to reason about

To preserve modular boundaries and test isolation, dependency construction
and wiring must be **explicit, centralized, and controlled**.

---

## Decision

The system adopts **constructor-based dependency injection** with a
single **Composition Root** located in the App layer.

### Key rules

1. Dependencies are injected explicitly (no service locator)
2. Feature and Core modules depend on **abstractions**, not implementations
3. Concrete implementations are created only in the App layer
4. The App acts as the sole composition root

---

## Dependency Injection approach

### Constructor-based injection

Dependencies are provided via initializers:

- no global singletons
- no hidden runtime resolution
- no implicit dependency graphs

Benefits:
- explicit contracts
- compile-time safety
- easy mocking and substitution in tests

---

### What is *not* used

The following patterns are intentionally avoided:

- Service Locator
- Global dependency containers
- Static shared instances for business dependencies
- Reflection-based injection

These approaches hide dependencies and weaken architectural guarantees.

---

## Composition Root

### Definition

The **Composition Root** is the place where:
- concrete implementations are created
- dependencies are wired together
- object graphs are assembled

In this architecture, the **App target** is the composition root.

---

### Responsibilities of the App layer

The App layer is responsible for:

- instantiating Core implementations
  - networking clients
  - loggers
  - interceptors
- constructing Feature modules with their required dependencies
- controlling lifecycle and scope of shared objects
- orchestrating communication between features

Feature modules never construct Core or App-level dependencies themselves.

---

## Dependency flow

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

## Testing implications

### Feature tests

- Feature modules inject mocked Core dependencies
- Tests run without App involvement
- No concrete networking or logging implementations required

---

### App tests

- App-level tests validate wiring correctness
- Integration tests ensure dependencies are composed as expected
- Failures indicate misconfiguration, not feature logic issues

---

## CI implications

The CI pipeline reinforces this strategy:

- Swift Package tests validate feature and core isolation
- App build step detects missing or miswired dependencies
- App tests validate the composed object graph

Dependency injection issues surface early and deterministically.

---

## Consequences

### Positive

- explicit and understandable dependency graph
- improved testability and mocking
- reduced coupling between layers
- safer refactoring and feature extraction

### Trade-offs

- more verbose initializers
- additional wiring code in the App layer
- slightly higher upfront design cost

These trade-offs are accepted to ensure long-term maintainability
and architectural clarity.

---

## Notes

This ADR defines *how dependencies are wired*, not *how state is managed*.
State management, lifetimes, and feature coordination may be addressed
in future ADRs.
