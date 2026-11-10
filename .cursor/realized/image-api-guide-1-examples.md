# Plan — Image API guide step 1 — Examples

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** Final step
>
> **Parent** [Image API guide](image-api-guide-overview.md)

## TL;DR

Give readers complete starting programs and focused recipes for editing, displaying and processing Vision images.

## Iteration bootstrap

- **Iteration slug** `image-api-guide-1-examples`
- **Required evidence** Example compilation, output checks, and valid relative links.

## Reference pattern

[CarveExamples.hx](../../tools/docs/CarveExamples.hx) runs documentation examples against the library.

## Steps

### 1. Document the destination and its renderer

Explain the browser and native paths and link the recipes from the existing README.

### 2. Add runnable examples

Use the existing `tools/docs` directory for CPU output, a browser example, and a standalone window.

## Verification

- Run the CPU example and inspect the output files.
- Build and run the browser example and check the rendered pixels.
- Compile the native example for HashLink and hxcpp.

Verified the four PNGs, checked actual browser colors before and after a click, and compiled the guide and the two native targets.
