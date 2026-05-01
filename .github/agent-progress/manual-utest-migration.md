# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-2-harness.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `step 2 is approved and closed out; the next recovery point is retargeting the iteration to step 3.`
- Approved range: `4649713738100c31fb9277bcf66e4b7e31678648..a811b9d6e98d50dcf625add678f9747873efab87 on feature/manual-utest-migration-1-cutover.`
- Harness outcomes: `tests/src/Main.hx now supports deterministic suite and case filtering, tests/src/tests/support/ManualSuites.hx centralizes authored suite registration, shared helpers under tests/src/tests/support are in active use, .vscode/tasks.json exposes suite/case/current-file entrypoints, and tests/README.md documents the verified filter contract for this Windows environment.`
- Accepted waiver: `D-003 remains in force only for tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7, where the retained reference-only generated runner still shows unresolved utest.Runner and PrettyReporter diagnostics until step 7 deletes tests/generated and tests/compile.hxml.`
- Windows passthrough caveat: `The direct Windows commands haxe test.hxml -- --tests ... and haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only still fail before Main or LocalCi runs on this Haxe build, so local verification here continues to rely on the documented VISION_TESTS, VISION_TEST_CASES, and VISION_CI_* environment-variable fallbacks.`
- Residual risks: `Opening tests/generated/src/Main.hx directly still shows the accepted red diagnostics, and the authored suite still carries the pre-existing deprecation warnings from tests/src/tests/GaussTest.hx and tests/src/tests/ImageToolsTest.hx.`
- Next action: `Retarget the iteration to .github/plans/manual-utest-migration-3-tools-and-core-ds.md and begin the tools/core-ds migration work while carrying forward D-003 plus the Windows passthrough caveat.`