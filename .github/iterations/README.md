# Iteration Workflow

This directory holds the durable context for active agent work. Every active loop gets one folder under `.github/iterations/{iteration-slug}/` so planning, implementation, review, commit work, and finalization can survive context compression and agent handoff.

## Goals

- Keep the current state in one canonical file that another agent can resume from quickly.
- Keep richer supporting context in packet files instead of chat-only summaries.
- Make review findings, rebuttals, commit intent, and accepted waivers durable and reusable.
- Keep plan files, packet files, and `.github/agent-progress/` notes linked together.

## Directory Layout

Every active iteration directory uses this exact layout:

```text
.github/iterations/{iteration-slug}/
  run-ledger.md
  implementation-handoff.md
  review-packet.md
  commit-packet.md
  decision-log.md
  timeline.md
  execution-report.md
```

Do not rename these files. Other agents are allowed to assume these names.

## Ownership Model

### Canonical current-state owner

- `run-ledger.md` is the canonical summary of the current loop state.
- `@Iterate` owns this file during autonomous orchestration.
- If `@Implement` or another agent is running without `@Iterate`, it may bootstrap the file once, but should not keep rewriting ownership semantics after `@Iterate` takes over.

### Packet owners

- `implementation-handoff.md` is primarily authored by `@Implement`.
- `review-packet.md` is primarily authored by `@Intake`.
- `commit-packet.md` is primarily authored by `@Inscribe`.
- `decision-log.md` is append-only and may be updated by `@Iterate`, `@Inspect`, `@Implement`, `@Intake`, or `@Index` when they accept a waiver, settle a dispute, or lock a design decision.
- `timeline.md` is append-only. Packet-owning agents should append their own transition entries, and `@Index` curates the sequence and backfills missing context when needed.
- `execution-report.md` is primarily authored by `@Iterate` at final stop time, with `@Index` allowed to help when the caller explicitly asks for stop reporting.

### Read requirements

Unless the prompt explicitly narrows scope, agents should read these files before acting:

- `@Inquire`: parent plan, selected step, and `run-ledger.md` when refining an in-flight plan.
- `@Implement`: `run-ledger.md`, `review-packet.md`, and `decision-log.md`.
- `@Inspect`: selected plan step, `implementation-handoff.md`, `review-packet.md`, and `decision-log.md`.
- `@Intake`: the incoming review source and the current `review-packet.md` if it exists.
- `@Inscribe`: `implementation-handoff.md`, `review-packet.md`, `commit-packet.md`, and `execution-report.md` when it exists.
- `@Index`: all packet files when writing a resumable summary, and `execution-report.md` when it exists.
- `@Iterate`: all packet files when resuming or changing loop phase, and `execution-report.md` before any final stop.

## File Rules

### 1. `run-ledger.md`

Purpose: current state only.

- Replaceable summary.
- Must always point to the selected plan step, parent overview, current branch, baseline commit, latest commit, next agent, and current status.
- Must always include the matching `.github/agent-progress/` note path.

### 2. `implementation-handoff.md`

Purpose: the latest implementer-facing and reviewer-facing summary.

- Replace the `## Current Pass` section on each new implementation pass.
- Keep the `## Pass History` table so later agents can recover prior passes quickly.
- List changed files, verification, unresolved risks, and disposition per review finding.

### 3. `review-packet.md`

Purpose: normalized review that another agent can consume without reinterpretation.

- `@Intake` should preserve finding IDs across rounds when the underlying issue is the same.
- Findings must include severity, file reference, concern, required action, and evidence.
- Dispositions must track `FIXED`, `ALREADY SATISFIED`, `WAIVER REQUESTED`, `WON'T FIX BECAUSE`, or `OPEN`.

### 4. `commit-packet.md`

Purpose: explicit commit grouping and gitflow intent.

- Capture the current pass type, commit scope, included files, excluded files, branch action, commit message, the actual commit hash, and the actual push result.
- Do not leave placeholders such as `this commit`; once a commit exists, record the full commit id in the packet history and result section.
- `@Inscribe` should update this file after every commit-producing pass.

### 5. `decision-log.md`

Purpose: durable record of accepted waivers, design choices, and review outcomes that should not be re-litigated in the same iteration.

- Append-only.
- Every entry must reference the plan step or finding ID it relates to.

### 6. `timeline.md`

Purpose: append-only event trail for cross-agent recovery.

- Packet-owning agents should add a narrow entry when they finish a major transition they own.
- `@Index` keeps the sequence readable, backfills missed transitions, and updates the matching `.github/agent-progress/` note.
- Add entries for bootstrap, implementation passes, `@Inspect` review verdicts, `@Intake` review normalizations, commit events, approvals, plan finalization, and blockers.

### 7. `execution-report.md`

Purpose: durable end-of-execution report for the current run.

- Must be written or updated before an orchestrator stops because work is complete or blocked.
- Must describe what actually happened, including scope, files changed, verification run, review outcomes, commits, push results, waivers/exceptions, blockers, and final workspace state.
- Must not claim the run is clean if relevant files remain uncommitted or diagnostics remain failing.

## Bootstrap Rules

- The default iteration slug should derive from the active plan step file name.
- `@Iterate` should create the directory and required files before the first delegated implementation pass.
- If `@Implement` is invoked directly on a step without an iteration directory, it should create the directory and a minimal `run-ledger.md` plus `implementation-handoff.md` before editing code.
- `@Inquire` should recommend an iteration slug and call out which verification evidence later agents must preserve.
- `execution-report.md` should be created from the template during bootstrap even though it is mainly filled at stop time.

## Resume Rules

When an agent resumes an existing iteration, it should recover state in this order:

1. Read `run-ledger.md` for the current loop state.
2. Read the selected plan step and parent overview.
3. Read the packet file owned by the previous agent in the loop.
4. Read `decision-log.md` for accepted waivers or settled disputes.
5. Read `timeline.md` only if more history is needed.
6. Read `execution-report.md` when resuming after a prior stop.

## Packet Templates

Use the files under `.github/iterations/templates/` as the source of truth for headings. If a packet is missing, create it with the matching template headings before continuing.