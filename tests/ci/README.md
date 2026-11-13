# Local CI Runner

Run the same compile/run workflow as CI locally.

## Usage

From repo root:

- Run all targets:

  haxe tests/ci/local-ci.hxml --

- Run specific targets:

  haxe tests/ci/local-ci.hxml -- --targets=interp,js,neko

- If your Haxe build doesn't accept `--` with `--interp`, you can use env vars instead:

  set VISION_CI_TARGETS=php
  haxe tests/ci/local-ci.hxml

- Compile only:

  haxe tests/ci/local-ci.hxml -- --compile-only

- Run only (assumes outputs already built):

  haxe tests/ci/local-ci.hxml -- --run-only

- Skip haxelib installs:

  haxe tests/ci/local-ci.hxml -- --skip-install

## Notes

- Java/JVM compile uses --no-inline by default to avoid method-size overflow.
- Java/JVM: VisionTest.test_limitColorRanges is skipped because it hits the JVM 64k method size limit even with no-inline.
- Local CI adds -D no-deprecation-warnings to reduce noise from deprecated APIs.
- The runner uses system tools (node, java, python, php, lua, mono, etc.). Ensure they are installed and on PATH.
- PHP runs with mbstring enabled by default. You can set VISION_PHP_EXT_DIR to the extension directory or set VISION_PHP_DISABLE_MBSTRING=1 to skip.
- JavaScript runs under Node with `hxnodejs`; its test reporter returns a nonzero process exit status on failure. Browser demos still compile with `haxe compile.hxml`.
- Lua requires its native dependencies (`rex_pcre2`, `luv`, `bit`/`bit32`, and sockets as applicable). CI installs these modules; PNG export uses stored DEFLATE blocks on Lua.
- Neko batches use `-dce full` so unreachable image methods cannot exceed the VM function-scope limit. Seam tests execute in batch 1.
- The interpreter job also exercises `vision_quiet` with `vision_higher_width_cap` using focused seam, malformed-format and fractional-matrix regressions.

## cppia host configuration

Use the pinned, patched interpreter host described in [cppia/README.md](cppia/README.md). The unpatched released host fails generic-array and matrix tests. GitHub CI builds the patched host; the local runner prefers the active haxelib checkout's host (including Linux64/Cppia) over an unrelated PATH executable. JIT mode is not qualified.

## Browser drawing

Run `haxe tests/ci/drawing.hxml` and open [drawing.html](drawing.html) in a browser with WebGL 2. The page reports `data-result="pass"` after the Canvas 2D, WebGL 2, attachment, readback, and compatibility checks. The separate `data-webgpu` result reports whether the compute path ran.

## Windows drawing

Install hxcpp and utest in the active haxelib repository. Build from the repository root with the Microsoft C++ toolchain available.

```powershell
haxe -cp src -cp tests/src -lib utest -main Main --cpp bin/native-drawing/cpp -D windows -D HXCPP_M64
$env:VISION_TESTS = 'ScreenTest'
./bin/native-drawing/cpp/Main.exe
```

The test uses a hidden window and checks composited pixels, presentation, and frame timing.

## Image operation benchmarks

Compile `ImageOperationBenchmark` with `-cp src -cp tests/ci -lib format
-main ImageOperationBenchmark -dce full` and use either `-cpp <directory>` or
`-js <file>`. Load the JavaScript output from a local browser page. Both
targets report median and maximum of five timed runs and a SHA-256 digest
of the output. The resize timings include cloning. Compare matching output
digests on each target before interpreting timing differences.

Compile `BrowserImageBatchBenchmark` using the same options, with
`-main BrowserImageBatchBenchmark` and the JavaScript target. It compares
processing on the CPU followed by WebGL drawing against processing and
drawing on the GPU. A separate measurement includes a GPU readback. The
benchmark waits for GL completion and checks residency, readback count,
and per-channel differences.

On Windows hxcpp and Edge on Intel Arc, the 384 × 384 synthetic fixture
produced these median results. The baseline contains the two changes to
float validation needed for the hxcpp build.

- Bilinear upscale to 576 × 576 took 2451.13 → 12.20 ms on hxcpp and 3730.80 → 11.80 ms in Edge CPU.
- 5 × 5 Gaussian convolution took 1794.33 → 20.45 ms on hxcpp and 3265.10 → 31.60 ms in Edge CPU.
- Non-local means with search radius 2 took 2911.82 → 1363.32 ms on hxcpp and 6821.30 → 1876.70 ms in Edge CPU.
- Resize to 256 × 256, convolve, fill, and draw took 23.4 ms using CPU processing and 4.0 ms using the GPU batch. Including a GPU export took 8.0 ms. Exported pixels matched exactly on this fixture.

All eight paired CPU workloads produced identical digests on each target.
These are local measurements from synthetic inputs.

## Windows D3D11 benchmark and live demo

From an x64 Visual Studio Developer Command Prompt:

```powershell
haxe -cp src -cp tests/ci -lib format -main WindowsD3D11Benchmark -D windows -D HXCPP_M64 -dce full -cpp bin/d3d11
./bin/d3d11/WindowsD3D11Benchmark.exe
./bin/d3d11/WindowsD3D11Benchmark.exe --demo
```

The demo opens a visible `Screen`, animates two shapes, and submits rectangle
fills, bilinear resize, and Gaussian convolution on the same device every
frame. Close the window to exit. The benchmark runs the same workload against
the optimized packed-pixel reference, checks screen capture and GPU residency,
and reports median milliseconds over ten measured frames after a warm-up.
An event query synchronizes timings with the GPU. Processing, presentation,
and processing with export are timed separately.

On this Windows machine, the 320 × 192 input and 800 × 480 output took
65.29 ms for CPU processing, 2.90 ms for D3D11 processing, 3.01 ms for D3D11
processing and presentation, and 4.45 ms for D3D11 processing and export.
The exported result matched the CPU reference exactly. The benchmark
observed zero readbacks through draw and one readback per exported image.

## Browser WebGPU batch benchmark

Compile `WebGpuBatchBenchmark` with `-cp src -cp tests/ci -lib format
-main WebGpuBatchBenchmark -dce full -js <file>`. Serve a page loading the
compiled script over localhost or HTTPS. The page reports JSON after testing
a 640 × 480 image resized to 480 × 360, convolved with a 5 × 5 kernel, and
marked with a rectangle. CPU and WebGPU timings include export, and the
WebGPU timing includes one upload and one readback. The benchmark checks
all output channels against the CPU reference and reports the median of
seven measured runs per path.

On the Windows Edge test host, CPU execution took 56.0 ms and WebGPU
execution took 9.8 ms. The maximum channel difference was 1. Adapter and
pipeline setup took 1066.3 ms and was measured separately.

The resident WebGPU variant attaches the source to a WebGPU `Screen`,
calls `commit()`, draws the result, and waits for queue completion before
stopping the timer. It then downloads and checks the output separately.
On the Windows Edge test host, CPU processing and export took 44.0 ms,
and WebGPU processing and presentation took 6.0 ms. These measure distinct
output boundaries. The downloaded result differed by at most one channel
value, and the device reported no validation error.
