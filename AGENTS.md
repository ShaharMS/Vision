# Vision — Agent Instructions

Cross-framework, cross-platform computer vision library for Haxe (`src/vision/`). Public API lives in `Vision.hx`; algorithms, data structures, tools, formats, and tests are organized under `src/vision/` and `tests/`.


## Non-negotiables

- **Reference patterns** — match existing code in the same layer (`ds`, `algorithms`, `Vision.hx`, tests) before inventing new structure.
- **Public API discipline** — new user-facing detectors and transforms should surface through `Vision.hx` with documentation, following existing wrappers.
