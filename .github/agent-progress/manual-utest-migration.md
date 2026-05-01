# Manual Utest Migration

- Active step: `.github/plans/manual-utest-migration-1-cutover.md`
- Overview: `.github/plans/manual-utest-migration-overview.md`
- Iteration state: delegated `@Implement` refined RVW-003 follow-up committed; awaiting reinspection on the feature branch.
- Latest outcome: updated `tests/generator/ManualInventoryBuilder.hx` so regeneration preserves checked-in deferred progress, verified it with a temporary `vision.tools.ArrayTools` deferredMembers edit/regeneration/revert proof, reran `haxe manual-inventory.hxml`, and left `tests/catalog/manual-test-inventory.json` restored with the full ArrayTools/ImageTools member sets.
- Branch: `feature/manual-utest-migration-1-cutover`
- Baseline commit: `f46848c831cf35ed2b6a8cd6d7e379d118a22bde`
- Latest commit: `the refined RVW-003 deferred-state preservation review-follow-up commit on this branch`
- Blockers: `Direct LocalCi -- passthrough is rejected by this Windows Haxe build; use the documented VISION_CI_* env vars in this environment.`
- Next action: have `@Inspect` review the full committed step-1 delta through the current branch head, focusing on deferredMembers preservation across manual inventory regeneration, final ArrayTools/ImageTools completeness, and the continued exclusion of the pre-existing untracked plan files from this pass.