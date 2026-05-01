# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-1-cutover.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: delegated `@Implement` pass committed; awaiting review on the feature branch.
- Latest outcome: committed the step-1 cutover that promoted `tests/generated/src` into `tests/src`, stripped generated ownership markers, repointed `test.hxml`, `tests/ci/LocalCi.hx`, and `.github/workflows/main.yml`, added `tests/catalog/manual-test-inventory.json`, and updated `tests/README.md` to freeze the old auto path as reference-only.
- Branch: `feature/manual-utest-migration-1-cutover`
- Baseline commit: `f46848c831cf35ed2b6a8cd6d7e379d118a22bde`
- Latest commit: `the current step-1 cutover commit on this branch`
- Blockers: `Direct LocalCi -- passthrough is rejected by this Windows Haxe build; use the documented VISION_CI_* env vars in this environment.`
- Next action: have `@Inspect` review the committed cutover diff, especially the inventory heuristics, the intentionally retained tests/generated reference tree, and the exclusion of the pre-existing untracked plan files from this commit.