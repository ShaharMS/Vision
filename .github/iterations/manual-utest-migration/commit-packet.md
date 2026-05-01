# Commit Packet

## Commit Intent

- Pass type: `initial implementation`
- Plan step: `.github/plans/manual-utest-migration-3-tools-and-core-ds.md`
- Scope: `Package the selected step-3 implementation pass: semantic rewrites for the vision.tools suites and the targeted core vision.ds suites, shared collection/color assertion helpers, manual inventory status updates, and the step-3 iteration-state files already recorded for this pass.`
- Reason this is one commit: `The selected plan step explicitly groups the tools and first core-ds rewrites into one reviewable pass, and the support helpers, inventory updates, progress/run-ledger state, and handoff/timeline notes are only meaningful together with that implementation delta.`

## Candidate Files

| Path | Include | Reason |
|------|---------|--------|
| `tests/src/tests/ArrayToolsTest.hx`, `tests/src/tests/MathToolsTest.hx`, `tests/src/tests/ImageToolsTest.hx` | `yes` | `These are the selected step-3 vision.tools semantic rewrites.` |
| `tests/src/tests/Array2DTest.hx`, `tests/src/tests/ByteArrayTest.hx`, `tests/src/tests/ColorTest.hx`, `tests/src/tests/PixelTest.hx` | `yes` | `These are the first targeted core collection/value suite rewrites from the plan step.` |
| `tests/src/tests/HistogramTest.hx`, `tests/src/tests/QueueTest.hx`, `tests/src/tests/QueueCellTest.hx`, `tests/src/tests/ImageFormatTest.hx`, `tests/src/tests/PixelFormatTest.hx` | `yes` | `These complete the targeted core data-structure rewrites for the step-3 pass.` |
| `tests/src/tests/support/CollectionAssertions.hx`, `tests/src/tests/support/ColorAssertions.hx` | `yes` | `These reusable helpers are part of the authored semantic assertions used across the rewritten suites.` |
| `tests/catalog/manual-test-inventory.json` | `yes` | `Moves the migrated step-3 modules from needs-migration to manual.` |
| `.github/agent-progress/manual-utest-migration.md` | `yes` | `Carries the current step-3 progress note that is still uncommitted and belongs to this implementation pass.` |
| `.github/iterations/manual-utest-migration/implementation-handoff.md` | `yes` | `Records the step-3 implementation summary, verification evidence, and changed-file scope.` |
| `.github/iterations/manual-utest-migration/run-ledger.md` | `yes` | `Carries the uncommitted step-3 bootstrap state that selected the clean baseline for this pass.` |
| `.github/iterations/manual-utest-migration/commit-packet.md` | `yes` | `Captures the grouping, branch decision, included files, and commit intent for this implementation pass.` |
| `.github/iterations/manual-utest-migration/timeline.md` | `yes` | `Carries the existing step-3 bootstrap and implementation entries and appends the @Inscribe commit event.` |
| `.github/iterations/manual-utest-migration/review-packet.md` | `no` | `No new review round was authored during this implementation commit.` |
| `.github/iterations/manual-utest-migration/execution-report.md` | `no` | `This pass does not stop the iteration or alter the durable stop report.` |

## Gitflow Decision

- Starting branch: `feature/manual-utest-migration-1-cutover`
- Target branch: `feature/manual-utest-migration-1-cutover`
- Branch action: `stayed on the existing feature branch because gitflow is already satisfied for the selected step-3 implementation pass`

## Commit Message

```text
refactor(tests): rewrite step 3 tools and core-ds suites

Package the selected step-3 implementation pass: semantic rewrites for
the vision.tools suites and the targeted core vision.ds suites, shared
collection/color assertion helpers, manual inventory status updates,
and the matching iteration-state files already recorded for this pass.

Plan: .github/plans/manual-utest-migration-3-tools-and-core-ds.md
Pass: initial implementation
```

## Result

- Commit hash: `this commit`
- Push result: `push this commit to origin/feature/manual-utest-migration-1-cutover immediately after creation when origin is available`
- Workspace status after commit: `expected clean after staging the full step-3 implementation delta`
- Remaining uncommitted files: `none expected`
- Follow-up needed: `Hand the committed step-3 implementation to review, carrying forward D-003 only for tests/generated/src/Main.hx and the Windows env-var filtered-run caveat.`

## Commit History

| Pass | Commit | Branch | Notes |
|------|--------|--------|-------|
| `1` | `9439dd742d49f6605b5d2f605431145141533250` | `feature/manual-utest-migration-1-cutover` | `Cuts execution over to tests/src, adds the manual inventory, excludes the then-untracked plan files, and relies on the VISION_CI_* fallback because this Windows Haxe build rejects -- passthrough before LocalCi runs.` |
| `2` | `2c71242bfc6c849b5944a1c804e223c0bba6f39c` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-001 and RVW-002 follow-up and keeps the same feature branch.` |
| `3` | `65b0e916018d55409e8c6bab374770cb480bc25e` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-003 follow-up, adds the repeatable inventory builder and regeneration entrypoint, and continues to exclude the local output captures.` |
| `4` | `52a6b0f045e4315d2a12581b04c8c102cf77900b` | `feature/manual-utest-migration-1-cutover` | `Packages the refined RVW-003 deferred-state preservation follow-up and closes the last blocker before approval.` |
| `5` | `4649713738100c31fb9277bcf66e4b7e31678648` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-1 closeout bookkeeping, adopts the full manual-utest-migration plan chain into git, and continues to exclude filtered-suite.out plus localci-js.out.` |
| `6` | `07f8f8284c6258a4d0c38bce736a87b4dbe718be` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-2 harness implementation, including deterministic suite/case filtering, the authored ManualSuites registry, shared support helpers, VS Code task entrypoints, README contract updates, and the matching iteration-state files.` |
| `7` | `fc51e41b22c39050acf832f88737794bb319e82c` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-004 README shell-syntax follow-up, the retargeted step-2 review packet, and the matching iteration bookkeeping after rerunning the exact documented PowerShell case-filter example.` |
| `8` | `a811b9d6e98d50dcf625add678f9747873efab87` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-005 waiver-request follow-up, including the pending decision-log entry, authored-surface verification evidence, and the matching iteration bookkeeping without application code changes.` |
| `9` | `e902a4633ee5d45a3488270ea48e9d7215ed914c` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-2 closeout bookkeeping, marks the plans complete, and points the next recovery step at the tools/core-ds migration while preserving D-003.` |
| `10` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-3 implementation delta, including the semantic tools/core-ds suite rewrites, shared assertion helpers, inventory manual-status updates, and the matching iteration-state files.` |
