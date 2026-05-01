# Decision Log

## Accepted Decisions

| Decision ID | Scope | Made by | Decision | Rationale |
|-------------|-------|---------|----------|-----------|
| D-001 | `.github/plans/manual-utest-migration-1-cutover.md` | `@Iterate` | `Use step 1 from the attached overview as the first operable scope for this iteration.` | `The overview is attached explicitly and step 1 is the first incomplete sub-plan in execution order.` |
| D-002 | `.github/plans/manual-utest-migration-1-cutover.md` | `@Implement` | `Use the documented VISION_CI_* env-var fallback for LocalCi verification on this Windows Haxe build.` | `The plan's direct haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only command fails before LocalCi runs because this Haxe CLI rejects -- passthrough with --interp.` |

## Waivers And Exceptions

| Decision ID | Applies to | Approved by | Reason | Follow-up |
|-------------|------------|-------------|--------|-----------|
