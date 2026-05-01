# Decision Log

## Accepted Decisions

| Decision ID | Scope | Made by | Decision | Rationale |
|-------------|-------|---------|----------|-----------|
| D-001 | `.github/plans/manual-utest-migration-1-cutover.md` | `@Iterate` | `Use step 1 from the attached overview as the first operable scope for this iteration.` | `The overview is attached explicitly and step 1 is the first incomplete sub-plan in execution order.` |
| D-002 | `.github/plans/manual-utest-migration-1-cutover.md` | `@Implement` | `Use the documented VISION_CI_* env-var fallback for LocalCi verification on this Windows Haxe build.` | `The plan's direct haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only command fails before LocalCi runs because this Haxe CLI rejects -- passthrough with --interp.` |

## Waivers And Exceptions

| Decision ID | Applies to | Approved by | Reason | Follow-up |
|-------------|------------|-------------|--------|-----------|

## Pending Waiver Requests

| Request ID | Applies to | Requested by | Reason | Follow-up |
|------------|------------|--------------|--------|-----------|
| `PENDING-RVW-005` | `.github/plans/manual-utest-migration-2-harness.md` | `@Implement` | `tests/generated/src/Main.hx is a retained reference-only runner during the manual migration. Clearing the remaining editor diagnostics with a code change would require either reactivating generated-tree build ownership or mutating the reference artifact purely to satisfy workspace display behavior, both of which conflict with the step-1 cutover and step-2 harness intent. The active command surfaces still compile and run tests/src via test.hxml, .vscode/settings.json, .vscode/tasks.json, tests/ci/LocalCi.hx, and .github/workflows/main.yml, while get_errors confines the red diagnostics to tests/generated/src/Main.hx and reports no errors for tests/src/Main.hx, tests/src/PrettyReporter.hx, or tests/generated/src/PrettyReporter.hx.` | `If approved, scope the waiver only to tests/generated/src/Main.hx until .github/plans/manual-utest-migration-7-decommission-and-coverage.md removes tests/generated and tests/compile.hxml.` |
