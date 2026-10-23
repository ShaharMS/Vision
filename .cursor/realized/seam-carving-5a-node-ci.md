# Plan: Seam carving release audit - Node CI exit status

> Status: ✅ Completed
> Parent: [overview](seam-carving-overview.md)

## TL;DR

Configure hxnodejs in local and GitHub CI; propagate reporter failure status.

## Reference Pattern

Existing target guards in src/vision/helpers/VisionThread.hx and tests/ci/LocalCi.hx.

## Steps

### 1. Repair observed failures

Configure hxnodejs in local and GitHub CI; propagate reporter failure status.

## Verification

JS full suite: 614 passed; deliberately failing reporter probe exits 1.
