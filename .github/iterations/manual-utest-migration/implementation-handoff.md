# Implementation Handoff

## Current Pass

- Pass type: `implementation`
- Authoring agent: `@Implement`
- Plan step: `.github/plans/manual-utest-migration-1-cutover.md`
- Branch: `feature/manual-utest-migration-1-cutover`
- Summary: `Promoted the current executable suite into tests/src, stripped generated ownership markers, repointed default execution entrypoints, added a checked-in migration inventory, and marked tests/generated as reference-only in docs.`

## Files Changed

| Path | Intent | Verification impact |
|------|--------|---------------------|
| `tests/src/**` | `Promote the checked-in operational suite into the authored root and strip generated ownership markers.` | `haxe test.hxml` |
| `test.hxml` | `Repoint the repo-root default test command to tests/src.` | `haxe test.hxml` |
| `tests/ci/LocalCi.hx` | `Repoint LocalCi to tests/src and remove stale generated-path references.` | `haxe tests/ci/local-ci.hxml` fallback plus js compile-only |
| `.github/workflows/main.yml` | `Repoint CI compilation to tests/src.` | `default-path search` |
| `tests/catalog/manual-test-inventory.json` | `Record explicit ownership status and public-member inventory for every src/vision module.` | `inventory spot-check and diagnostics` |
| `tests/README.md` | `Document tests/src as the operational suite and freeze tests/generated/tests/compile.hxml as reference-only.` | `default-path search and diagnostics` |

## Verification

| Check | Method | Result | Evidence |
|-------|--------|--------|----------|
| `Repo-root suite` | `haxe test.hxml` | `passed` | `716 tests / 716 methods passed against tests/src after the cutover and final ownership-marker cleanup.` |
| `Plan-specified LocalCi command` | `haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only` | `environment limitation` | `This Windows Haxe build rejects -- passthrough with "unknown option '--'" before LocalCi runs.` |
| `LocalCi fallback parity` | `VISION_CI_TARGETS=interp VISION_CI_COMPILE_ONLY=1 haxe tests/ci/local-ci.hxml` | `passed` | `The documented env-var fallback completed successfully.` |
| `LocalCi real compile path` | `VISION_CI_TARGETS=js VISION_CI_COMPILE_ONLY=1 VISION_CI_SKIP_INSTALL=1 haxe tests/ci/local-ci.hxml` | `passed` | `Confirmed LocalCi compiles tests/src on a non-interp target.` |
| `Default command surface search` | `grep_search over test.hxml, tests/ci/**, .github/workflows/**, and .vscode/**` | `passed` | `No matches remained for tests/generated/src, tests/compile.hxml, or BuildMacro.generateAll in default command/workflow files.` |
| `Diagnostics` | `get_errors on touched files` | `passed` | `No errors reported for tests/src/Main.hx, tests/src/PrettyReporter.hx, manual-test-inventory.json, tests/README.md, test.hxml, LocalCi.hx, or main.yml.` |

## Review Responses

| Finding ID | Disposition | Evidence | Notes |
|------------|-------------|----------|-------|
| `none` | `ALREADY SATISFIED` | `review-packet.md contains no findings.` | `No delegated review findings were supplied for this pass.` |

## Risks And Follow-Ups

- `tests/catalog/manual-test-inventory.json` uses regex-based public-member discovery and heuristic exclusions; later migration steps should refine entries as suites become fully manual.
- `haxe tests/ci/local-ci.hxml -- --...` remains unusable on this Windows Haxe build because the CLI rejects -- passthrough before LocalCi runs. Use the documented VISION_CI_* env vars in this environment.
- `tests/generated/**` and `tests/compile.hxml` remain in the repository intentionally as temporary reference material until later migration steps delete the old auto path.

## Pass History

| Pass | Commit | Summary |
|------|--------|---------|
| `1` | `this commit` | `Implemented step 1 cutover: promoted tests/src, repointed default entrypoints, added the manual inventory, and validated the authored root plus LocalCi fallback paths.` |
