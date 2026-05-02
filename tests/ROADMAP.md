# Vision Test Roadmap

The generator-backed test system is gone. The supported direction is a maintained manual suite under `tests/src` plus an authoritative checked-in inventory at `tests/catalog/manual-test-inventory.json`.

This roadmap is now about keeping that manual system healthy instead of replacing it.

## Current State

- `test.hxml` and `tests/ci/LocalCi.hx` compile the authored suite under `tests/src`.
- `tests/catalog/manual-test-inventory.json` records direct suite ownership and explicit exclusion rationale.
- Generated-tree artifacts, generator entrypoints, and generator-owned catalogs are no longer part of the repository workflow.

## Maintenance Priorities

### 1. Prefer direct member ownership when new work touches a module

When editing a source module or its test suite:

1. Add or strengthen the authored tests in `tests/src/tests`.
2. Add `@:visionTestId` metadata for the owned members.
3. Remove the corresponding member names from `deferredMembers` when direct ownership becomes explicit.

### 2. Keep explicit exclusions narrow and documented

`deferredMembers` is now the inventory of direct member-level exclusions, not a placeholder for a future generator pass.

When an exclusion remains, document why it is intentional. Typical reasons are:

- metadata-only declarations
- target-gated adapter shims
- facade wrappers already exercised through lower-level suites
- constructor or iterator wiring exercised only through consuming scenarios

### 3. Keep the filtered-run workflow stable

The manual runner depends on deterministic suite and case filtering. Changes to `tests/src/Main.hx` or `tests/src/tests/support/ManualSuites.hx` should preserve:

- `VISION_TESTS` suite filtering
- `VISION_TEST_CASES` regex case filtering
- the PowerShell env-var fallback used on this Windows Haxe build

### 4. Keep Local CI representative

`tests/ci/LocalCi.hx` is the lightweight proof that the authored suite still compiles across representative targets. Prefer fixing drift in that harness instead of adding new one-off compile scripts.

## Working Rules For New Test Work

- One suite per source module when direct ownership is intended.
- Prefer exact, semantic assertions over smoke checks.
- Use shared helpers in `tests/src/tests/support` instead of duplicating fixtures or assertion utilities.
- Update the inventory in the same change whenever ownership or exclusion rationale changes.

## Remaining Long-Tail Cleanup

The manual inventory still contains explicit direct-ownership exclusions for some broad surfaces such as `vision.Vision`, `vision.ds.Image`, and the large `vision.ds.Color` constant catalog.

When future work touches those modules, prefer shrinking those exclusions incrementally instead of attempting another broad migration campaign.
