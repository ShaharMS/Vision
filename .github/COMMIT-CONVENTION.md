# Commit Convention

Commits should tell the story of the plan: **one completed sub-plan step → one commit** by default.

## Branch rules

| Situation | Branch |
|-----------|--------|
| New plan step (default) | `feature/{iteration-slug}` |
| Critical production fix from `main` | `hotfix/{slug}` |
| Small integration fix on `develop` or `dev` (≤2 files, ≤20 lines, build/CI/config only) | May commit on the integration branch when explicitly scoped |

- **Iteration slug** = active sub-plan filename without `.md` (e.g. `hough-harris-feature-detection-1-foundation`).
- Never commit feature work directly to `main`.
- Do not amend commits or skip hooks (`--no-verify`).
- When `origin` exists, push after every commit-producing pass.
- Do not force-push.

## One commit per plan step

Default: completing one sub-plan produces **exactly one commit** containing:

- All source changes for that step
- Plan status updates for that step (and parent overview if needed)
- Iteration packet updates for that pass

Split into multiple commits only when the plan explicitly calls for it or changes are clearly unrelated to the active step.

## Commit message format

```
<type>(<scope>): <imperative subject ≤72 chars>

<optional body: why, not what>
Plan: .cursor/plans/{plan-step}.md
```

**Types:** `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`

**Scope:** area (`algorithms`, `ds`, `vision-api`, `tests`, `ci`, …)

**Review follow-up** (same step, after `inspect` findings):

```
fix(<scope>): address review for <step short title>

Plan: .cursor/plans/{plan-step}.md
Pass: review follow-up
```

## Staging rules

- Group by **plan step intent**, not folder proximity.
- Unrelated dirty files: exclude and note them; do not mix into the step commit.
- Skip temp artifacts: `*.log`, `bin/`, editor files, etc.
- On hook failure: report output and stop; do not bypass the hook.

## Delegated / orchestrated runs

When `iterate` or delegated `implement` finishes a verified pass:

1. Create or switch to `feature/{iteration-slug}` before the first commit of that iteration.
2. Stage the step scope + matching packet/plan bookkeeping.
3. Commit with message per this document.
4. Push to `origin`.
5. Record branch, commit hash, and push result in `implementation-handoff.md`.

Review always runs against **committed** deltas unless the caller explicitly requests working-tree review.