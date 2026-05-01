# Plan: Manual Utest Migration — Step 7: Decommission The Auto System And Finalize Coverage

> **Status**: 🔲 Not started
> **Prerequisite**: [manual-utest-migration-6-formats-and-facade.md](manual-utest-migration-6-formats-and-facade.md)
> **Next**: None — this is the final step.
> **Parent**: [manual-utest-migration-overview.md](manual-utest-migration-overview.md)

## TL;DR

Once the authored suite is in place and the coverage inventory is current, remove the old generator and generated tree, rewrite stale docs, and prove that the repository no longer depends on auto-generated tests. The final result should be a normal manual `utest` suite with explicit coverage accounting.

## Reference Pattern

In [../../tests/compile.hxml](../../tests/compile.hxml):
- This is the compile-time generator entrypoint that should disappear once the manual suite is authoritative.

In [../../tests/generator/GeneratorCore.hx](../../tests/generator/GeneratorCore.hx):
- This is the old auto system being retired; use it only as a deletion target in this step, not as a pattern to preserve.

In [../../tests/ROADMAP.md](../../tests/ROADMAP.md):
- Replace generator-forward documentation with a manual-suite workflow description.

In [../../tests/REGENERATION_EXECUTION_PLAN.md](../../tests/REGENERATION_EXECUTION_PLAN.md):
- Remove or archive generator-centric execution guidance that no longer matches repository reality.

## Steps

### 1. Delete the old auto system

Remove the generator and generated-source tree once all default entrypoints and coverage tracking point at the authored suite:

- `tests/generator/**`
- `tests/generated/**`
- `tests/config.json`
- `tests/compile.hxml`
- any generator-only catalog or report artifacts that no longer serve the manual suite

Keep the manual inventory and any still-useful support files under the new `tests/src` ownership model.

### 2. Rewrite and prune docs

Update the repository docs so they describe the manual suite accurately:

- `tests/README.md`
- root `README.md` if it references the test system
- `.vscode` usage notes if needed

Delete or archive outdated generator plans and regeneration instructions if they no longer reflect the chosen direction.

### 3. Finish the coverage sweep

Use `tests/catalog/manual-test-inventory.json` to add any remaining small suites, especially trivial modules that were postponed during the batch rewrites. Every class and public member in scope should now be either:

- covered by a manual suite, or
- explicitly excluded with a documented reason

### 4. Run final validation against the manual tree

Run the root test command, a suite-filtered run, a case-filtered run, and at least one compiled-target CI harness command so the manual system is proven end-to-end.

## Verification

- No remaining default command, workflow, or VS Code setting references `tests/generated`, `tests/generator`, `BuildMacro.generateAll()`, or `tests/compile.hxml`.
- `haxe test.hxml` passes.
- A filtered run such as `haxe test.hxml -- --tests ArrayToolsTest --cases test_flatten__empty` succeeds.
- `haxe tests/ci/local-ci.hxml -- --targets=interp,js --compile-only --skip-install` succeeds against `tests/src`.
- `tests/catalog/manual-test-inventory.json` shows every in-scope module as covered or explicitly excluded.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-utest-migration`
- **Evidence to preserve** — Final inventory snapshot, proof that generator entrypoints are gone, and one full plus two filtered validation commands.
- **Review focus** — Verify that deletion happens only after the manual tree is authoritative and that no stale generator references remain in docs or CI.
- **Commit guidance** — Keep generator deletion and docs cleanup together in the final commit so the repository history has one clear cutover point.