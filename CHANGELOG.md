# 1.3.0

### `vision.ds`

 - **Added `Int16Point2D`** - An abstract over a 32-bit integer.
 - **Added `UInt16Point2D`** - Same abstract, but coordinates range from `0` to `65535`
 - **Added `Color.makeRandom()`**
 - **Fixed `Line2D.toString()` returning each point 4 times**

### `vision.algorithms`

 - **Fixed Bilinear interpolation failing with some aspect ratios**
 - **Added `Gaussian.create2DKernalOfSize`**
 - **Added `Gaussian.create1DKernalOfSize`**
 - **Added `Gaussian.fastBlur`, Optimized Version of `Vision.gaussianBlur`. More Bare-Bones**
 - **Deprecated `Gaussian.createXxXKernal` Functions**
 - **Deprecated `Gaussian.createKernalOfSize` in favour of `Gaussian.create2DKernalOfSize`**

### `vision.tools`

 - **Added `MathTools.isBetweenRange`**

### `Image.hx`
 
 - **Added Bitwise operators `|`, `&` and `^`**
 - **Floating pixel operations are now safe** - Using out-of-bounds coordinates won't throw an error.
 - **Added `movePixel()`**, allows moving a pixel from inside the image to another position, while resetting the old position. variations:
   - **`moveSafePixel()`**
   - **`moveFloatingPixel()`**
 - **Fixed `Image.drawLine()` hanging in certain scenarios** 
# 1.2.3

### `vision.ds`

 - **Added `ImageVIew.toString()`**
 - **Improved doc comment for private static field `Image.OFFSET`**

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
