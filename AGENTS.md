# Vision — Agent Instructions

Cross-framework, cross-platform computer vision library for Haxe (`src/vision/`). Public API lives in `Vision.hx`; algorithms, data structures, tools, formats, and tests are organized under `src/vision/` and `tests/`.


## Non-negotiables

- **Reference patterns** — match existing code in the same layer (`ds`, `algorithms`, `Vision.hx`, tests) before inventing new structure.
- **Public API discipline** — new user-facing detectors and transforms should surface through `Vision.hx` with documentation, following existing wrappers.

## Code and API documentation

- `src/vision/Vision.hx` — Place public wrappers beside related operations. Keep algorithm code in `src/vision/algorithms/`. Begin each public doc comment with a one-sentence summary, then explain the behavior and show an example where helpful. Finish with `@param`, `@return`, `@throws`, and `@see` where applicable. State whether the function edits the source, how it treats image views and alpha, and what it does at borders or on ties when relevant.
- `src/vision/ds/Image.hx` — Group pixel, drawing, and image operations with their existing peers. For drawing methods, document coordinates, clipping, and whether pixels are replaced or composited.
- `src/vision/ds/` and `src/vision/ds/specifics/` — Document public properties, constructors, and enum values. For geometry, describe units, boundary behavior, mutable inputs, and copy semantics. Keep options and technique selectors in `specifics`.
- `src/vision/algorithms/` — Follow the neighboring algorithm class layout. Keep implementation helpers private and explain non-obvious algorithm steps or conventions near the code.
- For public functions in `Vision.hx`, put a Before/After Markdown table after the explanatory prose and before the API tags. Use the standard valve image by default. Choose another input when it better demonstrates the operation, and label each output with its settings or behavior. Render the actual API output and give each image descriptive alt text. For functions that return geometry or measurements, show an overlay, a swatch, or the returned values. Prefer the existing `https://spacebubble.io/vision/docs/` host and check that the published URL serves the intended image. Use short Haxe examples to show calling conventions that screenshots cannot convey.
