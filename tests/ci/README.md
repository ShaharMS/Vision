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
