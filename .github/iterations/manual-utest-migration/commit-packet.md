# Commit Packet

## Commit Intent

- Pass type: `review follow-up`
- Plan step: `.github/plans/manual-utest-migration-2-harness.md`
- Scope: `Package the RVW-004 follow-up for the step-2 harness documentation: make the Windows suite/case filter fallback directly runnable in PowerShell, preserve an explicit cmd.exe variant, and commit the matching iteration bookkeeping for the review round.`
- Reason this is one commit: `The README shell-syntax remediation and the paired iteration packet updates all exist to close the same step-2 review finding, so they should land as one focused review-follow-up commit against the selected baseline.`

## Candidate Files

| Path | Include | Reason |
|------|---------|--------|
| `tests/README.md` | `yes` | `Fixes RVW-004 by documenting shell-specific PowerShell and cmd.exe fallback commands for suite and case filtering on Windows.` |
| `.github/iterations/manual-utest-migration/implementation-handoff.md` | `yes` | `Captures the RVW-004 remediation summary, verification evidence, and pass history.` |
| `.github/iterations/manual-utest-migration/review-packet.md` | `yes` | `Carries the normalized RVW-004 finding and the retargeted step-2 review state that this follow-up addresses.` |
| `.github/iterations/manual-utest-migration/commit-packet.md` | `yes` | `Captures the current grouping, branch decision, included files, and commit intent for this review-follow-up pass.` |
| `.github/iterations/manual-utest-migration/timeline.md` | `yes` | `Appends the RVW-004 review-follow-up commit event to the cross-agent history.` |
| `.github/agent-progress/manual-utest-migration.md` | `no` | `No new @Index resume-note pass has updated the progress summary for this review-follow-up commit.` |
| `.github/iterations/manual-utest-migration/run-ledger.md` | `no` | `This pass does not change the canonical selected-step or branch summary.` |
| `.github/iterations/manual-utest-migration/execution-report.md` | `no` | `This pass does not stop the iteration or change the durable run-stop report.` |
| `filtered-suite.out` | `no` | `Transient local output capture remains excluded if present.` |
| `localci-js.out` | `no` | `Transient local output capture remains excluded if present.` |

## Gitflow Decision

- Starting branch: `feature/manual-utest-migration-1-cutover`
- Target branch: `feature/manual-utest-migration-1-cutover`
- Branch action: `stayed on the existing feature branch because gitflow is already satisfied for the selected step-2 review-follow-up pass`

## Commit Message

```text
docs(tests): address RVW-004 PowerShell fallback docs

Update the step-2 README examples so the Windows env-var fallback runs
directly in PowerShell while still preserving an explicit cmd.exe
variant. This keeps the documented suite/case filter contract runnable
on the local Windows Haxe build where direct -- passthrough fails
before Main runs.

Plan: .github/plans/manual-utest-migration-2-harness.md
Pass: review follow-up for RVW-004 PowerShell fallback documentation
```

## Result

- Commit hash: `this commit`
- Push result: `push this commit to origin/feature/manual-utest-migration-1-cutover immediately after creation when origin is available`
- Workspace status after commit: `expected clean except for any intentionally excluded transient output captures that may appear locally later`
- Remaining uncommitted files: `none expected`
- Follow-up needed: `Request re-review of 4649713738100c31fb9277bcf66e4b7e31678648..HEAD with focus on RVW-004's PowerShell-ready README fallback while preserving the accepted D-002 passthrough caveat.`

## Commit History

| Pass | Commit | Branch | Notes |
|------|--------|--------|-------|
| `1` | `9439dd742d49f6605b5d2f605431145141533250` | `feature/manual-utest-migration-1-cutover` | `Cuts execution over to tests/src, adds the manual inventory, excludes the then-untracked plan files, and relies on the VISION_CI_* fallback because this Windows Haxe build rejects -- passthrough before LocalCi runs.` |
| `2` | `2c71242bfc6c849b5944a1c804e223c0bba6f39c` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-001 and RVW-002 follow-up and keeps the same feature branch.` |
| `3` | `65b0e916018d55409e8c6bab374770cb480bc25e` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-003 follow-up, adds the repeatable inventory builder and regeneration entrypoint, and continues to exclude the local output captures.` |
| `4` | `52a6b0f045e4315d2a12581b04c8c102cf77900b` | `feature/manual-utest-migration-1-cutover` | `Packages the refined RVW-003 deferred-state preservation follow-up and closes the last blocker before approval.` |
| `5` | `4649713738100c31fb9277bcf66e4b7e31678648` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-1 closeout bookkeeping, adopts the full manual-utest-migration plan chain into git, and continues to exclude filtered-suite.out plus localci-js.out.` |
| `6` | `07f8f8284c6258a4d0c38bce736a87b4dbe718be` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-2 harness implementation, including deterministic suite/case filtering, the authored ManualSuites registry, shared support helpers, VS Code task entrypoints, README contract updates, and the matching iteration-state files.` |
| `7` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-004 README shell-syntax follow-up, the retargeted step-2 review packet, and the matching iteration bookkeeping after rerunning the exact documented PowerShell case-filter example.` |
