# Vision
Cross framework, cross platform computer vision library for Haxe.

The goal of this library is to provide computer vision functionality to Haxe projects, but naturally:

### What Does That Mean?

Basically, if you're using HaxeFlixel for example, you should be able to easily use an FlxSprite as
an image to process, or if youre using OpenFL you should be able to use bitmaps and sprites to process.

### Why Does This Library Exist?

One of the problems i have with Haxe is the lack of non-game utilities and libraries. my goal is to provide those utilities, and make app development in Haxe easier.

### Roadmap

Here is a roadmap of all features added/planned for the future:

> **Bold** means high priority,  
> Regular means medium priority,  
> *Italic* means low priority.  
> 


#### class `Vision`:
 
 - [x] grayscaling
 - [x] black and white
 - [x] inverting
 - [ ] sharpening
 - [x] Contrast image (exaggerated colors) **needs fixing**
 - [ ] Line detection (hough method)
 - [x] Line detection (simple, recursive method)
 - [ ] *Circle detection (hough method)*
 - [ ] *Rectangle detection (recursive method)*
 - [ ] *Triangle detection (recursive method)*
 - [x] edge detection (perwitt method)
 - [x] edge detection (sobel method)
 - [ ] **edge detection (canny method)**
 - [x] nearest-neighbor style blur
 - [x] gaussian blur 

#### algorithms:

 - Hough Transform
    - [x] hough space generation
    - [ ] *adaptive hough space generation*
    - [ ] line segment finder
    - [ ] *Circle finder*

 - Gaussian
   - [x] 3x3 kernal generation
   - [x] 5x5 kernal generation
   - [x] 7x7 kernal generation
   - [x] 9x9 kernal generation
   - [x] custom size kernal generation
   
#### class `Image`:

 - [x] `getPixel()`
 - [x] `setPixel()`
 - [x] `hasPixel()`
 - [x] `paintPixel()`
 - [x] matrix access `image[x][y]`
 - Drawing:
   - [x] `fillColor`
   - [x] `fillColorRecursive`
   - [x] `drawLineSegment2D()`
   - [x] `drawRay2D()`
   - [x] `drawRect()`
   - [x] `drawCircle()`
   - [x] `drawEllipse()`
   - [x] `drawQuadraticBezier()`
   - [x] `drawCubicBezier()`
   - [x] `drawLineWithLerp()`
   - [x] `fillRect()`
   - [ ] `fillCircle()`
   - [x] `callDrawSequence()`
 - Copying:
   - [x] `clone()`
   - [x] `getImagePortion()`
   - [x] `setImagePortion()`
   - [x] `copyPixel()`


### Define List:

 - `vision_fill_color_optimization`