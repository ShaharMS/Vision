# Plan — Vision 3 step 2 — Draw on browser targets

> **Status** ✅ Completed
>
> **Prerequisite** [Preserve the image contract](vision-3-backends-1-image-storage.md)
>
> **Next** [Integrate native framework drawing](vision-3-backends-3-framework-drawing.md)
>
> **Parent** [Vision 3 native image and drawing backends](vision-3-backends-overview.md)

## TL;DR

Present ordinary Vision images on a browser canvas through a small Haxe adapter.

## Iteration bootstrap

- **Iteration slug** `vision-3-backends-2-browser-drawing`
- **Required evidence** Record the outcomes in the verification section before handing off the step.
- **Artifacts to verify** Target-specific builds, fixtures and runtime results described below.

## Reference pattern

[FrameworkImageIO.hx](../../src/vision/formats/__internal/FrameworkImageIO.hx) is the existing Canvas 2D interop entry point.

## Steps

### 1. Add a Canvas 2D presentation path

Add a browser adapter in the existing data and internal format packages. Use a caller-supplied canvas and track changes to CPU pixels, using full refresh when writable bytes have escaped. Keep the existing conversions' contracts.

### 2. Add a WebGL 2 presentation path

Reuse textures and upload changes before drawing. Resolve the destination context at initialization. Add a tiny browser example that composites two images in caller order and updates an image with `setPixel`.

## Verification

- Run `haxe compile.hxml` and the Node JS CI target. Exercise Canvas 2D and WebGL 2 separately in a browser and capture expected pixels before and after edits, including alpha, draw order and a raw byte write. Verify the Canvas 2D path on a fresh canvas when WebGL 2 is unavailable.

## Implementation and evidence

- [CanvasRenderer](../../src/vision/formats/__internal/CanvasRenderer.hx) draws at an offset into a caller-supplied canvas. The renderer reuses one staging image and one texture where applicable. It compares the current pixels on each draw so raw byte writes stay visible and identical pixels skip upload. Changes refresh the full texture.
- From the repository root run `haxe tests/ci/drawing.hxml`, then open [drawing.html](../../tests/ci/drawing.html). The two canvases exercise caller order, source-over alpha, pixel edits and raw byte writes. The page reports `data-result="pass"` after all assertions.
- Edge headless passed both Canvas 2D and WebGL 2 with SwiftShader. The Canvas 2D case starts with an existing 2D context to exercise fallback. This run verifies drawing behavior through a software WebGL implementation.
