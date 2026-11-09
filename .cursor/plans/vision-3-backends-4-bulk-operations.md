# Plan — Vision 3 step 4 — Qualify bulk operations

> **Status** 🔲 Not started
>
> **Prerequisite** [Integrate native framework drawing](vision-3-backends-3-framework-drawing.md)
>
> **Next** [Evaluate standalone native WebGPU](vision-3-backends-5-standalone-native.md)
>
> **Parent** [Vision 3 native image and drawing backends](vision-3-backends-overview.md)

## TL;DR

Route an existing bulk algorithm to a matching implementation only where it preserves caller behavior and improves the relevant workload.

## Iteration bootstrap

- **Iteration slug** `vision-3-backends-4-bulk-operations`
- **Required evidence** Record the outcomes in the verification section before handing off the step.
- **Artifacts to verify** Target-specific builds, fixtures and runtime results described below.

## Reference pattern

[Vision.hx](../../src/vision/Vision.hx) exposes the public algorithms. [Gauss.hx](../../src/vision/algorithms/Gauss.hx) is an example of an existing CPU path.

## Steps

### 1. Choose a matching operation

Select a bulk operation with clear expected output and meaningful device-resident use. Define alpha, borders, precision and parameter behavior against the CPU reference before writing a shader or delegating to a native routine.

### 2. Add one qualified backend

Implement the chosen operation in the relevant backend. Leave the CPU path as the default for unsupported conditions and synchronous results where device readback would break the contract. Qualify a WebGPU compute variant separately from the browser draw path.

## Verification

- Run `haxe test.hxml` and compare backend output against the CPU fixtures with the declared tolerance. Measure CPU input to CPU output and device-resident input to drawing separately, including initialization and warm runs. Record fallbacks on unsupported devices.
