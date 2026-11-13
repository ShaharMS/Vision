# Vision

### Cross framework, cross platform computer vision library for Haxe.
  
 - [**Structure**](https://github.com/ShaharMS/Vision/blob/main/README.md#structure)
 - [**Tutorials**](https://github.com/ShaharMS/Vision/blob/main/README.md#tutorials)
 - [**Versioning**](https://github.com/ShaharMS/Vision/blob/main/README.md#versioning)
 - [**About**](https://github.com/ShaharMS/Vision/blob/main/README.md#about)
 - [**Roadmap**](https://github.com/ShaharMS/Vision/blob/main/ROADMAP.md)
 - [**Changelog**](https://github.com/ShaharMS/Vision/blob/main/CHANGELOG.md)
 - [**Define List**](https://github.com/ShaharMS/Vision/blob/main/README.md#define-list)


# Structure

This Library is organized into 5 subfolders, and one important file:

 - [**`ds`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/ds) - contains Vision's data structures & types. Some functions and
Features require different return types which aren't basic - such as lines, rays or points.
Those can be found inside this folder.
 - [**`tools`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/tools) - contains classes that extend the functionality of certain aspects of the library.
For example, `MathTools` is a superset of the `Math` class from the standard library, and also adds many features related to finding data related to lines, rays and points.
 - [**`algorithms`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/algorithms) - contains every complex algorithm this library uses. They're all contained in one folder to help you learn from them :). **If you feel like some algorithms 
are lacking/have unclear documentation, please open an issue about it**
 - [**`exceptions`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/exceptions) - contains the errors usually thrown by Vision. **Notice - those errors are present just to let you know if you did something unexpected. If you want to get 
rid of them, define `vision_quiet`.**
 - [**`helpers`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/helpers) - contains some helper classes that may be used by Vision. Theres nothing preventing you from using them yourself though...
 - [**`Vision.hx`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/Vision.hx) - contains all image manipulation/computer vision methods. After 1.0.0, this class should always remain backwards compatible. It is always recommended to use the methods from this class instead for using the ones in the wanted algorithm's class, since the ones in `Vision` are much less likely to break compatibility, are usually simpler to use, and have much better documentation.



# Tutorials

For more tutorials (or further details about the tutorials here) check out the links below:

 - [`Vision` Tutorials On The Haxe Learning Center](https://spacebubble-io.pages.dev/haxe/?name=Vision)

---
### Creating an image

Create a blank image for drawing:
```haxe
var image = new Image(200, 300, Color.WHITE); //creates a new, 200x300 image with a white background
```

Drawing:
```haxe
image.setPixel(10, 35, 0xff3204);
image.drawLine(1,1, 34, 67, Color.LIME);
```

Create an image from a URL:
```haxe
var image:Image;
ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG",
    data -> {
        image = data;
    }
);
```

---
### Basic Image Manipulation

```haxe
import vision.ds.Kernels;

Vision.grayscale(image);
Vision.sharpen(image);
var blurred = Vision.convolve(image, Kernels.boxBlur());
```
OR
```haxe
import vision.ds.Kernels;
using vision.Vision;

image.grayscale();
image.sharpen();
var blurred = image.convolve(Kernels.boxBlur());
```
---

### Kernels, matrices, and transforms in Vision 3

Use `Matrix2D.fromRows` for custom coefficients, or a factory such as
`Kernels.boxBlur()` or `Kernels.gaussian(5, 1)`. `Vision.convolve` applies
the weights as supplied and returns a new image. Kernel dimensions must be
positive and odd. The center is the anchor, row and column orientation is
preserved, and samples outside the image repeat the nearest border pixel.
The source alpha is preserved. Blur presets have unit total weight.

Build coordinate maps with `Transform2D` and apply them to points or images.

```haxe
import vision.Vision;
import vision.ds.Matrix2D;
import vision.ds.Transform2D;

var transform = Transform2D.rotationDegrees(30).then(Transform2D.translation(10, 5));
var warped = Vision.affineTransform(image, transform);
var coefficients:Matrix2D = transform; // Independent mutable copy.
var custom = Transform2D.fromMatrix(coefficients); // Checks and copies the 3x3 matrix.
```

`Transform2D.apply(point)` handles affine and projective coordinates and
throws for points that map to infinity. Use `Vision.projectiveTransform`
when the homogeneous denominator varies with position. For linear algebra,
`Matrix2D.identity(size)` creates an identity matrix of the requested size.

### Implicit Conversions From/To Framework Specific Graphical Types

```haxe
import openfl.display.BitmapData;
import vision.ds.Image;

var future = BitmapData.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG");
future.onComplete(bitmapData -> {
	var image:Image = bitmapData; // converts the given openfl.display.BitmapData to vision.ds.Image
   // The conversions are lossless, so you never lose data.
	addChild(new Bitmap(image)); //converts back to a BitmapData.
});
```
---

### Using `MathTools`

```haxe
import vision.tools.MathTools;
using vision.tools.MathTools;

var ray = new Ray2D({x: 0, y: 0}, 1); //f(x) = x
trace(ray.distanceFromRayToPoint2D({1, 0}) /* function from MathTools */); // sqrt(2) / 2
trace(MathTools.median([[12, 123, 321, 4, 333], [12, 123, 145, 321, 4], [12, 123, 264, 321, 4], [12, 123, 234, 321, 4]].flatten())); //123;
//you can even chain calls
trace([[[[[1, 2, 3, 4], [5, 6, 7]]]]].flatten().flatten().flatten().flatten().median()); // 4
```

# Versioning

Vision's versioning will try to follow semver's specifications as accuratly as possible. Here is a list of what can change across version types:

> ✔️: This type of modification is allowed  
> ❌: This type of modification is disallowed  
> ❓: This type of modification may occur from time to time  

<table>
    <tr>
        <th>Version Type</th>
        <th>Changes Allowed</th>
    </tr>
    <tr>
        <td>patch (x.x.Y)</td>
        <td><table>
            <tr>
                <td>code changes</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>documentation</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>deprecation notices</td>
                <td>❌</td>
            </tr>
            <tr>
                <td>Implementation overhauls</td>
                <td>❌</td>
            </tr>
            <tr>
                <td>API additions</td>
                <td>❓</td>
            </tr>
            <tr>
                <td>API changes</td>
                <td>❌</td>
            </tr>
            <tr>
                <td>Major API changes</td>
                <td>❌</td>
            </tr>
        </table></td>
    </tr>
    <tr>
        <td>minor (x.Y.x)</td>
        <td><table>
            <tr>
                <td>code changes</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>documentation</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>deprecation notices</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>Implementation overhauls</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>API additions</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>API changes</td>
                <td>❓</td>
            </tr>
            <tr>
                <td>Major API changes</td>
                <td>❌</td>
            </tr>
        </table></td>
    </tr>
    <tr>
        <td>major (Y.x.x)</td>
        <td><table>
            <tr>
                <td>code changes</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>documentation</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>deprecation notices</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>Implementation overhauls</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>API additions</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>API changes</td>
                <td>✔️</td>
            </tr>
            <tr>
                <td>Major API changes</td>
                <td>✔️</td>
            </tr>
        </table></td>
    </tr>
</table>


# About 

**Vision** is a cross framework, cross platform Computer Vision & Image Manipulation library for [Haxe](https://haxe.org/).  
This library exists to provide CV & IM capabilities to Haxe projects, naturally:

### What Does That Mean?

Basically, if you're using HaxeFlixel for example, you should be able to easily use an FlxSprite as
an image to process, or if you're using OpenFL you should be able to use bitmaps and sprites to process.

### Why Does This Library Exist?

One of the problems i have with Haxe is the lack of non-game utilities and libraries. my goal is to provide those utilities, and make app development in Haxe easier.

### Contributions Are Welcomed.

I'm not the best at everything I do, especially in fields like computer vision, with which im not the most familiar. That means there are bound to be mistakes/bugs. Because of that, every issue, pull request or code review is welcomed. **Help me make this library bigger and better for everyone :)**

### About Documentation 

One of the things I can't stand with libraries similar to this one is the lack of docs, and unclear, obfuscated code.

If you see some code that you think is not understandable, or some place that lacks documentation, or even inaccurate/unclear documentation, please open an issue about it, and I'd try to resolve it asap ;).






## Define List:

| Define | Meaning | Versions |
| :---: | --- | :---: |
| `vision_disable_point_alloc_optimization` | enabling this makes every `IntPoint2D` allocate two integers as a class instance instead of working as an abstract over a 64 bit integer. The allocation optimization is enabled by default to reduce allocations, but you can flip this flag if your'e capped to 32bit integers | 1.0.0 - now |
| `vision_better_grayscale` | When enabled, grayscaling is done a bit differently to get an image that more closely resembles the original image. If you're noticing problems with grayscaling, turn this off. | 1.0.0 - 1.1.1 |
| `vision_quiet` | When enabled, no errors are thrown from this library's components, and an effort is made to return the "expected" value. For example, gaussian kernel's size would be incremented if even, and a `getPixel` call outside the bounds of the image should return the closest pixel to that point. | 1.0.0 - now |
| `vision_allow_resize` | When enabled, you can resize an image by directly setting its width/height property. Bilinear interpolation is used by default. If you wish to change this, change `defaultResizeAlgorithm` in `ImageTools`.| 1.0.0 - now |
| `vision_multithread` | Attempts to use multithreaded versions of some algorithms - might boost performance. Available on both web & sys. | 1.0.0 - now |
| `vision_higher_width_cap` | allows using images wider than 65535 pixels, but makes the image byte offset bigger (11 to 21 bytes) (for more information about the byte offset, [click here](https://github.com/ShaharMS/Vision/blob/ed042871963e7456161c00017e4c2bf79a1f26cc/src/vision/ds/Image.hx#L37)). Also allows image views to be wider & taller than 65535 pixels. | 1.2.0 - now |
| `vision_fancy_array_access` | Enables a fancy, shortened way to access arrays of multi-dimensional arrays (specifically Array2D) using double square brackets: `array[[x, y]]`. This is enabled by default. When disabled, only direct `get` and `set` calls are allowed. | 2.0.0 - now |
| `vision_hlc_color_compile` | When compiling to C code using the C transpiler of Hashlink, the word TRANSPARENT can clash with existing `#define`s in the resulting C code. To work around this, the defines disables `Color.TRANSPARENT`. You can use `Color.TRANSPARENT_COLOR` instead. | 2.0.0 - now |
| `vision_disable_inline_protection` | Disables the inline-stripping build macro used on java, jvm, and lua targets. Leave this off unless you explicitly want inline fields preserved on those targets. Pay attention - inlining was disabled on these targets because of errors related to variable count/function size | 2.2.0 - now |


## Building a release candidate

Run `haxe test.hxml` and the relevant targets in `tests/ci/local-ci.hxml` before packaging. Tests require `utest`; the library itself does not.

For Neko builds, use `-dce full` to discard unreachable image methods that can exceed the VM function-scope limit. Local and GitHub CI apply this flag to the Neko batches.

### cppia runtime requirement

The cppia interpreter needs the pinned hxcpp array-compatibility fixes in [the host build instructions](tests/ci/cppia/README.md). In a source checkout run `bash tests/ci/cppia/build-host.sh`; release ZIPs include the same helper and patch under `cppia/`. The helper selects the documented hxcpp version in the active haxelib repository, so use an isolated repository if another project needs a different version. JIT mode is not qualified. Other targets do not use this patch.

## Image acceleration

`Image.accelerate()` records image commands in order. Call `commit()` to
receive a new `Image`, or `commit(InPlace)` to update the existing image
when the batch retains its original dimensions. Rectangle and geometry
arguments and filter weights are copied when queued. Image operands are read
at commit. A batch can be committed once.

```haxe
screen.attach(image);
final result = image.accelerate()
    .resize(640, 360, BilinearInterpolation)
    .convolve(Kernels.gaussian(5, 1))
    .fillRect({x: 12, y: 12, width: 60, height: 20}, Color.CYAN)
    .commit();
screen.draw(result);
```

### Browser WebGL 2

Attach the source to the screen before committing. Supported commands run in
the screen's WebGL context and return a texture that the screen can draw
directly. Bilinear and nearest resize fetch source texels explicitly.
Convolution accepts up to 81 taps and clamps samples at the image edges.
A two-pass Gaussian uses an RGBA8 intermediate between the vertical and
horizontal passes. Rectangle fills use scissored clears and write the
supplied RGBA values. A pixel read or export downloads the committed result.
Disposing the screen synchronizes its remaining attached images.

Unattached images, images with an active view, and batches with unsupported
commands use the packed-pixel implementation. A batch that falls back can
download its input. The concrete `BrowserImageBatch` docs identify which
commands use the CPU executor. WebGL filtering uses floating-point shader
arithmetic, so results near rounding boundaries can differ from CPU results.

### Browser WebGPU compute

Initialize a `WebGpuBatchDevice` once, pass it to `Screen`, and attach the
source image before submitting a batch.

```haxe
WebGpuBatchDevice.create().then(device -> {
    if (device == null) return;
    final screen = new Screen(0, 0, 640, 360, {webGpu: device});
    if (!screen.attach(image)) return;
    final result = image.accelerate()
        .resize(640, 360, BilinearInterpolation)
        .convolve(Kernels.gaussian(5, 1))
        .commit();
    screen.draw(result);
});
```

The browser batch records the same commands for WebGL and WebGPU. WebGPU
supports nearest and bilinear resize, clear and rectangle fills, inversion,
both grayscale modes, thresholding, and horizontal, vertical, or rectangular
convolution with up to 81 weights. Passes share one queue submission and
keep intermediate packed ARGB buffers on the device. Resize truncates the
interpolated channels. General convolution rounds RGB and preserves alpha.
The one-dimensional passes truncate RGB and write opaque alpha. WebGPU uses
shader floats and can differ from CPU results near a rounding boundary.

`commit()` returns an image immediately after submitting GPU work. The WebGPU
screen reads the result buffer directly in its fragment shader. On this screen,
each draw replaces the frame, and the shader presents RGB with opaque alpha.
Use `result.readbackWebGpu()` and wait for the promise before synchronous CPU
pixel access, export, or detach. Synchronous screen capture is unavailable on
the WebGPU screen. `commitWebGpu(device)` remains available as a convenience
that submits a batch and waits for its CPU pixels. An unsupported command or
active view uses the packed-pixel executor and requires the source pixels to
be available first. Dispose the screen before its device.

### Native and headless

The concrete `CpuImageBatch` executes queued operations against packed
pixels and produces ordinary images. Metal and Vulkan batch executors are pending.

### Windows D3D11

Windows hxcpp builds with `-D windows` select `D3D11Image` and
`D3D11ImageBatch`. A hardware device is opened on first use. An image uploads
its packed ARGB bytes lazily on the first supported commit or `Screen.attach`.
Subsequent supported commits can use its texture directly, including when no
screen is open. `commit()` returns a new image, and `commit(InPlace)` publishes
the completed command sequence into the source storage.

D3D11 compute shaders execute nearest and bilinear resize, RGB inversion,
grayscale, thresholding, rectangle fills, and convolution with up to 81
coefficients. General convolution clamps coordinates at borders, rounds RGB,
and preserves alpha. The separable passes truncate RGB and write opaque alpha
to match the existing fast Gaussian algorithm. Each pass writes to an
independent texture. Active views, exposed writable bytes, unsupported
commands, and unavailable devices use packed pixels. CPU reads use a staging
texture and wait for pending GPU commands. GPU filtering can differ by one
channel value at a quantization boundary.

A default visible `Screen` on this target uses a DXGI swap chain when device
initialization succeeds. Drawing a device image composites it into the screen
texture and presents without downloading the image. The existing GDI path
handles unavailable swap chains and `preferGpu: false`. `Screen.capture()`
returns an independent image. Pixel reads and export materialize its CPU
copy. Close the window or call `dispose()` to release the swap chain.

### Native Vulkan compute

Build with `-D vision_vulkan` on hxcpp to select `VulkanImage` and
`VulkanImageBatch`. Windows normally selects D3D11, and the flag selects
Vulkan there for compute qualification. Vulkan currently uses the existing
CPU screen presentation path.

Nearest and bilinear resize, clear, rectangle fill, color transforms, and
convolution up to 81 taps run on a Vulkan compute queue. The backend keeps
packed ARGB buffers between commands. Each dispatch waits for completion
before the next command. CPU reads copy from a host-visible buffer. Views,
unsupported commands, and unavailable hardware use packed CPU pixels.
Software Vulkan is opt-in through `VISION_VULKAN_ALLOW_SOFTWARE`.
