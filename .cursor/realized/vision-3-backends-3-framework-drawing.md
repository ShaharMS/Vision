# Plan — Vision 3 step 3 — Integrate native framework drawing

> **Status** ✅ Completed
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

## Implementation and evidence

- [OpenFlBitmap](../../src/vision/formats/to/OpenFlBitmap.hx) presents an image as an OpenFL bitmap and retains the owned bitmap data across same-size updates.
- [HeapsBitmap](../../src/vision/formats/to/HeapsBitmap.hx) presents an image as a Heaps bitmap and reuses its texture for same-size updates. Both adapters use the host's drawing loop.
- Windows native smoke tests passed with Haxe 4.3.7, hxcpp 4.3.2, Lime 8.3.2, OpenFL 9.5.2, Heaps 2.1.0, and HashLink/hlsdl 1.16. The OpenFL frame handler verified pixel updates and bitmap-data identity. Heaps verified matching pixels through texture capture and checked texture identity across the update. [Reproduction](../../tests/ci/framework-drawing.md)
