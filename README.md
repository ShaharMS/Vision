# Vision

### Cross framework, cross platform computer vision library for Haxe.
  
 - [**Structure**](https://github.com/ShaharMS/Vision/blob/main/README.md#structure)
 - [**Tutorials**](https://github.com/ShaharMS/Vision/blob/main/README.md#tutorials)
 - [**About**](https://github.com/ShaharMS/Vision/blob/main/README.md#about)
 - [**Roadmap**](https://github.com/ShaharMS/Vision/blob/main/ROADMAP.md)
 - [**Define List**](https://github.com/ShaharMS/Vision/blob/main/README.md#define-list)


# Structure

This Library is organized into 4 subfolders, and one important file:

 - [**`ds`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/ds) - contains Vision's data structures & types. Some functions &
Features require different return types which aren't basic - such as lines, rays or points.
Those can be found inside this folder.
 - [**`tools`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/tools) - contains classes that extend the functionality of certain aspects of the library.
For example, `MathTools` is a superset of the `Math` class from the standard library, and also adds many features related to finding data related to lines, rays and points.
 - [**`algorithms`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/algorithms) - contains every complex algorithm this library uses. They're all contained in one folder to help you learn from them :). **If you feel like some algorithms 
are lacking/have unclear documentation, please open an issue about it**
 - [**`exceptions`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/exceptions) - contains the errors usually thrown by Vision. **Notice - those errors are present just to let you know if you did something unexpected. If you want to get 
rid of them, define `vision_quiet`.**
 - [**`Vision.hx`**](https://github.com/ShaharMS/Vision/tree/main/src/vision/Vision.hx) - contains all image manipulation/computer vision methods. After 1.0.0, this class should always remain backwards compatible. It is always recommended to use the methods from this class instead for using the ones in the algorithms class, since those are less likely to break compatibility, and are usually more concise.



# Tutorials

For more tutorials (or further details about the tutorials here) check out the links below:

 - [`Vision` Tutorials On The Haxe Learning Center](https://spacebubble.io/haxe/?name=Vision)

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

Create an image from a URL (right now, JS only):
```haxe
var image:Image;
ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG",
    data -> {
        image = data;
    }
);
```

Add that image to the screen (available in platforms & libraries that support drawing on screen):
```haxe
using vision.tools.ImageTools;

//...

image.addToScreen(); //alternatively, you can do - ImageTools.addToScreen(image)
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


# About 

**Vision** is a cross framework, cross platform Computer Vision & Image Manipulation library for [Haxe](https://haxe.org/).  
This library exists to provide CV & IM capabilities to Haxe projects, naturally:

### What Does That Mean?

Basically, if you're using HaxeFlixel for example, you should be able to easily use an FlxSprite as
an image to process, or if you're using OpenFL you should be able to use bitmaps and sprites to process.

### Why Does This Library Exist?

One of the problems i have with Haxe is the lack of non-game utilities and libraries. my goal is to provide those utilities, and make app development in Haxe easier.

### Contributions Are Welcomed.

I'm not the best at *everything* I do, especially in fields like computer vision, with which im not the most familiar. That means there are bound to be mistakes/bugs. Because of that, every issue, pull request or code review is welcomed. **Help me make this library bigger and better for everyone :)**

### About Documentation 

One of the things I can't stand with libraries similar to this one is the lack of docs, and unclear, obfuscated code.

If you see some code that you think is not understandable, or some place that lacks documentation, or even inaccurate/unclear documentation, please open an issue about it, and I'd try to resolve it asap ;).






## Define List:

| Define | Meaning | Versions |
| :---: | --- | :---: |
| `vision_disable_point_alloc_optimization` | enabling this makes every `IntPoint2D` allocate two integers as a class instance instead of working as an abstract over a 64 bit integer. The allocation optimization is enabled by default to reduce allocations, but you can flip this flag if your'e capped to 32bit integers | 1.0.0 |
| `vision_better_grayscale` | When enabled, grayscaling is done a bit differently to get an image that more closely resembles the original image. If you're noticing problems with grayscaling, turn this off. | 1.0.0 |
| `vision_quiet` | When enabled, no errors are thrown from this library's components, and an effort is made to return the "expected" value. For example, gaussian kernal's size would be incremented if even, and a `getPixel` call outside the bounds of the image should return the closest pixel to that point. | 1.0.0 |
| `vision_allow_resize` | When enabled, you can resize an image by directly setting its width/height property. Bilinear interpolation is used by default. If you wish to change this, change `defaultResizeAlgorithm` in `ImageTools`.| 1.0.0 |
| `vision_multithread` | Attempts to use multithreaded versions of some algorithms - might boost performance. Available on both web & sys. | 1.0.0 |

