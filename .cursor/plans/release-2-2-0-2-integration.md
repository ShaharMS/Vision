# Plan: Vision 2.2.0 - Step 2: integration

> Status: In progress
> Parent: [overview](release-2-2-0-overview.md)
> Prerequisite: Step 1

## TL;DR

Apply user release-note input, merge release documentation into dev, then merge dev into main while preserving history.

## Iteration Bootstrap

- Iteration slug: release-2-2-0
- Required evidence: merge SHAs, release note input, CI results, package hash, published release metadata
- Artifacts to verify: changelog, package manifest, release body, tag

## Reference Pattern

.github/COMMIT-CONVENTION.md and PRs #53/#54

## Steps

### 1. Prepare the scoped change

Apply user release-note input, merge release documentation into dev, then merge dev into main while preserving history.

### 2. Verify the concrete result

Main tree contains every required commit; release metadata says 2.2.0; full target matrix green.

## Verification

Main tree contains every required commit; release metadata says 2.2.0; full target matrix green.

Approved release summary: Seam carving, Hough line/circle detection, Harris corners, higher-quality resizing, modern image I/O, and cross-target reliability.

PR #54 merged at a439049ceb18ee8f41578e57f0364a6e42708500; #53 merged into dev at 3c186e71ff5e166083697b78b838d848aa910405. #55 carries final notes into dev; #56 promotes dev to main. Existing source review threads were verified against 9a74abe and resolved.
