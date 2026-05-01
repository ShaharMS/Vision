# Review Packet

## Review Source

- Source type: `@Inspect output for committed delta`
- Scope: `.github/plans/manual-utest-migration-1-cutover.md`
- Baseline: `f46848c831cf35ed2b6a8cd6d7e379d118a22bde..65b0e916018d55409e8c6bab374770cb480bc25e`
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
| `RVW-003` | `BLOCKER` | `tests/generator/ManualInventoryBuilder.hx#L42` | `The follow-up fixes the current member omissions, but the new inventory builder still does not preserve deferred coverage state. It never reads any existing deferredMembers state back from the checked-in manifest and always rewrites it to the full discovered members list, so rerunning the builder after later migration steps would erase curated uncovered-or-deferred tracking.` | `Update the builder so regeneration preserves the checked-in deferred coverage state required by step 1, then add verification that rerunning haxe manual-inventory.hxml does not erase deferred progress.` | `Round 2 opened RVW-003 for missing ArrayTools and ImageTools members. Round 3 @Inspect confirmed those omissions are fixed, but found that tests/generator/ManualInventoryBuilder.hx still rewrites deferredMembers from discovery instead of preserving the manifest state required by manual-utest-migration-1-cutover.md#L55 and #L58 and claimed by implementation-handoff.md#L35.` |

## Dispositions

| Finding ID | Status | Owner | Evidence | Reply |
|------------|--------|-------|----------|-------|
| `RVW-001` | `FIXED` | `@Implement` | `The round 2 @Inspect output explicitly says the prior README finding no longer reproduces, and the convention gate now passes for the tests/src cutover documentation.` | `Satisfied by the committed README cutover wording in 2c71242bfc6c849b5944a1c804e223c0bba6f39c.` |
| `RVW-002` | `FIXED` | `@Implement` | `The round 2 @Inspect output explicitly says the prior reporter finding no longer reproduces, and the verification/type-safety gates now pass for the exercised path.` | `Satisfied by the committed PrettyReporter follow-up in 2c71242bfc6c849b5944a1c804e223c0bba6f39c.` |
| `RVW-003` | `OPEN` | `@Implement` | `Round 3 @Inspect confirmed the ArrayTools and ImageTools omissions are fixed, but found the new builder still rewrites deferredMembers to the full discovered set and therefore is not safe as the authoritative migration tracker.` | `@Implement pass 3 claimed RVW-003 was fixed by making the inventory regeneration path repeatable, but @Inspect rejected that claim because deferred coverage state is still lost on rerun.` |

## Approval Gate

- Current verdict: `CHANGES REQUESTED`
- Approval blockers: `RVW-003`
- Next reviewer: `@Inspect after @Implement addresses RVW-003`

## Review History

| Round | Verdict | Reviewer | Notes |
|-------|---------|----------|-------|
| `1` | `CHANGES REQUESTED` | `@Inspect` | `Opened RVW-001 for stale README operational-path statements and RVW-002 for PrettyReporter encoding corruption. The Windows Haxe -- passthrough caveat was accepted as non-blocking because the CLI rejected -- before LocalCi ran and the VISION_CI_* plus JS compile-only fallbacks passed.` |
| `2` | `CHANGES REQUESTED` | `@Inspect` | `RVW-001 and RVW-002 no longer reproduce and are now treated as fixed. Opened RVW-003 because the manual inventory undercounts public overload-heavy APIs, failing the plan intent, verification, and regression gates. The accepted Windows Haxe CLI passthrough caveat remains non-blocking.` |
| `3` | `CHANGES REQUESTED` | `@Inspect` | `RVW-003 remains open with the same finding ID. The current ArrayTools and ImageTools omissions are fixed, but the new inventory builder still fails the plan intent, verification, and regression gates because rerunning it rewrites deferredMembers and erases curated deferred coverage progress. The accepted Windows Haxe CLI passthrough caveat remains non-blocking.` |
