# ADR-010: Preview / Demo App Strategy (Portfolio & Debug Builds)

- Status: Accepted
- Date: 2026-01-27

## Context

This repository is intended to serve both as:
- a realistic enterprise-style iOS codebase
- a portfolio and communication artifact

In real-world iOS projects, developers often need:
- isolated previews of features
- lightweight demo environments
- fast feedback without running the full application
- safe experimentation without affecting production flows

Relying solely on the main App target for development, previews, and demos
creates friction:
- slow iteration cycles
- tightly coupled UI previews
- difficulty showcasing individual features
- risk of preview/debug code leaking into production

A clear strategy is required to support previews and demos without compromising
architecture or production quality.

---

## Decision

We adopt a **dedicated Preview / Demo App strategy** that separates:
- production application logic
- development-time previews
- portfolio/demo use cases

### Core principles

- Preview and demo code must not pollute production App logic
- Feature modules must remain previewable in isolation
- Composition stays centralized and explicit
- Debug/demo tooling is opt-in and environment-scoped

---

## Strategy

### 1. Feature-level previews

Each Feature module may expose:
- SwiftUI previews
- lightweight UIKit demo views
- mock data and stub implementations

Rules:
- Previews live **inside the Feature module**
- Use mock Core dependencies
- No access to App-level routing or global state

This ensures:
- fast iteration
- feature isolation
- reusable previews across apps

---

### 2. Dedicated Demo / Preview App target (optional)

The repository may include a separate app target, e.g.:

EnterpriseDemoApp

Purpose:
- showcase features in isolation
- support portfolio screenshots and recordings
- validate feature composition without production constraints

Characteristics:
- depends on Feature and Core modules
- uses mock or demo implementations
- no production backend or secrets
- not shipped to users
- excluded from release and CI production pipelines

---

### 3. Build configuration separation

Preview and demo behavior is gated by:
- build configurations (Debug / Demo / Release)
- compiler flags
- environment-specific dependency injection

Production code paths remain clean and deterministic.

---

## Dependency rules

- Preview / Demo code may depend on:
  - Feature modules
  - Core abstractions
- Production App code must not depend on:
  - demo-only utilities
  - preview-only mocks

The dependency flow remains unchanged:

App → Features → Core

---

## Testing implications

- Preview and demo code is excluded from:
  - production builds
  - production test coverage requirements
- Core and Feature tests remain environment-agnostic
- Demo apps may include lightweight smoke tests only

---

## CI implications

CI focuses on:
- Core and Feature correctness
- App build and test validity

Preview and Demo apps:
- may be excluded from CI
- or built without running tests
- are never required for merge approval

---

## Consequences

### Positive
- faster development feedback loops
- clean separation of concerns
- improved portfolio clarity
- safer experimentation
- better feature isolation

### Trade-offs
- additional targets and configuration
- more explicit dependency wiring
- slightly higher setup complexity

These trade-offs are accepted to preserve architectural clarity
and professional-grade development workflows.

---

## Notes

This strategy mirrors common enterprise practices:
- internal demo apps
- feature playgrounds
- debug-only compositions

It balances developer productivity with long-term maintainability.
