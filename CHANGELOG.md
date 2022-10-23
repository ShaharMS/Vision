# 1.2.0

### `Vision.hx`

 - **Optimized algorithm's pixel looping method**
  
### `vision.ds`

 - **Added `ImageView`** - manipulate a section of the image without having to copy/paste pixels!
 - **Image's byte offset changed from `4` to `11`**
 - **Added `image.view`** - easy access for gettint & setting the currently set image view
 - **Added `image.forEachPixelInView()`** - allows iterating over only the pixels inside the current view
 - **Added `image.hasView()`**
 - **Added `image.getView()`**
 - **Added `image.setView()`**
 - **Added `image.removeView()`**
 - **Added `image.hasPixelInView()`** - allows checking whether or not the given pixel is inside a given/the image's view
 - **Added `vision.ds.ImageView`**
 - **Added `vision.ds.ImageViewShape`**

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
