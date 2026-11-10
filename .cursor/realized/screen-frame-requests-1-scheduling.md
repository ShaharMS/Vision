# Plan — Screen frame requests step 1 — Scheduling

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** Final step
>
> **Parent** [Screen frame requests](screen-frame-requests-overview.md)

## TL;DR

Provide one-shot Screen frame requests. The next deadline accounts for time spent drawing. Callers opt into each new frame.

## Iteration bootstrap

- **Iteration slug** `screen-frame-requests-1-scheduling`
- **Required evidence** Browser and desktop frame timing and cancellation checks.

## Reference pattern

[Screen](../../src/vision/ds/Screen.hx) owns presentation and exposes polling without owning application logic.

## Steps

### 1. Add the request API

Use browser frame callbacks and the Haxe event loop on native targets. Cancel the pending request during disposal.

### 2. Verify and document

Extend the Screen fixtures and prepare a local gitignored example.

## Verification

- Compile and run browser and Windows Screen tests, then check the CI matrix.

Edge, Windows HashLink, and Windows hxcpp passed the frame clock and cancellation checks. A Windows HashLink probe at 10 FPS with 60 ms of callback work reported 100.39 ms and 100.47 ms between callbacks. The local gitignored example compiled for JavaScript and HashLink.
