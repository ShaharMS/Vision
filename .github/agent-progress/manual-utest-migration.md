# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-7-decommission-and-coverage.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `Step 6 is approved and closed out; the iteration is bootstrapped on step 7 and awaiting delegated implementation.`
- Baseline and latest bookkeeping commit: `b8f290faf6c491696c146c6926089a5a23fa719c on feature/manual-utest-migration-1-cutover.`
- Latest review outcome: `RVW-018 and RVW-019 are approved in the published follow-up range 98de21b40c311cbba83806a9f0f7ee0b12f5adee..00c283516ed3ca30dc431ff481b3c975db961073, and the approved step-6 closeout is now the clean baseline for step 7.`
- Step-7 focus: `Delete tests/generated, tests/generator, tests/compile.hxml, and the remaining reference-only generated surface once the manual tree and inventory are confirmed authoritative; clean stale generator-forward docs; finish the final manual-inventory sweep; and prove the manual suite no longer depends on generator entrypoints.`
- Accepted waiver: `D-003 remains in force only for tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7 until step 7 deletes tests/generated/src/Main.hx and the rest of the reference-only generated surface.`
- Windows filtered-run caveat: `The direct Windows command haxe test.hxml -- --tests ... still fails before Main runs on this Haxe build, so local filtered verification here continues to rely on the documented VISION_TESTS and VISION_TEST_CASES environment-variable fallback; in persistent PowerShell sessions, clear VISION_TEST_CASES before suite-only reruns so stale case patterns do not collapse discovery to zero tests.`
- Open blockers: `none recorded`
- Next action: `Delegate .github/plans/manual-utest-migration-7-decommission-and-coverage.md to @Implement for generator/generated-tree deletion, stale-doc cleanup, the final inventory sweep, and proof that the manual suite no longer depends on generator entrypoints.`