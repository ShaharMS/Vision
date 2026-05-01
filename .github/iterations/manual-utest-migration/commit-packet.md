# Commit Packet

## Commit Intent

- Pass type: `initial implementation pass`
- Plan step: `.github/plans/manual-utest-migration-1-cutover.md`
- Scope: `Cut over the operational test entrypoints from tests/generated/src to tests/src, seed the manual inventory for src/vision, and capture the iteration bookkeeping for the step-1 cutover pass.`
- Reason this is one commit: `The promoted tests/src tree, entrypoint rewires, migration inventory, and packet bookkeeping establish one atomic cutover to the authored suite and should land together.`

## Candidate Files

| Path | Include | Reason |
|------|---------|--------|
| `tests/src/**` | `yes` | `Promotes the authored test root that now owns the executable suite.` |
| `test.hxml` | `yes` | `Moves the repo-root fast path to tests/src.` |
| `tests/ci/LocalCi.hx` | `yes` | `Moves the local CI harness to tests/src and removes stale generated class paths.` |
| `.github/workflows/main.yml` | `yes` | `Moves GitHub Actions compilation to tests/src.` |
| `tests/catalog/manual-test-inventory.json` | `yes` | `Adds the checked-in migration inventory for every src/vision module.` |
| `tests/README.md` | `yes` | `Documents tests/generated and tests/compile.hxml as reference-only during migration.` |
| `.github/iterations/manual-utest-migration/*.md` | `yes` | `Preserves the iteration packet set and this pass bookkeeping alongside the cutover.` |
| `.github/agent-progress/manual-utest-migration.md` | `yes` | `Provides the resumable progress note for this iteration.` |
| `.github/plans/manual-utest-migration-*.md` | `no` | `These plan files were already untracked workspace state before this pass and are explicitly excluded by instruction.` |

## Gitflow Decision

- Starting branch: `main`
- Target branch: `feature/manual-utest-migration-1-cutover`
- Branch action: `created and switched from main before committing this pass`

## Commit Message

```text
feat(tests): cut over manual utest entrypoints

Move repo-root, LocalCi, and GitHub Actions execution to tests/src,
seed the manual src/vision inventory, and keep tests/generated as
reference-only during migration.

Plan: .github/plans/manual-utest-migration-1-cutover.md
Pass: initial implementation pass
```

## Result

- Commit hash: `captured in git history for the single step-1 cutover commit`
- Push result: `captured by the same git push that publishes the feature branch`
- Workspace status after commit: `expected clean except for the intentionally excluded pre-existing plan files`
- Remaining uncommitted files: `the pre-existing .github/plans/manual-utest-migration*.md files excluded by instruction`
- Follow-up needed: `Run @Inspect against the committed cutover and preserve the Windows Haxe -- passthrough caveat.`

## Commit History

| Pass | Commit | Branch | Notes |
|------|--------|--------|-------|
| `1` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Cuts execution over to tests/src, adds the manual inventory, excludes the pre-existing plan files, and relies on the VISION_CI_* fallback because this Windows Haxe build rejects -- passthrough before LocalCi runs.` |
