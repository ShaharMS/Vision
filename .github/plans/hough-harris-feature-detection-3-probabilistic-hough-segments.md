# Plan: Standardized Hough and Harris Feature Detection — Step 3: Probabilistic Hough Segments

> **Status**: ✅ Completed
> **Prerequisite**: [hough-harris-feature-detection-2-standard-hough-lines.md](.github/plans/hough-harris-feature-detection-2-standard-hough-lines.md)
> **Next**: [hough-harris-feature-detection-4-hough-api-parity.md](.github/plans/hough-harris-feature-detection-4-hough-api-parity.md)
> **Parent**: [hough-harris-feature-detection-overview.md](.github/plans/hough-harris-feature-detection-overview.md)

## TL;DR

Add a probabilistic Hough variant that returns `Line2D` segments with gap and length controls. This is the step that should satisfy the user's request for line detection that behaves like segments instead of only unbounded lines or rays.

## Reference Pattern

[src/vision/algorithms/SimpleLineDetector.hx](src/vision/algorithms/SimpleLineDetector.hx) already contains the repo's closest segment-merging and gap-repair logic.

In [src/vision/algorithms/SimpleLineDetector.hx](src/vision/algorithms/SimpleLineDetector.hx):
- `lineCoveragePercentage` and `correctLines` model the local heuristics the probabilistic pass can reuse or adapt.
- The file already works in `Line2D` rather than `Ray2D`, which matches the desired output shape for `HoughLinesP`-style results.

In [src/vision/Vision.hx](src/vision/Vision.hx):
- `simpleLine2DDetection(...)` is the existing public precedent for a segment-oriented line detector.

## Steps

### 1. Add probabilistic segment extraction to `Hough.hx`

Build a `detectLineSegments(...)` or similarly explicit method that returns `Array<Line2D>` and supports at least:

- `minLineLength`
- `maxLineGap`
- vote threshold / candidate threshold
- optional reuse of a provided edge image

The algorithm does not have to copy OpenCV's internals literally, but the observable controls should align with `HoughLinesP` semantics.

```haxe
if (segment.length < options.minLineLength) return null;
if (gapLength > options.maxLineGap) break;
segments.push(new Line2D(startPoint, endPoint));
```

### 2. Reuse or adapt existing line clean-up heuristics carefully

Only reuse [src/vision/algorithms/SimpleLineDetector.hx](src/vision/algorithms/SimpleLineDetector.hx) helpers where they improve Hough segment quality without obscuring the probabilistic detector's own semantics.

The preferred order is:

- produce stable raw segments first
- merge only obvious duplicates or immediate fragments
- keep vote-driven confidence data available for later debugging

### 3. Add a public wrapper in `Vision.hx`

Expose a documented `Vision.houghLineSegmentDetection(...)` wrapper with sane defaults and explicit parameter descriptions for `minLineLength` and `maxLineGap`.

### 4. Add gapped-line and short-line rejection coverage

Cover fixtures such as:

- a long line with one or two small gaps that should still be linked
- a short isolated segment that should be rejected by `minLineLength`
- a dense grid-like image that should not explode into obvious duplicates

## Verification

- Filtered probabilistic Hough tests pass, including gap-linking and short-line rejection cases
- The public wrapper returns `Line2D` values and not rays or raw accumulator tuples
- A targeted compile-only `interp,js` run remains green after the new wrapper and options land

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **Evidence to preserve** — filtered probabilistic-Hough test output and a screenshot or textual summary from a synthetic fixture if useful during review
- **Review focus** — duplicate suppression, gap-linking semantics, and whether the wrapper defaults are predictable enough for users coming from OpenCV's `HoughLinesP`
- **Commit guidance** — keep wrapper/docs changes close to the algorithm pass so the review packet can judge behavior and API together
