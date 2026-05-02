# Plan: Standardized Hough and Harris Feature Detection — Step 1: Foundation and Shared Types

> **Status**: 🔲 Not started
> **Prerequisite**: None — this is the first step.
> **Next**: [hough-harris-feature-detection-2-standard-hough-lines.md](.github/plans/hough-harris-feature-detection-2-standard-hough-lines.md)
> **Parent**: [hough-harris-feature-detection-overview.md](.github/plans/hough-harris-feature-detection-overview.md)

## TL;DR

Create the shared option/result types and compatibility seams that the later Hough and Harris steps need. This keeps the later implementation passes focused on detector behavior instead of repeatedly revisiting return types, float-map storage, and backwards-compatibility concerns.

## Reference Pattern

[src/vision/algorithms/Canny.hx](src/vision/algorithms/Canny.hx) and [src/vision/Vision.hx](src/vision/Vision.hx) already show the repo's preferred split between a smaller algorithm class and a richer public wrapper.

In [src/vision/algorithms/Canny.hx](src/vision/algorithms/Canny.hx):
- The algorithm class exposes small, stage-oriented helpers instead of one monolithic method.
- The class reuses existing numeric and image helpers instead of inventing new image abstractions.

In [src/vision/Vision.hx](src/vision/Vision.hx):
- The public wrapper carries the defaults, documentation, and compatibility commitment.
- Algorithm classes are imported and composed from stable `Vision` methods instead of being the only user-facing API.

In [src/vision/ds/Line2D.hx](src/vision/ds/Line2D.hx):
- Small geometry types live under `src/vision/ds` with focused helpers and no unnecessary abstraction layers.

## Steps

### 1. Add shared detector types and option objects

Add the types that later steps can build on without reopening naming or storage debates:

- `src/vision/ds/HoughLine2D.hx` for `(rho, theta, votes)` plus mapping helpers
- `src/vision/ds/HarrisCorner2D.hx` for a detected corner point and score
- `src/vision/ds/Circle2D.hx` only if step 5 needs an explicit geometry type instead of ad-hoc tuples
- `src/vision/ds/specifics/*` or `src/vision/ds/*` option files for Hough line, probabilistic Hough, Hough circle, and Harris settings

Use explicit field names rather than abbreviations.

```haxe
@:structInit class HoughLineOptions {
	public var rhoResolution:Float = 1;
	public var thetaResolution:Float = Math.PI / 180;
	public var voteThreshold:Int = 100;
}
```

### 2. Standardize raw numeric-map storage

Choose one raw numeric representation and use it consistently:

- Hough accumulators should use `Matrix2D` unless an `Array2D<Int>` is clearly simpler for a specific hotspot.
- Harris response maps should use `Matrix2D` because score maps are float-heavy and need stable downstream comparisons.
- Only add helper conversions where later steps demonstrably repeat them; avoid bloating `Image` with raw float-map behavior.

### 3. Prepare the new algorithm entry points and compatibility seam

Create the files that later steps will fill in:

- `src/vision/algorithms/Hough.hx`
- `src/vision/algorithms/Harris.hx`

Update [src/vision/algorithms/SimpleHough.hx](src/vision/algorithms/SimpleHough.hx) only enough to make the later migration safe. The intent is to preserve existing call sites while redirecting new work into the new algorithm surface.

### 4. Add the first narrow coverage and suite registration scaffolding

Create or reserve the new suites under `tests/src/tests` so later steps can add behavior incrementally without waiting for a final big-bang test pass:

- `HoughStandardTest`
- `HoughProbabilisticTest`
- `HoughCircleTest`
- `HarrisTest`

Wire the new suites into [tests/src/tests/support/ManualSuites.hx](tests/src/tests/support/ManualSuites.hx) as they appear.

## Verification

- The new type files and placeholder algorithm files compile cleanly through a targeted compile-only run of `haxe tests/ci/local-ci.hxml` with `VISION_CI_TARGETS='interp,js'`, `VISION_CI_COMPILE_ONLY='1'`, and `VISION_CI_SKIP_INSTALL='1'`
- Existing [tests/src/tests/SimpleHoughTest.hx](tests/src/tests/SimpleHoughTest.hx) still compiles before the behavioral replacement lands
- No unrelated public `Vision.hx` signature is changed in this step

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **Evidence to preserve** — compile-only output for the touched type and algorithm files
- **Review focus** — naming clarity, compatibility with existing geometry types, and whether the new types are small enough to keep future algorithm files under control
- **Commit guidance** — one commit is ideal for this step because it is a clear foundation checkpoint
