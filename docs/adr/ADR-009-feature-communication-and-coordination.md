# ADR-009: Feature Communication & Coordination

- Status: Accepted
- Date: 2026-01-27

## Context

In a modular architecture, **feature-to-feature communication** is one of the
most common sources of architectural erosion.

Typical failure modes include:
- direct imports between feature modules
- shared state leaking across features
- navigation logic embedded inside features
- implicit coupling via global singletons

These patterns make features:
- harder to test
- harder to replace or remove
- harder to reason about as the system grows

A clear and enforceable communication strategy is required.

---

## Decision

**Features do not communicate with each other directly.**

All coordination happens through:
- the **App layer (composition root)**
- **protocols and abstractions**
- **events or callbacks**, not concrete implementations

The App layer is responsible for:
- wiring feature dependencies
- handling navigation and orchestration
- translating feature outputs into inputs for other features

---

## Communication patterns

### 1. Protocol-based output

Features expose **outputs** via protocols.

Example:
- `AuthenticationFeatureOutput`
- `ProfileFeatureOutput`

The App layer:
- implements these protocols
- reacts to feature events
- decides what happens next

This keeps features unaware of who consumes their output.

---

### 2. Dependency inversion

If a feature needs a capability:
- it depends on an **abstraction**
- not a concrete feature implementation

Abstractions live in:
- `Core`
- or a dedicated interfaces module (if needed later)

The App layer provides concrete implementations at composition time.

---

### 3. Event-driven coordination (lightweight)

For loosely coupled flows:
- features emit events
- the App layer subscribes and coordinates reactions

This avoids tight coupling while keeping flows explicit.

---

## What features must NOT do

Features must not:
- import other feature modules
- perform app-level navigation decisions
- mutate global application state
- assume lifecycle ownership beyond their scope

Violations are treated as architectural regressions.

---

## Rationale

This approach ensures:
- clear ownership boundaries
- testable features in isolation
- predictable coordination logic
- freedom to evolve features independently

It aligns with the principle that **features describe behavior,
the App decides orchestration**.

---

## Testing implications

- Feature tests validate **local behavior only**
- Coordination logic is tested at the App level
- Mocks and fakes are injected via protocols

This avoids cross-feature test coupling.

---

## Consequences

### Positive
- features remain independent and replaceable
- navigation logic is centralized
- easier refactoring and deletion of features
- improved onboarding clarity

### Trade-offs
- more explicit wiring in the App layer
- slightly more protocol definitions
- orchestration logic grows in one place

These trade-offs are accepted to preserve long-term modularity.
