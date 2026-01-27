# ADR-004: CI Pipeline and Branch Protection Ruleset

- Status: Accepted
- Date: 2026-01-27

## Context

As the repository grows, the main risks become:

- broken builds reaching `main`
- tests passing locally but failing in clean environments
- dependency boundary regressions going unnoticed
- “works on my machine” drift
- unreviewed changes landing directly on the default branch

To keep the project portfolio-grade and enterprise-like, we want a workflow that:
- validates changes automatically
- makes failures actionable
- requires checks before merging
- reflects a real team’s development process

---

## Decision

We adopt a GitHub Actions CI workflow and protect `main` via GitHub Rulesets.

### CI principles

- CI runs on every Pull Request targeting `main` and on pushes to `main`.
- CI is designed to fail fast and produce readable logs.
- CI verifies both:
  - Swift Package tests (`swift test`)
  - App-level build and tests (`xcodebuild` on iOS Simulator)

### Branch protection principles

- Direct pushes to `main` are disallowed (changes must land via PR).
- Required status checks must pass before merging.
- Branch must be up to date with `main` before merging (“merge queue” style safety).
- (Optional) Administrators are included when the repository supports it.

---

## CI workflow design

The pipeline is intentionally split into clear responsibilities:

### 1) SPM tests job

Runs unit tests for all Swift Packages independently:

- `Packages/CoreLogging`
- `Packages/CoreNetworking`
- `Packages/FeatureAuthentication`
- (future modules…)

Rationale:
- fast feedback
- detects hidden coupling between packages
- keeps module tests portable and deterministic

### 2) App build job

Builds the `EnterpriseApp` scheme (no tests):

Rationale:
- detects project-level configuration and linker issues
- validates the composition root and package wiring
- catches issues that SPM tests cannot (e.g., storyboard build, app target linking)

### 3) App tests job

Runs unit + UI tests for the app:

Rationale:
- validates integration boundaries
- ensures app-level tests remain healthy
- acts as end-to-end safety net

---

## Logging and developer experience

To keep CI output readable and diagnosable:

- `xcodebuild` output should be piped into a formatter when available
  (e.g. `xcpretty` or `xcbeautify`)
- test output should include failures with context
- Result bundles can be captured when needed for debugging

---

## Caching strategy

We use caching primarily to improve CI runtime:

- SPM build artifacts / derived package data
- DerivedData (selectively, if stable)

Notes:
- Cache keys include OS and resolved package state to avoid stale caches.
- Cache restores are treated as optimization; CI correctness must not depend on cache hits.

---

## Enforcement mechanism

These rules are enforced via GitHub’s native mechanisms:

- A Ruleset targets the `main` branch.
- The Ruleset requires CI checks to pass before merge.
- “Require branches to be up to date before merging” is enabled.

This ensures:
- CI is not optional
- merges happen from a known-good state
- regressions are caught early

---

## Consequences

### Positive

- `main` stays consistently green
- CI failures become actionable signals
- faster feedback via separated jobs and caching
- clearer governance: “PR + checks + merge”

### Trade-offs

- slightly more setup and maintenance
- CI time cost for contributors
- additional discipline required for ruleset management

These trade-offs are accepted to preserve long-term quality and predictability.
