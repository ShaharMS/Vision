# Plan: Manual Utest Migration — Step 6: Rewrite Formats, Facade, Helpers, And Exceptions

> **Status**: 🔲 Not started
> **Prerequisite**: [manual-utest-migration-5-algorithms.md](manual-utest-migration-5-algorithms.md)
> **Next**: [manual-utest-migration-7-decommission-and-coverage.md](manual-utest-migration-7-decommission-and-coverage.md)
> **Parent**: [manual-utest-migration-overview.md](manual-utest-migration-overview.md)

## TL;DR

Finish the manual rewrite with the format conversion surface, the public `Vision` facade, and the remaining helper or exception modules. These tests should focus on round trips, public compatibility contracts, and explicit failure modes rather than duplicating the entire algorithm suite one-for-one.

## Reference Pattern

In [../../src/vision/formats/from/FromBytes.hx](../../src/vision/formats/from/FromBytes.hx):
- Treat successful parse paths and invalid-byte failures as first-class behavior to test.

In [../../src/vision/formats/ImageIO.hx](../../src/vision/formats/ImageIO.hx):
- Prefer round-trip expectations and format-specific error handling over shallow shape assertions.

In [../../src/vision/Vision.hx](../../src/vision/Vision.hx):
- Test the public facade for stable behavior and delegation invariants without restating every algorithm test in full.

In [../../tests/generated/src/tests/FromBytesTest.hx](../../tests/generated/src/tests/FromBytesTest.hx):
- Preserve the useful invalid-input scenario style and expand it into stronger round-trip coverage.

## Steps

### 1. Rewrite format and conversion suites

Rewrite the authored suites for the conversion surface:

- `FromBytesTest.hx`
- `FromTest.hx`
- `ToBytesTest.hx`
- `ToTest.hx`
- `ImageIOTest.hx`

Use local deterministic fixtures and byte arrays so the tests do not need generator-only golden infrastructure. Cover both successful round trips and malformed-input failures.

### 2. Rewrite the `Vision` facade suite

Rewrite `VisionTest.hx` so it validates the stable public facade layer. Focus on representative delegation and compatibility checks, such as matching output dimensions or equivalent visible effects between `Vision` entrypoints and the underlying algorithm or tool implementation.

Do not duplicate every algorithm expectation in full; use the algorithm suites from the previous step as the deep coverage layer.

### 3. Rewrite helper and exception coverage

Rewrite or add authored suites for remaining helper and exception modules where public behavior exists:

- `VisionThreadTest.hx`
- exception constructor or message tests where message content or stored fields are part of the public surface

For modules that are pure markers or otherwise not meaningfully testable, mark them as explicit exclusions in the inventory with a rationale.

### 4. Update inventory and runner registration

As these suites become manual, update the inventory, suite registry, and any docs that describe how new manual test files should be added.

## Verification

- `haxe test.hxml -- --tests FromBytesTest,ToBytesTest,ImageIOTest,VisionTest,VisionThreadTest` passes.
- Invalid-input cases are runnable individually through case filters.
- `haxe tests/ci/local-ci.hxml -- --targets=python --compile-only --skip-install` succeeds.
- Remaining helper and exception modules are either covered or explicitly excluded in the inventory.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-utest-migration`
- **Evidence to preserve** — A round-trip pass example, an invalid-input failure assertion example, and inventory entries for any explicit helper or exception exclusions.
- **Review focus** — Ensure the `Vision` facade tests verify public compatibility semantics rather than becoming shallow duplicates of algorithm suites or placeholder delegation smoke tests.
- **Commit guidance** — Keep conversion tests, facade tests, and helper/exception cleanup in separate commits if they surface different classes of regressions.