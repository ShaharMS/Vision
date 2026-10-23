# Plan: Seam carving release audit - Node runtime compatibility

> Status: ✅ Completed
> Parent: [overview](seam-carving-overview.md)

## TL;DR

Keep typed exceptions and nonbrowser behavior under Node; dispatch VisionThread callbacks correctly.

## Reference Pattern

Existing target guards in src/vision/helpers/VisionThread.hx and tests/ci/LocalCi.hx.

## Steps

### 1. Repair observed failures

Keep typed exceptions and nonbrowser behavior under Node; dispatch VisionThread callbacks correctly.

## Verification

Full JS suite plus successful/failing job regression and interp suite.
