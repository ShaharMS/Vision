package vision;

import vision.algorithms.Laplacian;
import vision.ds.specifics.ColorImportanceOrder;
import vision.algorithms.BilateralFilter;
import vision.algorithms.RobertsCross;
import vision.ds.IntPoint2D;
import haxe.extern.EitherType;
import vision.algorithms.Radix;
import haxe.ds.ArraySort;
import vision.ds.Histogram;
import vision.ds.specifics.AlgorithmSettings;
import haxe.Timer;
import vision.helpers.VisionThread;
import vision.algorithms.Perwitt;
import vision.algorithms.Sobel;
import vision.ds.Kernal2D;
import vision.ds.canny.CannyObject;
import vision.algorithms.SimpleLineDetector;
import vision.ds.gaussian.GaussianKernalSize;
import vision.ds.hough.HoughSpace;
import vision.ds.Ray2D;
import vision.algorithms.Gaussian;
import vision.algorithms.Hough;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools;

using vision.tools.MathTools;
using vision.tools.ImageTools;
using vision.algorithms.Canny;

/**
	The class where all image manipulation & computer vision functions are stored.

	If you're going to make extensive use of this class, it is recommended to use this as a static extension:

	```haxe
	using vision.Vision;
	```
**/
class Vision {
	/**
		Grayscales an image, by averaging the color channels of each pixel.

		To get a higher quality grayscale, define `vision_better_grayscale`

		Example (both with & without `vision_better_grayscale`):

		| Original | Regular | `vision_better_grayscale` |
		|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-grayscale.png)|![After](https://spacebubble.io/vision/docs/valve-grayscale&vision_better_grayscale.png)|

		@param image The image to be grayscaled.

		@return The grayscaled image.
	**/
	public static function grayscale(image:Image):Image {
		for (i in 0...image.width) {
			for (j in 0...image.height) {
				var pixel = image.getPixel(i, j);
				var gray = #if vision_better_grayscale Std.int(0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue) #else Std.int((pixel.red
					+ pixel.green + pixel.blue) / 3) #end;
				image.setPixel(i, j, Color.fromRGBA(gray, gray, gray));
			}
		}
		return image;
	}

	/**
		Inverts an image.

		Inversion is just flipping the values of each color channel - `0xFFFFFF` will turn into `0x000000`, `0xFF00FF` will turn into `0x00FF00`, etc.

		The math behind inversion is just subtracting the current value of the channel from `0xFF`:

		| Color | Process | Result|
		|:---:|:---:|:---:|
		|`0xFFFF00` |FF - FF = **`00`**, FF - FF = **`00`**, FF - 00 = **`FF`**| `0x0000FF` |
		|`0xB13FFF` |FF - B1 = **`E4`**, FF - 3F = **`C0`**, FF - FF = **`00`**| `0xE4C000` |

		Example:

		| Original | Inverted |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-invert.png)|

		@param image The image to be inverted.

		@return The inverted image.
	**/
	public static function invert(image:Image) {
		for (i in 0...image.width) {
			for (j in 0...image.height) {
				var pixel = image.getPixel(i, j);
				image.setPixel(i, j, Color.fromRGBA(255 - pixel.red, 255 - pixel.green, 255 - pixel.blue));
			}
		}
		return image;
	}

	/**
		Converts an image to COMPLETE black and white.

		It does so by taking the color channel with the highest value, and checking if that maximum surpasses `threshold`.

		| Original | `threshold = 128` |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-blackAndWhite.png)|

		@param image The image to be converted.
		@param threshold The threshold for converting to black and white: 
		`threshold` is the maximum average of the three color components.
		that will still be considered black. `threshold` is a value between 0 and 255.
		The higher the value, the more "sensitive" the conversion. The default value is 128.

		@return The converted image.
	**/
	public static function blackAndWhite(image:Image, threshold:Int = 128):Image {
		for (i in 0...image.width) {
			for (j in 0...image.height) {
				var pixel = image.getPixel(i, j);
				var colorValue:Int = MathTools.max(pixel.red, pixel.green, pixel.blue);
				if (colorValue > threshold) {
					image.setPixel(i, j, 0xFFFFFFFF);
				} else {
					image.setPixel(i, j, Color.fromInt(0));
				}
			}
		}
		return image;
	}

	/**
		Gets a contrast-enhanced version of an image,
		with more exaggerated colors.

		| Original | Processed |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-contrast.png)|

		@param image The image to be contrasted.
	**/
	public static function contrast(image:Image):Image {
		return convolve(image, UnsharpMasking);
	}

	/**
		Returns a sharpened version of the provided image.

		When an image is sharpened. it's color differences are exaggerated. The more times
		the image is sharpened, the more "deepfried" it'll look.

		Example:

		| Original | Sharpened |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-sharpen.png)|

		@param image The image to be contrasted.
		@return The sharpened image. The original copy is not preserved.
	**/
	public static function sharpen(image:Image):Image {
		return convolve(image, Sharpen);
	}

	/**
		Deepfries an image by running to through a sharpening filter `iterations` times.

		Example:

		| Original | `iterations = 2` |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-deepfry.png)|

		The higher the value, the more deepfried the image will look.
		@param image The image to be deepfried
		@param iterations The amount of times the image gets sharpened. default is `2`
		@return The deepfried image. the original copy is not preserved.
	**/
	public static function deepfry(image:Image, iterations:Int = 2):Image {
		for (i in 0...iterations)
			image = sharpen(image);
		return image;
	}

	public static function erode(image:Image, ?erosionRadius:Int = 2, colorImportanceOrder:ColorImportanceOrder = RedGreenBlue):Image {
		var intermediate = new Image(image.width, image.height);
		image.forEachPixel((x, y, color) -> {
			var maxColor:Color = 0;
			for (color in image.getNeighborsOfPixelIter(x, y, erosionRadius * 2 + 1)) {
				color &= colorImportanceOrder;
				final redLarger = color.red > maxColor.red ? 1 : 0;
				final greenLarger = color.green > maxColor.green ? 1 : 0;
				final blueLarger = color.blue > maxColor.blue ? 1 : 0;
				if (redLarger + blueLarger + greenLarger >= 2) maxColor = color;
			}
			intermediate.setPixel(x, y, maxColor);
		});
		return image = intermediate;
	}

	public static function dilate(image:Image, ?dilationRadius:Int = 2, colorImportanceOrder:ColorImportanceOrder = RedGreenBlue):Image {
		var intermediate = new Image(image.width, image.height);
		image.forEachPixel((x, y, color) -> {
			var minColor:Color = 0;
			for (color in image.getNeighborsOfPixelIter(x, y, dilationRadius * 2 + 1)) {
				color &= colorImportanceOrder;
				final redSmaller = color.red < minColor.red ? 1 : 0;
				final greenSmaller = color.green < minColor.green ? 1 : 0;
				final blueSmaller = color.blue < minColor.blue ? 1 : 0;
				if (redSmaller + blueSmaller + greenSmaller >= 2) minColor = color;
			}
			intermediate.setPixel(x, y, minColor);
		});
		return image = intermediate;
	}

	/**
		Limits the range of colors on an image, by resizing the range of a given color channel, according to the values
		of `rangeStart`'s and `rangeEnd`'s color channels.
		
		### How Does this work?
		
		1. before calculating anything, you get the min & max values of each color channel from the two given colors.
		For example, if `rangeStart` is `0xFF05F243` and `rangeEnd` is `0x239A6262`, the min/max values of the `red` channel 
		will be set to (`0x05`, `0x9A`), the min/max values of the green channel will be set to (`0x62`, `0xF2`)...
		2. Loop over the pixels, and calculate the ratios between the the pixel's color channel's and the values (`0x00`, `0xFF`)
		3. Now, calculate the step between each color value of the new range, by dividing each channel's (`max` - `min`) by `255`. the
		default step between each color value is `1` by default (`(0xFF - 0x00) / 0xFF = 1`).
		4. Loop over the channels, and multiply their value by the value of the new `step` (for example, 4
		`newStep = (0x88 - 0x00) / 0xFF = 0.5`, `color.red = color.red * newStep`);
		5. enjoy your normalized image :)
		
		
		@param image The image to be normalized
		@param rangeStart The start of the range of channels. By default, this value is `0x00000000`
		@param rangeEnd The end of the range of channels. By default, this value is `0xFFFFFFFF
		@return The normalized image. The original copy is not preserved.
	**/
	public static function normalize(image:Image, rangeStart:Color = 0x00000000, rangeEnd:Color = 0xFFFFFFFF):Image {
		var max:Color = 0x0, min:Color = 0x0, step:Color = 0x0;
		max.red = MathTools.max(rangeStart.red, rangeEnd.red);
		min.red = MathTools.min(rangeStart.red, rangeEnd.red);
		max.green = MathTools.max(rangeStart.green, rangeEnd.green);
		min.green = MathTools.min(rangeStart.green, rangeEnd.green);
		max.blue = MathTools.max(rangeStart.blue, rangeEnd.blue);
		min.blue = MathTools.min(rangeStart.blue, rangeEnd.blue);
		step.redFloat = (max.red - min.red) / 0xFF;
		step.blueFloat = (max.blue - min.blue) / 0xFF;
		step.greenFloat = (max.green - min.green) / 0xFF;

		image.forEachPixel((x, y, color) -> {
			color.redFloat *= step.redFloat;
			color.blueFloat *= step.blueFloat;
			color.greenFloat *= step.greenFloat;
			image.setPixel(x, y, color);
		});
		return image;
	}

	/**
		Limits the range of colors on an image, by limiting the range of a given color channel, according to the values
		of `rangeStart`'s and `rangeEnd`'s color channels.
		
		@param image The image to be li processed
		@param rangeStart The start of the range of channels. By default, this value is `0x00000000`
		@param rangeEnd The end of the range of channels. By default, this value is `0xFFFFFFFF
		@return The normalized image. The original copy is not preserved.
	**/
	public static function limitColorRanges(image:Image, rangeStart:Color = 0x00000000, rangeEnd:Color = 0xFFFFFFFF):Image {
		image.forEachPixel((x, y, color) -> {
			color.red = MathTools.boundInt(color.red, rangeStart.red, rangeEnd.red);
			color.blue = MathTools.boundInt(color.blue, rangeStart.blue, rangeEnd.blue);
			color.green = MathTools.boundInt(color.green, rangeStart.green, rangeEnd.green);
			image.setPixel(x, y, color);
		});
		return image;
	}

	/**
		Replaces the colors inside each range with the given color inside that range object:  
		```haxe
		[{rangeStart: 0x00000000, rangeEnd = 0x88888888, replacement: 0xFFFFFFFF}] 
		```
		will replace every pixel inside the given color range with the color `0xFFFFFFFF`
		
		@param image The image process
		@param ranges array of color ranges & replacement colors.
		@return A processed version of the image. The original image is not preserved
	**/
	public static function replaceColorRanges(image:Image, ?ranges:Array<{rangeStart:Color, rangeEnd:Color, replacement:Color}>):Image {
		if (ranges == null) return image;
		for (range in ranges) {
			final rangeStart = range.rangeStart;
			final rangeEnd = range.rangeEnd;
			final with = range.replacement;
			image.forEachPixel((x, y, color) -> {
				var original:Int = color;
				color.red = MathTools.isBetweenRanges(color.red, {start: rangeStart.red, end: rangeEnd.red}) ? color.red : with.red;
				color.blue = MathTools.isBetweenRanges(color.blue, {start: rangeStart.blue, end: rangeEnd.blue}) ? color.blue : with.blue;
				color.green = MathTools.isBetweenRanges(color.green, {start: rangeStart.green, end: rangeEnd.green}) ? color.green : with.green;
				if (color == original) image.setPixel(x, y, color) else image.setPixel(x, y, with);
			});
		}
		return image;
	}

	/**
		manipulates the image's pixel data by passing the pixels' value through a kernal.

		This is useful for many things, such as simple blurring, sharpening, noise maps, and more that comes to mind :).

		There are a couple of preexisting matrices you can use, and also a custom tool to let you create your own kernals from scratch using enums.

		### How does this work?

		simply put, it takes each pixel, and multiples its surrounding pixels by the values you give the matrix.

		In the following demo, you can see how convolution works for the `Sharpen` matrix:

		![Sharpen Convolution](https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/2D_Convolution_Animation.gif/220px-2D_Convolution_Animation.gif)

		1. multiply the current pixel's value by the value of the center of the matrix
		1. multiply the current pixel's immediate neighbors (vertical/horizontal) by the matching value on the matrix 
		(the pixel to the right of the current pixel will be multiplied by the value to the right of the center of the matrix)
		1. do the same thing with the other neighbors
		1. enjoy your convolved image :)

		@param image the image to be manipulated
		@param kernal the type/value of the kernal. can be: **`Identity`**, **`BoxBlur`**, **`RidgeDetection`**, **`Sharpen`**, **`UnsharpMasking`**, **`Assemble3x3`**, **`Assemble5x5`**,
		or just a matrix: both `convolve(image, BoxBlur)` and `convolve(image, [[1,1,1],[1,1,1],[1,1,1]])` are valid ways to represent a box blur.
		@return A convolved version of the image. The original image is not preserved
	**/
	public static function convolve(image:Image, kernal:EitherType<Kernal2D, Array<Array<Float>>> = Identity):Image {
		var matrix:Array<Array<Float>>;
		if (kernal is Array) {
			matrix = cast kernal;
		} else {
			matrix = switch cast(kernal, Kernal2D) {
				case Identity: [[0, 0, 0], [0, 1, 0], [0, 0, 0]];
				case BoxBlur: [[1, 1, 1], [1, 1, 1], [1, 1, 1]];
				case RidgeDetection: [[-1, -1, -1], [-1, 4, -1], [-1, -1, -1]];
				case RidgeDetectionAggressive: [[-1, -1, -1], [-1, 7.75, -1], [-1, -1, -1]];
				case Sharpen: [[0, -1, 0], [-1, 5, -1], [0, -1, 0]];
				case UnsharpMasking: [
						[1, 4, 6, 4, 1],
						[4, 16, 24, 16, 4],
						[6, 24, -476, 24, 6],
						[4, 16, 24, 16, 4],
						[1, 4, 6, 4, 1]
					];
				case Assemble3x3(corner, edge, center): [[corner, edge, corner], [edge, center, edge], [corner, edge, corner]];
				case Assemble5x5(farCorner, farEdge, edge, midCorner, midEdge, center): [
						[farCorner, farEdge, edge, farEdge, farCorner],
						[farEdge, midCorner, midEdge, midCorner, farEdge],
						[edge, midEdge, center, midEdge, edge],
						[farEdge, midCorner, midEdge, midCorner, farEdge],
						[farCorner, farEdge, edge, farEdge, farCorner]
					];
				case Custom(kernal): kernal;
				case GaussianBlur(size, sigma): Gaussian.createKernalOfSize(size, sigma).inner.raise(size);
				case LaplacianPositive: [[0, 1, 0], [1, -4, 1], [0, 1, 0]];
				case LaplacianNegative: [[0, -1, 0], [-1, 4, -1], [0, -1, 0]];
			}
		}

		var convolved = new Image(image.width, image.height);
		var maxLength = -1;
		for (array in matrix) {
			if (array.length > maxLength)
				maxLength = array.length;
		};
		var flatMatrix = matrix.flatten();
		var denominator = 0.;
		for (number in flatMatrix)
			denominator += number;
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				var i = 0;
				var red = 0., green = 0., blue = 0.;
				for (color in image.getNeighborsOfPixelIter(x, y, maxLength)) {
					red += flatMatrix[i] * color.red;
					blue += flatMatrix[i] * color.blue;
					green += flatMatrix[i] * color.green;
					i++;
				}
				red /= denominator;
				green /= denominator;
				blue /= denominator;
				convolved.setPixel(x, y, Color.fromRGBA(Std.int(red), Std.int(green), Std.int(blue)));
			}
		}
		return image = convolved;
	}

	/**
		Uses an iterative, nearest-neighbor style algorithm to blur an image.

		The algorithm is very simple and quite fast, but also very sensitive 
		performance-wise. The maximum value recommended to use for the 
		`iterations` property is 100, altho you shouldn't really find yourself using more than `25`.

		Example:

		| Original | `iterations = 1` | `iterations = 4` |
		|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-nearestNeighborBlur%28iterations%20=%201%29.png)|![After](https://spacebubble.io/vision/docs/valve-nearestNeighborBlur%28iterations%20=%204%29.png)|

		@param image The image to be blurred.
		@param iterations The number of times the algorithm will be run. the more iterations, the more blurry the image will be, and the higher the "blur range". for example: a value of 3 will produce a blur range of 3 pixels on each object.

		@return A blurred version of the image. The original image is not preserved
	**/
	public static function nearestNeighborBlur(image:Image, iterations:Int = 1):Image {
		for (i in 0...iterations) image = convolve(image, BoxBlur);
		return image;
	}

	/**
		Uses the gaussian blur algorithm to blur an image.

		This algorithm works by creating a 5x5 (thats the default size) matrix, and then applying
		the gaussian distribution function to that matrix.

		That matrix will go over each pixel and decide it's color based on the values of 
		the pixels covered by the 5x5 matrix, and the [gaussian distribution function](https://en.wikipedia.org/wiki/Gaussian_function).

		You can modify the values of the matrix by passing a float to the `sigma` parameter.
		The higher the value of `sigma`, the blurrier the image:
		
		| Original | `sigma = 0.5` | `sigma = 1` | `sigma = 2` |
		|---|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-gaussianBlur%28sigma%20=%200.5%29.png)|![After](https://spacebubble.io/vision/docs/valve-gaussianBlur%28sigma%20=%201%29.png)|![After](https://spacebubble.io/vision/docs/valve-gaussianBlur%28sigma%20=%202%29.png)|

		@param image The image to be blurred
		@param sigma The sigma value to use for the gaussian distribution on the kernal. a lower value will focus more on the center pixel, while a higher value will shift focus to the surrounding pixels more, effectively blurring it better.
		@param kernalSize The size of the kernal (`width` & `height`)
		@throws InvalidGaussianKernalSize if the kernal size is even, negative or `0`, this error is thrown.
		@return A blurred version of the image. The original image is not preserved
	**/
	public static function gaussianBlur(image:Image, ?sigma:Float = 1, ?kernalSize:GaussianKernalSize = GaussianKernalSize.X5):Image {
		return convolve(image, GaussianBlur(kernalSize, sigma));
	}

	/**
		Applies a median filter to an image to reduce the amount of noise in that image.

		Median filter "blurs" the image by taking a pixel & its surrounding, 
		finding the median of that group, and setting the center pixel to that median.

		Example of the filter in action:

		| Original | `kernalSize = 5` | `kernalSize = 10` | `kernalSize = 15` |
		|---|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-medianBlur%28kernalRadius%20=%205%29.png)|![After](https://spacebubble.io/vision/docs/valve-medianBlur%28kernalRadius%20=%2010%29.png)|![After](https://spacebubble.io/vision/docs/valve-medianBlur%28kernalRadius%20=%2015%29.png)|

		@param image The image to apply median blurring to.
		@param kernalSize the width & height of the kernal in which we should search for the median. a radius of `9` will check in a `19x19` (`radius(9)` + `center(1)` + `radius(9)`) square around the center pixel.
		@return A filtered version of the image, using median blurring. The original image is not preserved
	**/
	public static function medianBlur(image:Image, kernalSize:Int = 5):Image {
		var median = new Image(image.width, image.height);
		image.forEachPixel((x, y, color) -> {
			var neighbors:Array<UInt> = image.getNeighborsOfPixel(x, y, kernalSize).inner;
			ArraySort.sort(neighbors, (a, b) -> a - b);
			median.setPixel(x, y, neighbors[Std.int(neighbors.length / 2)]);
		});

		return image = median;
	}

	/**
		Uses a simple, partially recursive algorithm to detect line segments in an image.

		those lines can be partially incomplete, but they will be detected as lines.

		@param image The image to be line detected.
		@param accuracy When a line is detected, the algorithm checks how much of the line actually covers a 
		"line portion" of the image. `accuracy` is set to `50` by default - at least half of the line has to match with the image.
		To optimize for line count, `40` and below is recommended. otherwise, `50` to `60` should be fine.
		@param minLineLength The minimum length of a line segment to be detected.
		@param speedToAccuracyRatio  If the algorithm is too slow/too inaccurate for you, you can change this setting.

		@return The line detected image.
	**/
	public static function simpleLine2DDetection(image:Image, accuracy:Float = 50, minLineLength:Float = 10, ?speedToAccuracyRatio:AlgorithmSettings = Medium_Intermediate):Array<Line2D> {
        final kernalSize = switch speedToAccuracyRatio {
            case VeryLow_VeryFast: X1;
            case Low_Fast: X3;
            case Medium_Intermediate: X5;
            case High_Slow: X7;
            case VeryHigh_VerySlow: X9;
        }
        var edgeDetected = cannyEdgeDetection(image, 1, kernalSize, 0.05, 0.16);
        var lines:Array<Line2D> = [];
		var actualLines:Array<Line2D> = [];
        for (x in 0...image.width) {
            for (y in 0...image.height) {
				lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, false, true));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true, true));
            }
        }
        for (l in lines) {
            if (l == null) continue;
            if (SimpleLineDetector.lineCoveragePercentage(edgeDetected, l) < accuracy) continue;
            actualLines.push(l);
        }
		lines = [];
        //now, get a mirrored version
        edgeDetected = cannyEdgeDetection(image.mirror(), 1, kernalSize, 0.05, 0.16);
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, false, true));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true, true));
            }
        }
        for (l in lines) {
            if (l == null) continue;
            if (SimpleLineDetector.lineCoveragePercentage(edgeDetected, l) < accuracy) continue;
            actualLines.push(l.mirrorInsideRectangle({x: 0, y: 0, width: image.width, height: image.height}));
        }
        return actualLines;
    }

	/**
		Applies the sobel filter to an image.

		The image doesn't have to get grayscaled before being passed 
		to this function.
		
		It is different from the `sobelEdgeDetection` function, since
		it doesn't try to threshold the resulting image to extract the strong edges,
		and leaves that information in. Example of this filter in action:

		| Original | After Filtering |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-sobelEdgeDiffOperator.png)|

		@param image The image to be operated on
		@return A new image, containing the gradients of the edges as whitened pixels.
	**/
	public static function sobelEdgeDiffOperator(image:Image) {
		return Sobel.convolveWithSobelOperator(grayscale(image.clone()));
	}

	/**
		Applies the perwitt filter to an image.
		
		The image doesn't have to get grayscaled before being passed 
		to this function.
		
		It is different from the `perwittEdgeDetection` function, since
		it doesn't try to threshold the resulting image to extract the strong edges,
		and leaves that information in. Example of this filter in action:
		
		| Original | After Filtering |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-perwittEdgeDiffOperator.png)|

		@param image The image to be operated on
		@return A new image, containing the gradients of the edges as whitened pixels.
	**/
	public static function perwittEdgeDiffOperator(image:Image) {
		return Perwitt.convolveWithPerwittOperator(grayscale(image.clone()));
	}

	/**
		Applies the Robert's Cross operator to an image.
		
		The image doesn't have to get grayscaled before being passed 
		to this function.
		
		While being the one of the oldest forms of edge gradient operators (dates back to 1963!),
		Its one of the fastest, if not *the* fastest.

		It does have its caveats though: while generally being 2x faster, its *way* more sensitive to noise, and may produce a more "jagged" image.
		
		| Original | After Filtering |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-robertEdgeDiffOperator.png)|

		@param image The image to be operated on
		@return A new image, containing the gradients of the edges as whitened pixels.
	**/
	public static function robertEdgeDiffOperator(image:Image) {
		return RobertsCross.convolveWithRobertsCross(grayscale(image.clone()));
	}

	/**
		Applies the laplacian filter to an image.
		
		The image doesn't have to get grayscaled before being passed 
		to this function.
		
		It is different from the `perwittEdgeDetection` function, since
		it doesn't try to threshold the resulting image to extract the strong edges,
		and leaves that information in. Example of this filter in action:
		
		| Original | After Filtering (Positive) | After Filtering (Negative) |
		|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-laplacianEdgeDiffOperator%28filterPositive%20=%20true%29.png)|![After](https://spacebubble.io/vision/docs/valve-laplacianEdgeDiffOperator%28filterPositive%20=%20true%29.png)|

		@param image The image to be operated on
		@param filterPositive Which version of the laplacian filter should the function use: the negative (detects "outward" edges), or the positive (detects "inward" edges). Default is positive (`true`).
		@return A new image, containing the gradients of the edges as whitened pixels.
	**/
	public static function laplacianEdgeDiffOperator(image:Image, filterPositive:Bool = true) {
		return Laplacian.convolveWithLaplacianOperator(image.clone(), filterPositive);
	}

	/**
		Uses Canny's edge multi stage edge detection algorithm to detect edges in an image,
		while reducing noise.

		This algorithm works by first applying a gaussian blur to the image, and then
		applying more filters to differentiate between strong edges, weak edges and non-edges.

		Example:

		| Original | Edge Detected (default settings) |
		|---|:---:|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-cannyEdgeDetection.png)|

		@param image The image to be edge detected.
		@param sigma The sigma value to be used in the gaussian blur.
		@param kernalSize This is used for the second step of the canny edge detection - gaussian blur. unless you want to improve performance, this should remain unchanged.
		@param lowThreshold The low threshold value to be used in the hysteresis thresholding.
		@param highThreshold The high threshold value to be used in the hysteresis thresholding.

		@throws InvalidGaussianKernalSize thrown if the `kernalSize` is negative/divisible by `2`.
		@return The edge detected image.
	**/
	public static function cannyEdgeDetection(image:Image, sigma:Float = 1, kernalSize:GaussianKernalSize = X5, lowThreshold:Float = 0.05, highThreshold:Float = 0.2):Image {
		var cannyObject:CannyObject = image.clone();
		return blackAndWhite(cannyObject.grayscale()
			.applyGaussian(kernalSize, sigma)
			.applySobelFilters()
			.nonMaxSuppression()
			.applyHysteresis(highThreshold, lowThreshold),
			40);
	}

	/**
		Detects edges within an image.

		Edges are detected using the Sobel operator, going from left to right and top to bottom.

		To improve angle related errors with the sobel operator, Scharr's optimized version is used.

		There's no need to pre-process the image, just throw it on it and it will do the rest
		(ie. it doesn't need to be grayscaled/black and white):

		| Before | After |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-sobelEdgeDetection.png)|

		@param image The image to be processed.
		@param threshold The threshold for detecting edges. The lower the value, 
		the more pixels will be considered edges. Default is `500`

		@return The image with edges detected. This image is returned as a new, black and white image.
	**/
	public static function sobelEdgeDetection(image:Image, threshold:Float = 500):Image {
		return Sobel.detectEdges(image, threshold);
	}

	/**
		Detects edges within an image.

		Edges are detected using the Perwitt operator, going from left to right and top to bottom.

		There's no need to pre-process the image, just throw it on it and it will do the rest
		(ie. it doesn't need to be grayscaled/black and white):

		| Before | After |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-perwittEdgeDetection.png)|

		@param image The image to be processed.
		@param threshold The threshold for detecting edges. The lower the value, 
		the more pixels will be considered edges. Default is `100`

		@return The image with edges detected. This image is returned as a new, black and white image.
	**/
	public static function perwittEdgeDetection(image:Image, threshold:Float = 100):Image {
		return Perwitt.detectEdges(image, threshold);
	}

	/**
		Detects edges within an image, using a gaussian blur & the laplacian filter.

		This algorithm works a bit like a combination of canny & perwitt edge detection, by blurring the image first to remove noise, and then
		going over the image with a kernal. With the default settings. This algorithm is the fastest when working with smaller images.

		There's no need to pre-process the image, just throw it into the function it will do the rest
		(ie. the image doesn't need to be grayscale/black and white):

		| Original | After Filtering (Positive) | After Filtering (Negative) |
		|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-laplacianOfGaussianEdgeDetection%28filterPositive%20=%20true%29.png)|![After](https://spacebubble.io/vision/docs/valve-laplacianOfGaussianEdgeDetection%28filterPositive%20=%20true%29.png)|

		@param image The image to be processed.
		@param threshold The threshold for detecting edges. The lower the value, the more pixels will be considered edges. Default is `5`.
		@param filterPositive Which version of the laplacian filter should the function use: the negative (detects "outward" edges), or the positive (detects "inward" edges). Default is positive (`true`).
		@param sigma The sigma value to use for the gaussian blur. a lower value will focus the kernal more on the center pixel, while a higher value will shift focus to the surrounding pixels more. **The higher the value, the blurrier the image.** Default is `1`.
		@param kernalSize The size of the kernal (`width` & `height`) - a kernal size of `7`/ will produce a `7x7` kernal. Default is `GaussianKernalSize.X3`.
		@return A new, black and white image, with white pixels being the detected edges.
	**/
	public static function laplacianOfGaussianEdgeDetection(image:Image, ?threshold:Int = 2, ?filterPositive:Bool = true, ?sigma:Float = 1, ?kernalSize:GaussianKernalSize = X3) {
		return Laplacian.laplacianOfGaussian(image, kernalSize, sigma, threshold, filterPositive);
	}

	/**
		Uses a fast, convolution-based method to detect ridges within an image.
		
		It does the detection by grayscaling & normalizing the image, and then
		convolving it with a ridge detection kernal.

		Useful as a fast alternative to other **edge** detection algorithms, since it usually
		produces the most accurate edge representation while being the fastest (`1.5x` faster than sobel & perwitt, 
		exponentially faster than canny (image size dependent)).  

		**Comparison:**
		  
		| Algorithm | Output | Time Complexity |
		|:---:|---|:---:|
		|None|![Perwitt Edge Detection](https://spacebubble.io/vision/docs/valve-original.png)| - |
		|**`perwittEdgeDetection`**|![Perwitt Edge Detection](https://spacebubble.io/vision/docs/valve-perwittEdgeDetection.png)| `O(width*height)` |
		|**`sobelEdgeDetection`**|![Sobel Edge Detection](https://spacebubble.io/vision/docs/valve-sobelEdgeDetection.png)| `O(width*height)` |
		|**`cannyEdgeDetection`**|![Perwitt Edge Detection](https://spacebubble.io/vision/docs/valve-cannyEdgeDetection.png)| `O(width*height log(width* height))` |
		|**`convolutionRidgeDetection`**|![Perwitt Edge Detection](https://spacebubble.io/vision/docs/valve-convolutionRidgeDetection.png)| `O(width*height)` |

		@param image the image to be ridge detected on
		@param normalizationRangeStart Optional, if you want to change the normalization range's start color. `0x44444444` by default.
		@param normalizationRangeEnd Optional, if you want to change the normalization range's end color `0xBBBBBBBB` by default.
		@param refine Appends an iterative pixel check to the algorithm, which removes isolated ridge pixels. `false` by default for performance reasons.
		@return The ridge-highlighted version of the image. **The original copy is preserved**
	**/
	public static function convolutionRidgeDetection(image:Image, ?normalizationRangeStart:Color = 0xFF444444, ?normalizationRangeEnd:Color = 0xFFBBBBBB, refine:Bool = false):Image {
		var clone = image.clone();
		Vision.grayscale(clone);
		Vision.normalize(clone, normalizationRangeStart, normalizationRangeEnd);
		clone = Vision.convolve(clone, RidgeDetectionAggressive);
		clone = Vision.replaceColorRanges(clone, [{rangeStart: 0xFF000000, rangeEnd: 0xFFAAAAAA, replacement: 0xFF000000}]);
		if (!refine) return clone;
		blackAndWhite(clone);
		clone.forEachPixel((x, y, color) -> {
			var neighbors = clone.getNeighborsOfPixelIter(x, y, 3);
			var count = 0;
			for(c in neighbors) if(c == color) count++;
			if (count <= 1) clone.setPixel(x, y, 0);
		});
		return clone;
	}

	/**
	    Applies the Bilateral Filter to the given image.  
		The bilateral filter denoises an image by using a "blur", 
		similar to the gaussian blur, but it differs from the gaussian blur 
		by assigning different weights & intensities to different pixels, 
		depending on their color differences, and not only their positions.
	    

		| Original | Sharpened | Sharpened (Denoised) |
		|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-sharpen.png)|![After](https://spacebubble.io/vision/docs/valve-bilateralDenoise)|

		@param image The image to operate on
		@param gaussianSigma The sigma to use when generating the gaussian kernal. This also decides the size of the kernal (The size of the kernal is always `Math.round(6 * gaussianSigma)`, and gets incremented if the resulting size is even)
		@param intensitySigma The intensity sigma decides how hard should the algorithm "try" to reduce the noise inside the image. A higher value causes a pixel that has vastly different color than it's surrounding to weigh much less, and pretty much get "ignored and overwritten". **tl;dr - a higher value reduces more noise, but may blur the image if too high.**

	**/
	public static function bilateralDenoise(image:Image, gaussianSigma:Float = 0.8, intensitySigma:Float = 50):Image {
		return BilateralFilter.filter(image, gaussianSigma, intensitySigma);
	}
}
