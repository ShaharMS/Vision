# Plan — Screen step 2 — Wire the native position and portable desktop host

> **Status** ✅ Completed
>
> **Prerequisite** [Previous step](screen-1-public-api.md)
>
> **Next** [Next step](screen-3-examples.md)
>
> **Parent** [Screen drawing API](screen-overview.md)

## TL;DR

Wire the native position and portable desktop host.

## Iteration bootstrap

- **Iteration slug** `screen-2-desktop`
- **Required evidence** Verify the expected platform behavior.

## Reference pattern

[Image](../../src/vision/ds/Image.hx) is the public image type. Existing platform adapters live under [formats](../../src/vision/formats).

## Steps

### 1. Apply this step

Wire the native position and portable desktop host.

## Verification

- Build the Windows and SDL libraries and verify their frame path.

The Windows HashLink and hxcpp executables passed. Linux passed through X11 under Xvfb. macOS passed the SDL software smoke. CI also runs the macOS Cocoa path.
