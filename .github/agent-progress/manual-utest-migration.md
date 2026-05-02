# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-5-algorithms.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `Steps 1 through 4 are complete, and the iteration is now active on step 5 from the clean baseline commit 41e803df1d8bbbb9a5c0a6cf02a4f84af5959ca2 on feature/manual-utest-migration-1-cutover.`
- Latest meaningful outcome: `Step 4 is approved through c9bd5f0478eece29b7f18b255f11bac702340649..1d3ea4d4f05c9b5bae9fdc6db56bb4746af98d28, and the step-4 closeout bookkeeping is committed in the clean step-5 baseline 41e803df1d8bbbb9a5c0a6cf02a4f84af5959ca2.`
- Foundation carried forward: `The earlier steps leave tests/src as the operational test root with deterministic suite/case filtering, ManualSuites registration, shared support helpers, and semantic manual coverage across the tools, core vision.ds, image, matrix, and geometry surfaces.`
- Local verification context: `Carry forward D-003 only for tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7 on the retained reference-only generated runner. On this Windows Haxe build, filtered local reruns still need the documented VISION_TESTS and VISION_TEST_CASES environment-variable fallback because haxe test.hxml -- --tests ... fails before Main runs; keep the broader VISION_CI_* fallback available for later LocalCi commands.`
- Open blockers: `none recorded`
- Outstanding findings: `none`
- Next implementation focus: `Rewrite the step-5 algorithm suites around deterministic fixtures and justified expectations, starting with interpolation and resampling, then edge-detection and transform coverage, then numeric solvers, clustering, hashing, and sorting, with shared helper or manual-inventory follow-up only where the migrated suites require it.`
- Next action: `Delegate implementation for .github/plans/manual-utest-migration-5-algorithms.md from baseline 41e803df1d8bbbb9a5c0a6cf02a4f84af5959ca2 while preserving D-003 plus the Windows env-var filtered-run fallback as local verification context.`