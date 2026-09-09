# Plan: Standardized Hough and Harris Feature Detection — Step 2: Standard Hough Lines

> **Status**: ✅ Completed
> **Prerequisite**: [hough-harris-feature-detection-1-foundation.md](hough-harris-feature-detection-1-foundation.md)
> **Next**: [hough-harris-feature-detection-3-probabilistic-hough-segments.md](hough-harris-feature-detection-3-probabilistic-hough-segments.md)
> **Parent**: [hough-harris-feature-detection-overview.md](hough-harris-feature-detection-overview.md)

## TL;DR

Replace the current intercept-string voting scheme with a standard polar Hough line transform. The output of this step should detect full image-bounded lines rather than rays and should expose the accumulator-backed `(rho, theta, votes)` representation internally.

## Reference Pattern

The current implementation in [src/vision/algorithms/SimpleHough.hx](src/vision/algorithms/SimpleHough.hx) shows the owning slice that needs replacement, while [src/vision/ds/Image.hx](src/vision/ds/Image.hx) shows how bounded line drawing already works.

In [src/vision/algorithms/SimpleHough.hx](src/vision/algorithms/SimpleHough.hx):
- The detector currently loops edge pixels and angles already, so the control path is local and replaceable.
- The main defect is the `xIntercept|deg` accumulator key, not the existence of an accumulator itself.

In [src/vision/ds/Image.hx](src/vision/ds/Image.hx):
- `drawLine2D` already renders bounded segments cleanly.
- `drawRay2D` demonstrates the exact ray-specific behavior this step should stop relying on for standard line output.

## Steps

### 1. Implement a polar accumulator in `Hough.hx`

For each candidate edge pixel, sweep theta bins and compute rho in the standard line form. Store votes in a numeric accumulator instead of string keys.

```haxe
var rho = x * Math.cos(theta) + y * Math.sin(theta);
var rhoIndex = Std.int((rho - minRho) / options.rhoResolution);
accumulator.set(thetaIndex, rhoIndex, accumulator.get(thetaIndex, rhoIndex) + vote);
```

The accumulator must support negative rho values by shifting the stored index range.

### 2. Convert accumulator peaks into full lines clipped to the image bounds

Standard Hough returns a full line description, not a ray. Map the internal `HoughLine2D` result into an image-bounded `Line2D` by intersecting the infinite line with the image rectangle.

Keep the parameter-space result accessible from the algorithm layer even if the public wrapper later returns only bounded `Line2D` values.

### 3. Replace or delegate the existing `SimpleHough.detectLines(...)`

Update [src/vision/algorithms/SimpleHough.hx](src/vision/algorithms/SimpleHough.hx) so existing callers stop receiving ray-only semantics from the legacy accumulator.

Be explicit about the compatibility choice:

- either keep `SimpleHough.detectLines(...)` as a delegating wrapper that maps to bounded lines through the new implementation
- or keep the old signature but document it as legacy and route new behavior through `Hough.detectLines(...)`

### 4. Add focused standard-line tests and fixtures

Add coverage for:

- horizontal lines
- vertical lines
- diagonal lines
- negative-rho cases caused by image origin placement
- empty or all-black images

Prefer synthetic fixtures under `tests/src/tests/support` so false positives are easy to diagnose.

## Verification

- A filtered `haxe test.hxml` run passes for the standard Hough suite and the updated compatibility suite
- Bounded results span the image edges on synthetic fixtures instead of originating from a single ray point
- A compile-only `haxe tests/ci/local-ci.hxml` run for `interp,js` stays clean after the accumulator and clipping logic lands

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **Evidence to preserve** — filtered standard-Hough test output and one compile-only run
- **Review focus** — rho indexing correctness, clipping correctness at image borders, and whether legacy `SimpleHough` behavior is now clearly defined instead of implicitly ray-based
- **Commit guidance** — keep the core accumulator change and any follow-up local fixes in the same reviewable pass if possible
