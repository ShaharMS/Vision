# Plan: CI Portability Recovery — Step 2: Portable Format Assertions

> **Status**: ✅ Completed
> **Prerequisite**: [Step 1](ci-portability-recovery-1-thread-fallback.md)
> **Next**: [Step 3](ci-portability-recovery-3-neko-test-partition.md)
> **Parent**: [ci-portability-recovery-overview.md](ci-portability-recovery-overview.md)

## TL;DR

Keep semantic color and image-format coverage while removing assumptions that only hold for signed 32-bit integers or platforms with a PNG encoder.

## Iteration Bootstrap

- **Iteration slug**: `ci-portability-recovery-2-portable-format-assertions`
- **Required evidence**: Python runs compare colors by channels and account for unavailable PNG encoding.
- **Artifacts to verify**: `ColorTest`, format suites, Python target run.

## Reference Pattern

In `tests/src/tests/support/ImageAssertions.hx`:
- `colorEquals` compares portable ARGB channels.

## Steps

### 1. Normalize test-only color equality

In `tests/src/tests/support/ColorAssertions.hx` and its consumers, compare packed colors through their ARGB channels.

### 2. Make unavailable PNG encoding explicit

In format tests, gate unsupported Python PNG encode/round-trip assertions and assert the documented failure where appropriate.

## Verification

- Filtered interpreter color and format suites
- Python feature and portability suite run
