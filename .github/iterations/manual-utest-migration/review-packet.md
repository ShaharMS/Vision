# Review Packet

## Review Source

- Source type: `@Inspect output for committed delta`
- Scope: `.github/plans/manual-utest-migration-1-cutover.md`
- Baseline: `f46848c831cf35ed2b6a8cd6d7e379d118a22bde..2c71242bfc6c849b5944a1c804e223c0bba6f39c`
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
| `RVW-003` | `BLOCKER` | `tests/catalog/manual-test-inventory.json#L1898, tests/catalog/manual-test-inventory.json#L1916` | `The step-1 inventory is materially incomplete. The ArrayTools entry only records flatten, distanceTo, flatMap, and distinct, while public raise, min, max, average, and median overloads are missing. The ImageTools entry also omits the public loadFromFile overloads.` | `Update the step-1 inventory so discovered public members and overload-heavy APIs are fully recorded before later migration steps consume it.` | `@Inspect round 2 tied the omissions to src/vision/tools/ArrayTools.hx#L30, #L63, #L108, #L138, and #L159 plus src/vision/tools/ImageTools.hx#L76 and #L187, and flagged plan intent, verification, and regression gate failures because manual-utest-migration-1-cutover.md#L54 requires the inventory to record discovered public members that require coverage.` |

## Dispositions

| Finding ID | Status | Owner | Evidence | Reply |
|------------|--------|-------|----------|-------|
| `RVW-001` | `FIXED` | `@Implement` | `The round 2 @Inspect output explicitly says the prior README finding no longer reproduces, and the convention gate now passes for the tests/src cutover documentation.` | `Satisfied by the committed README cutover wording in 2c71242bfc6c849b5944a1c804e223c0bba6f39c.` |
| `RVW-002` | `FIXED` | `@Implement` | `The round 2 @Inspect output explicitly says the prior reporter finding no longer reproduces, and the verification/type-safety gates now pass for the exercised path.` | `Satisfied by the committed PrettyReporter follow-up in 2c71242bfc6c849b5944a1c804e223c0bba6f39c.` |
| `RVW-003` | `OPEN` | `@Implement` | `@Inspect reported that tests/catalog/manual-test-inventory.json undercounts public ArrayTools and ImageTools members, making the checked-in inventory incomplete for the plan's required coverage-discovery seed.` | `No implementer response recorded in this round.` |

## Approval Gate

- Current verdict: `CHANGES REQUESTED`
- Approval blockers: `RVW-003`
- Next reviewer: `@Inspect after @Implement addresses RVW-003`

## Review History

| Round | Verdict | Reviewer | Notes |
|-------|---------|----------|-------|
| `1` | `CHANGES REQUESTED` | `@Inspect` | `Opened RVW-001 for stale README operational-path statements and RVW-002 for PrettyReporter encoding corruption. The Windows Haxe -- passthrough caveat was accepted as non-blocking because the CLI rejected -- before LocalCi ran and the VISION_CI_* plus JS compile-only fallbacks passed.` |
| `2` | `CHANGES REQUESTED` | `@Inspect` | `RVW-001 and RVW-002 no longer reproduce and are now treated as fixed. Opened RVW-003 because the manual inventory undercounts public overload-heavy APIs, failing the plan intent, verification, and regression gates. The accepted Windows Haxe CLI passthrough caveat remains non-blocking.` |
