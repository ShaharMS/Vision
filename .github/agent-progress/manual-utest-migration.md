# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-2-harness.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `step 2 initial harness implementation is committed and awaiting review.`
- Step-2 baseline: `Clean recovery point is 4649713738100c31fb9277bcf66e4b7e31678648 on feature/manual-utest-migration-1-cutover.`
- Major carry-forward outcomes: `tests/src` remains the operational suite for `test.hxml`, `tests/ci/LocalCi.hx`, and GitHub Actions; `tests/catalog/manual-test-inventory.json` still covers every `src/vision` module; tests/src/Main.hx now supports deterministic suite and case filtering through tests/src/tests/support/ManualSuites.hx; shared helpers now live under tests/src/tests/support; and .vscode/tasks.json plus tests/README.md document the env-var filter path verified on this Windows Haxe build.`
- Branch: `feature/manual-utest-migration-1-cutover`
- Current step-2 scope: `The initial harness implementation is committed on this branch, including an authored ImageTest.test_getPixel__outOfBounds case and FromBytesTest helper adoption that exercise the shared support surface.`
- Local verification caveat: `The direct Windows command haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only still fails before LocalCi runs on this Haxe build, so local verification in this environment must keep using the documented VISION_CI_* env-var fallback.`
- Residual limitation: `tests/generator/ManualInventoryBuilder.hx` still only discovers single-line public declarations, so multiline public signatures remain outside the current inventory scan.`
- Next review focus: `Review the committed .github/plans/manual-utest-migration-2-harness.md delta against 4649713738100c31fb9277bcf66e4b7e31678648 with emphasis on deterministic filtering through Runner.addCase(..., ?pattern), the curated ManualSuites registry, and the helper/task/doc contract.`