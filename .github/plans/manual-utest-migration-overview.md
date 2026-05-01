# Plan: Manual Utest Migration

## Status: 🟡 In progress

## Overview

This repository currently has two overlapping test systems: a generator pipeline under `tests/generator` and a checked-in suite under `tests/generated` that `test.hxml`, `tests/ci/LocalCi.hx`, the GitHub workflow, and VS Code effectively treat as the real test entrypoint. The checked-in suite already contains useful structure such as `PrettyReporter`, `VISION_TESTS` filtering, and some scenario variants, but it still carries generator ownership markers and too many smoke-level assertions.

The requested end state is an authored `utest` suite that is owned by humans, can be run from VS Code for each class and member scenario, and is strong enough to tell the difference between a library defect and a bad test. This plan replaces the generated ownership model with a normal manual test tree, preserves the existing `utest` runner/reporting flow, adds deterministic suite and case filtering, and migrates class-by-class from scaffold assertions to semantic and edge-case coverage.

## Sub-Plans (execute in order)

| Order | Plan File | Summary |
|-------|-----------|---------|
| 1 | [manual-utest-migration-1-cutover.md](manual-utest-migration-1-cutover.md) | ✅ Completed — moved operational test entrypoints off the generated tree and recorded a coverage inventory. |
| 2 | [manual-utest-migration-2-harness.md](manual-utest-migration-2-harness.md) | ✅ Completed — built the authored runner, shared helpers, and VS Code-friendly suite and case filtering. |
| 3 | [manual-utest-migration-3-tools-and-core-ds.md](manual-utest-migration-3-tools-and-core-ds.md) | ✅ Completed — rewrote `vision.tools` and core collection/value-type tests with semantic assertions and edge cases. |
| 4 | [manual-utest-migration-4-image-and-geometry-ds.md](manual-utest-migration-4-image-and-geometry-ds.md) | Rewrite image-centric, matrix, and geometry data-structure suites around explicit invariants. |
| 5 | [manual-utest-migration-5-algorithms.md](manual-utest-migration-5-algorithms.md) | Replace algorithm smoke tests with deterministic fixture-driven behavioral coverage. |
| 6 | [manual-utest-migration-6-formats-and-facade.md](manual-utest-migration-6-formats-and-facade.md) | Rewrite format, facade, helper, and exception coverage around round trips and failure contracts. |
| 7 | [manual-utest-migration-7-decommission-and-coverage.md](manual-utest-migration-7-decommission-and-coverage.md) | Delete the old auto system, update docs, and prove the manual suite covers the intended surface. |

## Key Decisions

- **Authoritative test root** — Move the owned suite to `tests/src` instead of keeping `tests/generated/src`, so repository structure no longer claims that manual tests are generated artifacts.
- **Generator removal strategy** — Remove generator ownership from the execution path first, then delete `tests/generator` and `tests/generated` once the manual tree and coverage inventory are authoritative.
- **Suite shape** — Keep one `utest.Test` class per source class and use one or more `test_<member>__<scenario>` methods per public function or readable field.
- **VS Code trigger model** — Preserve `.vscode/settings.json` and `test.hxml` as the main Test Explorer entrypoint, and add explicit suite and case filtering so developers can run a class or a single member scenario deterministically.
- **Filtering mechanism** — Use the existing `VISION_TESTS` / `--tests` flow for suite selection and extend the runner to use `utest.Runner.addCase(..., ?pattern:EReg)` for method-level filtering.
- **Coverage accounting** — Track migration with a checked-in inventory so uncovered APIs, explicit exclusions, and still-generated legacy surfaces are visible in source control.
- **Assertion philosophy** — Prefer exact results, explicit invariants, and documented failure modes over `Assert.notNull` smoke checks, even when that exposes library bugs that need follow-up.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-utest-migration`
- **Verification evidence to preserve** — Successful `haxe test.hxml`, focused filtered runs at both suite and case level, `haxe tests/ci/local-ci.hxml -- --targets=interp --compile-only`, and a final compiled-target smoke after generator deletion.
- **Expected artifacts** — `tests/src/Main.hx`, `tests/src/tests/**/*.hx`, `tests/src/tests/support/**/*.hx`, updated `test.hxml`, updated `tests/ci/LocalCi.hx`, updated `.vscode/settings.json`, new `.vscode/tasks.json`, workflow/docs cleanup, and a checked-in manual coverage inventory.
- **Review focus** — No default path should execute `tests/compile.hxml` or `BuildMacro.generateAll()` after cutover; per-member filtering must be deterministic; assertions must explain behavior rather than merely proving that calls compile.
- **Commit guidance** — Split cutover/tooling, domain migrations, and final generator deletion into separate commits so regressions can be isolated quickly.