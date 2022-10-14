1.1.0
===

### `Vision.hx`

 - **Added `erode()`**
 - **Added `dilate()`**
 - **Added `robertEdgeDiffOperator()`**, using the newly implemented `RobertsCross` algorithm.
 - **Added `bilateralDenoise`**, using the newly implemented `BilateralFilter` algorithm.
### `vision.ds`

 - Added `Array2D`
 - Added `Kernal2D.LaplacianPositive`
 - Added `Kernal2D.LaplacianNegative`

### `vision.tools`

 - **Added `MathTools.clamp()`**, which keeps a given number between a `min` and a `max`.
 - **Added `MathTools.raise()`**, which raises a given `1D` array/vector into a `2D` array/matrix
 - **Added `ImageTools.getNeighborsOfPixelIter()`**, which returns a for-loop friendly iterator over the neighboring pixels.
 - **Added full `ImageTools.loadFromFile` support on sys targets**. This change allows you to load images from URLs in a cross platform fashion.
  
### `vision.exceptions`

 - **Added `LibraryRequired`**, thrown when a method/field depends on a missing library.