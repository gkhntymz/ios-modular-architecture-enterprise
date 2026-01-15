# ADR-001: Why Modular Architecture?

- Status: Accepted
- Date: 2026-01-14

## Context
As an iOS codebase grows, teams face:
- increasing build times and merge conflicts
- unclear ownership boundaries (features touching shared code)
- fragile dependencies and unintended side effects
- reduced testability (tight coupling, difficult mocking)
- slower onboarding (hard to find where logic lives)

We want an architecture that supports scaling:
- codebase size
- team size
- release cadence
- reliability expectations (enterprise constraints)

## Decision
Adopt a **feature-based modular architecture** using **Swift Package Manager (SPM)**.

Structure:
- `App` as composition root
- `Core/*` for cross-cutting capabilities (Networking, Security, Persistence, Observability, etc.)
- `Features/*` as isolated feature modules (e.g., Authentication, Subscription)
- optional shared UI primitives (DesignSystem)

## Dependency Rules
1. `App` can depend on `Core/*` and `Features/*`.
2. `Features/*` can depend on `Core/*` and their own internal targets.
3. `Core/*` must not depend on `Features/*`.
4. Feature-to-feature direct dependencies are discouraged. Prefer:
   - protocols in `Core` or a dedicated `CoreInterfaces`
   - events/actions via a routing layer in `App`
   - dependency inversion (feature exposes interfaces, app composes)

## Consequences
### Positive
- clearer ownership and boundaries
- improved testability (modules can be tested in isolation)
- safer refactoring (explicit dependency graph)
- easier parallel work across teams
- potential build performance improvements

### Negative / Trade-offs
- additional up-front structure and ceremony
- dependency management requires discipline
- more targets/modules can increase initial configuration work

## Alternatives considered
1. **Single module (monolith)**
   - Pros: simpler at first
   - Cons: scales poorly for team/codebase growth

2. **Git submodules / multi-repo**
   - Pros: stronger separation
   - Cons: operational overhead; not needed for this portfolio baseline

3. **Framework targets (Xcode) instead of SPM**
   - Pros: classic approach; flexible
   - Cons: heavier Xcode configuration; less portable module boundaries

## Notes
This ADR focuses on structural modularity. Patterns like MVVM/Coordinator are secondary
and will be documented in separate ADRs as they are introduced.
