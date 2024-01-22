# 2.0.0

## Breaking!

 - **Typo fix: `Kernal` has been replaced by `Kernel` across the entire library**

### `Vision.hx`

 - **Added `affineWarp()`**
 - **Added `perspectiveWarp()`**


### `Image.hx`

 - **Added `rotate()`**
 - **Slight optimization for `getFloatingPixel()`, avoids recursive call for out-of-bounds coordinates**

### `vision.ds`

 - **Added `Matrix2D`, for better representation of transformation matrices. supports:**
   - **`determinant()`**
   - **`invert()`**
   - **Mathematical operations (`+`, `-`, `*` and `/`)**
   - **Matrix generation function (`ROTATION`, `SHEAR`, `TRANSLATION`, `SCALE`, `REFLECTION`)**
   - **Pretty printing of `Matrix2D`**
   - **And more convenient functions**
 - **Added new colors for `Color.hx` - _Bordeaux_, _Charcoal_, _Onyx_, _Jet_, _Jet Black_**
 - **Documented `IntPoint2D` and `Point2D`**
 - **Added `Array2D.clone()`**
 - **Added `Array2D.toString()`**
 - **Added `Array2D.row()` amd `Array2D.column()`**
 - **Added `ByteArray.resize()`**
 - **Added `ByteArray.concat()`**
 - **Added `ByteArray.getBytes()` and `ByteArray.setBytes()`**
 - **Added `ByteArray.toArray()`**
 - **`ByteArrays` are now pre-filled with `0`**

### `vision.tools`

 - **Added `MathTools` trigonometric functions using degrees:**
   - **`sind()`**
   - **`cosd()`**
   - **`tand()`**
   - **`cotand()`**
   - **`cosecd()`**
   - **`secd()`**
 - **Added `MathTools.parseFloat()` for compatibility**
 - **Added `MathTools.parseBool()` for comfort :)**
 - **Added `MathTools.factorial()`**
 - **Added `MathTools.gamma()`**
 - **Removed `MathTools.flatten`'s `Matrix` variation, as it is no longer relevant**
 - **Clarified parameter names in `MathTools`' compatibility functions**
 - **Added return types to all `MathTools` functions**
 - **Fixed `ImageTools.addToScreen()` not considering alpha**
 - **Fixed canvas to image conversion not considering alpha**
 - **Slight fix for file-name in `ImageTools.saveToFile` on web**
  
### `vision.algorithms`

 - **Added `GaussJordan` for matrix inversion**
 - **Added `BilinearInterpolation.interpolateMissingPixels()` for filling in of missing pixels in images**
 - **Added `Cramer` for solving systems of linear equations**

### `vision.exceptions`

 - **Added `MatrixOperationError`**
 - **Removed double mention of pixel position in `OutOfBounds` exception**


# 1.3.1

### `vision.algorithms`

 - **Improved `SimpleLineDetector`'s line filtering, reporting should be a bit better**

### `vision.ds`

 - **Fixed documentation on some classes**
 - **Fixed compile error on `c++`, `cppia` & `c#`**
 - **Added `distanceTo()` method to `Point2D` & `IntPoint2D`**
# 1.3.0


### `Vision.hx`
 - **Tweaked `Vision.simpleLine2DDetection()`, should report less overlapping lines**

### `Image.hx`
 
 - **Added Bitwise operators `|`, `&` and `^`**
 - **Floating pixel operations are now safe** - Using out-of-bounds coordinates won't throw an error.
 - **Added `movePixel()`**, allows moving a pixel from inside the image to another position, while resetting the old position. variations:
   - **`moveSafePixel()`**
   - **`moveFloatingPixel()`**
 - **Fixed `Image.drawLine()` hanging in certain scenarios** 
 - **Fixed inaccuracies in Image's view implementation, off-by-one pixels bugs should be fixed**
 - **Fixed `getSafePixel()`, `setS`**
 - **Removed `fromColorByteArrayAndData()` Due to buggy behavior**
 - **Added `fromBytes()` and `toBytes()` for easier cross-frameworking**
 - **Optimized `from2DArray()` and `to2DArray()`**
 - **Improved doc comment for private static field `Image.OFFSET`**
### `vision.exceptions`

 - **Renovated `LibraryRequired` to support dependencies and more accurate library inclusion methods**
### `vision.ds`

 - **Added `Int16Point2D`** - An abstract over a 32-bit integer.
 - **Added `UInt16Point2D`** - Same abstract, but coordinates range from `0` to `65535`
 - **Added `Color.makeRandom()`**
 - **Fixed `Line2D.toString()` returning each point 4 times**
 - **Exposed `Ray2D.point` and updated documentation**
 - **Added multiple get & set methods to `ByteArray`:**
    - `getUInt8()`
    - `setUInt8()`
    - `getInt8()`
    - `setInt8()`
 - **Added `Line2D.intersect()`** 
 - **Added `Line2D.distanceTo()`** 
 - **Added `Eay2D.distanceTo()`** 

### `vision.algorithms`

 - **Fixed Bilinear interpolation failing with some aspect ratios**
 - **Added `Gaussian.create2DKernalOfSize()`**
 - **Added `Gaussian.create1DKernalOfSize()`**
 - **Added `Gaussian.fastBlur`, Optimized Version of `Vision.gaussianBlur()`. More Bare-Bones**
 - **Deprecated `Gaussian.createXxXKernal()` Functions**
 - **Deprecated `Gaussian.createKernalOfSize()` in favor of `Gaussian.create2DKernalOfSize()`**

### `vision.tools`

 - **Added `MathTools.isBetweenRange()`**
 - **Added `MathTools.getClosestPointOnRay2D()`**
 - **Added `MathTools.distanceBetweenRays2D()`**
 - **Fixed `MathTools.distanceFromPointOnRay2D()`**
 - **Fixed `MathTools.clamp()`**

# 1.2.3

### `vision.ds`

 - **Added `ImageView.toString()`**
 - **Added `PixelFormat`** - Vision now supports importing/exporting differnt pixel formats! supports RGB, BGR and their different alpha position variants.

### `vision.tools`

 - **Implemented `ImageTools.saveToFile()` for JS**
 - **Fixed `ImageTools.saveToFile()` saving incorrectly on sys targets**
 - **Fixed `ImageTools.loadFromFile()` loading incorrectly on sys targets**

# 1.2.2

### `vision.ds`

 - **Fix `DivideByZero` errors on PHP when using `Color.divide()`**
 - **Fix Historgrams simply not working**
 - **Optimized `image.paintPixel()`**
 - **Fixed `image.stamp`, should now respect alpha values.**


# 1.2.1

### `Vision.hx`

 - **Slight optimization for `simpleLine2DDetection()`**

### `Image.hx`

 - **Added from/to casting methods for JS `Canvas` & `Image` elements**
 - **Added from/to casting methods for HaxeUI's `Image` element and `ImageData`**

### `vision.helpers`

 - **Added triangulation methods for drawing on images (Thanks [Nanjizal](https://github.com/nanjizal))**

### `vision.exceptions`

 - **Fixed LibraryRequired errors being inaccurate on Ceramic**

### `vision.tools`

 - **Added `MathTools.cropDecimal()`**

# 1.2.0

### `Vision.hx`

 - **Optimized algorithm's pixel looping method**
 - **`Vision.grayscale()` Now accepts an addition, optional, parameter**, replacing `vision_better_grayscale`.
  
### `vision.ds.Image`

 - **Image's byte offset changed from `4` to `11`**
 - **Added `image.stamp()`** - draw an image on top of another image
 - **Added `image.view`** - easy access for getting & setting the currently set image view
 - **Added `image.forEachPixelInView()`** - allows iterating over only the pixels inside the current view
 - **Added `image.hasView()`**
 - **Added `image.getView()`**
 - **Added `image.setView()`**
 - **Added `image.removeView()`**
 - **Added `image.hasPixelInView()`** - allows checking whether or not the given pixel is inside a given/the image's view
 - **Added `image.setFloatingPixel()`**
 - **Added `image.setSafePixel()`**
 - **Added `image.paintFloatingPixel()`**
 - **Added `image.paintSafePixel()`**
 - **Fixed `Image.paintPixel()` resetting `alpha` to `1`**
 - **Fixed `Image.resize()` not working with Nearest-Neighbor**

### `vision.ds`

 - **Added `vision.ds.ImageView`**  - manipulate a section of the image without having to copy/paste pixels!
 - **Added `vision.ds.ImageViewShape`**
 - **Changed `Color.grayscale()`'s signature to accept an optional, extra variable**. That variable enable/disables better grayscaling.
 - **Added `Color.blackOrWhite()`**

# 1.1.1

### `vision.ds`

 - **Fixed `Image.underlying` setter failing with `vision_allow_resize`**

### `vision.tools`

 - **Fixed forced dependency on `format`**
 - **Added more documentation for `ImageTools`**
 - **Fixed `MathTools.clamp()`**
 - **Optimized `MathTools.boundInt()`**

# 1.1.0

### `Vision.hx`

 - **Added `erode()`**
 - **Added `dilate()`**
 - **Added `combine()`**
 - **Added `robertEdgeDiffOperator()`**, using the newly implemented `RobertsCross` algorithm.
 - **Added `laplacianEdgeDiffOperator()`**
 - **Added `laplacianOfGaussianEdgeDetection()`**
 - **Added `bilateralDenoise()`**, using the newly implemented `BilateralFilter` algorithm.
 - **Added `saltAndPepperNoise()`**
 - **Added `dropOutNoise()`**
 - **Added `whiteNoise()`**
 - **Optimized `perwittEdgeDiffOperator()`**

### `vision.ds`

 - **Added `Array2D`**
 - **Added `ImageFormat`** for image saving.
 - **Added `WhiteNoiseRange`** for different white noise types (2-bit, 16-bit...)
 - **Added `Kernal2D.LaplacianPositive`**
 - **Added `Kernal2D.LaplacianNegative`**
 - **Added `Color.from8Bit()`** to get a gray color out of a single, 8-bit color channel.
 - **Optimized `Image.clone()`**

### `vision.tools`

 - **Added `MathTools.clamp()`**, which keeps a given number between a `min` and a `max`.
 - **Added `MathTools.raise()`**, which raises a given `1D` array/vector into a `2D` array/matrix
 - **Added `ImageTools.getNeighborsOfPixelIter()`**, which returns a for-loop friendly iterator over the neighboring pixels.
 - **Added full `ImageTools.loadFromFile` support on sys targets**. This change allows you to load images from URLs in a cross platform fashion.
 - **Fixed `MathTools.average`, `MathTools.median` For C#**. Fixed overload resolution failures getting thrown.
  
### `vision.exceptions`

 - **Added `LibraryRequired`**, thrown when a method/field depends on a missing library.
 - **Added `ImageSavingFailed`**.
 - **Added `ImageLoadingFailed`**

### `vision.helpers`

 - **Fixed `VisionThread` preventing compilation on some targets**. That had to do with that sys target not allowing multithreading.
