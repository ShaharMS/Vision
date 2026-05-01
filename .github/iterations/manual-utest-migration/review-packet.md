# Review Packet

## Review Source

- Source type: `@Inspect output for committed delta`
- Scope: `.github/plans/manual-utest-migration-1-cutover.md`
- Baseline: `f46848c831cf35ed2b6a8cd6d7e379d118a22bde..9439dd742d49f6605b5d2f605431145141533250`
- Reviewer: `@Inspect`

## Review Checklist

- [x] Plan intent reviewed
- [x] Verification claims checked
- [x] Repository conventions checked
- [ ] Shared package boundaries checked
- [x] Naming and structure checked
- [ ] Nesting and complexity checked
- [x] Risks and regressions checked

## Findings

| Finding ID | Severity | File | Concern | Required action | Evidence |
|------------|----------|------|---------|-----------------|----------|
| `RVW-001` | `MAJOR` | `tests/README.md#L43, tests/README.md#L426` | `Step 1 requires repository docs to stop describing the generated tree as the operational suite, but the README still says the repo-root fast path runs the generated suite and later says the committed suite under the generated tree is what test.hxml, LocalCi, and GitHub Actions execute.` | `Fix the remaining stale operational-path statements so the docs consistently mark tests/generated and tests/compile.hxml as reference-only.` | `The real entrypoints already target the authored tree in test.hxml#L1, tests/ci/LocalCi.hx#L32, and .github/workflows/main.yml#L192, so the current README is now false and the cutover step is incomplete.` |
| `RVW-002` | `MAJOR` | `tests/src/PrettyReporter.hx#L50, tests/src/PrettyReporter.hx#L97, tests/src/PrettyReporter.hx#L119, tests/src/PrettyReporter.hx#L151` | `The promoted reporter was re-encoded during the move, replacing the original box-drawing and emoji literals from tests/generated/src/PrettyReporter.hx with mojibake sequences.` | `Restore the original UTF-8 literals or replace them with ASCII-safe output, then rerun the repo-root suite to confirm the reporter output is clean.` | `The old-vs-new diff shows encoding corruption rather than intended behavioral change, and haxe test.hxml now prints corrupted sequences such as Ã¢Å“â€œ and ðŸ¥³ in the success output instead of the prior glyphs.` |

## Dispositions

| Finding ID | Status | Owner | Evidence | Reply |
|------------|--------|-------|----------|-------|
| `RVW-001` | `OPEN` | `@Implement` | `@Inspect reported stale README operational-path claims that still present the generated tree as the active suite despite the actual entrypoints already targeting tests/src.` | `No implementer response recorded in this round.` |
| `RVW-002` | `OPEN` | `@Implement` | `@Inspect reported mojibake in tests/src/PrettyReporter.hx after the move and tied it to corrupted repo-root test output.` | `No implementer response recorded in this round.` |

## Approval Gate

- Current verdict: `CHANGES REQUESTED`
- Approval blockers: `RVW-001, RVW-002`
- Next reviewer: `@Inspect after @Implement addresses the open findings`

## Review History

| Round | Verdict | Reviewer | Notes |
|-------|---------|----------|-------|
| `1` | `CHANGES REQUESTED` | `@Inspect` | `Opened RVW-001 for stale README operational-path statements and RVW-002 for PrettyReporter encoding corruption. The Windows Haxe -- passthrough caveat was accepted as non-blocking because the CLI rejected -- before LocalCi ran and the VISION_CI_* plus JS compile-only fallbacks passed.` |
