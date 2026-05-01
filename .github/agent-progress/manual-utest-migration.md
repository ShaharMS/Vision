# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-3-tools-and-core-ds.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `steps 1 and 2 are complete, and the iteration is now active on step 3 from a clean bootstrap baseline.`
- Clean baseline: `e902a4633ee5d45a3488270ea48e9d7215ed914c on feature/manual-utest-migration-1-cutover.`
- Completed foundation carried forward: `Step 1 established tests/src plus the manual inventory as the operational test root, and step 2 added deterministic suite/case filtering, ManualSuites registration, shared support helpers, VS Code task entrypoints, and the documented Windows filter contract.`
- Accepted waiver: `D-003 remains in force only for tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7, where the retained reference-only generated runner still shows unresolved utest.Runner and PrettyReporter diagnostics until step 7 deletes tests/generated and tests/compile.hxml.`
- Local verification context: `The direct Windows commands haxe test.hxml -- --tests ... and haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only still fail before Main or LocalCi runs on this Haxe build, so local filtered runs here continue to rely on the documented VISION_TESTS, VISION_TEST_CASES, and VISION_CI_* environment-variable fallbacks.`
- Residual risks: `Opening tests/generated/src/Main.hx directly still shows the accepted red diagnostics, and the authored suite still carries the pre-existing deprecation warnings from tests/src/tests/GaussTest.hx and tests/src/tests/ImageToolsTest.hx.`
- Next implementation focus: `Rewrite the step-3 vision.tools suites first (ArrayToolsTest, MathToolsTest, ImageToolsTest), then migrate the first core vision.ds suites to semantic assertions and shared edge-case helpers while updating tests/catalog/manual-test-inventory.json from needs-migration to manual for the completed modules.`