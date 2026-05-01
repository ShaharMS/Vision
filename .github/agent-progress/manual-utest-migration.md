# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-1-cutover.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: `step 1 approved and closeout committed; step 2 retarget pending.`
- Major outcomes: `tests/src` is now the operational suite for `test.hxml`, `tests/ci/LocalCi.hx`, and GitHub Actions; `tests/catalog/manual-test-inventory.json` now covers every `src/vision` module; and `tests/generator/ManualInventoryBuilder.hx` preserves checked-in `deferredMembers` progress while still appending newly discovered public members during regeneration.
- Branch: `feature/manual-utest-migration-1-cutover`
- Baseline commit: `f46848c831cf35ed2b6a8cd6d7e379d118a22bde`
- Latest approved commit: `52a6b0f045e4315d2a12581b04c8c102cf77900b`
- Closeout scope: `The approved step-1 state, iteration packet updates, execution report refresh, and the full manual-utest-migration overview plus step-plan chain are now committed on this branch.`
- Accepted caveat: `The direct Windows command haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only still fails before LocalCi runs on this Haxe build, so local verification in this environment must use the documented VISION_CI_* env-var fallback.`
- Residual limitation: `tests/generator/ManualInventoryBuilder.hx` still only discovers single-line public declarations, so multiline public signatures remain outside the current inventory scan.`
- Next action: `Advance the iteration to .github/plans/manual-utest-migration-2-harness.md and retarget the ledger/progress state there before the next implementation pass.`