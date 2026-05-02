# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-7-decommission-and-coverage.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `Step 7 is implemented in delegated mode and awaiting review or finalization.`
- Baseline and latest bookkeeping commit: `b4e8135ababc5a093d33e46db1c6cc59862e3c3e on feature/manual-utest-migration-1-cutover.`
- Latest review outcome: `Step 7 has not been reviewed yet; the pass starts from the approved step-6 packet state and now carries a fresh implementation handoff with full validation evidence.`
- Step-7 result: `Deleted tests/generated, tests/generator, tests/compile.hxml, tests/config.json, manual-inventory.hxml, and the generator-only catalog reports; rewrote the surviving test docs around the manual-only workflow; reconciled the manual inventory to manual or excluded state; and proved the final full plus suite-filtered plus case-filtered plus LocalCi compile-only paths.`
- Accepted waiver: `D-003 is resolved because the waived generated-runner surface was deleted in step 7.`
- Windows filtered-run caveat: `The direct Windows command haxe test.hxml -- --tests ... still fails before Main runs on this Haxe build, so local filtered verification here continues to rely on the documented VISION_TESTS and VISION_TEST_CASES environment-variable fallback; in persistent PowerShell sessions, clear VISION_TEST_CASES before suite-only reruns so stale case patterns do not collapse discovery to zero tests.`
- Open blockers: `none recorded`
- Next action: `Hand the implemented step-7 delta to @Inspect or @Iterate for review and bookkeeping finalization.`