# Plan — HashLink Screen step 1 — Windows

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** Final step
>
> **Parent** [HashLink Screen and target coverage](hashlink-screen-overview.md)

## TL;DR

Keep the Windows framebuffer in Haxe. Bind the Windows calls that HashLink needs through the approved native directory.

## Iteration bootstrap

- **Iteration slug** `hashlink-screen-1-windows`
- **Required evidence** Windows Screen suite and target coverage against Vision 2.x.

## Reference pattern

[WindowsRenderer](../../src/vision/backend/WindowsRenderer.hx) owns the Windows framebuffer. [ScreenTest](../../tests/src/tests/ScreenTest.hx) covers drawing and frame timing.

## Steps

### 1. Bind Windows presentation

Provide HashLink calls for opening, event processing, presentation, and closing. Reuse the Haxe framebuffer.

### 2. Verify targets

Retain the 12 Vision 2.x CI targets. Exercise the HashLink Screen on Windows and add the existing Flash and HashLink/C smoke program to CI.

## Verification

- Run the Windows suite through hxcpp and HashLink. Verify Flash compilation and HashLink/C execution. Check the full matrix.

The Windows Screen suite passed on hxcpp and HashLink. The bridge reported repaint and window-close events. Flash compiled and HashLink/C ran the image smoke test locally. The interpreter passed 616 tests.
