# Plan — Screen step 1 — Introduce Screen and remove ImageTools.addToScreen

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** [Next step](screen-2-desktop.md)
>
> **Parent** [Screen drawing API](screen-overview.md)

## TL;DR

Introduce Screen and remove ImageTools.addToScreen.

## Iteration bootstrap

- **Iteration slug** `screen-1-public-api`
- **Required evidence** Verify the expected platform behavior.

## Reference pattern

[Image](../../src/vision/ds/Image.hx) is the public image type. Existing platform adapters live under [formats](../../src/vision/formats).

## Steps

### 1. Apply this step

Introduce Screen and remove ImageTools.addToScreen.

## Verification

- Compile the library, run the image tools suite and verify the browser Screen smoke.

Edge verified positioning, drawing across animation frames, and disposal. The Haxe interpreter suite passed all 616 tests. The Windows HashLink smoke drew two frames and stopped.
