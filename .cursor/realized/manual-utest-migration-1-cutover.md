# Plan: Manual Utest Migration — Step 1: Cut Over The Execution Path

> **Status**: ✅ Completed
> **Prerequisite**: None — this is the first step.
> **Next**: [manual-utest-migration-2-harness.md](manual-utest-migration-2-harness.md)
> **Parent**: [manual-utest-migration-overview.md](manual-utest-migration-overview.md)

## TL;DR

Establish an authored `tests/src` tree and move all operational entrypoints to it before rewriting large numbers of tests. This gives later migration steps one stable home and makes the generator path inactive without deleting potentially useful reference material too early.

## Reference Pattern

The new manual tree should preserve the operational parts of the current checked-in suite while dropping generated ownership.

In [../../tests/generated/src/Main.hx](../../tests/generated/src/Main.hx):
- Preserve the current `VISION_TESTS` and `--tests` filter flow.
- Preserve `PrettyReporter` wiring and the explicit `Runner` entrypoint.

In [../../test.hxml](../../test.hxml):
- Preserve the minimal repo-root test command that VS Code and developers already use.

In [../../tests/ci/LocalCi.hx](../../tests/ci/LocalCi.hx):
- Preserve the multi-target harness role and its explicit class-path ownership.

## Steps

### 1. Create the authored test root

Add `tests/src` as the new owned test source root and promote the current operational surfaces into it:

- `tests/src/Main.hx`
- `tests/src/PrettyReporter.hx`
- `tests/src/tests/support/*`

Start by copying the committed implementations from `tests/generated/src` so behavior stays stable while ownership changes. Strip generated-file stamps and any "do not edit" messaging during promotion.

### 2. Repoint all execution entrypoints to `tests/src`

Update the files that define day-to-day execution so they compile the new authored tree instead of `tests/generated/src`:

- `test.hxml`
- `tests/ci/LocalCi.hx`
- `.github/workflows/main.yml`
- any repo docs that still describe `tests/generated/src` as the operational suite

The result should be: repo root test runs, local CI, and VS Code all compile `tests/src` by default.

### 3. Add a checked-in migration inventory

Create a manifest such as `tests/catalog/manual-test-inventory.json` that maps every module under `src/vision` to:

- its owned test file
- discovered public members that require coverage
- uncovered or deferred members
- an ownership status such as `manual`, `needs-migration`, or `excluded`

Use the current source tree and existing test files to seed the inventory; later steps should update it as suites become fully manual and semantic.

```json
{
  "vision.tools.ArrayTools": {
    "testFile": "tests/src/tests/ArrayToolsTest.hx",
    "members": ["flatten", "raise", "min", "max", "average", "median", "distanceTo", "flatMap", "distinct"],
    "status": "needs-migration"
  }
}
```

### 4. Freeze the old auto path

Stop treating `tests/generated` and `tests/compile.hxml` as part of the normal execution path. Update docs to mark them as temporary migration references only, and remove any workflow or local command that still depends on generator output.

Do not delete the old tree in this step; keep it available for diffing while the manual suite is still being rewritten.

## Verification

- `haxe test.hxml` runs from repo root against `tests/src`.
- `haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only` compiles the new root.
- No default workflow or repo-local command still points at `tests/generated/src`.
- `tests/catalog/manual-test-inventory.json` exists and lists every `src/vision/**/*.hx` module with an explicit status.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-utest-migration`
- **Evidence to preserve** — Diff showing `test.hxml`, `tests/ci/LocalCi.hx`, and workflow commands moved to `tests/src`, plus a sample inventory entry for at least one migrated and one unmigrated module.
- **Review focus** — Ensure the new tree is authoritative immediately; do not leave a hidden compile path that still uses generated sources.
- **Commit guidance** — Keep tree cutover and inventory creation in one commit; leave test-body rewrites for later commits.