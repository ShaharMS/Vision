# Plan — Backend cleanup step 1 — Bindings and tests

> **Status** ✅ Completed
>
> **Prerequisite** First step
>
> **Next** Final step
>
> **Parent** [Backend cleanup](backend-cleanup-overview.md)

## TL;DR

Use Haxe browser and Windows system externs under `vision.backend`. Preserve release packaging as documented commands.

## Iteration bootstrap

- **Iteration slug** `backend-cleanup-1-bindings`
- **Required evidence** Release archive contents, shared utest suites, and platform checks.

## Reference pattern

[ManualSuites](../../tests/src/tests/support/ManualSuites.hx) registers authored tests.

## Steps

### 1. Remove root scripts and documentation fixtures

Document release staging in the README. Bind the Windows drawing APIs with Haxe externs.

### 2. Move backend code and tests

Put rendering in `vision.backend`. Register Screen and WebGPU inversion suites in the existing test runner.

## Verification

- The release archive contained the manifest, source, and CPPIA build helper and patch.
- The interpreter passed all 616 tests. The three Windows Screen cases passed with hxcpp in a directory containing only the executable.
