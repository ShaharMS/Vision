# Plan — Vision 3 step 1 — library layout

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** [Step 2](vision-3-integration-2-image-backing.md)
>
> **Parent** [Vision 3 backend integration](vision-3-integration-overview.md)

## TL;DR

Fit the backend files into the existing data, tools and format packages.

## Iteration bootstrap

- **Iteration slug** `vision-3-integration-1-library-layout`
- **Required evidence** Save the checks below and note unsupported configurations.

## Reference pattern

[Image](../../src/vision/ds/Image.hx), [Vision](../../src/vision/Vision.hx), and [ImageTools](../../src/vision/tools/ImageTools.hx) define the public types, operations, and extensions. Platform interop lives under [formats](../../src/vision/formats).

## Steps

### 1. Implement the scoped change

Fit the backend files into the existing data, tools and format packages.

## Verification

- Compile the library and browser example after moving the modules.
