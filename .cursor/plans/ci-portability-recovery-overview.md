# Plan: CI Portability Recovery

## Status: ✅ Completed

## Overview

Restore trustworthy cross-target CI without weakening feature coverage. The current failures predate the Hough/Harris branch and have reproducible causes on PHP, Python, and Neko; each is repaired in a narrow layer with an independently runnable verification.

## Sub-Plans (execute in order)

| Order | Plan File | Summary |
| --- | --- | --- |
| 1 | [ci-portability-recovery-1-thread-fallback.md](ci-portability-recovery-1-thread-fallback.md) | Give non-threaded system targets deterministic `VisionThread` behavior. ✅ |
| 2 | [ci-portability-recovery-2-portable-format-assertions.md](ci-portability-recovery-2-portable-format-assertions.md) | Make color and unsupported-format coverage compare portable semantics. ✅ |
| 3 | [ci-portability-recovery-3-neko-test-partition.md](ci-portability-recovery-3-neko-test-partition.md) | Keep Neko-compatible coverage below its generated-program stack limit. ✅ |

## Key Decisions

- **Portable color equality** — compare ARGB channels, not target-dependent signed `Int` representation.
- **Unsupported format backends** — test the documented `Unimplemented` behavior rather than requiring an upstream encoder that does not exist on that target.
- **Neko coverage** — split execution only when required by Neko's stack limit; do not drop suites.

## Iteration Bootstrap

- **Iteration slug**: `ci-portability-recovery-3-neko-test-partition`
- **Required evidence**: PHP compile, targeted interpreter tests, and fresh GitHub Actions logs after each pushed step.
- **Artifacts to verify**: `VisionThreadTest`, format/color suites, and Neko target execution.
