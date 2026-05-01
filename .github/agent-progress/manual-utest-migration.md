# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-3-tools-and-core-ds.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `Steps 1 and 2 are complete, and step 3 remains active after the committed RVW-013 follow-up while awaiting reinspection.`
- Clean baseline: `e902a4633ee5d45a3488270ea48e9d7215ed914c on feature/manual-utest-migration-1-cutover.`
- Completed foundation carried forward: `Step 1 established tests/src plus the manual inventory as the operational test root, and step 2 added deterministic suite/case filtering, ManualSuites registration, shared support helpers, VS Code task entrypoints, and the documented Windows filter contract.`
- Accepted waiver: `D-003 remains in force only for tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7, where the retained reference-only generated runner still shows unresolved utest.Runner and PrettyReporter diagnostics until step 7 deletes tests/generated and tests/compile.hxml.`
- Local verification context: `The direct Windows commands haxe test.hxml -- --tests ... and haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only still fail before Main or LocalCi runs on this Haxe build, so local filtered runs here continue to rely on the documented VISION_TESTS, VISION_TEST_CASES, and VISION_CI_* environment-variable fallbacks.`
- Residual risks: `The RVW-013 follow-up is committed, but step 3 still depends on reinspection. Remaining non-blocking noise is still limited to the accepted D-003 generated-runner diagnostics plus the pre-existing deprecation warnings from tests/src/tests/GaussTest.hx and tests/src/tests/ImageToolsTest.hx.`
- Next recovery action: `Hand the committed RVW-013 MathTools wrapper follow-up back to @Inspect; if it is approved, close out step 3 and retarget the iteration to .github/plans/manual-utest-migration-4-image-and-geometry-ds.md.`