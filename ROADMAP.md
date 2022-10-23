# Roadmap

Here is a roadmap of all features added/planned for the future:

> **Bold** means high priority,  
> Regular means medium priority,  
> *Italic* means low priority.  
> 


#### class `Vision`:
 
 - [x] `grayscale()`
 - [x] `blackAndWhite()`
 - [x] `invert()`
 - [x] `sharpen()`
 - [x] `deepfry()` 
 - [x] `erode()`
 - [x] `dilate()`
 - [x] `convolve()`
 - [x] `contrast()`
 - [x] `normalize()`
 - [x] `combine()`
 - [x] `limitColorRanges()` 
 - [x] `replaceColorRanges()` 
 - [x] `saltAndPepperNoise()`
 - [ ] `gaussianNoise()`
 - [x] `whiteNoise()`
 - [x] `dropOutNoise()`
 - [x] `simpleLineDetector()`
 - [x] `convolutionRidgeDetection()`
 - [ ] *`robertEdgeDetection()`*
 - [x] `robertEdgeDiffOperator`
 - [x] `laplacianEdgeDetection`
 - [x] `laplacianEdgeDiffOperator`
 - [x] `perwittEdgeDetection()`
 - [x] `perwittEdgeDiffOperator()`
 - [x] `sobelEdgeDiffOperator()`
 - [x] `sobelEdgeDetection()`
 - [x] `cannyEdgeDetection()`
 - [ ] `houghRay2DDetection()`
 - [ ] `houghLine2DDetection()`
 - [ ] `harrisCornerDetection()`
 - [ ] `forstnerCornerDetection()`
 - [x] `nearestNeighborBlur()`
 - [x] `gaussianBlur()`
 - [x] `medianBlur()` 
 - [x] `bilateralDenoise()`
 - [ ] `nonLocalMeansDenoise()` 
 - [ ] `nonLocalIsolativeDenoise()`

#### class `Image`:

 - [x] `getPixel()`
 - [x] `getFloatingPixel()`
 - [x] `getSafePixel()` 
 - [x] `setPixel()`
 - [x] `hasPixel()`
 - [x] `hasPixelInView()`
 - [x] `paintPixel()`
 - [ ] matrix access `image[x][y]`
 - [x] Drawing:
   - [x] `fillColor()`
   - [x] `fillColorRecursive()`
   - [x] `fillUntilColor()`
   - [x] `drawLine2D()`
   - [x] `drawRay2D()`
   - [x] `drawRect()`
   - [x] `drawCircle()`
   - [x] `drawEllipse()`
   - [x] `drawQuadraticBezier()`
   - [x] `drawCubicBezier()`
   - [x] `fillRect()`
   - [x] `fillCircle()`
   - [ ] `drawText` 
 - [x] Copying:
   - [x] `clone()`
   - [x] `getImagePortion()`
   - [x] `setImagePortion()`
   - [x] `copyPixelFrom()`
 - [ ] Manipulation:
   - [x] `view`:
     - [x] `image.view`
     - [x] `hasView()`  
     - [x] `getView()`  
     - [x] `setView()`  
     - [x] `removeView()`  
   - [x] `forEachPixel()`
   - [x] `forEachPixelInView()`
   - [x] `iterator()`
   - [x] `mirror()`  
   - [x] `flip()`
   - [ ] `resize()`:
     - [x] `NearestNeighbor`
     - [x] `BilinearInterpolation`
     - [ ] `BicubicInterpolation`
