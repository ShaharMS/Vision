# Plan: Release audit - cppia runtime repair

> Status: ✅ Completed
> Parent: [overview](seam-carving-overview.md)

## TL;DR

Resolved the cppia release blocker with a versioned compatibility patch to the pinned hxcpp interpreter host. The Vision algorithms and original assertions remain unchanged. All 619 tests pass on the repaired host; all twelve GitHub target jobs pass.

## Reference Pattern

Existing cppia host build in .github/workflows/main.yml and the native array conversion helpers in pinned hxcpp ceb70d040f0792f004ccf1ed7eb6fcea01d7f3ff.

## Completed steps

1. Reproduced the baseline in an isolated Haxe 4.3.7 Linux Docker image. Direct Gaussian computation produced NaNs; a three-variable determinant crashed independently of utest.
2. Reduced host defects: interpreted dynamic resize was absent; dynamic float reads passed through integer conversion; typed/generic array receivers were reinterpreted without conversion; array lengths used incompatible layouts. Placeholder-array public lengths also had to be preserved after resize.
3. Added four regressions to the existing Array2DTest and Matrix2DTest suites. The baseline fails the dynamic-buffer regression; existing Gaussian, zero-fill and Cramer checks exercise the other defects.
4. Added tests/ci/cppia/hxcpp-array-compat.patch, an immutable pin, idempotent build-host.sh, and a reproducible Dockerfile. The helper verifies revision and applicability, bootstraps hxcpp.n noninteractively, and bounds compilation to four workers by default.
5. Updated GitHub CI and local host selection. The local runner prefers the active checkout's OS-specific executable. Release ZIPs include the same patch/helper under cppia/.
6. Verified all 619 tests on the fresh Docker host through the actual local CI runner, and verified the complete remote matrix.

## Verification evidence

- GitHub run https://github.com/ShaharMS/Vision/actions/runs/40021942920: all twelve targets pass at source 50e8bf98582aee39e26b9ccef1a92c2952e11205.
- Local interpreter: 619 methods pass; Node: 619 methods pass; cppia: 619 methods pass.
- Baseline and repaired hosts use the identical compiled module. Baseline regression exit 1; repaired full suite exit 0.
- Fresh Docker build from committed tools: vision-cppia:2.2.0-candidate (3b2f2d603380); full local runner succeeds. Packaged helper detects an already applied patch and rebuilds successfully.
- Workflow shell syntax checked with bash -n; library JS compile passes. ZIP helper and patch bytes match the committed source.

## Qualified configuration and scope

Haxe 4.3.7 with hxcpp ceb70d040f0792f004ccf1ed7eb6fcea01d7f3ff plus the versioned compatibility patch, running in interpreted mode on Linux x86-64. The unpatched host is not claimed to pass. JIT has separate known upstream issues and is not qualified. Global no-inline, broad generic dispatch, constructor/setter experiments and Vision algorithm workarounds were not retained.

Earlier diagnostics are retained under ignored bin/cppia-lab/. Relevant upstream background: https://github.com/HaxeFoundation/hxcpp/issues/1365 and https://github.com/HaxeFoundation/hxcpp/pull/1369. No upstream submission was performed.

## Docker retention

Retained three task-owned versions: baseline ec453a30cbf0 (A/B failure reference), locally verified length-fix-candidate 57cddb802ced, and reproducible 2.2.0-candidate 3b2f2d603380. Obsolete trial tags were removed after container-reference checks, without force. Cache, logs, exports and other projects' images were preserved. The diagnostic container vision-cppia-debug is stopped and retained. No requested image cleanup is blocked.
