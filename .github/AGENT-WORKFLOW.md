# Agent Workflow

This repository uses custom Cursor agents for plan-driven development. Agent definitions live in [`.cursor/agents/`](../.cursor/agents/). Agents define **roles and behavior only**; formatting, standards, and structural rules live in the convention documents below.

## Agents

Invoke in Cursor chat with `@inquire`, `@implement`, `@inspect`, or `@iterate`.

| Agent | File | Role |
|-------|------|------|
| `inquire` | `.cursor/agents/inquire.md` | Research the codebase and write plans to disk. Does not implement. |
| `implement` | `.cursor/agents/implement.md` | Execute one plan step at a time, verify, commit, and update iteration state. |
| `inspect` | `.cursor/agents/inspect.md` | Review a committed or working-tree delta against plan intent and repo standards. Read-only on source. |
| `iterate` | `.cursor/agents/iterate.md` | Orchestrate `implement` and `inspect` until a step is approved, then advance automatically. |

## Convention documents

Read these before acting. They are the source of truth for structure and standards.

| Document | Governs |
|----------|---------|
| [AGENTS.md](../AGENTS.md) | Project briefing, convention index, key commands |
| [.cursor/rules/plan-and-commit-workflow.mdc](../.cursor/rules/plan-and-commit-workflow.mdc) | Agent workflow, plans, commits, verification discipline |
| [.cursor/rules/haxe-formatting.mdc](../.cursor/rules/haxe-formatting.mdc) | Tabs, braces, spacing (`hxformat.json`) |
| [.cursor/rules/haxe-library.mdc](../.cursor/rules/haxe-library.mdc) | Layering, naming, docs, typing for `src/` |
| [.cursor/rules/haxe-testing.mdc](../.cursor/rules/haxe-testing.mdc) | utest suites, registration, fixtures, verify commands |
| [PLAN-CONVENTION.md](PLAN-CONVENTION.md) | Plan file layout, sub-plan sizing, templates, verification |
| [COMMIT-CONVENTION.md](COMMIT-CONVENTION.md) | Branch naming, one commit per plan step, commit messages |
| [ITERATION-CONVENTION.md](ITERATION-CONVENTION.md) | `.cursor/iterations/` layout, packet ownership, resume order |

## Directories

| Path | Purpose |
|------|---------|
| `.cursor/plans/` | Active plans (overview + numbered sub-plans) |
| `.cursor/realized/` | Completed plans moved out of `plans/` |
| `.cursor/iterations/{slug}/` | Durable state for an in-flight plan step |
| `.cursor/agent-progress/` | Short resume notes keyed by iteration slug |

## Typical flows

**Planning only:** `@inquire` → plans on disk → human or `@implement` picks up a step.

**Interactive execution:** `@implement` on a named plan step → user reviews in chat or invokes `@inspect`.

**Autonomous execution:** `@iterate` on a plan step → `implement` → `inspect` loop → finalize step → next step until blocked or queue exhausted.

## Principles

1. **Small plan steps** — Many short sub-plans beat few large ones. Large steps degrade code quality.
2. **One step per commit** — Each completed sub-plan maps to one descriptive commit unless `COMMIT-CONVENTION.md` says otherwise.
3. **File-backed state** — Plans and iteration packets survive context loss; chat is not the system of record.
4. **Uniform standards** — All agents enforce the same convention documents; agents do not embed duplicate rules.
