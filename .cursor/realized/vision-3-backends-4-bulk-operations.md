# Plan — Vision 3 step 4 — Qualify bulk operations

> **Status** ✅ Completed
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

## Implementation and evidence

- [CanvasRenderer.drawInverted](../../src/vision/backend/browser/CanvasRenderer.hx) inverts in the WebGL fragment pass for a full image. Canvas 2D and image views use `Vision.invert` on a copy. The existing synchronous `Vision.invert` call stays available for code that edits or reads CPU pixels immediately.
- [WebGpuInverter](../../src/vision/backend/browser/WebGpuInverter.hx) is an opt-in asynchronous compute path that returns a new image. The browser test compared its CPU-readable output byte for byte with the CPU implementation, including partial workgroups and opaque output alpha. The WebGPU factory can return null when a device or pipeline is unavailable.
- Edge passed the pixel tests with ANGLE D3D11 and SwiftShader. The WebGPU compute case passed on the Windows hardware browser run. The [browser fixture](../../tests/browser/drawing.html) reports both the overall result and the WebGPU result.
- On Intel Arc via ANGLE D3D11, median time across five groups of 30 draws of a 1024×1024 image was 5.71 ms for WebGL inversion, 21.44 ms for CPU clone/invert plus WebGL draw, and 5.77 ms when the caller reused an already inverted CPU result. Draw timing included a completion fence. The first individual draws took 14.3 ms and 22.6 ms respectively after renderer initialization. These measurements apply to inversion and presentation with a reused input, with no GPU readback. [Benchmark](../../tests/browser/BrowserInversionBenchmark.hx)
- To reproduce the benchmark, run `haxe -cp src -cp tests/browser -main BrowserInversionBenchmark --js bin/browser/inversion-benchmark.js -dce full` and open [inversion-benchmark.html](../../tests/browser/inversion-benchmark.html).
- In a separate Edge run, asynchronous WebGPU inversion of the same 1024×1024 CPU input took a median 10.4 ms across ten warmed calls, including upload and readback. CPU inversion of a cloned image averaged 17.0 ms across ten calls. WebGPU setup took 678 ms and the first call took 25.1 ms. The setup and asynchronous readback support keeping this path opt-in.
