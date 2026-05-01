# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-1-cutover.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: delegated `@Implement` RVW-003 follow-up committed; awaiting reinspection on the feature branch.
- Latest outcome: committed the RVW-003 review follow-up that added `manual-inventory.hxml` plus `tests/generator/ManualInventoryBuilder.hx`, regenerated `tests/catalog/manual-test-inventory.json` from source declarations, restored the missing overload-heavy ArrayTools/ImageTools members, and verified the result with `haxe manual-inventory.hxml` plus targeted inventory checks.
- Branch: `feature/manual-utest-migration-1-cutover`
- Baseline commit: `f46848c831cf35ed2b6a8cd6d7e379d118a22bde`
- Latest commit: `the current RVW-003 review-follow-up commit on this branch`
- Blockers: `Direct LocalCi -- passthrough is rejected by this Windows Haxe build; use the documented VISION_CI_* env vars in this environment.`
- Next action: have `@Inspect` review the full committed step-1 delta through the current branch head, focusing on inventory completeness, the repeatable regeneration/validation path, and the continued exclusion of the pre-existing untracked plan files from this pass.