# Implementation Handoff

## Current Pass

- Pass type: `implementation`
- Authoring agent: `@Implement`
- Plan step: `.github/plans/manual-utest-migration-2-harness.md`
- Branch: `feature/manual-utest-migration-1-cutover`
- Summary: `Built the manual harness for step 2 by moving suite registration into an authored registry, adding deterministic suite and case filtering in tests/src/Main.hx, introducing reusable support helpers plus an authored out-of-bounds ImageTest case, wiring VS Code tasks, and documenting the filter contract.`

## Files Changed

| Path | Intent | Verification impact |
|------|--------|---------------------|
| `tests/src/Main.hx` | `Parse suite and case filters from env or CLI and delegate suite registration to the authored registry.` | `Filtered suite run, filtered case run, and touched-file diagnostics` |
| `tests/src/tests/support/ManualSuites.hx` | `Centralize the curated runner.addCase(...) registry and apply an optional case EReg to every suite.` | `Filtered suite run, filtered case run, and touched-file diagnostics` |
| `tests/src/tests/support/ApproxAssertions.hx` | `Provide reusable numeric approximate-equality assertions for later authored suite rewrites.` | `Touched-file diagnostics` |
| `tests/src/tests/support/ExceptionAssertions.hx` | `Provide reusable exception assertions for authored tests.` | `Filtered case run and touched-file diagnostics` |
| `tests/src/tests/support/ImageAssertions.hx` | `Provide reusable image invariant helpers for authored tests.` | `Touched-file diagnostics` |
| `tests/src/tests/support/ManualFixtures.hx` | `Provide small authored fixture presets beyond the base Factories module.` | `Filtered case run and touched-file diagnostics` |
| `tests/src/tests/ImageTest.hx` | `Adopt the new helpers for a manual fixture/invariant path and add the authored test_getPixel__outOfBounds case used by the case-filter proof.` | `Filtered case run and touched-file diagnostics` |
| `tests/src/tests/FromBytesTest.hx` | `Replace repeated try/catch blocks with the new exception helper so authored suites start consuming shared support utilities.` | `Filtered suite run compile path and touched-file diagnostics` |
| `.vscode/tasks.json` | `Add VS Code-friendly full-suite, suite-only, case-pattern, and current-file entrypoints using the environment-variable filter path that works on this Windows Haxe build.` | `Task-file diagnostics and command-path parity with the verified env-var runs` |
| `tests/README.md` | `Document suite and case filter syntax, examples, and the local env-var fallback note for Haxe passthrough limitations.` | `README diagnostics and verification evidence reference` |

## Verification

| Check | Method | Result | Evidence |
|-------|--------|--------|----------|
| `Suite filter` | `$env:VISION_TESTS='ArrayToolsTest'; Remove-Item Env:VISION_TEST_CASES -ErrorAction SilentlyContinue; haxe test.hxml` | `passed` | `Only ArrayToolsTest methods executed, which proves tests/src/Main.hx and tests/src/tests/support/ManualSuites.hx deterministically limit the run to the selected suite on this Windows build via the documented env-var path.` |
| `Case filter` | `$env:VISION_TESTS='ImageTest'; $env:VISION_TEST_CASES='test_getPixel__outOfBounds'; haxe test.hxml` | `passed` | `Exactly one method ran: ImageTest.test_getPixel__outOfBounds. That proves the runner-level EReg case filter reaches utest.Runner.addCase(..., ?pattern) and does not execute neighboring ImageTest methods.` |
| `Touched-file diagnostics` | `get_errors on the edited Haxe, JSON, and Markdown files` | `passed` | `No errors were reported for tests/src/Main.hx, tests/src/tests/ImageTest.hx, tests/src/tests/FromBytesTest.hx, the new tests/src/tests/support helpers, .vscode/tasks.json, or tests/README.md.` |
| `VS Code entrypoint contract` | `Read .vscode/settings.json and validate .vscode/tasks.json` | `passed` | `.vscode/settings.json still points Haxe Test Explorer at test.hxml with test-adapter, and .vscode/tasks.json now adds explicit run-all, run-suite, run-case-pattern, and current-file entrypoints using the same env-var form that the verified local commands used.` |

## Review Responses

| Finding ID | Disposition | Evidence | Notes |
|------------|-------------|----------|-------|
| `none` | `ALREADY SATISFIED` | `The current review packet is approved and scoped to step 1 findings only, with no open review items that still apply to the step-2 harness files.` | `No carry-forward review remediation was needed for this pass.` |

## Risks And Follow-Ups

- This Windows Haxe build rejects the direct `haxe test.hxml -- --tests ...` passthrough form before Main runs, so local ad hoc execution and the new VS Code tasks currently rely on the equivalent `VISION_TESTS` and `VISION_TEST_CASES` environment-variable path. Main still accepts `--tests` and `--cases` on builds that pass them through.
- `tests/src/tests/support/ApproxAssertions.hx`, `tests/src/tests/support/ImageAssertions.hx`, `tests/src/tests/support/ExceptionAssertions.hx`, and `tests/src/tests/support/ManualFixtures.hx` establish the shared-helper surface for later migration steps, but most authored suites still need to be rewritten to consume them more broadly.
- `tests/generated/**` remains in the repository intentionally as temporary reference material until later migration steps delete the old auto path.

## Pass History

| Pass | Commit | Summary |
|------|--------|---------|
| `1` | `9439dd742d49f6605b5d2f605431145141533250` | `Implemented step 1 cutover: promoted tests/src, repointed default entrypoints, added the manual inventory, and validated the authored root plus LocalCi fallback paths.` |
| `2` | `2c71242bfc6c849b5944a1c804e223c0bba6f39c` | `Addressed RVW-001 and RVW-002 by correcting the last stale README operational-path claims and converting PrettyReporter output to ASCII-safe literals, then reran haxe test.hxml plus targeted README/diagnostic checks.` |
| `3` | `this commit` | `Addressed RVW-003 by adding manual-inventory.hxml plus tests/generator/ManualInventoryBuilder.hx, regenerating tests/catalog/manual-test-inventory.json from source declarations, and validating the inventory against both the source scan and promoted test ids.` |
| `4` | `this commit` | `Addressed the refined RVW-003 by preserving curated deferredMembers state during regeneration, proving the behavior with a temporary ArrayTools deferred-state edit/regeneration/revert dance, and rerunning haxe manual-inventory.hxml to leave the manifest restored.` |
| `5` | `this commit` | `Implemented step 2 harness support: manual suite registry, suite/case filtering, reusable support helpers, VS Code task entrypoints, README filter docs, and the authored ImageTest out-of-bounds case used for case-filter verification.` |
