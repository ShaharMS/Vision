# Plan — Vision 3 step 2 — image backing

> **Status** ✅ Completed
>
> **Prerequisite** [Step 1](vision-3-integration-1-library-layout.md)
>
> **Next** [Step 3](vision-3-integration-3-operation-dispatch.md)
>
> **Parent** [Vision 3 backend integration](vision-3-integration-overview.md)

## TL;DR

Preserve packed bytes and alias behavior while adding an optional device backing.

## Iteration bootstrap

- **Iteration slug** `vision-3-integration-2-image-backing`
- **Required evidence** Save the checks below and note unsupported configurations.

## Reference pattern

[Image](../../src/vision/ds/Image.hx), [Vision](../../src/vision/Vision.hx), and [ImageTools](../../src/vision/tools/ImageTools.hx) define the public types, operations, and extensions. Platform interop lives under [formats](../../src/vision/formats).

## Steps

### 1. Implement the scoped change

Preserve packed bytes and alias behavior while adding an optional device backing.

## Verification

- Run the image and packed-format tests, including writable byte aliases.

The filtered Image, ImageTools and ImageView suites passed 75 tests. The browser fixture verified readback and writable byte aliases.
