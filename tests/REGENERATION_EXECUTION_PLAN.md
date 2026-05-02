# Manual Test Maintenance Plan

Date: 2026-05-02

The old regeneration workflow is retired. This file remains in place only so historical links keep resolving.

## Supported Workflow

When you need to extend coverage now:

1. Edit or add the authored suite under `tests/src/tests`.
2. Register any new suite in `tests/src/tests/support/ManualSuites.hx`.
3. Add `@:visionTestId("<module>.<member>#<scenario>")` metadata for direct member ownership.
4. Update `tests/catalog/manual-test-inventory.json` if coverage ownership or exclusion rationale changes.
5. Run the narrowest relevant validation first, then the normal repo entrypoints:
   - `haxe test.hxml`
   - one suite-filtered run via `VISION_TESTS`
   - one case-filtered run via `VISION_TEST_CASES`
   - `haxe tests/ci/local-ci.hxml` for the relevant compile or run slice

## Unsupported Workflow

Do not reintroduce or rely on any of the following:

- `tests/generator/**`
- `tests/generated/**`
- `tests/config.json`
- `tests/compile.hxml`
- `BuildMacro.generateAll()`

If a future redesign wants generated support again, that work should start from a new plan and new owned paths rather than reviving the removed migration-era surface.
