# Iteration State

Durable execution context for active plan steps. See [ITERATION-CONVENTION.md](../../.github/ITERATION-CONVENTION.md).

## Layout

```text
.cursor/iterations/{iteration-slug}/
  run-ledger.md
  implementation-handoff.md
  review-packet.md
```

Templates: [templates/](templates/)

## Ownership

| File | Primary owner |
|------|----------------|
| `run-ledger.md` | `iterate` |
| `implementation-handoff.md` | `implement` |
| `review-packet.md` | `inspect` |

## Quick resume

1. `run-ledger.md` → current step, branch, verdict
2. Active plan step in `.cursor/plans/` + parent overview
3. Latest packet from the previous agent in the loop
