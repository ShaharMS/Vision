# Commit Packet

## Commit Intent

- Pass type: `initial implementation pass`
- Plan step: `.github/plans/manual-utest-migration-5-algorithms.md`
- Scope: `Package the selected step-5 algorithm rewrite and zero-test discovery repair: semantic interpolation or resampling rewrites, edge-detection or transform rewrites, numeric or clustering or hashing or sorting rewrites, shared algorithm or resampler helpers, manual inventory updates, the exposed Canny library fix, corrected Canny and SimpleLineDetector expectations, and the current step-5 iteration-state files.`
- Reason this is one commit: `The user explicitly selected one plan-step commit for step 5. The zero-test discovery repair did not start a separate review loop; it validated the same implementation pass, exposed a real Canny defect plus two expectation mismatches, and was repaired before the first review handoff, so the full step-5 delta belongs in one atomic commit on the existing feature branch.`

## Candidate Files

| Path | Include | Reason |
|------|---------|--------|
| `.github/agent-progress/manual-utest-migration.md, .github/iterations/manual-utest-migration/run-ledger.md` | `yes` | `Carry the current step-5 recovery baseline and selected-scope context that belongs with the implementation pass.` |
| `.github/iterations/manual-utest-migration/implementation-handoff.md, .github/iterations/manual-utest-migration/commit-packet.md, .github/iterations/manual-utest-migration/timeline.md` | `yes` | `Record the implementation summary, commit grouping, and cross-agent history for the selected step-5 pass.` |
| `src/vision/algorithms/Canny.hx` | `yes` | `Fixes the opaque-white hysteresis promotion defect exposed by the real grouped edge rerun after clearing the stale case filter.` |
| `tests/catalog/manual-test-inventory.json` | `yes` | `Promotes the migrated step-5 algorithm surfaces to manual coverage and records the updated deferred-member state.` |
| `tests/src/tests/support/AlgorithmFixtures.hx, tests/src/tests/support/ResamplerAssertions.hx` | `yes` | `Adds shared deterministic fixtures and resampler assertions reused across the rewritten algorithm suites.` |
| `tests/src/tests/BicubicInterpolationTest.hx, tests/src/tests/BilateralFilterTest.hx, tests/src/tests/BilinearInterpolationTest.hx, tests/src/tests/CatmullRomInterpolationTest.hx, tests/src/tests/KernelResamplerTest.hx, tests/src/tests/LanczosInterpolationTest.hx, tests/src/tests/MitchellNetravaliInterpolationTest.hx` | `yes` | `Rewrites the interpolation and resampling suites to semantic fixture-driven assertions.` |
| `tests/src/tests/CannyTest.hx, tests/src/tests/LaplaceTest.hx, tests/src/tests/PerspectiveWarpTest.hx, tests/src/tests/PerwittTest.hx, tests/src/tests/RobertsCrossTest.hx, tests/src/tests/SimpleHoughTest.hx, tests/src/tests/SimpleLineDetectorTest.hx, tests/src/tests/SobelTest.hx` | `yes` | `Rewrites the edge-detection and transform suites and carries the exposed expectation repairs.` |
| `tests/src/tests/ColorClusterTest.hx, tests/src/tests/CramerTest.hx, tests/src/tests/GaussJordanTest.hx, tests/src/tests/GaussTest.hx, tests/src/tests/ImageHashingTest.hx, tests/src/tests/KMeansTest.hx, tests/src/tests/RadixTest.hx` | `yes` | `Rewrites the numeric, clustering, hashing, and sorting suites to semantic assertions.` |
| `.github/iterations/manual-utest-migration/review-packet.md` | `no` | `No step-5 review round has been normalized yet; the review packet remains on the approved step-4 state.` |
| `.github/iterations/manual-utest-migration/execution-report.md` | `no` | `This pass is not a final stop report update.` |

## Gitflow Decision

- Starting branch: `feature/manual-utest-migration-1-cutover`
- Target branch: `feature/manual-utest-migration-1-cutover`
- Branch action: `stayed on the existing feature branch because gitflow is already satisfied for the selected step-5 implementation pass`

## Commit Message

```text
feat(algorithms): rewrite step 5 algorithm suites

Package the selected step-5 migration as one plan-step commit:
semantic rewrites across interpolation or resampling,
edge-detection or transform, and numeric or clustering or hashing
or sorting coverage, plus shared algorithm fixtures or assertions
and the updated manual inventory rows.

This also folds in the zero-test discovery repair by recording the
stale VISION_TEST_CASES shell-state root cause, rerunning the
grouped step-5 validations with the case filter cleared to real
counts, fixing Canny.applyHysteresis opaque-edge promotion, and
correcting the exposed Canny and SimpleLineDetector expectations
before the first review handoff.

Plan: .github/plans/manual-utest-migration-5-algorithms.md
Pass: initial implementation pass
```

## Result

- Commit hash: `this commit`
- Push result: `push this commit to origin/feature/manual-utest-migration-1-cutover immediately after creation when origin is available`
- Workspace status after commit: `expected clean after staging the selected step-5 implementation files plus the current step-5 iteration-state files`
- Remaining uncommitted files: `none expected`
- Follow-up needed: `Hand the iteration to @Intake or @Inspect for the first step-5 review pass while carrying forward D-003, the Windows env-var filtered-run fallback, and the stale-shell-case-filter lesson.`

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
| `19` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the approved step-4 closeout bookkeeping, marks the plans complete, and points the next recovery step at the algorithms migration while preserving D-003 plus the Windows env-var filtered-run fallback.` |
| `20` | `this commit` | `feature/manual-utest-migration-1-cutover` | `Packages the initial step-5 implementation delta, including the semantic algorithm-suite rewrites, shared AlgorithmFixtures or ResamplerAssertions helpers, manual inventory updates, the exposed Canny hysteresis fix, the corrected Canny or SimpleLineDetector expectations, and the current step-5 iteration-state files.` |
