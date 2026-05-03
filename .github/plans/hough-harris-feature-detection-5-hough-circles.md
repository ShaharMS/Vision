# Plan: Standardized Hough and Harris Feature Detection — Step 5: Hough Circles

> **Status**: ✅ Completed
> **Prerequisite**: [hough-harris-feature-detection-4-hough-api-parity.md](.github/plans/hough-harris-feature-detection-4-hough-api-parity.md)
> **Next**: [hough-harris-feature-detection-6-harris-response.md](.github/plans/hough-harris-feature-detection-6-harris-response.md)
> **Parent**: [hough-harris-feature-detection-overview.md](.github/plans/hough-harris-feature-detection-overview.md)

## TL;DR

Add a separate Hough circle detector after the line-transform work is stable. This step should treat circle detection as its own gradient-based detector with dedicated controls rather than trying to shoehorn circles into the line accumulator APIs.

## Reference Pattern

[src/vision/Vision.hx](src/vision/Vision.hx) already owns the edge-detection and preprocessing wrappers, while [src/vision/ds/Image.hx](src/vision/ds/Image.hx) already has the drawing helpers needed for circle overlays.

In [src/vision/Vision.hx](src/vision/Vision.hx):
- `cannyEdgeDetection(...)` gives a stable preprocessing path that circle detection can reuse.

In [src/vision/ds/Image.hx](src/vision/ds/Image.hx):
- `drawCircle` and `fillCircle` already support the visualization part of circle detection output.

In [tests/src/tests/support/ManualFixtures.hx](tests/src/tests/support/ManualFixtures.hx):
- Existing simple fixtures show the pattern for adding tight, synthetic image generators that are easier to debug than natural-image-only tests.

## Steps

### 1. Add a circle result type only if the existing geometry surface is insufficient

If a simple `Line2D`-like geometry type is needed, add `src/vision/ds/Circle2D.hx` with:

- center `Point2D`
- radius `Float`
- optional vote or confidence field if the detector naturally produces one

### 2. Implement a gradient-based circle detector in `Hough.hx` or a focused companion file

Match the OpenCV-style behavior surface closely enough to be intuitive:

- grayscale input
- median blur or similar denoising before voting
- `dp`
- `minDistance`
- internal Canny threshold(s)
- center threshold
- `minRadius`
- `maxRadius`

Keep the implementation as a dedicated path rather than over-generalizing the line accumulator.

### 3. Add `Vision.hx` wrappers and overlay helpers

Expose a documented wrapper such as `Vision.houghCircleDetection(...)` and make sure the demo path can draw centers and perimeters without custom user code.

### 4. Add synthetic circle fixtures and tests

Cover at least:

- one centered circle
- two circles that should survive `minDistance`
- radius bounds rejecting circles outside the configured range
- an empty image that should return no circles

## Verification

- Filtered circle-detection tests pass with coordinate and radius tolerances that are realistic for accumulator-based detection
- The public wrapper returns circle-shaped data and not a line-based placeholder type
- The compile-only `interp,js` run remains clean after the new geometry or wrapper additions

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **Evidence to preserve** — filtered circle suite output and one synthetic rendering example if the review needs visual confirmation
- **Review focus** — whether the circle path is isolated enough from the line path, whether radius thresholds behave predictably, and whether the new result type is truly necessary instead of over-designed
- **Commit guidance** — if a new geometry type is introduced, keep that change in the same review pass as the first detector that consumes it
