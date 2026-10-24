# Plan: Seam carving - Step 5: release readiness

> Status: ✅ Completed
> Parent: [overview](seam-carving-overview.md)

## TL;DR

Release qualification is complete for the documented target configurations. The cppia blocker is resolved by the pinned host compatibility patch, and all twelve target jobs pass.

## Reference Pattern

CHANGELOG.md, haxelib.json, tests/ci, and existing Haxe behavioral suites.

## Completed work

1. Reconciled 2.2.0 notes against history and removed the stale 2.1.0 package blurb.
2. Removed the unused runtime dependency on utest.
3. Added package-only building that preserves previous candidates and requires explicit submission.
4. Fixed Node false-green reporting, Node exception/browser compatibility and JavaScript job callbacks.
5. Verified all eight Neko batches with full DCE; verified quiet-mode compilation and focused regressions.
6. Fixed noninteractive hxcpp bootstrap, bounded runtime setup, and reduced Mono provisioning to necessary components.
7. Repaired cppia through the pinned host patch, shipped build tooling, and verified all supported targets without new exclusions.

## Verification

- All twelve GitHub jobs pass: https://github.com/ShaharMS/Vision/actions/runs/40021942920 (source 50e8bf9).
- Interpreter, Node and patched cppia each pass all 619 test methods.
- Neko retains its documented existing suite partitioning/exclusions; new regressions remain registered.
- Quiet mode plus large headers: eight focused regressions pass.
- Library JS compile, intentional failing Node reporter probe, package standalone smoke checks and hosted-image verification pass.
- Fresh Docker host and local CI runner pass; the packaged host helper is idempotent.
- Final candidate: `release\vision-2.2.0-20261023-235228-172.zip`.
- SHA256: `7e9a609f1f4b5670fb81136dbb35e5f55de3ef69622631b75fc61b5087ea715a`.
- ZIP contains source, metadata and cppia build tools; excludes tests/agent state. Runtime helper bytes were verified.

## Integration and publishing

PR https://github.com/ShaharMS/Vision/pull/54 is stacked on feature/hough-harris-feature-detection, feeding existing PR #53 into dev. No Haxelib submission or release tag was created. Merge/release remain the user's release actions.

CPPia requires the documented patched interpreter host; JIT is outside the qualified configuration. Native JPEG/WebP and other optional enhancement issues remain backlog, not promises made by this change.
