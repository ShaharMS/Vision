# Iteration Convention

Active execution state lives under `<temp>/vision/iterations/{iteration-slug}/` so agents can resume without chat memory.

## Three packet files

| File | Owner | Purpose |
|------|-------|---------|
| `run-ledger.md` | `iterate` (or bootstrapper) | Current state: step, branch, commits, verdict, next action |
| `implementation-handoff.md` | `implement` | Latest pass: files changed, verification, review dispositions |
| `review-packet.md` | `inspect` | Findings, verdict, waivers, review history |

Do not create additional packet types for new iterations. Legacy iterations may still contain older files (`commit-packet.md`, `timeline.md`, `decision-log.md`, `execution-report.md`, `manual-reviewes.md`, etc.); ignore them unless repairing history.

## Bootstrap

- Slug defaults to the active sub-plan filename without `.md`.
- Branch defaults to `feature/{slug}` per [COMMIT-CONVENTION.md](COMMIT-CONVENTION.md).
- Create the iteration directory and the three packet files before the first code edit.

## Resume order

1. `run-ledger.md`
2. Active plan step + parent overview
3. `implementation-handoff.md` or `review-packet.md` (whichever matches the last transition)

## `run-ledger.md`

Replaceable summary. Must track:

- Active plan step and overview
- Branch and baseline commit for review
- Latest commit hash
- Current verdict and next agent/action
- Open finding IDs (link to `review-packet.md`)
- Append one-line entries under `## History` for major transitions (replaces separate timeline files)

## `implementation-handoff.md`

Updated each `implement` pass:

- Pass type, changed files, verification evidence
- Commit hash and push result after commit
- Per-finding disposition: `FIXED`, `ALREADY SATISFIED`, `WAIVER REQUESTED`, `WON'T FIX BECAUSE`
- Blockers and workflow friction (process issues, not code bugs)

## `review-packet.md`

Updated each `inspect` pass:

- Preserve `RVW-###` IDs across rounds for the same concern
- Active table: open findings only
- `## Waivers` — accepted exceptions (reference finding ID or plan step)
- `## Review History` — closed rounds and findings
- Verdict: `APPROVED` or `CHANGES REQUESTED`

External review (PR comments, pasted CR text): `iterate` or `inspect` normalizes into this file.

## Final stop

Before stopping (complete or blocked), `iterate` updates `run-ledger.md` with a `## Final Report` section: scope, commits, review rounds, waivers, blockers, workspace state. Commits any remaining agent-authored files per [COMMIT-CONVENTION.md](COMMIT-CONVENTION.md).
