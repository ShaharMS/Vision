# Plan: Standardized Hough and Harris Feature Detection

## Status: 🔄 In progress

## Publication Status

- Authored on `feature/manual-utest-migration-1-cutover` as a docs-only planning pass.
- Intended branch flow: commit the plan set first, bring the feature branch up to date with `main`, then fast-forward `dev` and `main` to the published tip.

## Overview

Vision currently has two disconnected feature-detection stories: `Vision.simpleLine2DDetection(...)` exposes an image-space recursive segment finder, while `src/vision/algorithms/SimpleHough.hx` implements a narrow accumulator experiment that integer-buckets `xIntercept|deg` pairs and returns `Ray2D` values. That means the existing Hough path is not yet a standard line transform, is not surfaced through `Vision.hx`, and does not cover the line-segment, weighted-vote, point-set, or circle-oriented variants that users reasonably expect after using OpenCV-style Hough APIs.

This plan standardizes the Hough family around real polar-space voting and image-bounded outputs, then adds a Harris corner detector that is documented as a first-class public API instead of an internal experiment. The implementation should follow the repo's existing pattern of small algorithm classes under `src/vision/algorithms`, stable public wrappers and rich documentation in `src/vision/Vision.hx`, focused geometry/data types under `src/vision/ds`, and authored `utest` coverage under `tests/src/tests`.

## Sub-Plans (execute in order)

| Order | Plan File | Summary |
|-------|-----------|---------|
| 1 | [hough-harris-feature-detection-1-foundation.md](.github/plans/hough-harris-feature-detection-1-foundation.md) | ✅ Completed — Added shared types, options, numeric-map conventions, and compatibility seams for the new detectors. |
| 2 | [hough-harris-feature-detection-2-standard-hough-lines.md](.github/plans/hough-harris-feature-detection-2-standard-hough-lines.md) | ✅ Completed — Replaced the ray-oriented accumulator with a standard polar Hough line transform and a SimpleHough compatibility bridge. |
| 3 | [hough-harris-feature-detection-3-probabilistic-hough-segments.md](.github/plans/hough-harris-feature-detection-3-probabilistic-hough-segments.md) | ✅ Completed — Added probabilistic Hough line-segment detection, the Vision wrapper, and explicit custom edge-map validation. |
| 4 | [hough-harris-feature-detection-4-hough-api-parity.md](.github/plans/hough-harris-feature-detection-4-hough-api-parity.md) | ✅ Completed — Added parity coverage for weighted votes, theta bounds, point-set input, and explicit multi-scale omission. |
| 5 | [hough-harris-feature-detection-5-hough-circles.md](.github/plans/hough-harris-feature-detection-5-hough-circles.md) | ✅ Completed — Added a dedicated Hough circle detector, the Vision wrapper, and circle-specific regressions for large radii and no-edge inputs. |
| 6 | [hough-harris-feature-detection-6-harris-response.md](.github/plans/hough-harris-feature-detection-6-harris-response.md) | ✅ Completed — Implemented the raw Harris response map and synthetic score-ordering coverage. |
| 7 | [hough-harris-feature-detection-7-harris-corners-and-api.md](.github/plans/hough-harris-feature-detection-7-harris-corners-and-api.md) | ✅ Completed — Added Harris corner extraction, scored public wrappers, and deterministic corner-selection coverage. |
| 8 | [hough-harris-feature-detection-8-docs-tests-and-closeout.md](.github/plans/hough-harris-feature-detection-8-docs-tests-and-closeout.md) | ▶ Next — Finish demos, docs, suite registration, inventory updates, and cross-target regression checks. |

## Key Decisions

- **Treat `SimpleHough` as a compatibility seam, not the destination API** — the new work should land in dedicated `Hough` and `Harris` algorithm files, with `SimpleHough` delegating or remaining as a clearly limited shim so `Vision.hx` can become the stable public entry point.
- **Use real parameter-space representations internally** — standard lines should be represented by `(rho, theta, votes)` first and only mapped to image-bounded `Line2D` results for rendering, instead of storing integerized intercept strings.
- **Use `Matrix2D` for raw response and accumulator maps** — both Hough voting and Harris response need float-capable numeric storage, and `Matrix2D` already matches that need better than overloading `Image` with raw numeric semantics.
- **Prioritize OpenCV-adjacent Hough parity in layers** — first ship `HoughLines`, then `HoughLinesP`, then weighted votes, angle bounds, and point-set entry, and only then add circles because circles require a distinct three-parameter search space and, likely, a new geometry type.
- **Expose Harris in two levels** — one raw response-map API and one corner-extraction API with thresholding and non-maximum suppression. This mirrors how OpenCV separates `cornerHarris` from the more user-facing corner-selection helpers.
- **Prefer relative quality thresholds for corner extraction** — Harris point extraction should support image-scaled thresholds, `minDistance`, and `maxCorners` so it behaves predictably across different image ranges without hard-coding a single absolute score.
- **Keep docs in `Vision.hx` authoritative** — algorithm classes can expose stepwise helpers, but the user-facing explanation and stable defaults belong in `src/vision/Vision.hx`, matching the rest of the library.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `hough-harris-feature-detection`
- **First step to execute** — [hough-harris-feature-detection-1-foundation.md](.github/plans/hough-harris-feature-detection-1-foundation.md)
- **Verification evidence to preserve** — targeted `haxe test.hxml` runs with `VISION_TESTS` filters for the new Hough/Harris suites; targeted compile-only `haxe tests/ci/local-ci.hxml` runs with `VISION_CI_TARGETS='interp,js'`, `VISION_CI_COMPILE_ONLY='1'`, and `VISION_CI_SKIP_INSTALL='1'`
- **Review focus for later agents** — backward compatibility of `Vision.hx`, whether full lines are clipped consistently to image bounds, whether probabilistic segments avoid duplicate fragments, whether Harris thresholds are scale-stable, and whether new numeric helpers avoid leaking float-only semantics into unrelated image APIs
- **Commit-splitting guidance** — keep at least one commit for foundation/types, one or more commits for the Hough family, one or more commits for Harris, and a final commit for docs/tests/inventory reconciliation
