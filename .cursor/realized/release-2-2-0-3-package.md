# Plan: Vision 2.2.0 - Step 3: package

> Status: ✅ Completed
> Parent: [overview](release-2-2-0-overview.md)
> Prerequisite: Step 2

## TL;DR

Build an immutable package from the release commit and verify contents, helpers, hashes and smoke behavior.

## Iteration Bootstrap

- Iteration slug: release-2-2-0
- Required evidence: merge SHAs, release note input, CI results, package hash, published release metadata
- Artifacts to verify: changelog, package manifest, release body, tag

## Reference Pattern

build-release.ps1 and tests/ci/cppia/README.md

## Steps

### 1. Prepare the scoped change

Build an immutable package from the release commit and verify contents, helpers, hashes and smoke behavior.

### 2. Verify the concrete result

ZIP manifest/version/required files match release commit; smoke compile/run; SHA256 recorded.

## Verification

ZIP manifest/version/required files match release commit; smoke compile/run; SHA256 recorded.

## Completed evidence

Built from git archive of `2adc54e7b3a59e227a9d983b1e40a81d7e7f195d`, not the mutable workspace. Every packaged file matches the corresponding canonical archive file byte for byte. Manifest is vision 2.2.0; ZIP contains 116 entries including cppia host tooling and excludes tests/agent state.

- Package: `C:\Users\shaha\Documents\GitHub\Vision\release\2.2.0\vision-2.2.0.zip`.
- SHA256: `dfebc39e8f79e2e5885de9f13d1fe36a3c974bc51e725ae248ded22ecb447cc2`.
- Interpreter and Node package smoke checks pass (carve/RGBA, PNG round trip and Harris flat-image behavior).
- Downloaded GitHub asset and checksum match the local package.
