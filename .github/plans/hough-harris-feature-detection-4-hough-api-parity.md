# Plan: Standardized Hough and Harris Feature Detection — Step 4: Hough API Parity and Point-Set Input

> **Status**: ✅ Completed
> **Prerequisite**: [hough-harris-feature-detection-3-probabilistic-hough-segments.md](.github/plans/hough-harris-feature-detection-3-probabilistic-hough-segments.md)
> **Next**: [hough-harris-feature-detection-5-hough-circles.md](.github/plans/hough-harris-feature-detection-5-hough-circles.md)
> **Parent**: [hough-harris-feature-detection-overview.md](.github/plans/hough-harris-feature-detection-overview.md)

## TL;DR

Finish the most important OpenCV-adjacent line-transform controls after the standard and probabilistic implementations are stable: weighted votes, theta bounds, and a point-set entry path that does not require building an intermediate image first.

## Reference Pattern

[src/vision/algorithms/Sobel.hx](src/vision/algorithms/Sobel.hx) already computes gradient strength that weighted Hough voting can reuse, and [src/vision/ds/Matrix2D.hx](src/vision/ds/Matrix2D.hx) is the existing numeric-map surface for accumulator-like data.

In [src/vision/algorithms/Sobel.hx](src/vision/algorithms/Sobel.hx):
- The file already computes gradient magnitude and normalizes it for later use.
- The gradient path is local enough to refactor if weighted Hough needs raw strength instead of only normalized images.

In [src/vision/ds/Matrix2D.hx](src/vision/ds/Matrix2D.hx):
- Numeric-map helpers are already centered around float storage and should remain the raw accumulator substrate.

## Steps

### 1. Add weighted votes and angle bounds

Extend the line options so later callers can choose:

- unit votes from binary edge maps
- weighted votes from edge strength or grayscale strength
- `minTheta` and `maxTheta` limits that skip obviously irrelevant angles

This should line up with the observable behavior of OpenCV's weighted `HoughLines(..., use_edgeval=true)` and angle-range parameters, even if the internal code is tuned for Vision's own data structures.

### 2. Add a point-set entrypoint

Implement a point-based variant such as:

```haxe
public static function detectLinesFromPoints(points:Array<Point2D>, width:Int, height:Int, ?options:HoughLineOptions):Array<HoughLine2D>
```

This should reuse the same accumulator logic as the image-based line detector so sparse feature pipelines can call into Hough directly.

### 3. Expose accumulator/debug surfaces only where they help review and docs

If later steps need debug images or raw vote maps, expose them from `Hough.hx` in a narrow way. Avoid permanently widening `Vision.hx` unless the surface is useful for ordinary library consumers.

### 4. Decide explicitly on multi-scale parity

OpenCV exposes `srn` and `stn` for multi-scale standard Hough. Either:

- add a clean multi-scale mode now because the accumulator abstraction already supports it without making the code hard to test
- or document it as a conscious follow-on omission in the plan notes and public docs so the absence is explicit rather than accidental

## Verification

- Angle-bounded tests reject lines outside the requested theta window
- Weighted voting favors stronger lines on mixed-strength synthetic fixtures
- Point-set detection and image-based detection agree on the same sparse input geometry within expected binning tolerance

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **Evidence to preserve** — targeted parity tests for weighted voting, angle bounds, and point-set input
- **Review focus** — whether weighted voting is actually reusing meaningful intensity information, whether angle bounds are off-by-one around bin edges, and whether point-set detection really shares code instead of forking behavior
- **Commit guidance** — keep multi-scale inclusion or omission explicit in the decision log if review challenges the scope
