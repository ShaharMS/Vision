# Vision Tests

The repository now uses one authored `utest` suite rooted at `tests/src`.

The old generator pipeline, checked-in generated tree, and generator-specific hxml entrypoints were removed during the manual migration closeout. If you need to expand coverage, do it by editing the authored tests directly.

The forward-looking maintenance notes live in [ROADMAP.md](ROADMAP.md).

## Directory Roles

- `tests/src/Main.hx`
  - Manual test runner used by `test.hxml` and local filtered runs.
- `tests/src/PrettyReporter.hx`
  - Custom reporter used by the manual runner.
- `tests/src/tests/*`
  - Authored suites, one `utest.Test` class per source module when direct suite ownership exists.
- `tests/src/tests/support/*`
  - Shared fixtures, assertions, and suite registration helpers.
- `tests/src/tests/support/ManualSuites.hx`
  - Canonical suite registry for full, suite-filtered, and case-filtered runs.
- `tests/ci/LocalCi.hx`
  - Multi-target compile or run harness that mirrors CI behavior.
- `tests/catalog/manual-test-inventory.json`
  - Authoritative coverage inventory for the manual suite.

## Default Commands

Run the full suite from the repo root:

```powershell
haxe test.hxml
```

Run a filtered suite in the PowerShell environment used locally here:

```powershell
$env:VISION_TEST_CASES=''
$env:VISION_TESTS='ArrayToolsTest'
haxe test.hxml
```

Run a filtered case pattern:

```powershell
$env:VISION_TESTS='FromBytesTest'
$env:VISION_TEST_CASES='test_png__invalidHeaderThrows'
haxe test.hxml
```

Run the Local CI compile-only harness for a narrow target slice:

```powershell
$env:VISION_CI_TARGETS='interp,js'
$env:VISION_CI_COMPILE_ONLY='1'
$env:VISION_CI_SKIP_INSTALL='1'
haxe tests/ci/local-ci.hxml
```

Notes:

- On this Windows Haxe build, direct passthrough commands such as `haxe test.hxml -- --tests ArrayToolsTest` still fail before `Main` runs. Use the environment-variable fallback locally.
- In persistent PowerShell sessions, clear `VISION_TEST_CASES` before suite-only reruns so stale case filters do not collapse discovery to zero tests.

## Adding Or Updating Coverage

When a source module changes, keep the manual suite and the inventory in sync.

1. Add or update the authored suite under `tests/src/tests`.
2. Register any new suite in `tests/src/tests/support/ManualSuites.hx`.
3. Name test methods as `test_<member>__<scenario>` when practical.
4. Add `@:visionTestId("<module>.<member>#<scenario>")` metadata so the inventory has explicit member ownership evidence.
5. Update `tests/catalog/manual-test-inventory.json` if direct member ownership or exclusion rationale changes.

## Inventory Contract

`tests/catalog/manual-test-inventory.json` is the source-controlled contract for what the manual system owns.

- `status = manual`
  - The module is owned by the authored `tests/src` suite.
- `status = excluded`
  - The declaration surface is intentionally outside direct manual-suite ownership.
- `deferredMembers`
  - Public members intentionally excluded from direct member-level ownership in the final manual system.
  - The module `notes` field explains the rationale for those exclusions.

Direct exclusions are used for a few recurring cases:

- metadata-only declarations such as enum-like catalogs
- target-specific conversion shims
- facade wrappers already exercised through lower-level suites
- constructors or iterator helpers that are exercised indirectly by consuming scenarios

## Decommissioned Surfaces

These are no longer part of the repository workflow:

- `tests/generator/**`
- `tests/generated/**`
- `tests/config.json`
- `tests/compile.hxml`
- generator-owned catalog reports such as `tests/catalog/test-manifest.json`

Do not recreate those paths as part of routine test maintenance. The supported path is the authored suite under `tests/src` plus the checked-in manual inventory.
