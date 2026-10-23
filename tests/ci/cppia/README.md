# Qualified cppia interpreter host

Vision's cppia tests use Haxe 4.3.7 and hxcpp commit `ceb70d040f0792f004ccf1ed7eb6fcea01d7f3ff` plus `hxcpp-array-compat.patch`. The unpatched host fails the behavioral suite. These are interpreter compatibility fixes; JIT mode is not release-qualified and has separate upstream defects.

The patch fixes interpreted dynamic-array resize and fractional reads, normalizes typed/generic array receivers through hxcpp's native array conversion, and reads native/generic array lengths safely. Resized generic arrays can contain placeholder null slots, so their public length must be used rather than their storage-kind flag. No Vision algorithms or test expectations are changed.

## Build directly

With Haxe 4.3.7, Git, Bash and a C++ toolchain installed:

```sh
bash tests/ci/cppia/build-host.sh
```

In the release ZIP the same helper is at `cppia/build-host.sh`. The helper installs the exact hxcpp Git revision in the active haxelib repository, checks patch applicability, bootstraps hxcpp.n, and builds the host with four workers by default. Use an isolated haxelib repository when another project requires a different hxcpp version. `--use-existing` reuses an already registered checkout of that exact revision; applying the patch is idempotent.

Run scripts with the built `bin/Linux64/Cppia` executable on Linux x86-64. Do not enable `-jit`. The CI workflow demonstrates the standalone seam check and full suite invocation.

## Reproduce in Docker

From the Vision repository root in PowerShell:

```powershell
docker build -t vision-cppia:2.2.0 tests/ci/cppia
docker run --rm --mount "type=bind,source=$((Get-Location).Path),target=/work" vision-cppia:2.2.0 haxe --class-path tests/src --main Main --library vision --library format --library utest --cppia bin/cppia/tests.cppia
docker run --rm --mount "type=bind,source=$((Get-Location).Path),target=/work" vision-cppia:2.2.0 /haxelib/hxcpp/git/bin/Linux64/Cppia bin/cppia/tests.cppia
```

Retain the baseline and a few verified candidates, rather than keeping a permanent Docker image for every diagnostic pass. Preserve the build cache and logs.

## Regression coverage

The full suite retains Gaussian normalization, zero-fill, Hough accumulator, and Cramer checks. Additional tests cover dynamic buffer growth/shrinkage, fractional grid sums, nested float-row length/pop/shift, and recursive 4x4 determinants. Baseline and patched runtimes are compared using the identical compiled test module.

The hxcpp source retains its upstream MIT license. The compatibility patch is maintained here against an immutable revision; remove or replace it only after verifying a newer host against the complete suite.
