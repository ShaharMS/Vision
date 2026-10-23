# Plan: Seam carving — Step 5: release-readiness



> Status: Not started

> Parent: [overview](seam-carving-overview.md)

> Prerequisite: Step 4

> Next: None



## TL;DR



Reconcile 2.2.0 notes, run full tests/compile and inspect remote CI, packaging and remaining release gaps.



## Iteration Bootstrap



- Iteration slug: seam-carving

- Required evidence: verification results recorded in plan

- Artifacts to verify: source, tests, documentation assets



## Reference Pattern



`CHANGELOG.md`



## Steps



### 1. Implement scoped outcome



Reconcile 2.2.0 notes, run full tests/compile and inspect remote CI, packaging and remaining release gaps.



### 2. Verify and record evidence



Commit this completed step and push.



## Verification



Full behavioral suite, compile, remote CI and package audit



## Findings resolved



- Updated 2.2.0 changelog and stale manifest blurb.

- Removed unused runtime utest dependency; extracted package compiles independently.

- Replaced destructive, immediate-submit packaging with a package-only builder preserving earlier ZIPs.

- Fixed false-green Node tests, runtime dispatch, and Neko dead-code elimination (separate follow-up commits).

- Confirmed hosted generated PNG bytes and final browser rendering.



## Local evidence



- Full interp: 615 tests pass.

- Full Node JS: 615 tests pass.

- Eight Neko batches pass; six seam tests included in batch 1.

- Intentional failing Node reporter probe exits 1.

- haxe compile.hxml passes.

- Package-only ZIP: 112 entries; includes SeamCarving, source and metadata, excludes test and agent trees.

- Extracted package carve smoke passes on interp and JS without utest.

- Entire extracted vision package compiles to JS without utest.



## Integration boundary



Existing PR #53 carries Hough/Harris toward dev. Seam-carving work is based on that branch; integration will be a stacked PR into feature/hough-harris-feature-detection. No Haxelib submission or release tag is created by this work.


## Additional audit evidence

- Quiet mode plus large image headers: 8 focused regressions pass, including six seam cases.
- Latest default full interp and Node suites each pass 615 tests.
- Neko batches cover 389 methods across eight batches; intentional pre-existing suite exclusions remain documented in the registry.
- Final package smoke passes on interp, JS and Neko (`-dce full`) without utest.
- Reviewed open issues: #2 and #45 are implemented by the pending Hough/Harris integration; #49's optional native JPEG/WebP extensions and #46/#47 remain enhancement backlog, not promised release scope.
- No in-flight iteration ledgers or other active feature plans were present before this work.
- Draft stacked PR: https://github.com/ShaharMS/Vision/pull/54 (base feature/hough-harris-feature-detection, feeding #53 -> dev).
- Current release candidate: `release/vision-2.2.0-20261023-220214-569.zip`, SHA256 `77a373171fedb70247a1fcfa7e0caaaa07ff1dc34eafd062829ecff2536bc590`.

## Release status: NOT READY - one remaining runtime blocker

- Source f10a140: all six standalone seam tests pass on cppia (run 40012133065). Other eleven target jobs passed on this change set; full interp/Node suites each have 615 methods.
- Broad cppia remains red: existing Gaussian tests fail, then the runtime segfaults after Cramer duplicate validation (exit 139). Failed no-inline/JIT experiments were reverted; no exclusions were added.
- Fixed CI bootstrap itself: hxcpp.n is compiled explicitly, worker count is bounded, and runtime/job timeouts prevent indefinite provisioning. Minimal Mono provisioning has passed C# tests.
- Native JPEG/WebP etc. are documented enhancement backlog. CPPia full-suite failure is the only confirmed release-blocking item from this audit.
- PR #54 remains draft. Integrate into #53's branch only after review; no release tag or Haxelib submission has been performed.
- Completed implementation steps remain beside the active audit plan for coherent resume; do not archive the overview as all-complete while the release blocker is open.

Resume pointers: .cursor/plans/seam-carving-5g-cppia-runtime.md; https://github.com/ShaharMS/Vision/actions/runs/40012133065; https://github.com/ShaharMS/Vision/pull/54.
