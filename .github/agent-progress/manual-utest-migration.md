# Manual Utest Migration

- Active step: `.github/realized/manual-utest-migration-7-decommission-and-coverage.md`
- Overview: `.github/realized/manual-utest-migration-overview.md`
- Iteration state: `Complete; all manual-utest-migration steps are approved, realized, and closed out.`
- Branch and final approved follow-up range: `feature/manual-utest-migration-1-cutover at f9c59b654357eb1e8da8f5a7908dc1e8cefc2c8b..4d5676ec111e2edb504afa4033e35f32739711fc.`
- Latest review outcome: `@Inspect approved the final step-7 re-review after confirming the stale tracked root .unittest metadata is gone, future .unittest cache output is ignored, and decision-log.md no longer keeps D-003 or PENDING-RVW-005 active.`
- Repo end state: `The repository is manual-only: tests/src is the authoritative suite, tests/generated and tests/generator plus tests/compile.hxml and other generator-only artifacts are removed, the surviving docs describe the manual workflow, and the final inventory is reconciled to manual or excluded state.`
- Waiver state: `No active waiver remains; D-003 was resolved in step 7 when the deleted generated-runner surface and its generator-owned entrypoints were retired.`
- Open blockers: `none recorded`
- Next action: `None; the queue-exhausted closeout is published on feature/manual-utest-migration-1-cutover.`