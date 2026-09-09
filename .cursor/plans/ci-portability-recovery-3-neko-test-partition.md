# Plan: CI Portability Recovery — Step 3: Neko Test Partition

> **Status**: 🔲 Not started
> **Prerequisite**: [Step 2](ci-portability-recovery-2-portable-format-assertions.md)
> **Next**: None — final step.
> **Parent**: [ci-portability-recovery-overview.md](ci-portability-recovery-overview.md)

## TL;DR

Run the entire Neko suite in deterministic batches if its generated single-program test harness exceeds Neko's function-scope stack limit.

## Iteration Bootstrap

- **Iteration slug**: `ci-portability-recovery-3-neko-test-partition`
- **Required evidence**: all Neko batches compile and run, with no omitted suite.
- **Artifacts to verify**: Neko target commands and `.github/workflows/main.yml`.

## Reference Pattern

In `tests/src/tests/support/ManualSuites.hx`:
- Registration is centralized and controlled by `includeTest`.

## Steps

### 1. Add compile-time Neko batch selection

In the test registration layer, select a disjoint batch only for Neko builds while retaining the normal all-suite behavior elsewhere.

### 2. Execute every batch in CI

In `.github/workflows/main.yml`, compile and run each Neko batch under the existing Neko matrix lane.

## Verification

- Each Neko batch compiles and runs locally
- Fresh GitHub Neko job passes
