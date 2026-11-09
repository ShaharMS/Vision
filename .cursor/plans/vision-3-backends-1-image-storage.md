# Plan — Vision 3 step 1 — Preserve the image contract

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** [Draw on browser targets](vision-3-backends-2-browser-drawing.md)
>
> **Parent** [Vision 3 native image and drawing backends](vision-3-backends-overview.md)

## TL;DR

Keep the existing Haxe abstract and move its byte-backed implementation behind internal storage. Establish the compatibility baseline before any graphics work.

## Iteration bootstrap

- **Iteration slug** `vision-3-backends-1-image-storage`
- **Required evidence** Record the outcomes in the verification section before handing off the step.
- **Artifacts to verify** Existing public API and CI fixtures.

## Reference pattern

[Image.hx](../../src/vision/ds/Image.hx) owns byte layout and view metadata. [ImageTest.hx](../../tests/src/tests/ImageTest.hx) exercises the public abstract.

## Steps

### 1. Capture existing semantics

Audit `Image.hx`, `Vision.hx` and references to `Image.underlying`. Record constructor, clone, aliasing, resize, views, `ARGB` and optional define behavior.

### 2. Introduce portable storage

Keep the public declarations in `Image.hx`. Move byte storage ownership into the internal backend while preserving the observable behavior identified in the audit. Keep `ByteArray` available through existing APIs.

## Verification

- Run `haxe test.hxml` and `haxe compile.hxml`. Run `haxe tests/ci/local-ci.hxml -- --targets=interp,js,neko` where the runtimes are installed and retain the existing GitHub matrix for the full compiler gate. Cover direct `underlying` edits and mutation/return behavior in `ImageTest` if existing tests miss them.

## Implementation and evidence

- `ImageStorage` wraps the original `ByteArray` without adding a runtime allocation for the wrapper. Constructors share packed allocation and width initialization. VISION byte loads enter through an explicit storage conversion.
- An image assignment still shares its bytes. Clone copies them. Replacing the storage during resize or through the optional `underlying` setter changes the receiving variable while existing aliases retain their previous storage. Packed data keeps its original header and ARGB byte layout.
- The interpreter suite passed 619 tests. The browser JS compile and the local Node.js and Neko compile-and-run jobs passed. A focused interpreter probe checked direct byte edits, alias and clone behavior, packed VISION round trips and resize with the default layout and with `vision_higher_width_cap` and `vision_allow_resize` enabled.
- The optional build exposed pre-existing missing return values in the width and height setters. Both now return the resulting dimension.
