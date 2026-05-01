# Implementation Handoff

## Current Pass

- Pass type: `review follow-up`
- Authoring agent: `@Implement`
- Plan step: `.github/plans/manual-utest-migration-1-cutover.md`
- Branch: `feature/manual-utest-migration-1-cutover`
- Summary: `Addressed RVW-003 by adding a checked-in manual inventory generator/validator, regenerating tests/catalog/manual-test-inventory.json from source declarations, and restoring the missing overload-heavy members in the ArrayTools and ImageTools entries.`

## Files Changed

| Path | Intent | Verification impact |
|------|--------|---------------------|
| `tests/generator/ManualInventoryBuilder.hx` | `Add a reproducible generator/validator that rebuilds the manual inventory from source declarations, preserves the existing step-1 ownership metadata, and fails when promoted test ids reference missing inventory members.` | `haxe manual-inventory.hxml and diagnostics` |
| `manual-inventory.hxml` | `Add a narrow repo-root entrypoint for regenerating and validating tests/catalog/manual-test-inventory.json.` | `haxe manual-inventory.hxml and diagnostics` |
| `tests/catalog/manual-test-inventory.json` | `Regenerate the checked-in inventory so overload-heavy APIs are no longer undercounted.` | `haxe manual-inventory.hxml, targeted spot-check, and diagnostics` |

## Verification

| Check | Method | Result | Evidence |
|-------|--------|--------|----------|
| `Manual inventory regeneration` | `haxe manual-inventory.hxml` | `passed` | `The new entrypoint regenerated tests/catalog/manual-test-inventory.json and completed the built-in validation that compares every inventory members list to the source scan and checks every @:visionTestId in tests/src against the inventory.` |
| `RVW-003 target spot-check` | `read_file on tests/catalog/manual-test-inventory.json` | `passed` | `vision.tools.ArrayTools now lists flatten, raise, min, max, average, median, distanceTo, flatMap, and distinct; vision.tools.ImageTools now lists defaultResizeAlgorithm, loadFromFile, saveToFile, loadFromBytes, loadFromURL, exportToBytes, exportToFile, addToScreen, getNeighborsOfPixel, getNeighborsOfPixelIter, grayscalePixel, new, next, and hasNext.` |
| `Diagnostics` | `get_errors on tests/generator/ManualInventoryBuilder.hx, manual-inventory.hxml, and tests/catalog/manual-test-inventory.json` | `passed` | `No errors reported for the new generator, the new hxml entrypoint, or the regenerated inventory file.` |

## Review Responses

| Finding ID | Disposition | Evidence | Notes |
|------------|-------------|----------|-------|
| `RVW-003` | `FIXED` | `tests/catalog/manual-test-inventory.json now includes the previously missing overload-heavy members for vision.tools.ArrayTools and vision.tools.ImageTools, and haxe manual-inventory.hxml fails if any promoted tests/src @:visionTestId references a member missing from the inventory.` | `The follow-up adds a reproducible regeneration path instead of hand-patching the cited JSON entries, so future inventory refreshes keep the same check.` |

## Risks And Follow-Ups

- `tests/generator/ManualInventoryBuilder.hx` preserves the current step-1 status, notes, and test-file ownership data from the checked-in inventory, so future step work can keep updating ownership semantics without changing the discovery path again.
- The generator intentionally scans single-line public declarations in source files; if later formatting changes split a public declaration across multiple lines, the inventory builder will need the same expansion.
- `tests/generated/**` and `tests/compile.hxml` remain in the repository intentionally as temporary reference material until later migration steps delete the old auto path.

## Pass History

| Pass | Commit | Summary |
|------|--------|---------|
| `1` | `9439dd742d49f6605b5d2f605431145141533250` | `Implemented step 1 cutover: promoted tests/src, repointed default entrypoints, added the manual inventory, and validated the authored root plus LocalCi fallback paths.` |
| `2` | `2c71242bfc6c849b5944a1c804e223c0bba6f39c` | `Addressed RVW-001 and RVW-002 by correcting the last stale README operational-path claims and converting PrettyReporter output to ASCII-safe literals, then reran haxe test.hxml plus targeted README/diagnostic checks.` |
| `3` | `this commit` | `Addressed RVW-003 by adding manual-inventory.hxml plus tests/generator/ManualInventoryBuilder.hx, regenerating tests/catalog/manual-test-inventory.json from source declarations, and validating the inventory against both the source scan and promoted test ids.` |
