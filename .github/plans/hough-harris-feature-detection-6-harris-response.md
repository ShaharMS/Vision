# Plan: Standardized Hough and Harris Feature Detection — Step 6: Harris Response Map

> **Status**: 🔲 Not started
> **Prerequisite**: [hough-harris-feature-detection-5-hough-circles.md](.github/plans/hough-harris-feature-detection-5-hough-circles.md)
> **Next**: [hough-harris-feature-detection-7-harris-corners-and-api.md](.github/plans/hough-harris-feature-detection-7-harris-corners-and-api.md)
> **Parent**: [hough-harris-feature-detection-overview.md](.github/plans/hough-harris-feature-detection-overview.md)

## TL;DR

Implement the raw Harris response computation first: grayscale input, first derivatives, local structure tensor accumulation, and the Harris score map. This step should stop before corner picking so the numerical core can be tested on its own.

## Reference Pattern

[src/vision/algorithms/Sobel.hx](src/vision/algorithms/Sobel.hx) already computes x/y gradient information locally, and [src/vision/ds/Matrix2D.hx](src/vision/ds/Matrix2D.hx) is the existing float-capable numeric container for response maps.

In [src/vision/algorithms/Sobel.hx](src/vision/algorithms/Sobel.hx):
- The file already computes gradient components before collapsing them into a magnitude image.
- Harris needs those components before they are reduced to a single scalar magnitude.

In [src/vision/ds/Matrix2D.hx](src/vision/ds/Matrix2D.hx):
- The numeric helpers and float storage match the raw Harris score-map use case better than `Image` does.

## Steps

### 1. Add a raw Harris response method

Create `Harris.computeResponse(image, ?options):Matrix2D` and compute:

- grayscale image
- `Ix`, `Iy` derivatives
- local sums of `Ix^2`, `Iy^2`, and `IxIy`
- `R = det(M) - k * trace(M)^2`

```haxe
var det = (sumIx2 * sumIy2) - (sumIxIy * sumIxIy);
var trace = sumIx2 + sumIy2;
response.set(x, y, det - options.k * trace * trace);
```

### 2. Support OpenCV-like local-window controls

Add the core Harris parameters in the options surface:

- `blockSize`
- derivative kernel size / Sobel aperture
- `k`
- optional smoothing mode if a Gaussian-weighted window is added now

Choose defaults that align closely enough with OpenCV's common Harris settings to make the API intuitive.

### 3. Add visualization and normalization helpers without losing the raw map

If docs or manual inspection need a drawable score map, add a helper that normalizes a `Matrix2D` response into an `Image`. Do not replace the raw response with a quantized image return type.

### 4. Add score-ordering tests on synthetic corners and edges

Use simple square or L-shaped fixtures to assert:

- corners score higher than flat regions
- corners score higher than pure edge interiors
- the response map shape is stable under default settings

## Verification

- Filtered Harris-response tests pass on synthetic fixtures with approximate numeric assertions
- The raw response type is `Matrix2D` or another float-capable numeric surface, not a color image pretending to be raw data
- A compile-only `interp,js` run remains clean after the gradient-helper additions

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **Evidence to preserve** — filtered response-map test output and any compile-only output for new gradient helpers
- **Review focus** — derivative correctness, window aggregation correctness, and whether the raw response path stays numerically meaningful before thresholding or normalization
- **Commit guidance** — keep raw-response work separate from corner-picking so review can isolate the numerical core
