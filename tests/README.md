# Vision Test Generation

This directory currently contains two related but not identical systems:

1. A generator pipeline under `tests/generator` that can inspect `src/vision` and scaffold utest classes.
2. An authored executable test suite under `tests/src` that CI and day-to-day test runs actually compile.

`tests/generated` and `tests/compile.hxml` remain in the repository only as temporary migration references while the authored suite is being rewritten class by class.

That split is the most important fact to understand before changing anything: the generator explains how test scaffolds are produced, but the committed suite has already diverged from the raw template output through hand-authored assertions, skip macros, and a richer runner.

The forward-looking redesign plan lives in [ROADMAP.md](ROADMAP.md).

## Directory Roles

- `tests/config.json`
  - Declares the source tree to scan, exclusion filters, output directory, and runner file path.
- `tests/generator/Main.hx`
  - CLI-style entrypoint for generation, hxml emission, and fixture management.
- `tests/generator/Config.hx`
  - Macro that loads `config.json` at compile time and registers it as a module dependency.
- `tests/generator/MacroDetector.hx`
  - Compile-time introspection layer that discovers public methods and readable properties.
- `tests/generator/UtestGenerator.hx`
  - Scaffolds one utest class per source class.
- `tests/generator/BuildMacro.hx`
  - Older/parallel compile-time generation path driven by `--macro BuildMacro.generateAll()`.
- `tests/generator/FixtureManager.hx`
  - Golden fixture helper for image outputs. Present, but only partially integrated into generation.
- `tests/generator/PlatformHxmlGenerator.hx`
  - Emits multi-target hxml files for quick runs and CI.
- `tests/src/Main.hx`
  - The runner that current repo-level execution paths actually compile.
- `tests/src/PrettyReporter.hx`
  - Custom reporter that prints status, skipped tests, and exits with a failing code when needed.
- `tests/src/tests/*`
  - The authored test classes now used by default execution paths. Most were promoted from the checked-in generated tree and still need manual migration.
- `tests/generated/src/*`
  - Temporary migration reference material kept for diffing while `tests/src` is rewritten.
- `tests/ci/LocalCi.hx`
  - Local multi-target compile/run harness that mirrors CI behavior more closely than `test.hxml` does.
- `test.hxml`
  - Fast interpreter entrypoint from repo root. It runs the authored suite from `tests/src`, while `tests/generated` remains reference-only during migration.

## Current End-to-End Flow

### 1. Configuration

The generator reads `tests/config.json`.

Current values:

- `source = ../src/vision`
- `destination = ./generated/src/tests`
- `testsToRunFile = ./generated/src/Main.hx`
- `overwrite = false`
- `regenerateAll = true`
- `exclude = ["exceptions/", "Array2DMacro.hx", "FrameworkImageIO.hx"]`

Important consequences:

- Output is written into `tests/generated/src/tests`.
- The runner file is expected to live at `tests/generated/src/Main.hx`.
- That output is not part of the default execution path after the `tests/src` cutover.
- Existing generated files are preserved because `overwrite` is `false`.
- Generation is effectively all-or-nothing today because `Main.runGenerate()` only fills the file list when `regenerateAll` is `true`.

### 2. Entry Into Generation

There are two generation entrypoints.

#### Path A: `tests/generator/Main.hx`

This is the clearer high-level driver.

It supports three commands:

- `generate`
- `hxml`
- `fixtures`

When invoked through Haxe, it first strips compiler-specific arguments from `Sys.args()` so the command parser only sees its own flags.

The `generate` command then:

1. Loads `config.json` through `Config.load("config.json")`.
2. Recursively walks the configured source directory.
3. Skips:
   - `.js.hx` interface files
   - anything whose path contains an `exclude` substring
4. Converts each file path into a Haxe class path.
5. Calls `UtestGenerator.generateTestFile(...)` for each class.
6. Collects the generated test class names.
7. Rewrites the test runner file.

#### Path B: `tests/generator/BuildMacro.hx`

`tests/compile.hxml` references this path with:

`--macro BuildMacro.generateAll()`

This macro performs nearly the same job as `UtestGenerator`/`Main`, but it duplicates the template logic instead of sharing it. It also writes a runner class named `TestMain`, while the checked-in generated suite and `config.json` point at `Main`.

That means the repository currently has two test generation implementations that are conceptually similar but not fully unified.

### 3. Compile-Time Detection With `MacroDetector`

The real detection logic lives in `tests/generator/MacroDetector.hx`.

`MacroDetector.detectClass(classPath)` does the following in macro context:

1. Resolves the type through `haxe.macro.Context.getType(classPath)`.
2. Accepts class instances and abstracts.
3. Ignores enums and typedefs.
4. Enumerates:
   - public static fields
   - public instance fields
5. Converts supported fields into `TestableFunction` records.
6. Reads constructor parameters and attaches them to each instance member, so a generated test can build the class before calling an instance method.

What counts as testable right now:

- Public methods.
- Public readable properties.

What is skipped right now:

- Private fields.
- Constructors (`new`, `_new`).
- Write-only properties.
- Enums and typedefs.

Each detected member becomes a `TestableFunction` with:

- package name
- class name
- member name
- `isStatic`
- kind (`TKMethod` or `TKProperty`)
- parameter list
- return type
- constructor parameter list for instance members

### 4. Default Input Synthesis

`MacroDetector.getDefaultForType(typeName)` is the current strategy for producing call arguments.

This is heuristic and type-name based, not semantic.

Examples:

- `String -> ""`
- `Int -> 0`
- `Float -> 0.0`
- `Bool -> false`
- `Array<T> -> []`
- `Image -> new vision.ds.Image(100, 100)`
- `Point2D -> new vision.ds.Point2D(0.0, 0.0)`
- unknown types -> `null`

Function types are also synthesized into placeholder lambdas.

This is the reason the current generator can create a compilable call surface for many APIs, but not necessarily a meaningful behavioral test.

### 5. Test File Emission

`UtestGenerator.generateTestFile(sourceClassPath, outputPath, fixturesPath)` writes one class per source type.

The generated shape is:

1. `package tests`
2. Imports for utest and the source class
3. Extra imports inferred from parameter types
4. `@:access(sourceClassPath)` for internal access
5. Shared image fixtures:
   - `testImage`
   - `blackImage`
   - `gradientImage`
6. `setup()` that lazily creates those fixtures
7. `createGradientImage()` helper
8. One `test_<member>()` method per detected member

Inside each generated test method:

1. Parameters are initialized from `getDefaultForType()`.
2. Instance members trigger construction of `new SourceClass(...)` using default constructor arguments.
3. The member is invoked.
4. Assertions are shallow by default:
   - `Void` methods only assert that no exception was thrown.
   - Non-`Void` methods usually only assert `Assert.notNull(result)`.
   - `Image` return values currently only get a placeholder non-null check, plus TODO comments in `UtestGenerator` for fixture comparison.

This generator is therefore best described as scaffold generation, not full semantic test generation.

### 6. Runner Emission

After generation, the driver rewrites a runner file containing one `runner.addCase(new <ClassName>Test())` call per generated class.

For the authored `tests/src` suite, every new manual test class must also be added to `tests/src/tests/support/ManualSuites.hx` so `VISION_TESTS` and `VISION_TEST_CASES` filtering can discover it.

There is an important divergence here:

- `tests/generator/Main.hx` writes `generated/src/Main.hx`.
- `tests/generator/BuildMacro.hx` writes a class named `TestMain`.
- The checked-in `tests/generated/src/Main.hx` is richer than either template path.

The committed runner currently adds:

- `PrettyReporter`
- test filtering via `VISION_TESTS`, `VISION_TEST_CLASSES`, `VISION_TEST_CASES`, `--tests`, or `--cases`
- an explicit curated list of test classes

So even though the generator can rewrite `Main.hx`, the version committed in the repository is already manually evolved beyond the template.

### 7. HXML Generation

`tests/generator/Main.hx hxml ...` delegates to `PlatformHxmlGenerator`.

That file can emit:

- `generated/all-platforms.hxml`
- `generated/platforms/*.hxml`
- `generated/quick.hxml`
- `generated/ci.hxml`

This is separate from the root `test.hxml`, which is the shortest path to run the interpreter test suite.

## What Executes By Default After Cutover

The actual execution paths in this repository compile the authored suite under `tests/src`, not the generator outputs directly.

### Repo Root Fast Path

`test.hxml` does this:

1. `--cwd tests`
2. `--class-path src`
3. `--main Main`
4. loads `vision`, `format`, and `utest`
5. runs `--interp`

So `haxe test.hxml` from repo root executes `tests/src/Main.hx`.

### Suite And Case Filtering

The authored runner supports deterministic filtering at two levels:

- suite filtering by exact class name through `VISION_TESTS`, `VISION_TEST_CLASSES`, or `--tests`
- case filtering by `EReg` pattern through `VISION_TEST_CASES` or `--cases`

Suite filters accept a comma-separated list of exact `*Test` class names.

Case filters are regular expressions matched against the full test method name, such as `test_getPixel__outOfBounds` or `test_(png|bmp)__.*`.

Examples:

- `haxe test.hxml -- --tests ArrayToolsTest`
- `haxe test.hxml -- --tests ImageTest --cases test_getPixel__outOfBounds`
- PowerShell fallback on this Windows build:
  - `$env:VISION_TESTS='ImageTest,FromBytesTest'; haxe test.hxml`
  - `$env:VISION_TESTS='ImageTest'; $env:VISION_TEST_CASES='test_getPixel__outOfBounds'; haxe test.hxml`
- `cmd.exe` fallback:
  - `set VISION_TESTS=ImageTest,FromBytesTest && haxe test.hxml`
  - `set VISION_TESTS=ImageTest && set VISION_TEST_CASES=test_getPixel__outOfBounds && haxe test.hxml`

On this Windows Haxe build, direct `--` passthrough can fail before `Main` runs. When that happens, use the equivalent `VISION_TESTS` and `VISION_TEST_CASES` environment variables instead. In PowerShell, set them with `$env:...`; in `cmd.exe`, use `set ...`.

`.vscode/settings.json` remains the Test Explorer discovery entrypoint through `test.hxml`, and `.vscode/tasks.json` uses the environment-variable form for explicit filterable task entrypoints.

### Local CI

`tests/ci/LocalCi.hx` is the real multi-target harness.

It:

1. Compiles from `tests/src`.
2. Targets `interp`, `neko`, `hl`, `js`, `cpp`, `jvm`, `python`, `lua`, `php`, `cs`, `java`, and `cppia`.
3. Adds defines such as:
   - `vision_skip_golden`
   - `vision_skip_invalid_tests`
   - `vision_no_inline` when required
4. Runs the produced artifact with the correct runtime command for each platform.

`tests/ci/README.md` contains the invocation details. One important nuance is that argument passthrough with `--` is Haxe-build dependent when `--interp` is involved. That README already documents environment-variable fallbacks for builds that reject `--`.

### GitHub Actions

`.github/workflows/main.yml` follows the same pattern as local CI:

- compile `tests/src` with `--main Main`
- run per-target artifacts
- enable `vision_skip_golden`
- enable `vision_skip_invalid_tests`

This is why `tests/src/Main.hx` is the runner that matters operationally today.

`tests/generated` and `tests/compile.hxml` remain available only as temporary migration references and are not part of the normal repo-local or CI execution path.

## The Checked-In Suite Is Not Pure Generator Output

Understanding this matters for any future rewrite.

Examples of divergence already present in `tests/generated/src/tests`:

- `ArrayToolsTest` has stronger assertions and explicit edge-case coverage rather than only `Assert.notNull(result)`.
- `VisionTest` contains large hand-authored async golden-image tests that fetch reference images from the docs site.
- `FromBytesTest` and `ToBytesTest` are wrapped in `@:build(tests.macros.InvalidTestSkipper.build())` so CI can ignore placeholder/invalid-data cases.
- Several tests contain explicit `@Ignored("...")` reasons for target-specific instability or missing runtime prerequisites.
- `VisionTest` uses `@:build(tests.macros.GoldenTestSkipper.build())` to disable network-heavy golden tests when requested.

In other words, `tests/generated/src/tests` is currently a mixed ownership area:

- some content is still close to generated scaffolding
- some content is clearly hand-augmented
- some content is effectively manual but kept in the generated tree

There is no first-class provenance marker today that says whether a test or assertion is:

- generator-owned
- user-augmented
- fully manual

## Fixture Support: Present, But Not Fully Wired In

`FixtureManager.hx` already exists and supports:

- creating PNG fixtures
- writing perceptual hashes
- hash-distance comparison
- mismatch snapshots
- listing and clearing fixtures

But the emitted test methods do not currently call `FixtureManager.matches(...)`.

`UtestGenerator` still leaves fixture comparison as comments/TODOs for image-returning methods. So the repo contains the beginning of a golden-fixture system, but not a complete end-to-end integration into generated tests.

## Current Friction Points

These are the main design constraints exposed by the current implementation.

### 1. Two generators, one concept

`UtestGenerator` and `BuildMacro` duplicate the same basic scaffold logic. That increases drift risk and makes future changes harder to apply consistently.

### 2. Detection is macro-based, but scenarios are not

Member discovery is compile-time and robust. Test case design is still mostly a hard-coded mapping from type name to default literal.

### 3. One generated case per member

The default shape is roughly:

- one method
- one parameter set
- one shallow assertion

That is enough for API smoke coverage, but not enough for real behavior coverage.

### 4. Generated and manual code share the same files

Because user edits live in the same files as generated scaffolds, regeneration is risky. The current `overwrite = false` setting avoids destructive rewrites, but it also allows stale files to persist indefinitely.

### 5. Runner ownership is unclear

The checked-in `Main.hx` is richer than the template-generated one, while `BuildMacro` still assumes `TestMain`. The repo has not yet converged on a single source of truth for runner generation.

### 6. Fixtures and skip metadata are disconnected from generation

The codebase already has:

- fixture utilities
- skip macros
- per-test `@Ignored` reasons

But that metadata is not modeled as structured generation output.

### 7. Source discovery is heuristic

The generator depends on:

- substring-based exclusions
- a `/vision/` path assumption when reconstructing class paths
- type-name string matching for imports and default values

That works for the current tree, but it is brittle as a long-term abstraction boundary.

## Implications For A Future Rewrite

If the goal is a more macro-first and more maintainable system, the current code strongly suggests these architectural boundaries.

### Use the macro detector as the source of truth

`MacroDetector` is already the strongest part of the pipeline. The next version should likely expand it into a richer metadata collector rather than duplicate more template logic elsewhere.

### Separate detection, case synthesis, and file emission

Today those concerns are tightly coupled. A better pipeline would likely be:

1. Detect callable members and their metadata.
2. Expand each member into one or more test scenarios.
3. Attach provenance and constraints to each scenario.
4. Emit files from that structured model.

### Introduce explicit provenance markers

Your planned distinction is exactly the missing piece in the current design.

Useful labels would be:

- `generated`
- `generated+augmented`
- `manual`

Those markers should probably live in structured metadata, not just comments, so regeneration can preserve intent.

### Move from single default inputs to strategy-based case generation

Instead of one default argument set per function, future generation should be able to emit several cases per member, such as:

- happy path
- empty input
- degenerate geometry
- boundary values
- target-specific regression cases
- fixture-backed image cases

### Keep manual augmentation out of the regeneration blast radius

The current mixed-ownership files make safe regeneration difficult. Future options could include:

- separate generated and manual companion files
- generated regions plus protected manual regions
- generated manifests consumed by hand-authored test wrappers
- metadata-driven overlays

### Make skip reasons and fixture requirements first-class metadata

The repo already needs to encode:

- requires network
- requires filesystem
- invalid placeholder test data
- unstable on target X
- needs regenerated golden reference

That information should be emitted from the same model that emits the test case itself.

## Practical Summary

Today, the system works like this:

1. Macro detection discovers public members.
2. The generator can scaffold utest files into `tests/generated/src/tests`, but that path is now reference-only.
3. The committed suite in `tests/src` is then compiled and run by `test.hxml`, local CI, and GitHub Actions, while `tests/generated` and `tests/compile.hxml` remain reference-only.
4. The committed suite is already partly manual, so it should be treated as a curated artifact, not as disposable pure output.

If you redesign this area, the biggest win will come from making generation metadata explicit enough that the repo can safely distinguish:

- what is detected
- what is generated
- what is hand-authored
- what is target-conditional
- what is fixture-backed

That would let the project move from smoke-test scaffolding toward meaningful, regenerable, macro-driven test synthesis.