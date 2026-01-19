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

## CoreNetworking

CoreNetworking is a framework-level networking module designed to provide
a consistent, testable, and debuggable foundation for all network communication
across the application.

### Architecture

CoreNetworking is built around a small and explicit API surface that clearly
separates request description, request construction, execution, and response
decoding.

The primary goal is to ensure that feature modules focus on *what* they want
to request, not *how* networking is performed.

#### Core abstractions

- **Endpoint<Response>**  
  Describes an HTTP request together with its expected response type.
  An endpoint defines the HTTP method, path, headers, query/body parameters,
  and decoding strategy.

- **RequestBuilder**  
  Responsible for transforming an `Endpoint` into a concrete `URLRequest`.
  This centralizes URL construction, headers, and encoding logic in a single place.

- **HTTPClient**  
  Executes requests and returns decoded responses.
  The client is agnostic of concrete request details and focuses on execution,
  validation, and decoding.

#### Execution flow

1. A feature defines an `Endpoint<Response>`
2. The endpoint is converted into a `URLRequest` via `RequestBuilder`
3. `HTTPClient` executes the request
4. The response is validated and decoded into the expected response type

This flow ensures a clear separation of concerns and prevents feature modules
from duplicating networking logic.

#### Dependency direction

Feature modules depend on CoreNetworking abstractions.

CoreNetworking does **not** depend on feature, domain, or UI layers.
This guarantees a clean dependency graph and keeps the networking layer
independent and reusable.

### Error handling

CoreNetworking preserves underlying errors to support debuggability in
production environments.

Low-level errors (e.g. decoding failures or request construction issues)
are surfaced without losing context, allowing higher layers to map them
to user-facing errors without sacrificing diagnostic information.

### Usage

```swift
let endpoint = LoginEndpoint(...)
let response = try await client.send(endpoint, using: builder)

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
1. ✅ Project bootstrap
2. ✅ Architecture vision and ADRs
3. ✅ CoreNetworking (SPM) baseline
4. ✅ CoreNetworking framework-level architecture
5. ⬜ First Feature module (Authentication)
6. ⬜ CI checks on PRs (xcodebuild test)

## How to run
Open `EnterpriseApp.xcodeproj` and run the app target.
