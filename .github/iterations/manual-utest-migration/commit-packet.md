# Commit Packet

## Commit Intent

- Pass type: `initial implementation`
- Plan step: `.github/plans/manual-utest-migration-7-decommission-and-coverage.md`
- Scope: `Package the explicit step-7 decommission-and-coverage implementation pass: delete tests/generated, tests/generator, and the obsolete generator-only config or catalog surfaces; rewrite the surviving docs and manual inventory for the manual-only system; carry the narrow BilateralFilter or ImageHashing or Color or KernelResampler fixes required to close the final validation sweep; and resolve D-003 by deleting the waived generated surface.`
- Reason this is one commit: `The deleted generator surfaces, the manual-only docs or inventory updates, the narrow proof-run fixes, and the iteration packet updates together form one repository cutover point from the mixed migration-era test system to the final manual-only test system.`

## Candidate Files

| Path | Include | Reason |
|------|---------|--------|
| `tests/generator/**`, `tests/generated/**`, `tests/config.json`, `tests/compile.hxml`, `tests/catalog/test-health.json`, `tests/catalog/test-manifest.json`, `tests/catalog/test-report.md`, and `manual-inventory.hxml` | `yes` | `These are the retired generator-owned surfaces that step 7 decommissions in one cutover.` |
| `tests/README.md`, `tests/ROADMAP.md`, and `tests/REGENERATION_EXECUTION_PLAN.md` | `yes` | `These docs now describe the maintained manual-only workflow and the retired generator paths.` |
| `tests/catalog/manual-test-inventory.json` | `yes` | `Records the final manual or excluded ownership state after generator removal.` |
| `src/vision/algorithms/BilateralFilter.hx`, `src/vision/algorithms/ImageHashing.hx`, `src/vision/algorithms/KernelResampler.hx`, `src/vision/ds/Color.hx`, and `tests/src/tests/ColorTest.hx` | `yes` | `Carry the narrow fixes and expectation update exposed by the final proof reruns.` |
| `.github/agent-progress/manual-utest-migration.md`, `.github/iterations/manual-utest-migration/decision-log.md`, `.github/iterations/manual-utest-migration/implementation-handoff.md`, `.github/iterations/manual-utest-migration/commit-packet.md`, and `.github/iterations/manual-utest-migration/timeline.md` | `yes` | `Capture the completed implementation pass, the D-003 resolution, the explicit step-7 grouping, and the commit event for future recovery.` |
| `.github/iterations/manual-utest-migration/review-packet.md` | `no` | `Step 7 has not been reviewed yet, so the packet stays on the approved step-6 review state.` |
| `.github/plans/manual-utest-migration-7-decommission-and-coverage.md` | `no` | `This pass implements the selected step but does not close it out.` |
| `.github/iterations/manual-utest-migration/execution-report.md` | `no` | `This pass is not the final orchestrator stop report.` |

## Gitflow Decision

- Starting branch: `feature/manual-utest-migration-1-cutover`
- Target branch: `feature/manual-utest-migration-1-cutover`
- Branch action: `stayed on the existing feature branch because feature/manual-utest-migration-1-cutover already satisfies gitflow for the selected step-7 implementation pass`

## Commit Message

```text
refactor(tests): decommission generated test system

Delete the generator-owned suite, config, and catalog surfaces,
rewrite the surviving test docs and manual inventory for the
manual-only workflow, carry the narrow proof-run fixes in the
affected algorithm and color code paths, and resolve D-003 by
removing the waived generated runner surface.

Plan: .github/plans/manual-utest-migration-7-decommission-and-coverage.md
Pass: initial implementation
```

## Result

- Clean baseline before this pass: `b4e8135ababc5a093d33e46db1c6cc59862e3c3e`
- Commit hash: `Reported from branch history after the plan-step object exists because the tracked packet participates in the same tree and cannot embed its own object id before creation.`
- Push result: `Push the resulting step-7 implementation commit to origin/feature/manual-utest-migration-1-cutover immediately after creation when origin is available.`
- Workspace status after commit: `Expected clean after staging the selected step-7 implementation files.`
- Remaining uncommitted files: `none expected`
- Follow-up needed: `Hand the committed step-7 implementation range to @Inspect or @Iterate for review and final bookkeeping.`

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
| `15` | `c9bd5f0478eece29b7f18b255f11bac702340649` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-3 closeout bookkeeping, including the review-packet approval state, the updated run ledger and progress note, and the plan status changes that mark step 3 complete before the step-4 retarget.` |
| `16` | `b84983fcb72de929f4c54a7e34d36ba9f55bf605` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-4 implementation delta, including the semantic image/matrix and geometry suite rewrites, shared image fixtures or assertions, inventory manual-status or exclusion updates, the exposed Image or IntPoint2D or MathTools fixes, and the matching iteration-state files.` |
| `17` | `9637756030f9bc5cbaacbd64e00a45ee5a619883` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-014, RVW-015, and RVW-016 review follow-up, including the strengthened ImageViewShape consumer coverage, the asymmetric floating-pixel assertions, the singular Matrix2D duplicates contract, and the matching iteration packet updates.` |
| `18` | `1d3ea4d4f05c9b5bae9fdc6db56bb4746af98d28` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-017 review follow-up, including the step-4 manual inventory reconciliation, the updated review or implementation packet state, and the matching timeline bookkeeping.` |
| `19` | `41e803df1d8bbbb9a5c0a6cf02a4f84af5959ca2` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-4 closeout bookkeeping, marks the plans complete, and points the next recovery step at the algorithms migration while preserving D-003 plus the Windows env-var filtered-run fallback.` |
| `20` | `dcbe4c634fe2fafcd42229ee9956c4774f474117` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-5 implementation delta, including the semantic algorithm-suite rewrites, shared AlgorithmFixtures or ResamplerAssertions helpers, manual inventory updates, the exposed Canny hysteresis fix, the corrected Canny or SimpleLineDetector expectations, and the current step-5 iteration-state files.` |
| `21` | `87d4780fdb8cfce014e223582057080c841429b3` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-5 closeout bookkeeping, marks the plans complete, and points the next recovery step at the formats or facade migration while preserving D-003 plus the Windows env-var filtered-run fallback and stale-case-filter reset note.` |
| `22` | `3bfc8312d0ea5cbf4eb9f0025add1a2cdd2767bd` | `feature/manual-utest-migration-1-cutover` | `Packages the committed step-6 bootstrap and packet-hygiene refresh, including the explicit @Inspect timeline backfill, the step-6 ledger or progress retarget, and the iteration guidance or template updates that remove placeholder commit wording from future packets.` |
| `23` | `facad364a1d996a3156d647d9c405118a2425d75` | `feature/manual-utest-migration-1-cutover` | `Packages the follow-on packet-consistency repair that preserves row 22 for 3bfc8312d0ea5cbf4eb9f0025add1a2cdd2767bd, aligns the live step-6 packet history or resumable notes with the already-pushed bootstrap pass, and keeps delegated implementation next.` |
| `24` | `98de21b40c311cbba83806a9f0f7ee0b12f5adee` | `feature/manual-utest-migration-1-cutover` | `Packages the selected step-6 implementation delta, including deterministic format round-trip and malformed-input coverage, representative Vision facade compatibility checks, helper and exception suites, the exposed format-loader/exporter and exception-surface fixes, and the matching inventory, README, and iteration bookkeeping updates.` |
| `25` | `00c283516ed3ca30dc431ff481b3c975db961073` | `feature/manual-utest-migration-1-cutover` | `Packages the RVW-018 and RVW-019 review follow-up, including the explicit ImageLoadingFailed malformed-input assertions, the MatrixError.Add_MismatchingDimensions test repair, and the matching iteration packet updates.` |
| `26` | `b8f290faf6c491696c146c6926089a5a23fa719c` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-6 closeout bookkeeping, marks the plans complete, and points the next recovery step at decommission-and-coverage while preserving D-003 plus the Windows env-var filtered-run fallback and stale-case-filter reset note.` |
| `27` | `b4e8135ababc5a093d33e46db1c6cc59862e3c3e` | `feature/manual-utest-migration-1-cutover` | `Packages the step-7 bootstrap bookkeeping, records the clean baseline after the approved step-6 closeout, and retargets the iteration to the final decommission-and-coverage implementation scope.` |
