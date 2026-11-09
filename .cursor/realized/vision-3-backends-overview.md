# Plan — Vision 3 native image and drawing backends

## Status

✅ All steps completed

## Overview

Keep the public Haxe `Image` abstract and the existing `Vision` algorithms. A caller can create an image, edit and read pixels synchronously, run existing algorithms with the same parameters, and draw the result. A sprite or display-tree library can call Vision's drawing adapter in traversal order. It owns the hierarchy and app loop. Vision owns image semantics and the work needed to present those images.

Vision 2 stores pixels and metadata together in `Image(ByteArray)`. `ByteArray` wraps `haxe.io.Bytes`. The existing browser and framework adapters convert images through CPU pixels. First preserve that behavior behind internal storage. Then add native drawing and eligible bulk operations in small steps. [Image.hx](../../src/vision/ds/Image.hx) · [ByteArray.hx](../../src/vision/ds/ByteArray.hx) · [FrameworkImageIO.hx](../../src/vision/formats/__internal/FrameworkImageIO.hx)

## Compiler and host choices

- Vision CI declares 12 Haxe 4.3.7 targets. Its JS job runs under Node, so it provides no browser graphics coverage. The installed 4.3.7 CLI also exposes Flash/SWF and HashLink/C. `--run` uses the interpreter. [GitHub CI](../../.github/workflows/main.yml) · [Local CI](../../tests/ci/README.md) · [Haxe CLI](https://haxe.org/manual/compiler-usage.html)
- Keep 4.3.7 as the starting floor. Add a pinned Haxe 5 preview check for the shared core and first graphics adapters. The published 5.0.0-preview.1 removes the old `--java` and `--cs` generators and keeps `--jvm`. Its module resolution and macro changes still need compatibility tests. Requiring Haxe 5 would mainly retire two legacy generators and would leave the browser, framework and native graphics integration work. Revisit the floor once the actual adapters build. [Haxe 5 preview release](https://github.com/HaxeFoundation/haxe/releases/tag/5.0.0-preview.1) · [Haxe development compiler source](https://github.com/HaxeFoundation/haxe/blob/development/src/compiler/args.ml)
- Verified locally on Haxe 4.3.7 and 5.0.0-preview.1 with identical module names in `Probe.hx` and `Probe.js.hx`. The JS compiler selected the suffix and `--interp` selected the base. Use descriptive modules such as `browser/WebGlDraw.hx` for substantive code. Browser and Node share the JS target, so distinguish their capabilities at runtime. The drawing adapters use guarded imports and explicit setup. [Haxe target defines](https://haxe.org/manual/lf-target-defines.html)

## Source layout

The follow-up integration uses Vision's existing packages for data types, format adapters and internal platform code. Its plan records the implemented layout. [Backend integration](vision-3-integration-overview.md)

## Target inventory and implementation

### Graphics paths

- **`--js` → JavaScript in a browser.** Use Haxe's existing `js.html` Canvas 2D and WebGL 2 externs. Present a CPU-backed image to Canvas 2D and test pixel edits first. Then reuse a WebGL texture across frames and upload changed regions before drawing. Accept the app's context where practical. Add WebGPU via a narrow set of Haxe externs for browser APIs used by Vision. No WebGPU extern package was present in the local Haxe 4.3.7 stdlib. Probe adapters/devices at runtime. Canvas 2D, WebGL and WebGPU targets are selected during setup, since a canvas already committed to one context type needs a separate or replacement canvas to switch. [Haxe browser API](https://api.haxe.org/js/html/CanvasElement.html) · [Canvas context types](https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement/getContext) · [WebGPU spec](https://www.w3.org/TR/webgpu/)
- **`--cpp` → C++ → native executable.** First use the app's renderer through a Haxe adapter, with Lime/OpenFL as the first hxcpp candidate. Reuse the app's texture/context and update it in its render loop. For a plain Haxe app that needs its own GPU backend, qualify a thin hxcpp bridge to `wgpu-native` and a host-provided window/surface. Build and package per OS and architecture. Start with Windows, then qualify Linux and macOS separately. Mobile surfaces and packaging are separate checks. The existing `hxwgpu` project is a useful binding reference. Its README describes incomplete coverage and Linux/X11 testing. [hxcpp](https://github.com/HaxeFoundation/hxcpp) · [Lime](https://github.com/openfl/lime) · [wgpu-native](https://github.com/gfx-rs/wgpu-native) · [hxwgpu](https://github.com/ibilon/hxwgpu)
- **`--hl out.hl` → HashLink bytecode.** Start with a Heaps adapter using the application's existing texture and engine. Standalone GPU support could use an HDLL that wraps the same native library as hxcpp. Evaluate `hlwgpu` first. Its documented native API uses an HDLL and expects the Ash Future ABI or a compatible host. Verify that against plain HashLink and Vision's pinned CI runtime before choosing it. [Heaps](https://github.com/HeapsIO/heaps) · [HashLink](https://github.com/HaxeFoundation/hashlink) · [hlwgpu 0.2.0](https://lib.haxe.org/p/hlwgpu/0.2.0/)
- **`--hl out.c` → C → native executable using HashLink/C.** Reuse the Haxe HashLink adapter and qualify C generation, native linking/loading and presentation independently. This output mode has no dedicated Vision CI job today. [HashLink/C compilation](https://haxe.org/manual/target-hl-c-compilation.html)
- **`--cppia` → script for an hxcpp host.** Keep the CPU path in the existing patched host. A graphics-enabled host can explicitly expose its texture and drawing services to scripts. Qualify this with a host build once a real integration needs it. [Vision's CPPIA host](../../tests/ci/cppia/README.md) · [hxcpp](https://github.com/HaxeFoundation/hxcpp)

### Shared CPU path and optional host integrations

- **`--js` → JavaScript in Node.** Keep the headless Haxe CPU path and current CI. An opt-in Dawn binding could provide offscreen compute. Browser canvas presentation is covered separately. [Vision CI](../../tests/ci/README.md) · [Dawn Node WebGPU](https://github.com/dawn-gpu/node-webgpu)
- **`--jvm` → JVM bytecode.** Keep the CPU implementation. For a desktop app, an optional Haxe/JVM adapter can stage pixels into a Java image for Java2D or upload them to an existing LWJGL renderer through externs. Qualify those separately from core JVM builds. [Java BufferedImage](https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/image/BufferedImage.html) · [LWJGL](https://www.lwjgl.org/)
- **`--python` → Python source.** Keep portable CPU operations. If there is demand, add bulk interop through a Haxe extern for Pillow or OpenCV. Convert channel layout once at the boundary and compare results and whole-call cost before delegating any existing operation. [Pillow Image](https://pillow.readthedocs.io/en/stable/reference/Image.html) · [OpenCV image I/O](https://docs.opencv.org/4.x/d4/da8/group__imgcodecs.html)
- **`--lua` → Lua source.** Keep the headless CPU path for plain Lua. A Defold host adapter could upload and present Vision images through engine APIs via `hxdefold`. Validate within the engine since Vision's Lua CI runs outside it. [hxdefold](https://github.com/hxdefold/hxdefold) · [Defold resource API](https://defold.com/ref/resource/)
- **`--php` → PHP source.** Keep the headless CPU path. Optional GD interop could serve server-side image output. Verify alpha and round-trip behavior before delegating work. [PHP GD](https://www.php.net/manual/en/book.image.php)
- **`--neko` → Neko VM bytecode.** Keep the portable CPU path and existing CI batches. Use existing format and framework conversions where the host supports them. [Vision CI](../../tests/ci/README.md) · [Neko](https://github.com/HaxeFoundation/neko)
- **`--interp` / `--run` → Haxe evaluator.** Keep the shared CPU implementation as the behavior reference. Compiler macros execute in the evaluator too. Keep device setup in the application runtime. [Haxe CLI](https://haxe.org/manual/compiler-usage.html) · [Target defines](https://haxe.org/manual/lf-target-defines.html)

### Legacy and additional outputs

- **`--java` → Java source.** Retain the CPU path in Haxe 4 CI. Put new Java-platform graphics work behind the JVM route. Haxe 5 preview removes the Java source generator. [Vision CI](../../.github/workflows/main.yml) · [Haxe 5 preview release](https://github.com/HaxeFoundation/haxe/releases/tag/5.0.0-preview.1)
- **`--cs` → C# source.** Retain the CPU path in Haxe 4 CI. Haxe 5 preview removes the built-in C# generator. A future C# extension target would need its own qualification. [Vision CI](../../.github/workflows/main.yml) · [Haxe 5 preview release](https://github.com/HaxeFoundation/haxe/releases/tag/5.0.0-preview.1)
- **`--swf` → Flash/AIR bytecode.** Existing Flash conversion code supplies a `BitmapData` route. Treat it as legacy and unverified for Vision 3 since the current matrix has no SWF job. Qualify a CPU build and bitmap presentation if a consumer needs it. [Flash conversion code](../../src/vision/formats/__internal/FrameworkImageIO.hx) · [Haxe CLI](https://haxe.org/manual/compiler-usage.html)
- **WebAssembly and custom targets.** The stock compiler inspected here has no dedicated Wasm switch. Browser JS can use WebGPU directly. An Emscripten build, a custom Haxe target, or a Wasm module for CPU bulk operations is a separate integration with its own host and tooling. [Haxe compiler source](https://github.com/HaxeFoundation/haxe/blob/development/src/compiler/args.ml) · [Dawn's Emscripten port](https://github.com/google/dawn/tree/main/src/emdawnwebgpu/pkg)

## Framework choices

- **Lime/OpenFL and HaxeFlixel.** Lime provides low-level native and browser facilities. OpenFL provides a display list and bitmap types. Start with an OpenFL bitmap adapter on top of Lime, using the renderer's public integration points. HaxeFlixel can consume the same OpenFL path through its sprite/bitmap integration. Verify live bitmap updates and texture reuse on the active renderer. [Lime](https://github.com/openfl/lime) · [OpenFL architecture](https://www.openfl.org/learn/haxelib/docs/core-architecture/) · [Current Flixel conversion](../../src/vision/formats/__internal/FrameworkImageIO.hx)
- **Heaps.** Use its texture and bitmap path on the application's existing renderer. Vision currently converts `hxd.Pixels`, which gives a CPU fixture for interop tests. [Heaps Texture](https://github.com/HeapsIO/heaps/blob/master/h3d/mat/Texture.hx) · [Current conversion](../../src/vision/formats/__internal/FrameworkImageIO.hx)
- **Kha.** Add an optional adapter using the host's `kha.Image` and graphics calls. Qualify it as a separate integration because Kha owns its build, shaders and render loop. [Kha](https://github.com/Kode/Kha)
- **HaxeUI.** Keep the existing image conversion. For live rendering, route through its host backend, such as OpenFL or Heaps. [HaxeUI backends](https://github.com/haxeui/haxeui-core)

## Key decisions

- Preserve call shape and observable behavior, including pixel format, alpha, borders, views, mutation and return behavior. Check aliasing around `underlying` before moving storage. An externally mutable byte buffer must keep rendering coherent. Start with conservative re-upload after exposing it if writes cannot be tracked.
- CPU-readable images keep `getPixel` and `setPixel` synchronous. Texture upload for drawing can wait until presentation. For existing algorithms whose results are immediately CPU-readable, use a GPU implementation only if it can preserve that contract and is worthwhile with transfers included. Browser WebGPU buffer mapping is asynchronous. GPU-resident workflows can be additive while the existing synchronous CPU contract remains available. [WebGPU buffer mapping](https://www.w3.org/TR/webgpu/#buffer-mapping)
- A draw adapter needs a host destination and a small set of operations for presenting images. Start with drawing one image and compositing several in caller order. A demo can build a tiny sprite group over that interface to verify a downstream framework can own its scene structure.
- Later matrix and inference features can reuse the bulk operation boundary. Preserve the existing matrix API. Use separate typed tensor buffers if an inference integration needs them, and qualify image-to-tensor conversion and device transfer as part of that integration.
- Treat target support, graphics interop and acceleration as separate evidence. Qualify performance per workload and report whether data started on the CPU or GPU. A successful compile verifies only compiler compatibility.

## Sub-plans

1. ✅ [Preserve the image contract](vision-3-backends-1-image-storage.md)
2. ✅ [Draw on browser targets](vision-3-backends-2-browser-drawing.md)
3. ✅ [Integrate native frameworks](vision-3-backends-3-framework-drawing.md)
4. ✅ [Qualify bulk operations](vision-3-backends-4-bulk-operations.md)
5. ✅ [Evaluate standalone native WebGPU](vision-3-backends-5-standalone-native.md)
6. ✅ [Qualify compiler targets and public entry points](vision-3-backends-6-target-qualification.md)

## Iteration bootstrap

The CPU compatibility baseline is the Haxe 4.3.7 CI matrix. Each graphics adapter's runtime and device evidence is in its completed sub-plan.
