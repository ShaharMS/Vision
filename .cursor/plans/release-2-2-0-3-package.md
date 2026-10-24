# Plan: Vision 2.2.0 - Step 3: package

> Status: Not started
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
