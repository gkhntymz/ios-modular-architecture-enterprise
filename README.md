# iOS Modular Architecture (Enterprise)

A portfolio-grade, enterprise-style iOS codebase demonstrating:
- Feature-based modularization (SPM)
- Clear dependency boundaries
- Testability-first design
- Concurrency correctness
- Architectural Decision Records (ADRs)

> Goal: provide a realistic foundation for scaling an iOS app and team.

## Why this repository exists
Most sample apps optimize for “demo speed”. This repository optimizes for:
- maintainability at scale
- explicit architectural trade-offs
- clean module boundaries
- predictable testing strategy

## High-level architecture
**Layers**
- **App**: composition root, routing bootstrap
- **Core**: cross-cutting capabilities (Networking, Persistence, Security, Observability, etc.)
- **Features**: isolated feature modules (Authentication, Subscription, Profile, etc.)
- **Shared UI** (optional): design system and reusable UI primitives

**Dependency direction (rule)**
`App → Features → Core`  
`Core` must not depend on `Features`.  
`Features` must not depend on each other directly (prefer protocols/events).

## Module strategy
We use **Swift Package Manager (SPM)** for modules to:
- enforce boundaries via explicit dependencies
- keep modules portable and testable
- reduce coupling with Xcode project settings

## Testing strategy (baseline)
- Unit tests per module (fast feedback)
- Minimal integration tests for critical seams (later)
- CI will run `xcodebuild test` on PRs (planned)

## ADRs
Architecture decisions are documented in:
- `docs/adr/`

Start here:
- `docs/adr/ADR-001-why-modular-architecture.md`

## Roadmap
1. ✅ Project bootstrap (done)
2. ⬜ README + Architecture Vision
3. ⬜ ADR-001: Why modular architecture?
4. ⬜ Introduce first Core module via SPM (CoreNetworking)
5. ⬜ Introduce first Feature module (Authentication)
6. ⬜ CI checks on PRs (xcodebuild test)

## How to run
Open `EnterpriseApp.xcodeproj` and run the app target.
