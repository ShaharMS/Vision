# Plan — Vision 3 step 4 — native drawing

> **Status** 🔲 Not started
>
> **Prerequisite** [Step 3](vision-3-integration-3-operation-dispatch.md)
>
> **Next** [Step 5](vision-3-integration-5-examples-and-tests.md)
>
> **Parent** [Vision 3 backend integration](vision-3-integration-overview.md)

## TL;DR

Draw ordinary Vision images through a standalone native host and qualify its fallback.

## Iteration bootstrap

- **Iteration slug** `vision-3-integration-4-native-drawing`
- **Required evidence** Save the checks below and note unsupported configurations.

## Reference pattern

[Image](../../src/vision/ds/Image.hx), [Vision](../../src/vision/Vision.hx), and [ImageTools](../../src/vision/tools/ImageTools.hx) define the public types, operations, and extensions. Platform interop lives under [formats](../../src/vision/formats).

## Steps

### 1. Implement the scoped change

Draw ordinary Vision images through a standalone native host and qualify its fallback.

## Verification

- Exercise native pixels and presentation from hxcpp and HashLink on the available host.
