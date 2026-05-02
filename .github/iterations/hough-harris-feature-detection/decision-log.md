# Decision Log

## Accepted Decisions

| Decision ID | Scope | Made by | Decision | Rationale |
|-------------|-------|---------|----------|-----------|
| HH-DEC-001 | .github/plans/hough-harris-feature-detection-overview.md | @Iterate bootstrap | Treat SimpleHough as a compatibility seam rather than the long-term public API surface. | Matches the selected overview and preserves Vision.hx as the stable public entry point. |
| HH-DEC-002 | .github/plans/hough-harris-feature-detection-1-foundation.md | @Iterate bootstrap | Use Matrix2D as the default raw numeric-map representation for Hough accumulators and Harris response maps unless a later reviewed hotspot clearly justifies a narrower storage type. | Matches the selected plan and avoids leaking float-map semantics into unrelated Image APIs. |
| HH-DEC-003 | RVW-001 and RVW-002 follow-up on .github/plans/hough-harris-feature-detection-1-foundation.md | @Implement review remediation | Keep the review follow-up narrowly scoped to HoughLine2D ray semantics and packet/progress-state alignment without widening the already accepted placeholder Hough/Harris or Circle2D foundation surfaces. | Matches the committed @Inspect review, closes the requested changes locally, and preserves the intended step-1 foundation boundary for re-review. |

## Waivers And Exceptions

| Decision ID | Applies to | Approved by | Reason | Follow-up |
|-------------|------------|-------------|--------|-----------|