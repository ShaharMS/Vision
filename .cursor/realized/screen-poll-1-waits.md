# Plan — Screen frame waits step 1 — Poll

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** Final step
>
> **Parent** [Screen frame waits](screen-poll-overview.md)

## TL;DR

Make the argument-free `poll()` wait for the next frame. Keep draws persistent and run a local 20-second color demo.

## Iteration bootstrap

- **Iteration slug** `screen-poll-1-waits`
- **Required evidence** Browser and desktop frame waits, persistence checks, and measured demo duration.

## Reference pattern

[Screen](../../src/vision/ds/Screen.hx) owns presentation. [NativeImageRenderer](../../src/vision/formats/__internal/NativeImageRenderer.hx) owns desktop events and presentation.

## Steps

### 1. Separate frame waits and events

Make poll wait from the previous frame start. Use a promise in the browser and a blocking wait on desktop. Keep drawing independent of polling.

### 2. Verify presentation

Check timing, persistence, and disposal in the existing fixtures. Open the local color demo on Windows.

## Verification

- Run browser and desktop drawing fixtures and the CI matrix.

Edge and Windows hxcpp and HashLink passed. The browser fixture checked drawing without a poll, preservation across waits, elapsed time, and disposal during a pending wait. The Windows desktop demo submitted 1,188 frames at a 60 FPS target during its 20-second animation.
