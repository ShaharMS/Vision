# Decision Log

## Accepted Decisions

| Decision ID | Scope | Made by | Decision | Rationale |
|-------------|-------|---------|----------|-----------|
| `MRI-DEC-001` | `.github/plans/manual-review-integration.md` | `@Iterate bootstrap` | `Capture the current cr.md review in a new repo-root file named manual-reviewes.md and assign durable manual-review IDs there instead of leaving the review only in chat or in the source CR file.` | `The user explicitly requested a new durable file with IDs for the manual review, and the workflow change needs a canonical source that future iterations can consume.` |
| `MRI-DEC-002` | `.github/plans/manual-review-integration.md` | `@Iterate bootstrap` | `Keep this iteration scoped to workflow integration only; do not start resolving the product-code requests from cr.md after the manual-review file and agent-prompt changes are in place.` | `The user explicitly said there is no need to start working the review items themselves after incorporating the manual review and the agent self changes.` |

## Waivers And Exceptions

| Decision ID | Applies to | Approved by | Reason | Follow-up |
|-------------|------------|-------------|--------|-----------|
