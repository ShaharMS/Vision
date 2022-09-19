# Vision
Cross framework, cross platform computer vision library for Haxe.

The goal of this library is to provide computer vision functionality to Haxe projects, but naturally:

### What Does That Mean?

Basically, if you're using HaxeFlixel for example, you should be able to easily use an FlxSprite as
an image to process, or if youre using OpenFL you should be able to use bitmaps and sprites to process.

### Why Does This Library Exist?

One of the problems i have with Haxe is the lack of non-game utilities and libraries. my goal is to provide those utilities, and make app development in Haxe easier.

### Contributions Are Welcomed.

I'm not the best at *everything* I do, especially in fields like computer vision, with which im not the most familiar. That means there are bound to be mistakes/bugs. Because of that, every issue, pull request or code review is welcomed. **Help me make this library bigger and better for everyone :)**

### About Documentation 

One of the things I can't stand with libraries similar to this one is the lack of docs, and unclear, obfuscated code.

If you see some code that you think is not understandable, or some place that lacks documentation, or even inaccurate/unclear documentation, please open an issue about it, and I'd try to resolve it asap ;).

### Roadmap

Here is a roadmap of all features added/planned for the future:

> **Bold** means high priority,  
> Regular means medium priority,  
> *Italic* means low priority.  
> 


#### class `Vision`:
 
 - [x] `grayscale()`
 - [x] `blackAndWhitd()`
 - [x] `invert()`
 - [x] `sharpen()`
 - [x] `deepfry()` 
 - [x] `convolve()`
 - [x] `contrast()`
 - [x] `normalize()`
 - [ ] **`houghRay2DDetection()`**
 - [ ] **`houghLineSegment2DDetection()`**
 - [ ] `simpleLineDetector()` **needs fixing**
 - [x] `perwittEdgeDetection()`
 - [x] `perwittEdgeDiffOperator()`
 - [x] `sobelEdgeDiffOperator()`
 - [x] `sobelEdgeDetection()`
 - [x] `cannyEdgeDetection()`
 - [x] `nearestNeighborBlur()`
 - [x] `gaussianBlur()`

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

 - Canny
    - [x] grayscale
    - [x] gaussian blur
    - [x] Sobel filter (needs tweaking)
    - [x] non-max suppression 
    - [x] hysteresis
  
 - Sobel
    - [x] Sobel filter
    - [x] Sobel edge detection

 - Perwitt
    - [x] Perwitt filter
    - [x] Perwitt edge detection
   
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
   - [ ] `fillRectRecursive()` 
   - [ ] `fillCircle()`
   - [ ] `fillCircleRecursive()`
   - [x] `callDrawSequence()`
 - Copying:
   - [x] `clone()`
   - [x] `getImagePortion()`
   - [x] `setImagePortion()`
   - [x] `copyPixel()`
 - Manipulation:
   - [x] `forEachPixel()`
   - [x] `iterator()`
   - [x] `mirror()`  
   - [x] `flip()`
   - [ ] `resizeNearestNeighbor()`
   - [ ] `resizeBilinear()`
   - [ ] `resizeBicubic()`


### Define List:

| Define | Meaning | Versions |
| :---: | --- | :---: |
| `vision_disable_point_alloc_optimization` | enabling this makes every `IntPoint2D` allocate two integers as a class instance instead of working as an abstract over a 64 bit integer. The allocation optimization is enabled by default to reduce allocations, but you can flip this flag if your'e capped to 32bit integers | 1.0.0 |
| `vision_better_grayscale` | When enabled, grayscaling is done a bit differently to get an image that more closely resembles the original image. If you're noticing problems with grayscaling, turn this off. | 1.0.0 |
