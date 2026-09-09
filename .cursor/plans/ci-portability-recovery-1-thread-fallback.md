# Plan: CI Portability Recovery — Step 1: Thread Fallback

> **Status**: ✅ Completed
> **Prerequisite**: None — first step.
> **Next**: [Step 2](ci-portability-recovery-2-portable-format-assertions.md)
> **Parent**: [ci-portability-recovery-overview.md](ci-portability-recovery-overview.md)

## TL;DR

Make `VisionThread` compile and behave deterministically on system targets that do not implement `sys.thread.Thread`, while retaining existing asynchronous implementations for JS and threaded targets.

## Iteration Bootstrap

- **Iteration slug**: `ci-portability-recovery-1-thread-fallback`
- **Required evidence**: PHP compilation no longer resolves `sys.thread.Thread`.
- **Artifacts to verify**: `VisionThreadTest`, PHP target compile.

## Reference Pattern

In [src/vision/helpers/VisionThread.hx](../../src/vision/helpers/VisionThread.hx):
- The `underlying` field already distinguishes `js`, `target.threaded`, and fallback targets.

## Steps

### 1. Align dispatch with the field's target guards

In `src/vision/helpers/VisionThread.hx`, use the threaded branch only when `target.threaded` is defined and add a synchronous fallback that preserves success and failure callbacks.

### 2. Preserve behavior through the existing suite

In `tests/src/tests/VisionThreadTest.hx`, add coverage for the synchronous fallback only where it is compiled.

## Verification

- `haxe test.hxml` with `VISION_TESTS=VisionThreadTest`
- Exact PHP compile command from `.github/workflows/main.yml`
