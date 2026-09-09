---
name: vision-tests
description: Run and audit the Vision Haxe utest suite. Use when asked to run tests, verify changes, check CI parity, filter suites, or understand test layout and coverage inventory.
---

# Vision test suite

## Prerequisites

- Haxe 4.x on PATH (`haxe --version`)
- Run all commands from the **repo root**
- Dependencies resolve via haxelib (`vision`, `format`, `utest` — declared in `test.hxml`)

## Run tests

### Full behavioral suite (default)

```powershell
haxe test.hxml
```

Interp target; compiles `tests/src/Main.hx` and runs all registered suites. Success ends with `All tests passed!` and a total count.

### Filter by suite (Windows — prefer env vars)

Direct CLI passthrough (`haxe test.hxml -- --tests Foo`) fails on this Windows Haxe build. Use env vars:

```powershell
$env:VISION_TEST_CASES=''
$env:VISION_TESTS='ArrayToolsTest'
haxe test.hxml
```

### Filter by test method pattern

```powershell
$env:VISION_TESTS='FromBytesTest'
$env:VISION_TEST_CASES='test_png__invalidHeaderThrows'
haxe test.hxml
```

Clear `VISION_TEST_CASES` before suite-only reruns in persistent shells.

### Multi-target compile CI (mirrors GitHub Actions)

```powershell
haxe tests/ci/local-ci.hxml --
```

Narrow / faster slice:

```powershell
$env:VISION_CI_TARGETS='interp,js'
$env:VISION_CI_SKIP_INSTALL='1'
haxe tests/ci/local-ci.hxml
```

Compile-only (no test execution):

```powershell
$env:VISION_CI_COMPILE_ONLY='1'
$env:VISION_CI_TARGETS='interp,js'
haxe tests/ci/local-ci.hxml
```

### Library compile check

```powershell
haxe compile.hxml
```

## What to run when

| Change scope | Command |
|--------------|---------|
| Algorithm / ds / tool logic | `haxe test.hxml` with `VISION_TESTS` set to the owning `*Test` class |
| New or edited test file | Same filtered run, then full `haxe test.hxml` before closeout |
| Cross-target / macro / typing | `haxe tests/ci/local-ci.hxml -- --targets=interp,js` (or plan-specified targets) |
| Public API surface only | Owning suite + `haxe compile.hxml` |

## Audit test layout

| Path | Role |
|------|------|
| `tests/README.md` | Canonical workflow and commands |
| `tests/src/tests/` | Authored `utest.Test` subclasses (`{Module}Test`) |
| `tests/src/tests/support/ManualSuites.hx` | Suite registry — new suites must be registered here |
| `tests/catalog/manual-test-inventory.json` | Coverage contract (`manual` vs `excluded`, deferred members) |
| `tests/ci/README.md` | Local CI targets, env vars, platform skips |
| `.cursor/rules/haxe-testing.mdc` | Naming, metadata, fixture helpers |

### Adding coverage checklist

1. Add/update suite under `tests/src/tests/`
2. Register in `ManualSuites.hx` (keep `GeneratedSuites.hx` aligned if needed)
3. Method names: `test_<member>__<scenario>`
4. `@:visionTestId("module.member#scenario")` on each method
5. Update `manual-test-inventory.json` when ownership or exclusions change

### Fixture helpers (prefer over one-offs)

`AlgorithmFixtures`, `Factories`, `ImageAssertions`, `ApproxAssertions`, `ExceptionAssertions`, `FormatAssertions` in `tests/src/tests/support/`.

## Interpreting output

- Exit code `0` + `All tests passed!` → success
- Deprecation warnings in output are expected for some legacy API tests; they do not fail the run
- Failure shows `[FAIL]` with assertion details from `utest.Assert`

## Further reading

- [tests/README.md](../../../tests/README.md) — full command reference
- [tests/ci/README.md](../../../tests/ci/README.md) — multi-target CI runner
