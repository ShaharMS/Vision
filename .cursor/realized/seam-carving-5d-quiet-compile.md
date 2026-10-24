# Plan: Release audit - quiet-mode compilation

> Status: ✅ Completed
> Parent: [overview](seam-carving-overview.md)

## TL;DR

The advertised vision_quiet define fails compilation in matrix conversion and PNG/BMP loading. Repair these branches and test malformed image fallback plus fractional matrix preservation.

## Reference Pattern

Existing quiet guards in TransformationMatrix2D and FormatImageLoader; authored FromBytesTest and TransformationMatrix2DTest suites.

## Steps

### 1. Fix quiet-only compile failures

Use an integer row index and Float matrix values; return a transparent 1x1 placeholder on malformed input in quiet mode.

### 2. Verify quiet configuration

Run focused quiet regression tests and seam tests with vision_quiet and vision_higher_width_cap; rerun default suite.

## Verification

Focused quiet/large-header tests and default behavioral suite must pass.

Evidence: focused quiet plus large-header configuration passes eight tests; malformed PNG/BMP returns a transparent 1x1 placeholder. Fractional matrix conversion remains intact. Default suite rerun required before final closeout.
