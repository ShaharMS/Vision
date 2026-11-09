# Plan — Vision 3 step 5 — Evaluate standalone native WebGPU

> **Status** 🔲 Not started
>
> **Prerequisite** [Qualify bulk operations](vision-3-backends-4-bulk-operations.md)
>
> **Next** Final step
>
> **Parent** [Vision 3 native image and drawing backends](vision-3-backends-overview.md)

## TL;DR

Determine whether plain hxcpp and HashLink builds can share a small native WebGPU integration without depending on a game framework.

## Iteration bootstrap

- **Iteration slug** `vision-3-backends-5-standalone-native`
- **Required evidence** Record the outcomes in the verification section before handing off the step.
- **Artifacts to verify** Target-specific builds, fixtures and runtime results described below.

## Reference pattern

[Local CI](../../tests/ci/README.md) supplies the existing native target baseline. There is no GPU-native binding precedent in Vision. [FrameworkImageIO.hx](../../src/vision/formats/__internal/FrameworkImageIO.hx) is the closest integration boundary.

## Steps

### 1. Qualify a native binding

Prototype a pinned `wgpu-native` ABI through hxcpp on Windows with an app-provided surface. Evaluate `hlwgpu` with the plain HashLink host and compare its requirements with a thin HDLL over the same ABI.

### 2. Decide what to ship

Use the existing draw boundary from the previous steps. Document binary packaging, resource ownership and fallback when native device creation fails. Qualify Linux and macOS separately before listing them.

## Verification

- Build a CPU-only hxcpp and HashLink binary, then run graphics-enabled versions on a qualified host. Verify edit to draw, teardown and clean fallback on unavailable hardware. Record the Haxe version, runtime version, native ABI, OS and GPU used.
