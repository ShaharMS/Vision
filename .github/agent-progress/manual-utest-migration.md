# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-4-image-and-geometry-ds.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `step 4 is approved and closed out; the next recovery point is retargeting the iteration to step 5.`
- Approved range: `c9bd5f0478eece29b7f18b255f11bac702340649..1d3ea4d4f05c9b5bae9fdc6db56bb4746af98d28 on feature/manual-utest-migration-1-cutover.`
- Step-4 outcome: `The authored suite now covers the targeted image, image-view, matrix, and geometry data-structure surfaces with semantic assertions, shared image fixtures/assertions, and reconciled manual-inventory rows that defer only the still-uncovered member surface.`
- Review-driven fixes: `The step-4 loop exposed and fixed Image.setView, IntPoint2D.radiansTo, and MathTools.distanceBetweenLines2D, then strengthened ImageViewShape consumer coverage, floating-pixel neighbor assertions, Matrix2D singular-duplicates behavior, and the final manifest reconciliation before approval.`
- Foundation carried forward: `Steps 1 through 3 still provide tests/src as the operational test root, deterministic suite/case filtering, ManualSuites registration, shared support helpers, and the earlier semantic tools/core vision.ds coverage.`
- Accepted waiver: `D-003 remains in force only for tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7, where the retained reference-only generated runner still shows unresolved utest.Runner and PrettyReporter diagnostics until step 7 deletes tests/generated and tests/compile.hxml.`
- Windows filtered-run caveat: `The direct Windows command haxe test.hxml -- --tests ... still fails before Main runs on this Haxe build, so local filtered verification here continues to rely on the documented VISION_TESTS and VISION_TEST_CASES environment-variable fallback; keep the broader VISION_CI_* fallback in mind for later LocalCi commands.`
- Residual risks: `Beyond D-003, the remaining non-blocking noise is the pre-existing utest enum-abstract warning and deprecated Gauss helper warnings noted in the approval round.`
- Next action: `Retarget the iteration to .github/plans/manual-utest-migration-5-algorithms.md and begin the algorithm migration while carrying forward D-003 plus the Windows env-var filtered-run fallback.`