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
- Lua target: I attempted to add runtime shims/stubs and test skips to work around missing Lua modules and limits, then reverted all of it. Lua may still require proper dependencies (rex_pcre2/luv/bit) and can hit the “too many local variables” limit with large generated files.
