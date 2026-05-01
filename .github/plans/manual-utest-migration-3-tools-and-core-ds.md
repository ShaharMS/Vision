# Plan: Manual Utest Migration — Step 3: Rewrite Tools And Core Data Structures

> **Status**: 🔲 Not started
> **Prerequisite**: [manual-utest-migration-2-harness.md](manual-utest-migration-2-harness.md)
> **Next**: [manual-utest-migration-4-image-and-geometry-ds.md](manual-utest-migration-4-image-and-geometry-ds.md)
> **Parent**: [manual-utest-migration-overview.md](manual-utest-migration-overview.md)

## TL;DR

Replace the weakest smoke-style tests first in `vision.tools` and the simpler collection and value-oriented `vision.ds` types. This batch should establish the manual testing style: exact results where possible, explicit edge-case coverage, and documented platform branches where behavior intentionally differs.

## Reference Pattern

In [../../src/vision/tools/ArrayTools.hx](../../src/vision/tools/ArrayTools.hx):
- Cover empty inputs, duplicates, overloads, and platform-specific return behavior explicitly.
- Use source branches such as `min([])` to drive test expectations instead of generic non-null assertions.

In [../../tests/generated/src/tests/ArrayToolsTest.hx](../../tests/generated/src/tests/ArrayToolsTest.hx):
- Preserve the existing class-per-source and member-per-scenario layout.
- Replace structural smoke assertions with semantic results and targeted negative cases.

## Steps

### 1. Rewrite `vision.tools` suites

Manually rewrite these suites under `tests/src/tests`:

- `ArrayToolsTest.hx`
- `MathToolsTest.hx`
- `ImageToolsTest.hx`

Focus on behaviors that are obvious from source and can be checked exactly: flattening, raising, ordering, median selection, distinct semantics, empty-array behavior, NaN and boundary math, and any image helper contract that has a deterministic local path.

### 2. Rewrite core collection and value-type suites

Rewrite the manual tests for the simpler `vision.ds` classes first:

- `Array2DTest.hx`
- `ByteArrayTest.hx`
- `ColorTest.hx`
- `PixelTest.hx`
- `HistogramTest.hx`
- `QueueTest.hx`
- `QueueCellTest.hx`
- `ImageFormatTest.hx`
- `PixelFormatTest.hx`

Each suite should verify both public readable fields and public methods. Mutation tests should assert the changed state, not just that the call returned.

### 3. Add edge-case helpers where exact expectations repeat

If the same approximate float comparison, byte-array expectation, or exception assertion appears in several suites, move it into `tests/src/tests/support` immediately rather than duplicating it.

### 4. Update the coverage inventory

As each suite becomes manual and semantic, update `tests/catalog/manual-test-inventory.json` so later steps can see which modules are still legacy or partially migrated.

## Verification

- `haxe test.hxml -- --tests ArrayToolsTest,MathToolsTest,ImageToolsTest` passes.
- `haxe test.hxml -- --tests Array2DTest,ByteArrayTest,ColorTest,PixelTest` passes.
- `haxe test.hxml -- --tests QueueTest,QueueCellTest,HistogramTest,ImageFormatTest,PixelFormatTest` passes.
- Inventory entries for the migrated modules move from `needs-migration` to `manual`.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-utest-migration`
- **Evidence to preserve** — Focused run output for at least one `vision.tools` suite and one `vision.ds` suite, plus before/after inventory status changes.
- **Review focus** — Ensure tests encode real behavior, especially platform branches and empty-input behavior, instead of just copying current smoke assertions into a new directory.
- **Commit guidance** — Split `vision.tools` and `vision.ds` rewrites into separate commits if the diff becomes difficult to review.