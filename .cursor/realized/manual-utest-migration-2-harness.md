# Plan: Manual Utest Migration — Step 2: Build The Manual Harness

> **Status**: ✅ Completed
> **Prerequisite**: [manual-utest-migration-1-cutover.md](manual-utest-migration-1-cutover.md)
> **Next**: [manual-utest-migration-3-tools-and-core-ds.md](manual-utest-migration-3-tools-and-core-ds.md)
> **Parent**: [manual-utest-migration-overview.md](manual-utest-migration-overview.md)

## TL;DR

Turn the promoted runner into a real manual test harness: central suite registration, reusable assertion and fixture helpers, and deterministic suite and case filtering that VS Code can drive. This step makes per-class and per-member execution practical before the bulk of the test rewrite begins.

## Reference Pattern

In [../../tests/generated/src/Main.hx](../../tests/generated/src/Main.hx):
- Preserve the current environment and CLI filtering pattern.
- Preserve the explicit `runner.addCase(new <Suite>())` ownership model.

In [../../tests/generated/src/tests/support/Factories.hx](../../tests/generated/src/tests/support/Factories.hx):
- Preserve reusable image factories instead of duplicating inline fixture setup.

In [../../tests/generated/src/tests/FromBytesTest.hx](../../tests/generated/src/tests/FromBytesTest.hx):
- Preserve the `test_<member>__<scenario>` naming convention because it maps cleanly to member-level filters.

## Steps

### 1. Add suite-level and case-level filtering

Extend `tests/src/Main.hx` so it can select both full suites and individual test methods.

Keep suite selection via `VISION_TESTS`, `VISION_TEST_CLASSES`, or `--tests`, and add a case filter such as `VISION_TEST_CASES` or `--cases`. Use `utest.Runner.addCase(..., ?pattern:EReg)` so filtering is driven by `Runner` rather than fragile reflection.

```haxe
var pattern:EReg = caseFilter != null ? new EReg(caseFilter, "") : null;
runner.addCase(new ArrayToolsTest(), "setup", "teardown", "test", pattern);
```

### 2. Centralize suite registration

Create a small authored registry module, for example `tests/src/tests/support/ManualSuites.hx`, that owns `runner.addCase(new ...)` calls.

This keeps the manual runner short and gives later migration steps one place to add or remove test classes as coverage grows.

### 3. Add reusable support helpers

Create or expand manual helper modules under `tests/src/tests/support` for:

- image comparisons and invariants
- numeric approximate equality
- exception assertions
- common test fixtures beyond the existing `Factories`

Favor helpers over repeated inline logic so later suites stay readable and easier to audit.

### 4. Add VS Code-friendly entrypoints

Preserve `.vscode/settings.json` with `test.hxml` and `test-adapter`, and add `.vscode/tasks.json` tasks or inputs for:

- running the full suite
- running one suite by class name
- running one member pattern
- running the current file's suite when the file name matches `*Test.hx`

Document the filter format in `tests/README.md` so the runner contract is visible outside chat history.

## Verification

- `haxe test.hxml -- --tests ArrayToolsTest` runs a single suite.
- A case-filtered command such as `haxe test.hxml -- --tests ImageTest --cases test_getPixel__outOfBounds` runs only matching methods.
- VS Code Test Explorer still discovers the suite from `test.hxml`.
- At least one helper module under `tests/src/tests/support` is used by an authored test file.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-utest-migration`
- **Evidence to preserve** — A sample filtered suite run, a sample filtered case run, and the exact filter syntax documented in `tests/README.md`.
- **Review focus** — Ensure filtering is deterministic and does not rely on generated metadata or generated registries.
- **Commit guidance** — Keep runner/filtering support and VS Code task wiring together; helper module growth can happen in the same commit only if it is directly required for the filter implementation.