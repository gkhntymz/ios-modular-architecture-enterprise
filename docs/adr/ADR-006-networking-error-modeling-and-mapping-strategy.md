# ADR-006: Networking Error Modeling and Mapping Strategy

- Status: Proposed
- Date: 2026-01-27

## Context

Networking failures are inevitable in production (timeouts, no connection, server errors,
decoding issues, unexpected status codes). If errors are modeled poorly:

- features implement inconsistent error handling
- user-facing messages become unpredictable
- observability suffers (hard to debug real incidents)
- tests become fragile (string matching / ad-hoc mapping)

This repository uses a modular architecture:
- `CoreNetworking` owns low-level transport and decoding
- `App` and/or Features own user-facing error semantics

We need a clear strategy for:
- how errors are represented in CoreNetworking
- how those errors are mapped to app/feature domain errors
- what is considered stable API vs internal detail

---

## Decision

### 1) CoreNetworking exposes structured, diagnostic-friendly errors

`CoreNetworking` defines a small set of error types that retain context.

Principles:
- never lose the underlying error
- keep error surface area small and consistent
- include status code / decoding context where relevant
- do not leak UI or feature domain semantics into CoreNetworking

Recommended model (example names):

- `HTTPClientError`
  - `.unacceptableStatusCode(Int, data: Data?)`
  - `.transport(URLError)` (or `.network(URLError)`)
  - `.decoding(DecodingError, data: Data?)`
  - `.requestConstruction(Error)`
  - `.cancelled`
  - `.unknown(Error)`

Notes:
- include `Data?` only when it helps debugging and can be safely retained
- avoid storing large bodies; consider truncation / redaction if needed (future ADR)

---

### 2) Mapping to app/feature errors happens outside CoreNetworking

`App` (composition root) or Features define user-facing error enums, e.g.:

- `AppNetworkError` (or `DomainNetworkError`)
  - `.unauthorized`
  - `.forbidden`
  - `.notFound`
  - `.serverError`
  - `.timeout`
  - `.offline`
  - `.cancelled`
  - `.unexpected`
  - `.decoding`
  - `.unknown`

Mapping rules:
- `HTTPClientError` → `AppNetworkError` is a pure function
- mapping is deterministic and unit-tested
- CoreNetworking stays reusable across different apps/features

---

### 3) Status code semantics are centralized

Status codes are mapped in one place (App or shared domain layer), not scattered.

Example:
- `401` → `.unauthorized`
- `403` → `.forbidden`
- `404` → `.notFound`
- `408` or `URLError.timedOut` → `.timeout`
- `>= 500` → `.serverError`
- others → `.unexpected`

This reduces duplicated logic and makes behavior easy to audit.

---

### 4) Observability is handled via CoreLogging + interceptors

CoreNetworking errors retain enough information for:
- logging
- metrics
- debugging

Interceptors (e.g. `LoggingInterceptor`) may:
- log request/response metadata
- redact sensitive headers/body
- classify transport errors for metrics

But interceptors must not:
- transform errors into user-facing domain errors
- depend on App or Features

---

## Rationale

- **Separation of concerns:** CoreNetworking focuses on HTTP mechanics and diagnostics.
- **Stability:** A small, structured error API is easier to maintain.
- **Consistency:** Mapping in one place prevents drift.
- **Testability:** Both CoreNetworking and mapping logic can be tested independently.
- **Enterprise readiness:** Better debugging, monitoring, and predictable user experience.

---

## Consequences

### Positive
- consistent error handling across the codebase
- easier debugging in production incidents
- clean module boundaries (Core vs App/Feature semantics)
- straightforward unit testing for mapping rules

### Trade-offs
- requires an explicit mapping layer
- some duplication of concepts (transport vs domain errors)
- decisions needed on how much response data to retain/log

---

## Implementation notes

- CoreNetworking keeps `HTTPClientError` and related structures public.
- App defines `AppNetworkError` and `map(_:)` function.
- Tests:
  - CoreNetworking tests cover error generation cases
  - App tests cover mapping rules (e.g. 401 → unauthorized)

---

## Follow-ups

- ADR for logging/redaction policy (what is safe to log, truncation rules)
- ADR for retry policy and idempotency strategy
- ADR for HTTP status code policy (which codes are handled explicitly)
