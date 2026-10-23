# Plan: Seam carving — Step 5: release-readiness

> Status: Not started
> Parent: [overview](seam-carving-overview.md)
> Prerequisite: Step 4
> Next: None

## TL;DR

Reconcile 2.2.0 notes, run full tests/compile and inspect remote CI, packaging and remaining release gaps.

## Iteration Bootstrap

- Iteration slug: seam-carving
- Required evidence: verification results recorded in plan
- Artifacts to verify: source, tests, documentation assets

## Reference Pattern

`CHANGELOG.md`

## Steps

### 1. Implement scoped outcome

Reconcile 2.2.0 notes, run full tests/compile and inspect remote CI, packaging and remaining release gaps.

### 2. Verify and record evidence

Commit this completed step and push.

## Verification

Full behavioral suite, compile, remote CI and package audit

## Findings resolved

- Updated 2.2.0 changelog and stale manifest blurb.
- Removed unused runtime utest dependency; extracted package compiles independently.
- Replaced destructive, immediate-submit packaging with a package-only builder preserving earlier ZIPs.
- Fixed false-green Node tests, runtime dispatch, and Neko dead-code elimination (separate follow-up commits).
- Confirmed hosted generated PNG bytes and final browser rendering.

## Local evidence

- Full interp: 615 tests pass.
- Full Node JS: 615 tests pass.
- Eight Neko batches pass; six seam tests included in batch 1.
- Intentional failing Node reporter probe exits 1.
- haxe compile.hxml passes.
- Package-only ZIP: 112 entries; includes SeamCarving, source and metadata, excludes test and agent trees.
- Extracted package carve smoke passes on interp and JS without utest.
- Entire extracted vision package compiles to JS without utest.

## Integration boundary

Existing PR #53 carries Hough/Harris toward dev. Seam-carving work is based on that branch; integration will be a stacked PR into feature/hough-harris-feature-detection. No Haxelib submission or release tag is created by this work.
