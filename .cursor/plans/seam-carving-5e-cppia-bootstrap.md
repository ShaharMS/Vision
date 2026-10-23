# Plan: Release audit - noninteractive cppia bootstrap

> Status: Completed
> Parent: [overview](seam-carving-overview.md)

## TL;DR

A canceled superseded run exposed an interactive hxcpp first-use prompt, which waited indefinitely after reporting missing hxcpp.n. Explicitly compile the build tool before invoking the pinned cppia host build.

## Reference Pattern

Pinned hxcpp tools/hxcpp/compile.hxml emits ../../hxcpp.n; project/compile-cppia.hxml builds the host.

## Steps

### 1. Bootstrap hxcpp.n without prompting

Run haxe compile.hxml under tools/hxcpp, then the existing bounded-worker host build.

### 2. Verify remote runtime

The final GitHub cppia job must reach compilation and run the suite; record its result in release closeout.

## Verification

Source of the pinned bootstrap hxml verified through GitHub API. Canceled run 40007517423 logs show the missing hxcpp.n prompt and lack of compilation progress after the prompt.
