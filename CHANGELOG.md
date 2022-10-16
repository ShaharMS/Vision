# 1.1.0

### `Vision.hx`

 - **Added `erode()`**
 - **Added `dilate()`**
 - **Added `robertEdgeDiffOperator()`**, using the newly implemented `RobertsCross` algorithm.
 - **Added `laplacianEdgeDiffOperator()`**
 - **Added `laplacianOfGaussianEdgeDetection()`**
 - **Added `bilateralDenoise()`**, using the newly implemented `BilateralFilter` algorithm.
 - **Added `saltAndPepperNoise()`**
 - **Added `dropOutNoise()`**
### `vision.ds`

 - **Added `Array2D`**
 - **Added `ImageFormat`** for image saving.
 - **Added `Kernal2D.LaplacianPositive`**
 - **Added `Kernal2D.LaplacianNegative`**

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
