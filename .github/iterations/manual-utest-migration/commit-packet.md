# Commit Packet

## Commit Intent

- Pass type: `review follow-up`
- Plan step: `.github/plans/manual-utest-migration-4-image-and-geometry-ds.md`
- Scope: `Package the RVW-017 step-4 follow-up delta: reconcile the promoted image-and-geometry manual inventory rows so deferredMembers reflects only the still-uncovered member surface, and carry the matching iteration packet updates.`
- Reason this is one commit: `These files answer one explicit review round on the selected step-4 baseline. Splitting the manual inventory reconciliation away from the updated handoff, review packet, commit packet, or timeline would fragment one reviewer-requested remediation slice across multiple commits.`

## Candidate Files

| Path | Include | Reason |
|------|---------|--------|
| `tests/catalog/manual-test-inventory.json` | `yes` | `Prunes the promoted step-4 manual entries so deferredMembers reflects only the members still uncovered by authored @:visionTestId coverage.` |
| `.github/iterations/manual-utest-migration/implementation-handoff.md` | `yes` | `Records the RVW-017 inventory-reconciliation summary, targeted manifest-check evidence, and the remaining deferred-member rationale for the selected step-4 review round.` |
| `.github/iterations/manual-utest-migration/review-packet.md` | `yes` | `Carries the normalized step-4 review round that opened RVW-017 and defines the exact remediation scope being committed.` |
| `.github/iterations/manual-utest-migration/commit-packet.md`, `.github/iterations/manual-utest-migration/timeline.md` | `yes` | `Capture this review-follow-up grouping, gitflow decision, push intent, and the append-only commit event for recovery.` |
| `.github/iterations/manual-utest-migration/execution-report.md` | `no` | `This is not a final stop report update; it remains intentionally unchanged.` |

## Gitflow Decision

- Starting branch: `feature/manual-utest-migration-1-cutover`
- Target branch: `feature/manual-utest-migration-1-cutover`
- Branch action: `stayed on the existing feature branch because gitflow is already satisfied for the selected step-4 review-follow-up pass`

## Commit Message

```text
fix(tests): address RVW-017 inventory reconciliation

Reconcile the promoted step-4 manual inventory rows so
deferredMembers now matches the authored uncovered-member
surface instead of leaving the same modules marked manual
and fully deferred at the same time.

Plan: .github/plans/manual-utest-migration-4-image-and-geometry-ds.md
Pass: review follow-up
Baseline: c9bd5f0478eece29b7f18b255f11bac702340649
Review: RVW-017
```

## Result

- Commit hash: `this commit`
- Push result: `push this commit to origin/feature/manual-utest-migration-1-cutover immediately after creation when origin is available`
- Workspace status after commit: `expected clean after staging the selected step-4 review-follow-up files`
- Remaining uncommitted files: `none expected`
- Follow-up needed: `Hand the committed RVW-017 remediation pass back to review intake for reinspection of the selected step-4 baseline while carrying forward D-003 and the Windows env-var filtered-run fallback.`

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
| `10` | `6b44dce7ffb458984b97ef50cbcdfb7907bb8206` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-3 implementation delta, including the semantic tools/core-ds suite rewrites, shared assertion helpers, inventory manual-status updates, and the matching iteration-state files.` |
| `11` | `a6c6894864eb40a3e8fb1510103435b391d31292` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-006 and RVW-007 review follow-up, including the Queue.has and ByteArray.getInt8 library fixes, the new edge-case coverage in QueueTest and ByteArrayTest, and the matching iteration packet updates.` |
| `12` | `1c05e1ebf05e0ef2d04436eada47b1c91ce6e51f` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-008, RVW-009, and RVW-010 review follow-up, including the MathTools.isBetweenRange(s), ArrayTools.distanceTo, and Histogram.length library fixes, the strengthened semantic coverage in MathToolsTest, ArrayToolsTest, and HistogramTest, and the matching iteration packet updates.` |
| `13` | `e616da22e10ea88d1140780219ac4ed6d2164807` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-011 and RVW-012 review follow-up, including the semantic Color constant coverage, the deterministic sys temp-file ImageTools coverage, and the matching iteration packet updates.` |
| `14` | `7cf5d491504c87db4fd2c8dbcce15cfff4e869fe` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-013 review follow-up, including the semantic MathTools wrapper coverage, the updated progress note, and the matching iteration packet updates.` |
| `15` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-3 closeout bookkeeping, including the review-packet approval state, the updated run ledger and progress note, and the plan status changes that mark step 3 complete before the step-4 retarget.` |
| `16` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-4 implementation delta, including the semantic image/matrix and geometry suite rewrites, shared image fixtures/assertions, inventory manual-status/exclusion updates, the exposed Image/IntPoint2D/MathTools fixes, and the matching iteration-state files.` |
| `17` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-014, RVW-015, and RVW-016 review follow-up, including the strengthened ImageViewShape consumer coverage, the asymmetric floating-pixel assertions, the singular Matrix2D duplicates contract, and the matching iteration packet updates.` |
| `18` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-017 review follow-up, including the step-4 manual inventory reconciliation, the updated review/implementation packet state, and the matching timeline bookkeeping.` |
