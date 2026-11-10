# Plan — Screen lifecycle step 1 — Public API

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** Final step
>
> **Parent** [Application-owned Screen loops](screen-lifecycle-overview.md)

## TL;DR

Replace the callback loop with `poll()` and `onFirstDraw`. Provide local, gitignored examples.

## Iteration bootstrap

- **Iteration slug** `screen-lifecycle-1-api`
- **Required evidence** Browser and desktop draw checks, plus successful compilation of local examples.

## Reference pattern

[Screen](../../src/vision/ds/Screen.hx) owns the destination and [NativeImageRenderer](../../src/vision/formats/__internal/NativeImageRenderer.hx) polls desktop events.

## Steps

### 1. Update the API and tests

Remove the internal frame loop. Verify drawing, polling, and the one-time callback in the existing browser and desktop fixtures.

### 2. Update documentation and local examples

Remove the obsolete callback examples and provide gitignored Haxe files with caller-owned loops.

## Verification

- Compile and run the browser and Windows drawing fixtures, then run the repository CI matrix.

Edge and both Windows native targets passed. The three local example files are gitignored and compiled for their intended targets.
