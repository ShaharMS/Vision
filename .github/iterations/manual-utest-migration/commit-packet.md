# Commit Packet

## Commit Intent

- Pass type: `initial implementation`
- Plan step: `.github/plans/manual-utest-migration-2-harness.md`
- Scope: `Package the step-2 manual harness implementation: deterministic suite and case filtering, authored suite registration, reusable support helpers, one authored helper-using test path, VS Code task entrypoints, README contract updates, and the matching step-2 iteration-state files.`
- Reason this is one commit: `The filtering behavior, registry extraction, helper wiring, task entrypoints, README contract, and step-2 iteration bookkeeping together form one coherent harness transition that should review as a single delta against the selected baseline.`

## Candidate Files

| Path | Include | Reason |
|------|---------|--------|
| `.github/agent-progress/manual-utest-migration.md` | `yes` | `Records the committed step-2 implementation state and the next review focus.` |
| `.github/iterations/manual-utest-migration/implementation-handoff.md` | `yes` | `Captures the step-2 implementation summary, verification evidence, and pass history.` |
| `.github/iterations/manual-utest-migration/run-ledger.md` | `yes` | `Advances the canonical loop state from bootstrap to review-ready committed implementation.` |
| `.github/iterations/manual-utest-migration/commit-packet.md` | `yes` | `Captures the step-2 grouping, branch decision, included files, and exclusion set for this pass.` |
| `.github/iterations/manual-utest-migration/timeline.md` | `yes` | `Appends the implementation commit event to the cross-agent history.` |
| `tests/src/Main.hx` | `yes` | `Implements deterministic suite and case filter parsing and delegates suite registration to the authored registry.` |
| `tests/src/tests/support/ManualSuites.hx` | `yes` | `Centralizes the curated runner.addCase(...) registry and threads the case pattern into every suite.` |
| `tests/src/tests/support/ApproxAssertions.hx` | `yes` | `Adds reusable approximate-equality assertions for later authored rewrites.` |
| `tests/src/tests/support/ExceptionAssertions.hx` | `yes` | `Adds reusable exception assertions consumed by authored tests in this pass.` |
| `tests/src/tests/support/ImageAssertions.hx` | `yes` | `Adds reusable image invariant assertions for authored tests.` |
| `tests/src/tests/support/ManualFixtures.hx` | `yes` | `Adds small authored fixture presets used by the step-2 harness tests.` |
| `tests/src/tests/ImageTest.hx` | `yes` | `Uses the new helper surface and adds the out-of-bounds case used for the case-filter proof.` |
| `tests/src/tests/FromBytesTest.hx` | `yes` | `Adopts the new exception helper so authored suites start using shared support utilities.` |
| `.vscode/tasks.json` | `yes` | `Adds local suite and case entrypoints using the env-var form verified on this Windows Haxe build.` |
| `tests/README.md` | `yes` | `Documents the suite and case filter contract and the env-var fallback note.` |
| `.github/iterations/manual-utest-migration/review-packet.md` | `no` | `No new review round exists yet for the step-2 implementation delta.` |
| `.github/iterations/manual-utest-migration/execution-report.md` | `no` | `This pass does not stop the iteration or change the durable run-stop report.` |
| `filtered-suite.out` | `no` | `Transient local output capture remains excluded if present.` |
| `localci-js.out` | `no` | `Transient local output capture remains excluded if present.` |

## Gitflow Decision

- Starting branch: `feature/manual-utest-migration-1-cutover`
- Target branch: `feature/manual-utest-migration-1-cutover`
- Branch action: `stayed on the existing feature branch because gitflow is already satisfied for the selected step-2 implementation pass`

## Commit Message

```text
feat(tests): build manual harness filtering

Add deterministic suite and case filtering plus authored suite
registration so the manual migration can target individual suites and
test members without generated metadata. The tasks and docs follow the
env-var path verified on this Windows Haxe build because direct --
passthrough is rejected before Main runs locally.

Plan: .github/plans/manual-utest-migration-2-harness.md
Pass: initial implementation pass for step 2 harness
```

## Result

- Commit hash: `this commit`
- Push result: `push this commit to origin/feature/manual-utest-migration-1-cutover immediately after creation when origin is available`
- Workspace status after commit: `expected clean except for any intentionally excluded transient output captures that may appear locally later`
- Remaining uncommitted files: `none expected`
- Follow-up needed: `Run the review pass against 4649713738100c31fb9277bcf66e4b7e31678648..HEAD with focus on deterministic filtering, helper adoption, task wiring, and the documented Windows env-var fallback contract.`

## Commit History

| Pass | Commit | Branch | Notes |
|------|--------|--------|-------|
| `1` | `9439dd742d49f6605b5d2f605431145141533250` | `feature/manual-utest-migration-1-cutover` | `Cuts execution over to tests/src, adds the manual inventory, excludes the then-untracked plan files, and relies on the VISION_CI_* fallback because this Windows Haxe build rejects -- passthrough before LocalCi runs.` |
| `2` | `2c71242bfc6c849b5944a1c804e223c0bba6f39c` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-001 and RVW-002 follow-up and keeps the same feature branch.` |
| `3` | `65b0e916018d55409e8c6bab374770cb480bc25e` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-003 follow-up, adds the repeatable inventory builder and regeneration entrypoint, and continues to exclude the local output captures.` |
| `4` | `52a6b0f045e4315d2a12581b04c8c102cf77900b` | `feature/manual-utest-migration-1-cutover` | `Packages the refined RVW-003 deferred-state preservation follow-up and closes the last blocker before approval.` |
| `5` | `4649713738100c31fb9277bcf66e4b7e31678648` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-1 closeout bookkeeping, adopts the full manual-utest-migration plan chain into git, and continues to exclude filtered-suite.out plus localci-js.out.` |
| `6` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-2 harness implementation, including deterministic suite/case filtering, the authored ManualSuites registry, shared support helpers, VS Code task entrypoints, README contract updates, and the matching iteration-state files.` |
