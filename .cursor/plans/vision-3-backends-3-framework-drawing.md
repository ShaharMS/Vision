# Plan — Vision 3 step 3 — Integrate native framework drawing

> **Status** 🔲 Not started
>
> **Prerequisite** [Draw on browser targets](vision-3-backends-2-browser-drawing.md)
>
> **Next** [Qualify bulk operations](vision-3-backends-4-bulk-operations.md)
>
> **Parent** [Vision 3 native image and drawing backends](vision-3-backends-overview.md)

## TL;DR

Show the same image editing and drawing workflow inside existing Haxe graphics frameworks.

## Iteration bootstrap

- **Iteration slug** `vision-3-backends-3-framework-drawing`
- **Required evidence** Record the outcomes in the verification section before handing off the step.
- **Artifacts to verify** Target-specific builds, fixtures and runtime results described below.

## Reference pattern

[FrameworkImageIO.hx](../../src/vision/formats/__internal/FrameworkImageIO.hx) already has framework guards and bitmap/pixel conversions.

## Steps

### 1. Integrate one hxcpp host

Add a framework adapter for Lime/OpenFL using the app's existing renderer. Demonstrate repeat draws of one mutable Vision image. Document whether the adapter shares, caches or copies the host's graphics resource.

### 2. Integrate one HashLink host

Use the same presentation boundary for Heaps. Qualify OpenFL and Heaps as separate passes within this step. Use the host render loop and cover cleanup when an image or scene is released.

## Verification

- Build and run one hxcpp Lime/OpenFL sample and one HashLink Heaps sample. Verify updates across consecutive frames and record upload counts or texture handles to distinguish reuse from reallocation. Run `haxe tests/ci/local-ci.hxml -- --targets=cpp,hl` with the required runtimes.
