# Plan — Vision 3 step 3 — operation dispatch

> **Status** 🔲 Not started
>
> **Prerequisite** [Step 2](vision-3-integration-2-image-backing.md)
>
> **Next** [Step 4](vision-3-integration-4-native-drawing.md)
>
> **Parent** [Vision 3 backend integration](vision-3-integration-overview.md)

## TL;DR

Route exact whole-image operations through attached storage and retain the current CPU implementations.

## Iteration bootstrap

- **Iteration slug** `vision-3-integration-3-operation-dispatch`
- **Required evidence** Save the checks below and note unsupported configurations.

## Reference pattern

[Image](../../src/vision/ds/Image.hx), [Vision](../../src/vision/Vision.hx), and [ImageTools](../../src/vision/tools/ImageTools.hx) define the public types, operations, and extensions. Platform interop lives under [formats](../../src/vision/formats).

## Steps

### 1. Implement the scoped change

Route exact whole-image operations through attached storage and retain the current CPU implementations.

## Verification

- Compare invert and simple grayscale byte for byte and exercise GPU chains, views, and CPU fallbacks in a browser.
