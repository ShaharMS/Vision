# Vision image examples

An `Image` holds pixels. A `Screen` is where you draw those pixels. Create a screen with a position and size, then call `draw(image, x, y)`. On browser builds it creates the drawing area on the page. On desktop it creates a window.

Screen coordinates are relative to the top-left corner of the page or desktop. The coordinates passed to `draw` are relative to the top-left corner of the screen. Desktop window managers may override a requested window position.

## Run the examples

All commands start from the repository root.

### Four PNGs from the CPU API

```powershell
haxe -cp src -cp tools/docs -lib format --run ImageExamples bin/image-examples
```

Open the original, region-edited, thresholded, and resized PNGs in `bin/image-examples`. [Complete Haxe program](ImageExamples.hx)

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

## Draw to a Screen

### Open a screen and draw an image

```haxe
import vision.ds.Screen;

final screen = new Screen(24, 32, 320, 180);
screen.draw(image, 20, 20);
```

The screen appears as soon as you construct it. `draw` and `clear` take effect immediately.

### Manage a screen's lifetime

- Assign `onFirstDraw` before drawing to run setup once, immediately before the first nonempty image is drawn.
- Call `requestAnimationFrame` to schedule one callback at the screen's target `frameRate`, which defaults to 60. Each callback receives elapsed seconds since the previous one. The first callback receives zero. Request another frame from the callback to continue.
- Time spent updating and drawing counts toward the next frame deadline. The browser's refresh rate and the desktop event loop determine when a callback can actually run.
- Each screen accepts one pending request. Call `cancelAnimationFrame` to cancel it and reset the elapsed time. Closing or disposing the screen cancels its request.
- With a manual desktop loop, call `poll()` to process window events. It returns false after the window closes or the screen is disposed.
- To draw layers, clear the screen, draw the background, then draw each foreground image in order.
- Call `dispose()` to close the window or remove the browser drawing area.

### Open a second drawing area

```haxe
final originalScreen = new Screen(24, 32, 180, 120);
final previewScreen = new Screen(224, 32, 180, 120);
originalScreen.draw(image);
previewScreen.drawInverted(image);
```

### Request the software path

```haxe
final screen = new Screen(24, 32, 320, 180, {preferGpu: false});
screen.draw(image);
```

### Attach an image and use the same Vision calls

Attachment is optional. When the screen supports device-backed images, the eligible whole-image operations can run there. The calls also work when attachment returns false.

```haxe
screen.attach(badge);
badge.invert();
badge.grayscale(true);
badge.blackAndWhite(140);
screen.draw(badge, 80, 40);
```

### Read an edited pixel and draw again

```haxe
final color = badge.getPixel(4, 4);
badge.setPixel(5, 4, color);
screen.draw(badge, 80, 40);
```

### Keep the image after releasing its device backing

```haxe
screen.detach(badge);
screen.dispose();
trace(badge.getPixel(4, 4));
```

### Run a filter with the CPU path

```haxe
screen.attach(badge);
badge.invert();
final blurred = badge.gaussianBlur();
screen.draw(blurred, 80, 40);
```

## Add an image to an existing framework scene

When you already have a framework-owned scene, use its bitmap adapter to add the image to that scene. A standalone `Screen` owns a separate drawing area.

### OpenFL

```haxe
final bitmap = new vision.formats.to.OpenFlBitmap(badge);
bitmap.x = 20;
addChild(bitmap);

badge.setPixel(5, 5, 0xFFFFAA00);
bitmap.update(badge);
```

### Heaps

```haxe
final bitmap = new vision.formats.to.HeapsBitmap(badge, s2d);
bitmap.x = 20;
badge.invert();
bitmap.update(badge);
```
