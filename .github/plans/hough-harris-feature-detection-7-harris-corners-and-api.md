# Plan: Standardized Hough and Harris Feature Detection — Step 7: Harris Corners and Public API

> **Status**: ✅ Completed
> **Prerequisite**: [hough-harris-feature-detection-6-harris-response.md](.github/plans/hough-harris-feature-detection-6-harris-response.md)
> **Next**: [hough-harris-feature-detection-8-docs-tests-and-closeout.md](.github/plans/hough-harris-feature-detection-8-docs-tests-and-closeout.md)
> **Parent**: [hough-harris-feature-detection-overview.md](.github/plans/hough-harris-feature-detection-overview.md)

## TL;DR

Turn the raw Harris response map into a usable corner detector with thresholding, local maxima, distance suppression, and documented public wrappers. This is the step that should make Harris immediately usable to Vision consumers instead of only numerically present.

## Reference Pattern

[src/vision/Vision.hx](src/vision/Vision.hx) is the public wrapper pattern to follow, while [src/vision/ds/Point2D.hx](src/vision/ds/Point2D.hx) shows the lightweight point result style that corner outputs can build on.

In [src/vision/Vision.hx](src/vision/Vision.hx):
- Doc-heavy wrappers with stable defaults are the public contract pattern to preserve.

In [src/vision/ds/Point2D.hx](src/vision/ds/Point2D.hx):
- Simple geometry outputs are small and direct, which matches detected-corner use cases.

## Steps

### 1. Add Harris corner extraction on top of the raw response map

Implement a `detectCorners(...)` method that takes the response map or source image and applies:

- relative or absolute thresholding
- non-maximum suppression in a small neighborhood
- border exclusion
- `minDistance`
- `maxCorners`

Prefer a relative threshold based on the best response so the detector is usable across images with different dynamic ranges.

### 2. Decide and implement the public output shape

Choose between:

- `Array<Point2D>` for the simplest caller experience
- `Array<HarrisCorner2D>` if score-preserving output is important enough to justify the extra type

If `HarrisCorner2D` is kept, make the public wrapper choice explicit: either expose scored results directly or expose points and keep scored results available from the algorithm layer.

### 3. Add documented `Vision.hx` wrappers and marker guidance

Add wrappers such as:

- `Vision.harrisCornerResponse(...)`
- `Vision.harrisCorners(...)`

Document how callers can overlay corners with existing drawing primitives such as `drawCircle(...)` or a small helper if repeated marker drawing becomes noisy.

### 4. Add deterministic corner-selection tests

Cover:

- a square fixture returning four corners
- `minDistance` collapsing nearby peaks
- `maxCorners` keeping only the strongest responses
- empty or flat images returning no corners

If order is exposed, keep it deterministic by sorting on response and then coordinates.

## Verification

- Filtered Harris-corner tests pass for thresholding, non-max suppression, `minDistance`, and `maxCorners`
- Public `Vision.hx` wrappers are documented and compile without changing unrelated signatures
- The output shape is explicit and stable enough that later descriptor work could build on it

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **Evidence to preserve** — filtered Harris-corner test output and a short note explaining the chosen public result shape
- **Review focus** — non-max suppression behavior, threshold semantics, deterministic ordering, and whether the wrapper defaults feel predictable to users familiar with Harris and `goodFeaturesToTrack`-style APIs
- **Commit guidance** — keep any public-shape decision recorded in the decision log because later descriptor work may depend on it
