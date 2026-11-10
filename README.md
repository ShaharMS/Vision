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

The library includes these main source directories and entry points.

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

Add that image to the screen (available on platforms & libraries that support drawing on screen):
```haxe
using vision.tools.ImageTools;

//...

image.addToScreen(0, 0); //alternatively, you can do - ImageTools.addToScreen(image, 0, 0)
```

### Draw and process the same image

An `Image` holds the pixels you edit. A `CanvasRenderer` draws them onto a browser canvas. Create one renderer for the canvas, then give it each image and position you want to draw. [Image API recipes and runnable programs](tools/docs/image-api.md)

Vision images keep synchronous pixel access. Operations use the CPU by default. An attached WebGL image can run inversion, simple grayscale, and black-and-white thresholding directly on its texture. A Windows build with the optional native library uses native C implementations for the same operations. Weighted grayscale, image views, and algorithms without a backend implementation use the existing Haxe code.

#### Edit pixels and run an algorithm

```haxe
import vision.ds.Color;
import vision.ds.Image;
using vision.Vision;

final image = new Image(64, 64, 0xFF223344);
image.setPixel(10, 10, 0xFFFF8800);
image.drawLine(4, 4, 30, 20, Color.WHITE);

final pixel = image.getPixel(10, 10);
image.invert(); // modifies this image and returns it
```

#### Process a region

Views work with the same API on CPU and attached images. Operations preserve pixels outside the view.

```haxe
image.setView({x: 8, y: 8, width: 16, height: 16});
image.grayscale(true);
image.removeView();
```

#### Make an independent copy or export pixels

```haxe
final edited = image.clone();
edited.setPixel(0, 0, 0xFF00FF00);

final argb = edited.exportToBytes();
final restored = Image.loadFromBytes(argb, edited.width, edited.height);
```

Assigning an image to another variable shares its pixels. Cloning copies its pixels. Reading an attached image or exporting a copy synchronizes its pixels when necessary. Requesting the writable `underlying` buffer also releases the graphics backing, so writes through an existing byte alias stay visible.

```haxe
final alias = image;
final packed = alias.underlying; // packed Vision header followed by ARGB pixels
trace(packed.length);
alias.setPixel(0, 0, 0xFFFFFFFF);
trace(image.getPixel(0, 0));
```

#### Draw a browser frame

```haxe
import js.Browser;
import vision.ds.CanvasRenderer;
import vision.ds.Image;

class Main {
	static function main() {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = 240;
		canvas.height = 160;
		Browser.document.body.appendChild(canvas);

		final renderer = new CanvasRenderer(canvas);
		final image = new Image(64, 64, 0xFF315A83);
		image.fillCircle(32, 32, 18, 0xFFFFAA44);
		renderer.draw(image, 20, 20);
	}
}
```

Load the compiled JavaScript from an HTML page with a body. The renderer prefers WebGL 2. Pass `false` as the second argument to choose Canvas 2D. Keep the renderer to draw more images or redraw after edits. [Runnable click-to-redraw example](tools/docs/BrowserImageExample.hx)

```haxe
final software = new CanvasRenderer(anotherCanvas, false);
software.draw(image, 12, 8);
software.dispose();
```

#### Keep a browser image on the device

Attach the image once to the renderer that will draw it. The same Vision calls work when attachment is unavailable. Subsequent ordinary pixel edits are picked up by the next draw or GPU operation.

```haxe
final attached = renderer.attach(image);
image.invert();
image.grayscale(true);
image.blackAndWhite(128);
renderer.draw(image, 20, 20);
```

```haxe
final color = image.getPixel(0, 0); // read back only when the CPU copy is stale
image.setPixel(1, 1, 0xFF00FF00);
renderer.draw(image);

renderer.detach(image); // keep the image and release this renderer's texture
renderer.dispose(); // also detaches any remaining images
```

A GPU-backed image can still run operations such as weighted grayscale and Gaussian blur. Those use the CPU implementation. WebGL context loss can make a GPU-only result unavailable until it can be recreated from the source data.

```haxe
image.grayscale();
final blurred = image.gaussianBlur();
renderer.draw(blurred, 32, 12);
```

#### Preview or compute an inverted image

`drawInverted` changes the preview. For an asynchronous WebGPU result, create the inverter once and dispose of it when it is no longer needed.

```haxe
renderer.drawInverted(image, 0, 0);
renderer.draw(image, image.width, 0);
```

```haxe
import vision.ds.WebGpuInverter;

WebGpuInverter.create().then(inverter -> {
	if (inverter == null) {
		renderer.draw(image.clone().invert());
		return;
	}
	inverter.invert(image).then(result -> {
		inverter.dispose();
		renderer.draw(result);
	}).catchError(error -> {
		inverter.dispose();
		throw error;
	});
});
```

#### Put a Vision image in an existing display hierarchy

```haxe
import vision.formats.to.OpenFlBitmap;

final sprite = new OpenFlBitmap(image);
addChild(sprite);
image.setPixel(5, 5, 0xFFFFAA00);
sprite.update(image);
```

```haxe
import vision.formats.to.HeapsBitmap;

final sprite = new HeapsBitmap(image, s2d);
sprite.x = 20;
image.invert();
sprite.update(image);
```

Call `dispose()` to release the adapter's bitmap data or texture. [Framework smoke tests](tests/ci/framework-drawing.md)

#### Draw in a standalone Windows window

Build the optional native library and compile the application with `-D vision_native`. The same API works with hxcpp or HashLink. A build with wgpu-native presents through WebGPU when available and uses GDI otherwise. Both paths composite ordinary Vision images into a CPU frame before presentation. [Build and test instructions](tests/ci/README.md#standalone-native-drawing)

```haxe
import vision.ds.NativeImageRenderer;

final window = new NativeImageRenderer(640, 480);
while (window.poll()) {
	window.clear(0xFF181818);
	window.draw(background);
	window.draw(image, 24, 16);
	if (!window.present())
		break;
	Sys.sleep(1 / 60);
}
window.dispose();
```

```haxe
final window = new NativeImageRenderer(640, 480, false); // use GDI
window.clear();
window.draw(image);
window.present();
window.dispose();
```

---
### Basic Image Manipulation

```haxe
Vision.grayscale(image);
Vision.sharpen(image);
Vision.convolve(image, BoxBlur);
```
OR
```haxe
using vision.Vision;

image.grayscale();
image.sharpen();
image.convolve(BoxBlur);
```
---

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

On Windows, `powershell -NoProfile -File build-release.ps1` (or `release-to-haxelib.bat`) creates a timestamped ZIP under `release/` without deleting earlier candidates or publishing anything. After reviewing the candidate, submit that ZIP explicitly with `haxelib submit <zip-path>`.

For Neko builds, use `-dce full` to discard unreachable image methods that can exceed the VM function-scope limit. Local and GitHub CI apply this flag to the Neko batches.

### cppia runtime requirement

The cppia interpreter needs the pinned hxcpp array-compatibility fixes in [the host build instructions](tests/ci/cppia/README.md). In a source checkout run `bash tests/ci/cppia/build-host.sh`; release ZIPs include the same helper and patch under `cppia/`. The helper selects the documented hxcpp version in the active haxelib repository, so use an isolated repository if another project needs a different version. JIT mode is not qualified. Other targets do not use this patch.
