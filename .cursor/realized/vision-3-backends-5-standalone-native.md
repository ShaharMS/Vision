# Plan — Vision 3 step 5 — Evaluate standalone native WebGPU

> **Status** ✅ Completed
>
> **Prerequisite** [Qualify bulk operations](vision-3-backends-4-bulk-operations.md)
>
> **Next** [Qualify compiler targets and public entry points](vision-3-backends-6-target-qualification.md)
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

## Implementation and evidence

- Both standalone Windows builds passed with Haxe 4.3.7 and wgpu-native v29.0.1.1 on the RTX 4060 Laptop GPU via Vulkan. hxcpp 4.3.2 used an NDLL and HashLink 1.16 used an HDLL, with both calling the same C surface probe. The probe exercised device creation, acquiring and clearing a Win32 surface texture, presentation and resource teardown. [Reproduction](../../tests/native-webgpu/README.md)
- The CPU-only HashLink smoke passed in a directory with no WebGPU library. The C++ and HashLink portable CPU paths also passed their regular CI jobs.
- The `hlwgpu` package expects an Ash-compatible Future ABI. The probe uses a thin HashLink HDLL and avoids that host requirement. The implementation ships Windows qualification code under tests. Application drawing on native targets uses the OpenFL or Heaps adapters. Standalone texture drawing and packaging for Linux and macOS remain separate work. [hlwgpu runtime requirements](https://lib.haxe.org/p/hlwgpu/0.2.0/)
