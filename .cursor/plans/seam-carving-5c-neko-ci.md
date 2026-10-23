# Plan: Release audit - Neko module loading

> Status: Completed
> Parent: [overview](seam-carving-overview.md)

## TL;DR

Neko rejects unreachable image-heavy functions retained by default DCE. Compile the existing Neko batches with full dead-code elimination, retain seam behavior tests and register them only in batch 1.

## Reference Pattern

Existing Neko batch handling in tests/ci/LocalCi.hx, .github/workflows/main.yml and ManualSuites.hx.

## Steps

### 1. Align local and remote Neko compile flags

Use -dce full in both Neko batch compilers.

### 2. Verify real runtime execution

Run all eight Neko batches and assert focused seam tests pass.

## Verification

Focused six seam tests pass on Neko with -dce full. Full eight-batch run required before closeout.

Evidence: All eight local Neko batches pass with full DCE, including all six seam tests.
