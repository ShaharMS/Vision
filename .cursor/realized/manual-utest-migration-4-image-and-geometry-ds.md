# Plan: Manual Utest Migration — Step 4: Rewrite Image And Geometry Data Structures

> **Status**: ✅ Completed
> **Prerequisite**: [manual-utest-migration-3-tools-and-core-ds.md](manual-utest-migration-3-tools-and-core-ds.md)
> **Next**: [manual-utest-migration-5-algorithms.md](manual-utest-migration-5-algorithms.md)
> **Parent**: [manual-utest-migration-overview.md](manual-utest-migration-overview.md)

## TL;DR

Rewrite the higher-value `vision.ds` suites around image, matrix, and geometry behavior. These tests should use shared fixtures and explicit invariants so failures point to either a precise library contract or a clearly wrong expectation.

## Reference Pattern

In [../../src/vision/ds/Image.hx](../../src/vision/ds/Image.hx):
- Drive tests directly from bounds checks, clamping behavior, floating-pixel interpolation, and view-aware mutation rules.
- Prefer exact pixel and dimension assertions over `Assert.pass()` or `Assert.notNull(result)`.

In [../../tests/generated/src/tests/support/Factories.hx](../../tests/generated/src/tests/support/Factories.hx):
- Reuse gradient, checkerboard, and white-line fixtures as the base of deterministic image tests.

In [../../tests/generated/src/tests/ImageTest.hx](../../tests/generated/src/tests/ImageTest.hx):
- Preserve the current class/member mapping, but replace smoke expectations with stateful assertions and edge cases.

## Steps

### 1. Add image-specific support helpers

Create helpers such as `ImageAssertions.hx` or similarly named support modules under `tests/src/tests/support` for:

- exact pixel assertions
- approximate color checks when interpolation is involved
- dimension and view invariants
- small fixture builders for odd dimensions, alpha-heavy pixels, and edge-touching coordinates

### 2. Rewrite image-centric suites

Rewrite the suites that directly exercise image storage and matrix-like behavior:

- `ImageTest.hx`
- `ImageViewTest.hx`
- `Matrix2DTest.hx`
- `TransformationMatrix2DTest.hx`
- `Kernel2DTest.hx` if needed

Focus on pixel get/set behavior, out-of-bounds behavior, safe/floating variants, cloning and copy semantics, view clipping, and transform invariants.

### 3. Rewrite geometry suites

Rewrite the geometry and coordinate-oriented suites:

- `Point2DTest.hx`
- `Point3DTest.hx`
- `IntPoint2DTest.hx`
- `Int16Point2DTest.hx`
- `UInt16Point2DTest.hx`
- `Line2DTest.hx`
- `Ray2DTest.hx`
- `RectangleTest.hx`
- `PointTransformationPairTest.hx`

Use exact coordinates, degenerate shapes, symmetry, containment edges, and identity-transform cases so the tests stay understandable and debuggable.

### 4. Handle enum-like or shape metadata types explicitly

For public `vision.ds.specifics` modules and similar metadata types, either:

- add lightweight authored coverage when public behavior exists, or
- mark them as explicit exclusions in the inventory if they are pure enum or alias surfaces with no meaningful function or field behavior to test

## Verification

- `haxe test.hxml -- --tests ImageTest,ImageViewTest,Matrix2DTest,TransformationMatrix2DTest` passes.
- `haxe test.hxml -- --tests Point2DTest,Point3DTest,RectangleTest,Line2DTest,Ray2DTest` passes.
- Case-filtered runs for at least one image member and one geometry member work through the new runner filter.
- Inventory entries for migrated image and geometry modules are updated.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-utest-migration`
- **Evidence to preserve** — At least one focused run that exercises pixel assertions and one that exercises geometry invariants, plus any explicit inventory exclusions for enum-like modules.
- **Review focus** — Ensure the tests assert behavior from source, especially around bounds, clamping, and view logic, and do not silently depend on generated helper assumptions.
- **Commit guidance** — Keep image-centric suites separate from geometry suites if the helper churn becomes large.