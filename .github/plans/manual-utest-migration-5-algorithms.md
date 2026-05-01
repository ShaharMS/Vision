# Plan: Manual Utest Migration — Step 5: Rewrite Algorithm Suites

> **Status**: 🔲 Not started
> **Prerequisite**: [manual-utest-migration-4-image-and-geometry-ds.md](manual-utest-migration-4-image-and-geometry-ds.md)
> **Next**: [manual-utest-migration-6-formats-and-facade.md](manual-utest-migration-6-formats-and-facade.md)
> **Parent**: [manual-utest-migration-overview.md](manual-utest-migration-overview.md)

## TL;DR

Replace algorithm smoke suites with deterministic fixture-driven tests that exercise dimensions, invariants, expected values, and documented failure modes. This is where the migration should stop looking like scaffolding and start looking like a trustworthy regression suite.

## Reference Pattern

In [../../src/vision/algorithms/BicubicInterpolation.hx](../../src/vision/algorithms/BicubicInterpolation.hx):
- Use small images and explicit dimension expectations rather than generic result existence checks.

In [../../src/vision/algorithms/Cramer.hx](../../src/vision/algorithms/Cramer.hx):
- Derive exact matrix and solver expectations from source behavior and failure contracts.

In [../../tests/generated/src/tests/BicubicInterpolationTest.hx](../../tests/generated/src/tests/BicubicInterpolationTest.hx):
- Preserve the basic `default`, `tiny`, and `checkerboard` scenario shape where it still adds signal.

In [../../tests/generated/src/tests/support/Factories.hx](../../tests/generated/src/tests/support/Factories.hx):
- Reuse tiny deterministic images so algorithm outputs stay debuggable.

## Steps

### 1. Rewrite interpolation and resampling suites

Rewrite the suites for interpolation and resampling families:

- `BicubicInterpolationTest.hx`
- `BilinearInterpolationTest.hx`
- `CatmullRomInterpolationTest.hx`
- `LanczosInterpolationTest.hx`
- `MitchellNetravaliInterpolationTest.hx`
- `KernelResamplerTest.hx`
- `BilateralFilterTest.hx`

Assert dimensions, identity-like behavior on unchanged sizes, and key pixel or structural invariants for tiny images.

### 2. Rewrite edge-detection and transform suites

Rewrite the suites for filters, edge detectors, and transform-style algorithms:

- `CannyTest.hx`
- `LaplaceTest.hx`
- `PerwittTest.hx`
- `RobertsCrossTest.hx`
- `SobelTest.hx`
- `SimpleHoughTest.hx`
- `SimpleLineDetectorTest.hx`
- `PerspectiveWarpTest.hx`

Use line images, checkerboards, and small controlled matrices so expected structural changes are easy to reason about.

### 3. Rewrite math, clustering, hashing, and sorting suites

Rewrite the remaining algorithm and algorithm-adjacent suites:

- `CramerTest.hx`
- `GaussTest.hx`
- `GaussJordanTest.hx`
- `KMeansTest.hx`
- `ColorClusterTest.hx`
- `ImageHashingTest.hx`
- `RadixTest.hx`

Include explicit negative cases such as singular matrices, invalid clustering inputs, and duplicate-heavy sort inputs where source behavior defines an expectation.

### 4. Update helpers and inventory as needed

If several algorithm suites need tiny matrices, line images, or tolerance-based numeric comparisons, move those into shared support helpers and update the coverage inventory as each suite becomes manual.

## Verification

- `haxe test.hxml -- --tests BicubicInterpolationTest,BilinearInterpolationTest,KernelResamplerTest` passes.
- `haxe test.hxml -- --tests CramerTest,GaussTest,GaussJordanTest,RadixTest` passes.
- `haxe test.hxml -- --tests SobelTest,CannyTest,SimpleHoughTest,SimpleLineDetectorTest` passes.
- `haxe tests/ci/local-ci.hxml -- --targets=js --compile-only --skip-install` succeeds against the manual tree.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-utest-migration`
- **Evidence to preserve** — Focused run output for one interpolation family, one edge-detection family, and one numeric solver family.
- **Review focus** — Ensure expectations are derived from controlled fixtures or known math, not from copying whatever the current implementation returns without justification.
- **Commit guidance** — Consider separate commits for interpolation/resampling, edge detection, and numeric algorithms if failures are expected to surface library issues.