# Plan Convention

Plans are the contract between planning and execution. Keep them **small, ordered, and verifiable**. Long or vague steps produce inconsistent code.

## Sizing rules

- Split work into **many sub-plans**, not few large ones.
- Each sub-plan must be **completable in one agent session**.
- Each sub-plan touches **one layer or concern** (types, algorithm, public API wrapper, tests — not mixed).
- If a step needs more than ~8 numbered actions or spans unrelated modules without a single verifiable outcome, split it.
- Order by dependency: shared types → algorithm implementation → `Vision.hx` wrapper → tests/docs.

## File layout

```
.cursor/plans/
  {feature-name}-overview.md
  {feature-name}-1-{short-label}.md
  {feature-name}-2-{short-label}.md
  ...
```

- Use **kebab-case** file names.
- Number sub-plans sequentially.
- When all sub-plans are done, move overview + sub-plans to `.cursor/realized/` and fix cross-links (`.cursor/plans/` → `.cursor/realized/`).

## Overview template

```markdown
# Plan: {Feature Title}

## Status: 🔲 Not started

## Overview

{1–2 paragraphs: current state, desired end state, pattern followed.}

## Sub-Plans (execute in order)

| Order | Plan File | Summary |
|-------|-----------|---------|
| 1 | [{feature}-1-{label}.md](.cursor/plans/{feature}-1-{label}.md) | {one line} |

## Key Decisions

- **{Topic}** — {choice and brief rationale}

## Iteration Bootstrap

- **Iteration slug**: `{slug}` — usually the active sub-plan filename without `.md`
- **Required evidence**: {what later agents must preserve}
- **Artifacts to verify**: {test suites, compile targets, or "None"}
```

Record decisions that affect multiple steps, deviate from reference patterns, or fix naming.

## Sub-plan template

````markdown
# Plan: {Feature Title} — Step {N}: {Step Title}

> **Status**: 🔲 Not started
> **Prerequisite**: {link or "None — first step."}
> **Next**: {link or "None — final step."}
> **Parent**: [{feature}-overview.md]({feature}-overview.md)

## TL;DR

{1–2 sentences: scope without reading the full step.}

## Iteration Bootstrap

- **Iteration slug**: `{slug}`
- **Required evidence**: {verification evidence to preserve}
- **Artifacts to verify**: {test class names, CI targets, or "None"}

## Reference Pattern

Link existing code to mimic. If none exists, say so and link the closest analogue.

In [path/to/file.hx](path/to/file.hx):
- {pattern element}

## Steps

### 1. {Action}

{File-scoped, actionable instructions. Minimal structural snippets only — not full implementations.}

### 2. {Action}

{Continue…}

## Verification

- {Concrete check — compile, utest, local CI target}
- {Named test class or regression when behavior matters}
````

### Authoring rules

- **TL;DR** is mandatory.
- **Reference Pattern** is mandatory — search the codebase first.
- Steps are numbered, file-scoped, and unambiguous.
- Snippets show shape only (~5 lines max); executing agents write real code.
- **Verification** must be concrete, not "should work."
- Prefer `haxe tests/ci/local-ci.hxml` or targeted test compilation for the touched scope.
- When revising in-flight work, preserve existing status markers; do not reset completed steps.

## Status markers

| Marker | Meaning |
|--------|---------|
| `🔲 Not started` | Not begun |
| `🔄 In progress` | Active |
| `✅ Completed` | Step done |
| `✅ All steps completed` | Entire plan done (overview only) |

## Revision rules

- One active plan focus at a time.
- If `{feature}-overview.md` already exists, ask whether to revise, supersede, or abandon before writing.
- If execution is in flight, read `.cursor/iterations/{slug}/run-ledger.md` and packets before rewriting.
- Write plans to disk in the same turn once scope is clear; do not leave plans only in chat.
