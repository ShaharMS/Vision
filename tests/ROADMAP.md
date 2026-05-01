# Vision Test System Roadmap

This document is the implementation plan for replacing the current mixed generator plus curated-suite model with a macro-first, scenario-driven, regenerable test system.

It is intentionally opinionated. The current repository already shows the failure modes of the old design:

- two generation paths that drift
- string-based defaults instead of semantic case planning
- generated and manual code mixed in the same files
- shallow smoke-style assertions in many generated tests
- runner behavior and test metadata living outside the generator model

The goal of the next system is not just to generate more code. The goal is to generate tests that are easier to trust, easier to regenerate, easier to review, and easier to extend by hand without losing ownership clarity.

## Outcomes

The new system should deliver all of the following.

- One authoritative macro-driven pipeline for detection, planning, and emission.
- More than one scenario per function when that adds signal.
- Better inserted values through reusable providers, domain heuristics, and explicit metadata.
- More readable generated tests with stable structure, shared helpers, and deterministic formatting.
- Clear markers for provenance, maturity, skip conditions, and lifecycle status.
- Safe regeneration without clobbering hand-authored work.
- Better observability into which APIs have only smoke coverage versus semantic, golden, or regression coverage.
- A migration path that preserves the currently useful hand-written logic in the checked-in suite.

## Design Principles

### 1. Detection, planning, and emission must be separate stages

The current generator jumps from type discovery straight to handwritten string output. The replacement should have three explicit stages:

1. Detect a typed model of what is callable and testable.
2. Expand that model into one or more test scenarios.
3. Emit readable Haxe from the planned scenarios.

This separation is the main prerequisite for meaningful test generation.

### 2. Provenance must be explicit

The new system must never leave it ambiguous whether a test is:

- fully generated
- generated and then augmented
- fully manual
- legacy and not yet migrated

Today that distinction is implicit and fragile.

### 3. Status should be modeled on several axes, not one overloaded flag

Do not collapse authorship, execution state, and quality into a single enum.

At minimum, the plan should separate:

- provenance: who owns the test body
- maturity: how strong the assertion style is
- lifecycle: whether the case is active, quarantined, deprecated, or obsolete
- requirements: whether the case needs network, filesystem, golden fixtures, or target-specific capabilities
- observed health: pass/fail/flaky data from recent runs

Observed health should be derived from test results, not hard-coded into source.

### 4. Generated code must be readable by humans

Generated tests are still source code. Developers will debug them, review them, and sometimes extend them. The generator should optimize for readability, not just compiler acceptance.

### 5. Regeneration must be safe by default

The current `overwrite = false` setting avoids destructive rewrites, but it also leaves stale files behind. The replacement should move from "do not overwrite" to "overwrite only generator-owned output, preserve authored overlays, and report drift clearly."

## Target Architecture

## High-Level Pipeline

The future pipeline should be:

1. Source scan
2. Macro detection
3. Test catalog build
4. Scenario planning
5. Capability and status annotation
6. Haxe emission
7. Formatting
8. Runner and manifest emission
9. Validation and drift report

Recommended internal split under `tests/generator`:

- `detect/`
  - macro scanners that inspect modules, fields, signatures, metadata, abstracts, and constructor surfaces
- `model/`
  - typed intermediate representation for suites, cases, requirements, provenance, and statuses
- `plan/`
  - scenario expansion, value providers, assertion planners, and skip planners
- `emit/`
  - Haxe source emission, import sorting, formatting, and runner generation
- `catalog/`
  - manifest serialization and drift detection
- `support/`
  - generated shared helpers for fixtures, factories, custom assertions, and runner metadata

The current duplicated behavior in `BuildMacro.hx` and `UtestGenerator.hx` should be collapsed into one orchestrator that owns the whole pipeline.

## Detection Model

`MacroDetector` should evolve from a thin callable extractor into a richer metadata collector.

It should capture at least:

- fully qualified source path
- package and module
- class or abstract kind
- static versus instance member
- constructor requirements
- parameter names, types, optionality, nullability, default values when available
- return type
- visibility
- existing source metadata that should affect testing
- hints about mutability, purity, async behavior, fixture requirements, or known special handling

The detector should stop reducing everything to stringly-typed values too early. Prefer typed metadata and only convert to emitted Haxe expressions at the final emission stage.

## Scenario Planner

The planner is the missing middle layer in the current design.

Instead of producing one default invocation per member, it should select one or more scenarios using ordered rules.

Priority order:

1. Explicit source metadata on the target API.
2. Explicit test-spec overlay files for that API.
3. Type-based provider registry.
4. Domain heuristics for known Vision concepts.
5. Generic fallback smoke scenario.

Each scenario should carry:

- stable case id
- display name
- suite kind
- input strategy
- expected assertion strategy
- provenance
- lifecycle status
- capability requirements
- target skip rules
- fixture ids if applicable

## Value Providers

The current `getDefaultForType()` should be replaced with a provider system.

Provider layers should be:

### Layer 1: Explicit overrides

Source metadata or sidecar specs should be able to say exactly which values to use.

Examples:

- use a gradient image
- use a degenerate line
- use an odd-sized matrix
- expect this call to throw

### Layer 2: Type providers

Core type providers should exist for common Haxe and Vision types.

Examples:

- numeric: `0`, `1`, `-1`, min/max-safe boundary values, fractional values
- array: empty, single-element, already sorted, reverse sorted, duplicates
- string: empty, ascii, unicode-safe sample if needed, long sample
- function: deterministic stub functions with named behavior
- nullable: both `null` and non-null paths when allowed
- image: blank, black, gradient, checkerboard, alpha-heavy, odd-dimension, tiny image, large-ish image
- geometry: aligned points, diagonal points, degenerate lines, edge-touching rectangles
- kernels and matrices: identity, zero, small blur, asymmetric values, odd/even dimensions where relevant

### Layer 3: Domain heuristics

Known API families should get specialized planners.

Examples:

- image transforms: identity-like invariants, output dimensions, alpha preservation expectations
- serializers and parsers: round-trip tests, invalid input tests, format detection tests
- sort and collection helpers: ordering, stability where promised, empty input, duplicate input
- color conversions: channel range preservation, reversible paths where expected
- geometry: symmetry, distance invariants, containment edges, transformation consistency

### Layer 4: Combination control

More scenarios per function is useful only if explosion is controlled.

Use bounded strategies such as:

- curated scenario packs per API family
- pairwise combinations instead of full Cartesian products
- explicit max-scenario budgets per method
- a smoke-only fallback for low-signal members

## Assertion Planning

The generator should move away from "call method, assert not null."

Assertion strategies should be selected per scenario.

Suggested maturity levels:

- `smoke`
  - method runs without throwing or returns a non-null value
- `structural`
  - shape and invariants such as length, width, height, type, sort order, monotonicity, or bounds
- `semantic`
  - concrete expected values or invariants that describe actual behavior
- `golden`
  - fixture-backed image or serialized-output comparison
- `regression`
  - targeted reproduction for a known bug or past failure mode
- `metamorphic`
  - property-based or relation-based checks such as idempotence, reversibility, or preservation under transformation

The planner should be able to say: this method gets one smoke case, two structural cases, and one semantic case, instead of emitting four copies of the same low-value assertion.

## Generated Test Structure

Generated tests should be easier to read and easier to diff.

Recommended shape:

1. Stable imports, sorted deterministically.
2. Small suite-level metadata block.
3. Shared helper access through support modules, not repeated boilerplate in every file.
4. One method per scenario, named `test_<member>__<scenario>()`.
5. Clear arrange, act, assert sections.
6. Minimal inline comments only when the behavior is not obvious.
7. No repeated local helper code when a shared support helper can carry it.

Useful support modules to generate or hand-maintain:

- `tests.support.Factories`
- `tests.support.Fixtures`
- `tests.support.Assertions`
- `tests.support.Targets`
- `tests.support.Metadata`

The current repeated `gradientImage` boilerplate in many generated files should be replaced with shared fixture helpers.

## Provenance And Status Model

This should be first-class and queryable.

Recommended authored metadata fields:

- `provenance`
  - `generated`
  - `generated_augmented`
  - `manual`
  - `legacy_mixed`
- `maturity`
  - `smoke`
  - `structural`
  - `semantic`
  - `golden`
  - `regression`
  - `metamorphic`
- `lifecycle`
  - `active`
  - `draft`
  - `quarantined`
  - `deprecated`
  - `obsolete`
- `requirements`
  - `network`
  - `filesystem`
  - `golden_fixture`
  - `display_context`
  - `format_library`
  - others as needed
- `skipPolicy`
  - per-target ignores and reasons

Recommended observed metadata fields, stored outside authored source:

- last pass/fail result
- flaky signal
- last updated generator version
- signature hash of the source member
- last reviewed timestamp

## Where The Metadata Should Live

Use two layers:

1. A generated manifest file as the canonical source of truth.
2. Lightweight Haxe metadata on emitted test classes and methods for IDE visibility and compile-time filtering.

Example manifest entry:

```json
{
  "id": "vision.Vision.combine#identity",
  "source": "vision.Vision.combine",
  "suite": "VisionTest",
  "provenance": "generated_augmented",
  "maturity": "golden",
  "lifecycle": "active",
  "requirements": ["network", "golden_fixture"],
  "targets": {
    "skip": ["cs"],
    "reasons": {
      "cs": "golden tests disabled in CI"
    }
  },
  "generatorVersion": 2,
  "signatureHash": "..."
}
```

Example emitted Haxe metadata:

```haxe
@:visionTestId("vision.Vision.combine#identity")
@:visionProvenance("generated_augmented")
@:visionMaturity("golden")
@:visionLifecycle("active")
@:visionRequires("network", "golden_fixture")
```

## Ownership And File Layout

The current system mixes generated and hand-edited tests in the same directory tree. That should end.

Recommended steady-state layout:

```text
tests/
  README.md
  ROADMAP.md
  config.json
  generator/
  catalog/
    test-manifest.json
    test-health.json
  support/
    src/tests/support/
  generated/
    src/tests/auto/
    src/tests/legacy/
  authored/
    src/tests/augmented/
    src/tests/manual/
```

Meaning:

- `generated/src/tests/auto`
  - generator-owned output, safe to rewrite completely
- `generated/src/tests/legacy`
  - temporary landing zone for not-yet-migrated mixed files
- `authored/src/tests/augmented`
  - user-owned overlays that extend or supplement generated suites
- `authored/src/tests/manual`
  - fully manual tests that should never be rewritten

The runner should consume the manifest and load all active suites regardless of origin.

## Macro Annotations To Add

The next system should let source code opt in to more meaningful test generation.

Tentative metadata to support:

- `@:visionTestIgnore("reason")`
- `@:visionTestStatus("draft")`
- `@:visionTestProvider("image:gradient")`
- `@:visionTestScenario("identity")`
- `@:visionTestGolden("combine.identity")`
- `@:visionTestThrows("vision.exceptions.Unimplemented")`
- `@:visionTestTargets(skip = ["lua", "cs"])`
- `@:visionTestAugmentable`

The exact names can change, but the concept matters: explicit metadata should beat heuristics.

## Runner And CI Improvements

The runner should stop being a hand-maintained list of test classes.

It should be generated from the manifest and support filtering by:

- suite name
- source class
- source member
- provenance
- maturity
- lifecycle
- capability requirements
- target

Examples:

- run only `manual` or `generated_augmented` tests
- run only `golden` tests
- run only `regression` tests
- skip anything requiring network
- run tests for one source class while iterating

CI should also gain:

- regeneration check to ensure committed generated output matches the generator
- manifest drift check when source signatures change
- optional catalog report of APIs that only have smoke coverage
- stable seed enforcement for deterministic generators and fuzz-like scenarios

## Fixture Strategy

`FixtureManager` should become part of the planned system, not a side utility.

Plan:

1. Treat golden fixtures as just another scenario kind.
2. Assign stable fixture ids from scenario ids.
3. Store fixture metadata in the test manifest.
4. Generate fixture-aware assertions automatically.
5. Separate fixture creation, fixture update, and fixture verification commands.

This avoids embedding fixture policy only in manual tests like the current `VisionTest` golden cases.

## Migration Plan

## Phase 0: Inventory And Freeze

Goal: understand current ownership before changing code generation.

Deliverables:

- create the roadmap and agree on the status model
- generate an inventory of all current suites under `tests/generated/src/tests`
- classify them as `legacy_mixed` initially
- identify which files are largely scaffolded and which are heavily hand-authored
- add a generator version stamp to future emitted files

Acceptance criteria:

- every current suite is cataloged
- every suite has an initial provenance classification
- no behavior changes to test execution yet

## Phase 1: Unify The Generator Core

Goal: remove duplicated generation logic.

Deliverables:

- replace `BuildMacro` and `UtestGenerator` duplication with one orchestration path
- introduce a typed intermediate model for detected members and planned scenarios
- keep emitted output close to the current shape at first to reduce migration risk
- make runner generation come from the same source of truth

Acceptance criteria:

- one generator path owns detection and emission
- `tests/config.json` points to one authoritative flow
- runner generation is no longer split between `Main` and `TestMain`

## Phase 2: Introduce Scenario Planning And Providers

Goal: generate more than one useful case per member.

Deliverables:

- provider registry for common types
- domain planners for images, geometry, collections, and serializers
- scenario budgeting to prevent explosion
- structured assertion strategies by maturity level

Acceptance criteria:

- at least the highest-value API families emit multiple scenario types
- generated tests are no longer dominated by `Assert.notNull(result)`
- case ids are stable across regenerations

## Phase 3: Add Provenance, Status, And Capability Metadata

Goal: make ownership and execution policy explicit.

Deliverables:

- manifest with provenance, maturity, lifecycle, requirements, and target skips
- emitted Haxe metadata mirroring the key fields
- runner filtering based on manifest metadata
- reporting that distinguishes authored intent from observed health

Acceptance criteria:

- every emitted case has a stable id and metadata
- the runner can filter by metadata without hand-maintained code
- skip reasons are structured rather than scattered ad hoc

## Phase 4: Split Generator-Owned And Authored Code

Goal: make regeneration safe.

Deliverables:

- introduce separate generated and authored directories
- move heavily manual suites such as golden or regression-heavy cases out of generator-owned output
- support augmentation overlays or companion suites
- mark untouched old files as `legacy_mixed` until migrated

Acceptance criteria:

- generator rewrites only generator-owned files
- manual and augmented tests survive regeneration untouched
- the runner still compiles and discovers all active suites

## Phase 5: Migrate High-Value Existing Tests

Goal: preserve the value already in the repository.

Priority targets:

- `VisionTest`
- file/byte format tests
- tests with target-specific `@Ignored` logic
- suites that currently have meaningful semantic assertions beyond smoke checks

Deliverables:

- move golden tests to explicit `golden` scenarios or manual suites with manifest entries
- convert current invalid-test macros into structured capability and lifecycle metadata
- extract common assertion helpers and fixture helpers from repeated manual logic

Acceptance criteria:

- migrated suites no longer rely on undocumented special cases
- fixture and skip behavior is represented in the new catalog

## Phase 6: Add Governance And Quality Gates

Goal: stop the system from drifting again.

Deliverables:

- CI regeneration check
- CI manifest drift check
- smoke-versus-semantic coverage report
- stale legacy-suite report
- formatting step for generated output

Acceptance criteria:

- generator changes cannot silently leave committed output stale
- maintainers can see which APIs still only have smoke coverage
- generated code remains stable and readable between runs

## Useful Additions Not Explicitly Requested

These are worth adding because they make the system easier to maintain.

### 1. Test catalog report

Produce a machine-readable and human-readable report showing:

- which public members have no tests
- which only have smoke tests
- which have golden or regression coverage
- which are skipped on some targets and why

### 2. Deterministic seed policy

Any random or pseudo-random scenario generation should use stable seeds and persist them in the manifest.

### 3. Signature drift detection

If a source method signature changes, the catalog should detect that and mark related cases for regeneration or review.

### 4. Legacy quarantine support

During migration, allow legacy suites to remain runnable but mark them clearly so they do not look like first-class generated output.

### 5. Formatter integration

Generated code should be formatted deterministically after emission. Readability will improve immediately if emission is followed by a consistent formatting step instead of ad hoc string assembly.

### 6. Support-library extraction

Common helpers such as image factories, custom assertions, and target capability checks should move into shared support code rather than being emitted into every suite.

### 7. Optional performance-regression track

Once the catalog exists, it becomes much easier to attach benchmark or performance-regression cases to selected algorithms without mixing them into normal unit suites.

## Recommended First Implementation Slice

The smallest high-value sequence is:

1. Unify `BuildMacro` and `UtestGenerator` behind one orchestration path.
2. Introduce a typed `TestCase` model and manifest emission, even if the first emitted cases are still mostly smoke tests.
3. Add provenance and maturity metadata to every generated case.
4. Replace repeated per-file fixture boilerplate with shared support helpers.
5. Add two or three real provider families:
   - images
   - arrays and collections
   - numeric and geometry values
6. Move one high-value suite through the full new flow as a pilot, likely `VisionTest` or one smaller image-processing suite.

This sequence creates the structural foundation before trying to fully solve semantic test generation.

## Success Criteria

The redesign is working when the following statements become true.

- There is only one generator path.
- Every generated case has a stable id and explicit provenance.
- Regeneration does not threaten hand-authored tests.
- The runner does not rely on a manually curated class list.
- The catalog can answer which APIs have only smoke coverage.
- Generated tests are readable enough that developers are willing to debug them directly.
- Adding a new domain-specific scenario provider is localized and does not require editing the whole generator.

## Anti-Goals

The redesign should avoid these traps.

- Do not try to infer every meaningful assertion from type signatures alone.
- Do not generate full Cartesian products of all input values.
- Do not keep manual and generated ownership mixed once migration starts.
- Do not overload a single `status` flag with provenance, runtime health, and lifecycle meaning.
- Do not make the new system depend on fragile string templates as its only representation.

## Short Version

The next test system should be a catalog-driven macro pipeline:

- detect source members into a typed model
- plan multiple scenarios per member using providers and metadata
- emit readable generator-owned suites
- keep manual and augmented code separate
- attach explicit provenance and lifecycle metadata
- drive the runner and CI from the generated manifest

That is the shortest path from the current scaffold generator to a system that can safely auto-generate meaningful tests and still stay friendly to manual development.