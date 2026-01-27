# ADR-007: Logging and Redaction Strategy

- Status: Accepted
- Date: 2026-01-27

## Context

In an enterprise iOS application, logging serves multiple purposes:

- debugging during development
- diagnosing issues in production
- observability and incident analysis
- compliance with security and privacy requirements

Unstructured or ad-hoc logging leads to:
- inconsistent log formats
- accidental exposure of sensitive data
- noisy logs that reduce signal-to-noise ratio
- difficulty correlating logs across layers

This ADR defines a **structured logging strategy** with explicit rules
for **redaction of sensitive information**.

---

## Decision

The system adopts a **centralized, structured logging approach** with
mandatory redaction of sensitive data.

### Core principles

1. Logging is a **cross-cutting concern**, owned by Core modules
2. Sensitive data must **never** appear in logs
3. Redaction is enforced centrally, not left to feature authors
4. Features log intent and context, not raw data

---

## Logging architecture

### CoreLogging

All logging capabilities are provided by the `CoreLogging` module.

Responsibilities:
- log level definitions
- logger abstraction
- concrete logger implementations
- redaction mechanisms
- metrics sinks (where applicable)

Feature and App layers depend only on **logging abstractions**, not
concrete implementations.

---

### Logger abstraction

Logging is performed via a `Logger` protocol.

Characteristics:
- level-based logging (debug, info, warning, error)
- structured messages
- context-first logging (what happened, where, why)

Concrete implementations (e.g. `OSLogLogger`) live inside CoreLogging.

---

## Redaction strategy

### What must be redacted

The following data is considered sensitive and must never appear in logs:

- authentication tokens
- authorization headers
- session identifiers
- personally identifiable information (PII)
- payment or credential-related data

---

### Redaction enforcement

Redaction is applied **before logging**, using a dedicated `Redactor`
abstraction.

- Redaction rules are defined centrally
- Default redaction is applied automatically
- Feature modules cannot bypass redaction accidentally

Example responsibilities:
- removing or masking sensitive HTTP headers
- obfuscating request/response payload fields
- normalizing error output

---

### Why central redaction?

Leaving redaction to feature authors:
- is error-prone
- relies on discipline instead of enforcement
- increases security risk over time

Central redaction ensures:
- consistency
- safety by default
- easier auditing and evolution of rules

---

## Logging levels and intent

Logging levels are used intentionally:

- **Debug**
  - detailed information for local development
  - disabled or heavily sampled in production

- **Info**
  - high-level system events
  - lifecycle and state transitions

- **Warning**
  - recoverable issues
  - degraded behavior

- **Error**
  - failures requiring attention
  - includes contextual metadata (never raw data)

---

## Interaction with CoreNetworking

CoreNetworking integrates with CoreLogging to:

- log request lifecycle events
- record transport and decoding failures
- surface classified errors without leaking payloads

Networking logs:
- never include raw request bodies
- never include authorization headers
- rely on redaction before emission

---

## Consequences

### Positive

- consistent and predictable logging behavior
- reduced risk of sensitive data leakage
- improved debuggability and observability
- logging concerns isolated from feature logic

### Trade-offs

- additional abstraction layers
- slightly more upfront configuration
- less flexibility for ad-hoc logging

These trade-offs are accepted to ensure safety and maintainability
in a long-lived codebase.

---

## Notes

This ADR focuses on **logging structure and safety**.
Log aggregation, external observability tooling, and remote log shipping
are intentionally out of scope and may be addressed in future ADRs.
