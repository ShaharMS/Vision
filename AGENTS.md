# Vision — Agent Instructions

Cross-framework, cross-platform computer vision library for Haxe (`src/vision/`). Public API lives in `Vision.hx`; algorithms, data structures, tools, formats, and tests are organized under `src/vision/` and `tests/`.

**If instructions conflict with the current repo, ask before deviating.**

## Convention sources (read the relevant one)

| Topic | Location |
|-------|----------|
| Plan structure & sizing | `.github/PLAN-CONVENTION.md` |
| Commits & branches | `.github/COMMIT-CONVENTION.md` |

Keep plans and iteration notes in the system temp directory.

## Repository layout

| Path | Purpose |
|------|---------|
| `src/vision/ds/` | Data structures and geometry types |
| `src/vision/algorithms/` | Algorithm implementations |
| `src/vision/tools/` | Extended utilities (e.g. `ImageTools`, `MathTools`) |
| `src/vision/formats/` | Image I/O and format conversion |
| `src/vision/exceptions/` | Library-specific errors |
| `src/vision/helpers/` | Internal helpers and macros |
| `src/vision/Vision.hx` | Stable public API — prefer wrappers here over calling algorithm classes directly |
| `tests/src/tests/` | `utest` suites |
| `tests/ci/` | Local CI runner mirroring GitHub Actions |

## Non-negotiables

- **Small steps** — many short plan sub-plans; large steps degrade code quality.
- **One commit per completed sub-plan** — descriptive message per `.github/COMMIT-CONVENTION.md`.
- **Reference patterns** — match existing code in the same layer (`ds`, `algorithms`, `Vision.hx`, tests) before inventing new structure.
- **Verify before done** — run the plan step's verification plus the narrowest relevant compile/test command for touched scope.
- **Public API discipline** — new user-facing detectors and transforms should surface through `Vision.hx` with documentation, following existing wrappers.

## Key commands

| Action | Command |
|--------|---------|
| Behavioral tests (full suite) | `haxe test.hxml` |
| Behavioral tests (filtered) | Set `VISION_TESTS` / `VISION_TEST_CASES`, then `haxe test.hxml` (see `tests/README.md`) |
| Compile (JS default) | `haxe compile.hxml` |
| Local CI (all targets) | `haxe tests/ci/local-ci.hxml --` |
| Local CI (specific targets) | `haxe tests/ci/local-ci.hxml -- --targets=interp,js,neko` |
| Compile only | `haxe tests/ci/local-ci.hxml -- --compile-only` |

See `tests/ci/README.md` for target selection, env vars, and platform notes.
