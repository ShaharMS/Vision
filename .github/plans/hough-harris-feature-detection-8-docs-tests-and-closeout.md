# Plan: Standardized Hough and Harris Feature Detection — Step 8: Docs, Tests, and Closeout

> **Status**: 🔲 Not started
> **Prerequisite**: [hough-harris-feature-detection-7-harris-corners-and-api.md](.github/plans/hough-harris-feature-detection-7-harris-corners-and-api.md)
> **Next**: None — this is the final step.
> **Parent**: [hough-harris-feature-detection-overview.md](.github/plans/hough-harris-feature-detection-overview.md)

## TL;DR

Close the plan by making the new detectors discoverable, documented, and durably covered. This step should leave behind stable public docs, demo coverage, registered suites, and inventory updates that match the new surfaces.

## Reference Pattern

[src/VisionMain.hx](src/VisionMain.hx) is the local demo surface for algorithm visualization, [tests/README.md](tests/README.md) documents the current test workflow, and [tests/src/tests/support/ManualSuites.hx](tests/src/tests/support/ManualSuites.hx) is the canonical suite registry.

In [src/VisionMain.hx](src/VisionMain.hx):
- Existing feature-detection demos already render line-detection outputs for manual inspection.

In [tests/README.md](tests/README.md):
- The repo has a clear contract for filtered `utest` runs and compile-only CI checks.

In [tests/src/tests/support/ManualSuites.hx](tests/src/tests/support/ManualSuites.hx):
- New suites must be registered directly in the authored manual test system.

## Steps

### 1. Refresh public docs and demos

Update the relevant sections in [src/vision/Vision.hx](src/vision/Vision.hx) and [src/VisionMain.hx](src/VisionMain.hx) so the new detectors are visible and easy to inspect locally.

Be explicit in docs about:

- standard Hough lines versus probabilistic line segments
- circle detection being a separate Hough family member
- Harris raw response versus extracted corners

### 2. Reconcile compatibility and legacy coverage

Decide whether [tests/src/tests/SimpleHoughTest.hx](tests/src/tests/SimpleHoughTest.hx) should remain as a compatibility suite, be renamed, or be superseded by new `Hough*` suites.

Whatever path is chosen, make the compatibility story explicit instead of leaving a stale legacy suite with ambiguous expectations.

### 3. Register all suites and update the manual inventory

Make sure all new or renamed suites are wired into:

- [tests/src/tests/support/ManualSuites.hx](tests/src/tests/support/ManualSuites.hx)
- [tests/src/tests/support/GeneratedSuites.hx](tests/src/tests/support/GeneratedSuites.hx) if still required by the authored setup
- [tests/catalog/manual-test-inventory.json](tests/catalog/manual-test-inventory.json) for new direct ownership surfaces

### 4. Run the narrowest meaningful regression set, then one broader compile check

Run the relevant filtered suites together first, then one compile-only local CI slice so the plan closes with executable evidence instead of doc-only confidence.

## Verification

- Filtered `haxe test.hxml` runs pass for all new Hough and Harris suites together
- `haxe tests/ci/local-ci.hxml` passes in compile-only mode for at least `interp,js`
- The manual suite registry and inventory reflect the new surfaces with no stale or missing references
- Public docs and demos no longer describe the standard Hough path as ray-based

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **Evidence to preserve** — final filtered test output, final compile-only output, and the final list of touched docs/suites/inventory files
- **Review focus** — stale documentation, stale suite registration, missing inventory ownership, and any remaining mismatch between algorithm behavior and user-facing wording
- **Commit guidance** — use a final docs/tests/inventory commit only if the implementation commits before it are already coherent and reviewable on their own
