# Vision image examples

An `Image` is the pixel data. A browser `<canvas>` is a rectangle on the page. A `CanvasRenderer` connects the two. You create it once for the canvas, then call `draw(image, x, y)` to put an image on that canvas. One renderer can draw several images. Drawing again shows any edits you've made since the previous draw.

For a one-off browser image, use `image.addToScreen(x, y)`. For a scene you redraw, keep a `CanvasRenderer`. In OpenFL and Heaps, the framework owns drawing. Give it a bitmap adapter and call `update(image)` after edits. For a standalone Windows app, `NativeImageRenderer` creates the window and presents your frame.

## Run the examples

All commands start from the repository root.

### Four PNGs from the CPU API

```powershell
haxe -cp src -cp tools/docs -lib format --run ImageExamples bin/image-examples
```

Open the original, region-edited, thresholded, and resized PNGs in `bin/image-examples`. [Complete Haxe program](ImageExamples.hx)

### A clickable browser scene

```powershell
haxe -cp src -cp tools/docs -main BrowserImageExample --js bin/browser/image-example.js
```

Open [browser-image-example.html](browser-image-example.html) after compiling. The badge inverts on each click. [Complete Haxe program](BrowserImageExample.hx)

### A standalone Windows animation

Build the native libraries first. For HashLink, put `vision_native.hdll` and any required `wgpu_native.dll` beside `image-example.hl`, then run it from that directory. [Native build instructions](../../tests/ci/README.md#standalone-native-drawing)

```powershell
haxe -cp src -cp tools/docs -main NativeImageExample --hl bin/native-drawing/image-example.hl -D vision_native -D hl-ver=1.16.0
```

For hxcpp, place `vision_native.ndll` and any required `wgpu_native.dll` beside the generated executable. Run it from that directory. [Complete Haxe program](NativeImageExample.hx)

```powershell
haxe -cp src -cp tools/docs -main NativeImageExample --cpp bin/native-drawing/example-cpp -D vision_native -D HXCPP_M64
```

## Make and edit images

The snippets use `Image` and the usual Vision extensions. Put the statements inside a function.

```haxe
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageResizeAlgorithm;
using vision.Vision;
```

### Create a transparent image

```haxe
final icon = new Image(32, 32);
icon.setPixel(4, 5, 0xFFFF8800);
trace(icon.getPixel(4, 5));
```

### Fill a shape

```haxe
final badge = new Image(64, 64);
badge.fillRect(8, 8, 48, 48, 0xFF315A83);
badge.fillCircle(32, 32, 14, 0xFFFFAA44);
```

### Draw an outline and a line

```haxe
final diagram = new Image(96, 64, 0xFF20304A);
diagram.drawRect(8, 8, 72, 40, Color.WHITE);
diagram.drawLine(8, 8, 80, 48, 0xFFE69B42);
```

### Use alpha

```haxe
final overlay = new Image(32, 32);
overlay.fillRect(0, 0, 32, 32, Color.fromRGBA(255, 136, 0, 128));
```

### Share an image or make a copy

```haxe
final source = new Image(16, 16);
final shared = source;
final independent = source.clone();

shared.setPixel(0, 0, Color.WHITE);
trace(source.getPixel(0, 0));      // white
trace(independent.getPixel(0, 0)); // transparent
```

### Extract a region as its own image

```haxe
final portion = diagram.getImagePortion({x: 8, y: 8, width: 24, height: 16});
portion.invert();
```

### Run a filter inside a view

```haxe
diagram.setView({x: 8, y: 8, width: 24, height: 16});
diagram.invert();
diagram.removeView();
```

### Stamp one image into another

This changes the destination's pixels. Keep the stamp within the destination bounds.

```haxe
final card = new Image(160, 96, 0xFF20304A);
card.stamp(16, 16, badge);
```

### Resize a copy

Use the returned image. Passing `-1` for one dimension preserves the aspect ratio.

```haxe
var thumbnail = card.clone();
thumbnail = thumbnail.resize(80, -1, ImageResizeAlgorithm.NearestNeighbor);
```

### Make separate filter previews

```haxe
final grayscale = card.clone().grayscale();
final threshold = card.clone().blackAndWhite(120);
final edges = card.clone().sobelEdgeDetection();
```

### Export raw pixels and load them again

```haxe
final argb = card.exportToBytes();
final restored = Image.loadFromBytes(argb, card.width, card.height);
```

### Save a PNG on a system target

Build with `-lib format`.

```haxe
sys.io.File.saveBytes("card.png", vision.formats.ImageIO.to.bytes.png(card));
```

### Open a PNG on a system target

```haxe
final bytes = sys.io.File.getBytes("card.png");
final loaded = vision.formats.ImageIO.from.bytes.png(bytes);
```

## Draw in a browser

### Put one image on the page

```haxe
using vision.tools.ImageTools;

image.addToScreen(20, 20);
```

### Create the canvas and its renderer

```haxe
import js.Browser;
import vision.ds.CanvasRenderer;

final canvas = Browser.document.createCanvasElement();
canvas.width = 240;
canvas.height = 160;
Browser.document.body.appendChild(canvas);

final renderer = new CanvasRenderer(canvas);
renderer.draw(image, 20, 20);
```

### Draw a layer over a background

```haxe
renderer.clear();
renderer.draw(background);
renderer.draw(badge, 80, 40);
```

### Edit and redraw when clicked

```haxe
canvas.onclick = _ -> {
	badge.invert();
	renderer.clear();
	renderer.draw(background);
	renderer.draw(badge, 80, 40);
};
```

### Select Canvas 2D for a different canvas

```haxe
final previewCanvas = Browser.document.createCanvasElement();
previewCanvas.width = image.width;
previewCanvas.height = image.height;
Browser.document.body.appendChild(previewCanvas);

final previewRenderer = new CanvasRenderer(previewCanvas, false);
previewRenderer.draw(image);
previewRenderer.dispose();
```

### Convert to and from a Canvas 2D snapshot

```haxe
final snapshot = image.toJsCanvas();
final copy = Image.fromJsCanvas(snapshot);
Browser.document.body.appendChild(snapshot);
```

### Attach once and use ordinary Vision calls

Attachment lets the renderer's WebGL context keep this image's pixels on the device. The same calls work when attachment returns false.

```haxe
renderer.attach(badge);
badge.invert();
badge.grayscale(true);
badge.blackAndWhite(140);
renderer.draw(badge, 80, 40);
```

### Read a GPU result and edit it again

```haxe
final color = badge.getPixel(4, 4);
badge.setPixel(5, 4, color);
renderer.draw(badge, 80, 40);
```

### Keep the image after releasing its texture

```haxe
renderer.detach(badge);
renderer.dispose();
trace(badge.getPixel(4, 4));
```

### Preview inversion while keeping the source

```haxe
renderer.clear();
renderer.draw(badge, 16, 20);
renderer.drawInverted(badge, 112, 20);
```

### Run an operation with a CPU fallback

Gaussian blur uses the CPU and returns an image. A GPU-backed input can still be passed to it.

```haxe
renderer.attach(badge);
badge.invert();
final blurred = badge.gaussianBlur();
renderer.draw(blurred, 80, 40);
```

## Draw in an existing app or a native window

### OpenFL inside a display object

```haxe
final bitmap = new vision.formats.to.OpenFlBitmap(badge);
bitmap.x = 20;
addChild(bitmap);

badge.setPixel(5, 5, 0xFFFFAA00);
bitmap.update(badge);
```

### Heaps inside an app

```haxe
final bitmap = new vision.formats.to.HeapsBitmap(badge, s2d);
bitmap.x = 20;
badge.invert();
bitmap.update(badge);
```

### Draw one native frame

The standalone renderer owns a window. Call `present()` after composing the frame. In an interactive program, keep polling while the window is open.

```haxe
final window = new vision.ds.NativeImageRenderer(320, 180);
window.clear(0xFF20304A);
window.draw(background);
window.draw(badge, 20, 60);
window.present();
```

### Move an image across frames

```haxe
var x = 0;
while (window.poll()) {
	window.clear(0xFF20304A);
	window.draw(badge, x, 60);
	if (!window.present())
		break;
	x = (x + 2) % (window.width - badge.width + 1);
	Sys.sleep(1 / 60);
}
window.dispose();
```

### Request the native GDI path

```haxe
final window = new vision.ds.NativeImageRenderer(320, 180, false);
trace(window.usesWebGpu); // false
window.dispose();
```
