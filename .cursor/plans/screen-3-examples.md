# Plan — Screen step 3 — Rewrite the public drawing examples around Screen

> **Status** ✅ Completed
>
> **Prerequisite** [Previous step](screen-2-desktop.md)
>
> **Next** Final step
>
> **Parent** [Screen drawing API](screen-overview.md)

## TL;DR

Rewrite the public drawing examples around Screen.

## Iteration bootstrap

- **Iteration slug** `screen-3-examples`
- **Required evidence** Verify the expected platform behavior.

## Reference pattern

[Image](../../src/vision/ds/Image.hx) is the public image type. Existing platform adapters live under [formats](../../src/vision/formats).

## Steps

### 1. Apply this step

Rewrite the public drawing examples around Screen.

## Verification

- Compile the same example for JS and native targets and verify browser output.

ScreenExample compiled to JavaScript and HashLink and type-checked for hxcpp. Edge showed the requested 320 by 180 screen at the requested position.
