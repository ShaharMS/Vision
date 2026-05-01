# Review Packet

## Review Source

- Source type: `@Inspect approval for committed delta`
- Scope: `.github/plans/manual-utest-migration-2-harness.md`
- Baseline: `4649713738100c31fb9277bcf66e4b7e31678648..a811b9d6e98d50dcf625add678f9747873efab87`
- Reviewer: `@Inspect`

## Review Checklist

- [x] Plan intent reviewed
- [x] Verification claims checked
- [x] Repository conventions checked
- [ ] Shared package boundaries checked
- [ ] Naming and structure checked
- [x] Nesting and complexity checked
- [x] Risks and regressions checked

## Findings

| Finding ID | Severity | File | Concern | Required action | Evidence |
|------------|----------|------|---------|-----------------|----------|
| `RVW-001` | `MAJOR` | `tests/README.md#L43, tests/README.md#L426` | `Step 1 requires repository docs to stop describing the generated tree as the operational suite, but the README still says the repo-root fast path runs the generated suite and later says the committed suite under the generated tree is what test.hxml, LocalCi, and GitHub Actions execute.` | `Fix the remaining stale operational-path statements so the docs consistently mark tests/generated and tests/compile.hxml as reference-only.` | `Round 1 evidence cited false README operational-path statements against the real entrypoints in test.hxml#L1, tests/ci/LocalCi.hx#L32, and .github/workflows/main.yml#L192. Round 2 @Inspect output reported that the prior README finding no longer reproduces.` |
| `RVW-002` | `MAJOR` | `tests/src/PrettyReporter.hx#L50, tests/src/PrettyReporter.hx#L97, tests/src/PrettyReporter.hx#L119, tests/src/PrettyReporter.hx#L151` | `The promoted reporter was re-encoded during the move, replacing the original box-drawing and emoji literals from tests/generated/src/PrettyReporter.hx with mojibake sequences.` | `Restore the original UTF-8 literals or replace them with ASCII-safe output, then rerun the repo-root suite to confirm the reporter output is clean.` | `Round 1 evidence cited mojibake in the promoted reporter and corrupted repo-root test output. Round 2 @Inspect output reported that the prior reporter finding no longer reproduces.` |
| `RVW-003` | `BLOCKER` | `tests/generator/ManualInventoryBuilder.hx#L42` | `The follow-up fixes the current member omissions, but the new inventory builder still does not preserve deferred coverage state. It never reads any existing deferredMembers state back from the checked-in manifest and always rewrites it to the full discovered members list, so rerunning the builder after later migration steps would erase curated uncovered-or-deferred tracking.` | `Update the builder so regeneration preserves the checked-in deferred coverage state required by step 1, then add verification that rerunning haxe manual-inventory.hxml does not erase deferred progress.` | `Round 2 opened RVW-003 for missing ArrayTools and ImageTools members. Round 3 @Inspect confirmed those omissions are fixed but kept the finding open because deferredMembers was still rewritten on rerun. Round 4 @Inspect approved the committed delta after confirming the preservation fix in tests/generator/ManualInventoryBuilder.hx and the final inventory entries.` |
| `RVW-004` | `MAJOR` | `tests/README.md#L257, tests/README.md#L258, tests/README.md#L260` | `Step 2 requires the filter contract to be documented outside chat history, but the README documents the Windows env-var fallback with CMD-style set commands that do not execute in the PowerShell environment used for local verification here. Because the direct haxe passthrough form already fails before Main runs on this build, the documented fallback is not a runnable replacement in the local shell.` | `Replace or supplement the fallback examples with PowerShell-compatible commands such as $env:VISION_TESTS='...' and $env:VISION_TEST_CASES='...', or clearly label separate CMD and PowerShell variants so the Windows fallback is directly runnable in this environment.` | `The selected step explicitly requires the filter contract to be documented in .github/plans/manual-utest-migration-2-harness.md#L63. In this PowerShell environment, haxe test.hxml -- --tests ArrayToolsTest exits with unknown option '--' before Main runs, while set VISION_TESTS=ImageTest leaves $env:VISION_TESTS unset. This keeps D-002 intact as the accepted step-1 LocalCi passthrough caveat, but shows the step-2 README fallback examples are not executable in the shell used here.` |
| `RVW-005` | `BLOCKER` | `tests/generated/src/Main.hx#L6, tests/generated/src/Main.hx#L7` | `Workspace diagnostics remain red in the retained reference-only generated runner because Haxe cannot resolve utest.Runner and PrettyReporter there, but the active step-2 harness entrypoints do not compile that surface.` | `No code fix is required for step 2 beyond preserving the accepted narrow waiver in .github/iterations/manual-utest-migration/decision-log.md until step 7 removes tests/generated and tests/compile.hxml.` | `The approval round passes the type-safety gate with an accepted narrow waiver scoped only to tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7, while test.hxml, .vscode/settings.json, .vscode/tasks.json, tests/ci/LocalCi.hx, and .github/workflows/main.yml contain no tests/generated or tests/compile.hxml references.` |

## Dispositions

| Finding ID | Status | Owner | Evidence | Reply |
|------------|--------|-------|----------|-------|
| `RVW-001` | `FIXED` | `@Implement` | `The round 2 @Inspect output explicitly says the prior README finding no longer reproduces, and the convention gate now passes for the tests/src cutover documentation.` | `Satisfied by the committed README cutover wording in 2c71242bfc6c849b5944a1c804e223c0bba6f39c.` |
| `RVW-002` | `FIXED` | `@Implement` | `The round 2 @Inspect output explicitly says the prior reporter finding no longer reproduces, and the verification/type-safety gates now pass for the exercised path.` | `Satisfied by the committed PrettyReporter follow-up in 2c71242bfc6c849b5944a1c804e223c0bba6f39c.` |
| `RVW-003` | `FIXED` | `@Implement` | `The approval round reports no material findings, passes the plan-intent, verification, type-safety, convention, complexity, and regression gates, and explicitly substantiates the RVW-003 preservation fix with tests/generator/ManualInventoryBuilder.hx plus the final inventory entries.` | `Closed by the committed deferredMembers-preservation follow-up in 52a6b0f045e4315d2a12581b04c8c102cf77900b.` |
| `RVW-004` | `FIXED` | `@Implement` | `The current @Inspect round explicitly says RVW-004 is fixed, while the scope evidence, plan intent, verification, convention, complexity, and regression gates all pass for the committed step-2 harness delta.` | `Closed by the committed README shell-syntax follow-up in fc51e41b22c39050acf832f88737794bb319e82c.` |
| `RVW-005` | `WON'T FIX BECAUSE` | `@Implement` | `The approval round reports no material findings, passes the reviewed gates, and explicitly accepts RVW-005 as a narrow waiver for the retained reference-only tests/generated/src/Main.hx runner while the active harness stays on tests/src.` | `Accepted as D-003 in decision-log.md for tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7 only; the exception remains in force until step 7 removes that surface.` |

## Approval Gate

- Current verdict: `APPROVED`
- Approval blockers: `none`
- Next reviewer: `@Iterate`

## Review History

| Round | Verdict | Reviewer | Notes |
|-------|---------|----------|-------|
| `1` | `CHANGES REQUESTED` | `@Inspect` | `Opened RVW-001 for stale README operational-path statements and RVW-002 for PrettyReporter mojibake, while preserving the accepted Windows passthrough caveat as non-blocking context.` |
| `2` | `CHANGES REQUESTED` | `@Inspect` | `RVW-001 and RVW-002 no longer reproduce and are now treated as fixed. Opened RVW-003 because the manual inventory undercounts public overload-heavy APIs, failing the plan intent, verification, and regression gates. The accepted Windows Haxe CLI passthrough caveat remains non-blocking.` |
| `3` | `CHANGES REQUESTED` | `@Inspect` | `RVW-003 remains open with the same finding ID. The current ArrayTools and ImageTools omissions are fixed, but the new inventory builder still fails the plan intent, verification, and regression gates because rerunning it rewrites deferredMembers and erases curated deferred coverage progress. The accepted Windows Haxe CLI passthrough caveat remains non-blocking.` |
| `4` | `APPROVED` | `@Inspect` | `Reviewed f46848c831cf35ed2b6a8cd6d7e379d118a22bde..52a6b0f045e4315d2a12581b04c8c102cf77900b and found no material issues. All reported gates pass, RVW-003 is resolved, D-002 remains accepted and non-blocking, and the residual risks are limited to the existing single-line declaration assumption in ManualInventoryBuilder plus the pre-existing deprecation warnings from tests/src/tests/GaussTest.hx and tests/src/tests/ImageToolsTest.hx.` |
| `5` | `CHANGES REQUESTED` | `@Inspect` | `First step-2 harness review for 4649713738100c31fb9277bcf66e4b7e31678648..07f8f8284c6258a4d0c38bce736a87b4dbe718be opened RVW-004 because the README documents the Windows env-var fallback with CMD-style set commands that are not executable in the PowerShell environment used for local verification. This is distinct from D-002, which remains the accepted step-1 LocalCi passthrough caveat.` |
| `6` | `CHANGES REQUESTED` | `@Inspect` | `Reviewed 4649713738100c31fb9277bcf66e4b7e31678648..fc51e41b22c39050acf832f88737794bb319e82c. RVW-004 no longer reproduces and is now fixed, but RVW-005 opens as a new blocker because workspace diagnostics still fail in tests/generated/src/Main.hx on unresolved utest.Runner and PrettyReporter imports, with no accepted waiver recorded in decision-log.md. The type-safety gate fails while the other reported gates pass.` |
| `7` | `APPROVED` | `@Inspect` | `Reviewed 4649713738100c31fb9277bcf66e4b7e31678648..a811b9d6e98d50dcf625add678f9747873efab87 and found no material issues. The scope evidence, plan intent, verification, type-safety, convention, complexity, and regression gates all pass. RVW-005 is accepted as a narrow waiver for tests/generated/src/Main.hx#L6 and tests/generated/src/Main.hx#L7 until step 7 removes that reference-only surface. Residual risks remain limited to opening that file directly still showing red diagnostics and the pre-existing deprecation warnings from tests/src/tests/GaussTest.hx and tests/src/tests/ImageToolsTest.hx.` |

