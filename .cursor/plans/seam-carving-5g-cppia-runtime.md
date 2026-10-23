# Plan: Release audit - cppia runtime diagnosis

> Status: In progress
> Parent: [overview](seam-carving-overview.md)

## TL;DR

With bootstrap repaired, cppia exposes existing Gaussian failures and segfaults after Cramer duplicate handling. Verify seam tests independently and test a no-inline compilation configuration before claiming cppia readiness.

## Reference Pattern

Existing java/JVM no-inline configuration and cppia run command in .github/workflows/main.yml.

## Steps

### 1. Compile cppia without optional compiler inlining

Align local runner target settings with GitHub CI (java, JVM, cppia).

### 2. Run seam slice before broad suite

Run the six new seam cases in a separate process, then require the full suite to pass.

## Verification

Remote run 40010003388 exposed Gaussian failures and exit 139 after Cramer tests; no exclusions or assertion changes are used. The next remote result decides whether this is a usable configuration.

No-inline experiment failed before the first seam case with argument-count mismatch / hxSehException in run 40010722215. Reverted cppia no-inline. Next diagnostic uses the documented cpp.cppia.Host -jit option on the same pinned host; both focused and broad suites remain required.

JIT mode failed before test startup with Bad move target (40011376611). Reverted JIT selection. Added standalone SeamCarvingMain (only six seam tests, full DCE) to distinguish new API coverage from unrelated runtime failures in the broad module. Full cppia job remains required and failures are not suppressed.

## Confirmed result and remaining blocker

Run 40012133065 at source f10a140 confirms all six standalone SeamCarvingTest cases pass on cppia (including exhaustive minimum-energy comparison). The broad suite then repeats Gaussian failures and segfaults after Cramer duplicate validation (exit 139). The same existing cases fail without the standalone entrypoint in earlier runs.

Neither no-inline nor JIT is retained as a workaround. Default interpreted execution stays enabled and failing; no tests or targets are excluded. Related upstream reports: https://github.com/HaxeFoundation/hxcpp/issues/1365 and https://github.com/HaxeFoundation/hxcpp/pull/1369 (the latter describes the exact JIT Bad move target boot error).

The next step, if cppia remains supported for 2.2.0, is a minimal standalone reproduction of the existing Gaussian/Cramer runtime failures and an upstream host fix verified against the full suite. Do not claim the release matrix is green or mark the release ready until that passes. User was asked whether cppia remains release-blocking; absent a decision it remains blocking.

## Authorized continuation

User requested tackling the remaining blocker. Continue this active sub-plan rather than superseding it. Build one isolated Linux Docker cppia lab matching Haxe 4.3.7 and the pinned hxcpp host. First reduce generic-array/Gaussian/Cramer behavior; then implement a source or pinned-runtime fix with regressions, and verify the entire matrix without test exclusions.

Verification additions: local Linux full cppia suite, full interpreter suite, GitHub 12-target matrix. Retain at most a few Vision image versions and preserve diagnostics and cache; other projects' Docker images are out of scope.

## Local repair evidence

The Docker reproduction matches Haxe 4.3.7, format 3.8.0, utest 1.13.2, and hxcpp ceb70d040f0792f004ccf1ed7eb6fcea01d7f3ff. Baseline image: ec453a30cbf0. Focused reduction identified missing interpreted dynamic-array resize, fractional values truncated by ArrayBuiltinAny.runFloat, unsafe typed/generic array receiver casts, and incompatible length reads. No source-level algorithm workarounds are retained.

Patched interpreter candidate c118fed3eb55 and earlier partial candidates still failed zero fills. The final candidate (image tagged vision-cppia-lab:length-fix-candidate; exact digest recorded at closeout) corrects length handling for resized placeholder arrays as well. All 619 tests pass locally on the original Vision code, including four new runtime regressions.

This continuation uses separate commits for (1) runtime regressions, (2) pinned host patches/build and package integration, (3) final verification closeout. Global no-inline and JIT are not used, and no suite exclusions are added. Qualify interpreted cppia with the patched host; do not describe an unpatched released hxcpp host as passing.
