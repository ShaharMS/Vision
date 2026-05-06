# Manual Reviews

- Source: `cr.md`
- Captured: `2026-05-06`
- Role: durable raw manual-review source for future `@Iterate` and `@Intake` passes
- Current-state owner: `review-packet.md` after `@Intake` normalization
- ID rule: preserve existing IDs and append new ones; do not renumber prior findings

## Status Legend

| Status | Meaning |
|--------|---------|
| `OPEN` | Raw finding is still waiting to be resolved, rebutted, or waived in a scoped iteration review loop. |

## Vision.hx

| ID | Status | Target | Requested change |
|----|--------|--------|------------------|
| `MR-001` | `OPEN` | `Vision.hx` | Rename `houghLineSegmentDetection` to `houghLine2DDetection` so `Vision` exposes the requested shape-focused API name. |
| `MR-002` | `OPEN` | `Vision.hx` | Rename `houghCircleDetection` to `houghCircle2DDetection` so `Vision` uses the requested shape-focused API name. |
| `MR-003` | `OPEN` | `Vision.hx` | Remove `mapHoughCircles` from `Vision` because the review says it is not part of feature detection. |
| `MR-004` | `OPEN` | `Vision.hx` | Replace `harrisCorners:HarrisCorner2D` with `harrisPoint2DCornerDetection:Point2D` in the `Vision` API. |
| `MR-005` | `OPEN` | `Vision.hx` | Remove or move `harrisCornerResponse` out of `Vision` because the review says it does not belong in the public `Vision` feature-detection surface. |
| `MR-006` | `OPEN` | `VisionMain`, `spacebubble.io`, algorithm docs | Generate before-and-after assets for the `Vision` algorithms through `VisionMain`, store them in `spacebubble.io` with the existing filename schema, and push that repo so the hosted assets update. |
| `MR-007` | `OPEN` | algorithm docs | Add before-and-after documentation tables for `simpleLine2DDetection`, `houghLine2DDetection`, `houghCircle2DDetection`, and `harrisPoint2DCornerDetection`, showing the input image and the red overlay output. |

## Vision.algorithms

| ID | Status | Target | Requested change |
|----|--------|--------|------------------|
| `MR-008` | `OPEN` | `vision.algorithms.SimpleHough` | Keep `SimpleHough` unchanged and independent. |
| `MR-009` | `OPEN` | `vision.algorithms`, `vision.ds.specific` | Move the `ProbabilisticSegment` typedef under `vision.ds.specific` and rename it to `ProbabilisticHoughSegment`. |
| `MR-010` | `OPEN` | `HoughCircles.medianBlur` | Replace the local `medianBlur` reimplementation with `Vision.medianBlur`. |
| `MR-011` | `OPEN` | `vision.algorithms`, `vision.ds.specific` | Move `HoughVotePoint` to `vision.ds.specific` and rename it to `HoughLineVotePoint` so it is clearly line-specific. |
| `MR-012` | `OPEN` | `Hough.detectLineSegments` | Stop throwing `VisionException`; introduce a custom `InvalidCustomImageException` instead. |
| `MR-013` | `OPEN` | `Hough.detectLineSegments` | Handle `vision_quiet` by falling back to the provided image instead of failing when custom image handling is unavailable. |
| `MR-014` | `OPEN` | `Hough` implementation style | Replace direct `Math` and `Std.int` usage with `using vision.tools.MathTools` extension calls, including `.round` and `.floor`. |
| `MR-015` | `OPEN` | `Hough.mapCircles` | Remove `Hough.mapCircles` because the review says it is not algorithm-related. |
| `MR-016` | `OPEN` | `Hough.mapLines` | Remove `Hough.mapLines` because the review says it is not algorithm-related. |
| `MR-017` | `OPEN` | Harris and Hough algorithm classes | Remove abbreviations, add function documentation, add comments in dense blocks, and document each class-level algorithm flow and function order clearly. |

## Vision.ds

| ID | Status | Target | Requested change |
|----|--------|--------|------------------|
| `MR-018` | `OPEN` | `HoughLine2D`, `Ray2D` | Rework, justify, or remove `HoughLine2D` because the review says it behaves like `Ray2D` and should integrate with `rho`/`theta` ray accessors instead of standing alone as a line type. |
| `MR-019` | `OPEN` | `MathTools`, near-zero checks | Replace `isNearZero` with `MathTools.isApproximating(epsilon)` when needed, and call it through `using vision.tools.MathTools` extension syntax. |
| `MR-020` | `OPEN` | value-type conversions | Keep conversions between value types inside `MathTools` and expose them from the value types through `@:to`. |
| `MR-021` | `OPEN` | `HarrisCorner2D`, `Point2D` | Rework or justify `HarrisCorner2D` because the review says it may be better represented as `Point2D` plus vote data instead of a standalone type. |
| `MR-022` | `OPEN` | `Circle2D` | Remove the `votes` property from `Circle2D` and store vote counts separately as key/value data. |
| `MR-023` | `OPEN` | `Circle2D` geometry helpers | Add `Circle2D` support for construction from three points, perimeter length, points at angle, perimeter retrieval in multiple data types, and conversion from circle to point. |