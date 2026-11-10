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

## Standalone native drawing

`vision.ds.Screen` is the same public API for browser JavaScript, Windows, Linux, and macOS. Desktop builds use `-D vision_native` and load the corresponding native library at runtime.

### Windows

Use a Windows x64 Native Tools prompt, hxcpp 4.3.2, HashLink 1.16, and optionally the MSVC x64 archive from [wgpu-native v29.0.1.1](https://github.com/gfx-rs/wgpu-native/releases/tag/v29.0.1.1). Run the commands from the repository root with the two variables pointing to the extracted SDK roots.

```powershell
./build-native-drawing.ps1 -HashLink $visionHashLink -Wgpu $visionWgpu
haxe -lib vision -cp tests/ci -main NativeDrawingTest --hl bin/native-drawing/test.hl -D vision_native -D hl-ver=1.16.0
haxe -lib vision -cp tests/ci -main NativeDrawingTest --cpp bin/native-drawing/cpp -D vision_native -D HXCPP_M64
Copy-Item bin/native-drawing/vision_native.ndll,bin/native-drawing/wgpu_native.dll bin/native-drawing/cpp
```

Run HashLink from `bin/native-drawing` with `hl test.hl --gpu`. Run the hxcpp smoke from `bin/native-drawing/cpp` with `./NativeDrawingTest.exe --gpu`. Repeat both without `--gpu` to force GDI. The smoke tests use hidden windows.

Omit `-Wgpu` when building the native library for a GDI-only application. That build needs only the appropriate `vision_native.ndll` or `vision_native.hdll` beside the application. A GPU-enabled build also needs `wgpu_native.dll`. Compile the application without `-D vision_native` to use portable Vision without the native library.

### Linux and macOS

Install the SDL2 development files, `pkg-config`, a C/C++ compiler, hxcpp, and the HashLink headers. The first argument below points to the directory containing `hl.h`.

```bash
bash build-native-drawing.sh /path/to/hashlink/include
haxe -cp src -cp tests/ci -main ScreenDrawingTest --cpp bin/native-drawing/cpp -D vision_native
cp bin/native-drawing/vision_native.ndll bin/native-drawing/cpp/
(cd bin/native-drawing/cpp && ./ScreenDrawingTest)
```

For an arm64 macOS hxcpp build, add `-D HXCPP_ARM64`. For HashLink, compile with `--hl` and place `vision_native.hdll` beside the bytecode. SDL selects an accelerated renderer when available and uses its software renderer as a fallback.
