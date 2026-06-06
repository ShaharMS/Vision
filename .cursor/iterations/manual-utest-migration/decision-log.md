# Decision Log

## Accepted Decisions

| Decision ID | Scope | Made by | Decision | Rationale |
|-------------|-------|---------|----------|-----------|
| D-001 | `.github/plans/manual-utest-migration-1-cutover.md` | `@Iterate` | `Use step 1 from the attached overview as the first operable scope for this iteration.` | `The overview is attached explicitly and step 1 is the first incomplete sub-plan in execution order.` |
| D-002 | `.github/plans/manual-utest-migration-1-cutover.md` | `@Implement` | `Use the documented VISION_CI_* env-var fallback for LocalCi verification on this Windows Haxe build.` | `The plan's direct haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only command fails before LocalCi runs because this Haxe CLI rejects -- passthrough with --interp.` |
| D-004 | `.github/plans/manual-utest-migration-7-decommission-and-coverage.md / D-003` | `@Implement` | `Resolve D-003 by deleting the retained generated-runner surface and its generator-owned entrypoints in step 7.` | `The waived diagnostics surface no longer exists after deleting tests/generated, tests/generator, tests/compile.hxml, tests/config.json, and the generator-only catalog artifacts.` |

## Waivers And Exceptions

| Decision ID | Applies to | Approved by | Reason | Follow-up |
|-------------|------------|-------------|--------|-----------|
| `none active` | `n/a` | `n/a` | `Step 7 deleted the only previously waived generated-runner surface, so no active exceptions remain.` | `n/a` |

## Pending Waiver Requests

| Request ID | Applies to | Requested by | Reason | Follow-up |
|------------|------------|--------------|--------|-----------|
| `none active` | `n/a` | `n/a` | `PENDING-RVW-005 is closed because the deleted generated-runner surface no longer needs a waiver.` | `n/a` |

## Closed Waivers And Requests

| Entry ID | Closed by | Original scope | Closure reason |
|----------|-----------|----------------|----------------|
| `D-003` | `D-004` | `RVW-005 / tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7` | `Closed after step 7 deleted tests/generated/src/Main.hx together with tests/generated and tests/compile.hxml, so the waived diagnostics surface no longer exists.` |
| `PENDING-RVW-005` | `D-003` and `D-004` | `.github/plans/manual-utest-migration-2-harness.md` | `Superseded by D-003 during step 2 and fully retired by D-004 once the generated-runner surface was deleted in step 7.` |
