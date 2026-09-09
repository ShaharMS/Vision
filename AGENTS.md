# Vision — Agent Instructions

Cross-framework, cross-platform computer vision library for Haxe (`src/vision/`). Public API lives in `Vision.hx`; algorithms, data structures, tools, formats, and tests are organized under `src/vision/` and `tests/`.

**If instructions conflict with the current repo, ask before deviating.**

## Convention sources (read the relevant one)

| Topic | Location |
|-------|----------|
| Workflow (always on) | `.cursor/rules/plan-and-commit-workflow.mdc` |
| Haxe formatting | `.cursor/rules/haxe-formatting.mdc` |
| Library code (`src/`) | `.cursor/rules/haxe-library.mdc` |
| Tests (`tests/`) | `.cursor/rules/haxe-testing.mdc` + `.cursor/skills/vision-tests/SKILL.md` |
| Active plans | `.cursor/plans/` |
| Completed plans | `.cursor/realized/` |
| Iteration / resume state | `.cursor/iterations/` + `.cursor/agent-progress/` |
| Plan structure & sizing | `.github/PLAN-CONVENTION.md` |
| Commits & branches | `.github/COMMIT-CONVENTION.md` |
| Custom agents | `.cursor/agents/` + `.github/AGENT-WORKFLOW.md` |

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

## Custom agents

| Agent | Use for |
|-------|---------|
| `@inquire` | Research + write plans to `.cursor/plans/` |
| `@implement` | Execute one plan step, verify, commit |
| `@inspect` | Review diff vs plan + conventions (read-only) |
| `@iterate` | Autonomous implement → inspect loops |
