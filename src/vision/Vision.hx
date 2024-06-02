package vision;

import vision.ds.TransformationMatrix2D;
import vision.ds.specifics.TransformationMatrixOrigination;
import vision.ds.Point3D;
import vision.ds.specifics.ImageExpansionMode;
import vision.algorithms.PerspectiveWarp;
import vision.ds.specifics.PointTransformationPair;
import vision.algorithms.BilinearInterpolation;
import vision.ds.Matrix2D;
import vision.ds.Int16Point2D;
import haxe.ds.Vector;
import vision.ds.specifics.WhiteNoiseRange;
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
import vision.algorithms.Perwitt;
import vision.algorithms.Sobel;
import vision.ds.Kernel2D;
import vision.ds.canny.CannyObject;
import vision.algorithms.SimpleLineDetector;
import vision.ds.gaussian.GaussianKernelSize;
import vision.ds.hough.HoughSpace;
import vision.ds.Ray2D;
import vision.algorithms.Gauss;
import vision.algorithms.Hough;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools;
import vision.tools.MathTools.*;

using vision.tools.MathTools;
using Math;
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
	    Combines two images by averaging out the values of each pixel's color channels, according to `percentage`.

		The images can be of different sizes. 
		
		| Original | Combined With Default |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-combine.png)|

		@param image The image to combine on. When this function returns, that image should be modified
		@param with The second image to combine with. That image is preserved throughout the function.
		@param percentage The ratio between the contributions of each pixel within the two images, from 0 to 100: a lower value will make the first image's pixels contribute more to the the final image, thus making that image more similar to the first image, and vice-versa.
	**/
	public static function combine(image:Image, ?with:Image, percentage:Float = 50) {
		if (with == null) with = new Image(image.width, image.height);
		final translated = percentage / 100;
		image.forEachPixelInView((x, y, first) -> {
			var second = with.getSafePixel(x, y);
			first.red = Math.round((first.red * (1 - translated) + second.red * translated));
			first.blue = Math.round((first.blue * (1 - translated) + second.blue * translated));
			first.green = Math.round((first.green * (1 - translated) + second.green * translated));
			image.setUnsafePixel(x, y, first);
		});
		return image;
	}
	/**
		Grayscales an image, by averaging the color channels of each pixel.

		If for some reason, you want to get a lower quality grayscale, set `simpleGrayscale` to `true`.

		Example:

		| Original | `simpleGrayscale` | `!simpleGrayscale` default) |
		|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-grayscale.png)|![After](https://spacebubble.io/vision/docs/valve-grayscale&vision_better_grayscale.png)|

		@param image The image to be grayscaled.
		@param simpleGrayscale When enabled, gets the gray by averaging pixel's color-channel values, instead of using a special ratio for more accurate grayscaling. Defaults to `false`.

		@return The grayscaled image.
	**/
	public static function grayscale(image:Image, simpleGrayscale:Bool = false):Image {
		image.forEachPixelInView((x, y, pixel) -> {
			var gray = if (!simpleGrayscale) Std.int(0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue) else Std.int((pixel.red + pixel.green + pixel.blue) / 3);
			image.setUnsafePixel(x, y, Color.fromRGBA(gray, gray, gray));
		});
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
		image.forEachPixelInView((x, y, pixel) -> {
			image.setUnsafePixel(x, y, Color.fromRGBA(255 - pixel.red, 255 - pixel.green, 255 - pixel.blue));
		});
		return image;
	}

	/**
		Converts an image to COMPLETE black and white.

		It does so by taking the color channel with the highest value, and checking if that maximum surpasses `threshold`.

		| Original | `threshold = 128` |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-blackAndWhite.png)|

		@param image The image to be converted.
		@param threshold The threshold for converting to black and white: `threshold` is the maximum average of the three color components, that will still be considered black. `threshold` is a value between 0 and 255. The higher the value, the more "sensitive" the conversion. The default value is 128.

		@return The converted image.
	**/
	public static function blackAndWhite(image:Image, threshold:Int = 128):Image {
		image.forEachPixelInView((x, y, pixel) -> {
			var colorValue:Int = MathTools.max(pixel.red, pixel.green, pixel.blue);
			if (colorValue > threshold) {
				image.setUnsafePixel(x, y, 0xFFFFFFFF);
			} else {
				image.setUnsafePixel(x, y, 0xFF000000);
			}
		});
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
	    Smooths out an image, by averaging the pixel values around each pixel, and
		interpolating it with the currently processed pixel.

		This is a lower quality, but faster alternative to `Vision.bilateralDenoise`.

		| Original | Processed |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-smooth.png)|

		@param image The image to be smoothed.
		@param strength The strength of the smoothing. Higher values will result in more smoothing. Ranges from 0 to 1. Default is `0.1`.
		@param affectAlpha If `true`, the alpha channel will be smoothed as well. Defaults to `false`.
		@param kernelRadius The radius of the smoothing kernel. Higher values will result in more smoothing. Default is `1`, which uses a 3x3 kernel.
		@param circularKernel If `true`, the kernel will be circular. If `false`, the kernel will be square.
		@param iterations The number of times the smoothing should be applied. Higher values will result in more smoothing. Default is `1`.
		@return The smoothed image. The given image is modified.	
	**/
	public static function smooth(image:Image, strength:Float = 0.1, affectAlpha:Bool = false, kernelRadius:Int = 1, circularKernel:Bool = true, iterations:Int = 1):Image {
		var size = kernelRadius * 2 + 1;
		for (_ in 0...iterations) {
			image.forEachPixelInView((x, y, pixel) -> {
				var r = 0., g = 0., b = 0., a = 0., denominator = 0;
				for (c in image.getNeighborsOfPixelIter(x, y, size, circularKernel)) {
					denominator++;
					r += c.red;
					g += c.green;
					b += c.blue;
					if (affectAlpha) a += c.alpha;
				}

				r /= denominator;
				g /= denominator;
				b /= denominator;
				if (affectAlpha) a /= denominator else a = pixel.alpha;
				image.setUnsafePixel(x, y, Color.interpolate(pixel, Color.fromRGBA(Std.int(r), Std.int(g), Std.int(b), Std.int(a)), strength));
			});
		}

		return image;
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

		| Original | `iterations = 1` | `iterations = 2` |
		|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After One Iteration](https://spacebubble.io/vision/docs/valve-sharpen.png)|![After Two Iterations](https://spacebubble.io/vision/docs/valve-deepfry.png)|

		The higher the value, the more deepfried the image will look.
		@param image The image to be deepfried.
		@param iterations The amount of times the image gets sharpened. default is `2`.
		@return The deepfried image. The original copy is not preserved.
	**/
	public static function deepfry(image:Image, iterations:Int = 2):Image {
		for (i in 0...iterations)
			image = sharpen(image);
		return image;
	}

	public static function fisheyeDistortion(image:Image, ?strength:Float = 1.5):Image {
		var centerX = image.width / 2,
			centerY = image.height / 2;
		
		var processed = new Image(image.width, image.height);
		var maxRadius = Math.min(centerX, centerY);

		image.forEachPixelInView((x, y, color) -> {
			var dx = (x - centerX) / maxRadius;
            var dy = (y - centerY) / maxRadius;
            var distance = Math.sqrt(dx * dx + dy * dy);

			var r = Math.pow(distance, distance * strength);

            var srcX = centerX + r * dx * maxRadius;
            var srcY = centerY + r * dy * maxRadius;

			if (!image.hasPixel(srcX, srcY)) return;
            var color = image.getFloatingPixel(srcX, srcY);
            processed.setPixel(x, y, color);
		});

		return processed;
	}

	public static function barrelDistortion(image:Image, ?strength:Float = 0.2) {
		var centerX = image.width / 2,
			centerY = image.height / 2;

		var processed = new Image(image.width, image.height);

		image.forEachPixelInView((x, y, color) -> {
			// Translate pixel coordinates to centered coordinates
            var normalizedX = (x - centerX);
            var normalizedY = (y - centerY);
			// So we'd be able to work in polar coords
			var radius = Math.sqrt(normalizedX * normalizedX + normalizedY * normalizedY);
			var theta = Math.atan2(normalizedY, normalizedX);

			var distortedRadius = radius * (1 + strength * (radius * radius) / (centerX * centerX));
			
			// Cast back to cartesian coords
			var distortedX = centerX + distortedRadius * Math.cos(theta);
			var distortedY = centerY + distortedRadius * Math.sin(theta);

			if (!image.hasPixel(distortedX, distortedY)) return;
			// (Unsafe setting is faster)
			processed.setUnsafePixel(x, y, image.getFloatingPixel(distortedX, distortedY));
		});

		return processed;
	}

	public static function pincushionDistortion(image:Image, ?strength:Float = 0.2) {
		return barrelDistortion(image, -strength);
	}

	public static function mustacheDistortion(image:Image, amplitude:Float = 0.2) {
		// Basically the same algorithm as barrel distortion, but strength somewhat alternates
		var centerX = image.width / 2,
			centerY = image.height / 2;

		var processed = new Image(image.width, image.height);

		var maxRadius = new IntPoint2D(0, 0).distanceTo(new Point2D(centerX, centerY));

		image.forEachPixelInView((x, y, color) -> {
			// Translate pixel coordinates to centered coordinates
            var normalizedX = (x - centerX);
            var normalizedY = (y - centerY);
			// So we'd be able to work in polar coords
			var radius = Math.sqrt(normalizedX * normalizedX + normalizedY * normalizedY);
			var theta = Math.atan2(normalizedY, normalizedX);

			var strength = amplitude - amplitude * (radius / maxRadius);

			var distortedRadius = radius * (1 + strength * (radius * radius) / (centerX * centerX));
			
			// Cast back to cartesian coords
			var distortedX = centerX + distortedRadius * Math.cos(theta);
			var distortedY = centerY + distortedRadius * Math.sin(theta);

			if (!image.hasPixel(distortedX, distortedY)) return;
			// (Unsafe setting is faster)
			processed.setUnsafePixel(x, y, image.getFloatingPixel(distortedX, distortedY));
		});

		return processed;
	}

	/**
	    Loops over the given image's pixels with a kernel, and replaces the center pixel of that kernel with the "maximum value" inside that kernel:

		**What does replacing with the maximum value mean?**

		Basically, if a nearby pixel is lighter than the current pixel, the current pixel is replaced with the lighter pixel.
		That check is applied to all neighboring pixels, resulting in each pixel's color being the lightest color in its surroundings. 
		
		**example:** an image being dilated with a 5x5 square kernel. you should see how each time the kernel moves, it picks the lightest colors inside of it, and continues.

		![example](https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Grayscale_Morphological_Dilation.gif/220px-Grayscale_Morphological_Dilation.gif)

		| Original | Dilated |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-dilate.png)|

		@param image The image to operate on.
		@param dilationRadius The radius of the kernel used for the dilation process. The radius does not include the center pixel, so a radius of `2` should give a `5x5` kernel. The higher this value, the further each pixel checks for a nearby lighter pixel.
		@param colorImportanceOrder Since there may be conflicts when calculating the difference in lightness between colors with similar values in different color channels (e.g. `0xFF0000` and `0x0000FF` - channel values are "similar", colors are not), this parameter is used to favor the given color channels. The default is `RedGreenBlue` - `red` is the most important, and is considered the "lightest", followed by green, and blue is considered the "darkest".
		@param circularKernel When enabled, the kernel used to loop over the pixels becomes circular instead of being a square. This results in a slight performance increase, and a massive quality increase. Turned on by default.
		@return The dilated image. The original copy is not preserved.
	**/
	public static function dilate(image:Image, ?dilationRadius:Int = 2, ?colorImportanceOrder:ColorImportanceOrder = RedGreenBlue, circularKernel:Bool = true):Image {
		var intermediate = image.clone();
		image.forEachPixelInView((x, y, c) -> {
			var maxColor:Color = 0;
			for (color in image.getNeighborsOfPixelIter(x, y, dilationRadius * 2 + 1, circularKernel)) {
				color &= colorImportanceOrder;
				final redLarger = color.red > maxColor.red ? 1 : 0;
				final greenLarger = color.green > maxColor.green ? 1 : 0;
				final blueLarger = color.blue > maxColor.blue ? 1 : 0;
				if (redLarger + blueLarger + greenLarger >= 2) maxColor = color;
			}
			intermediate.setUnsafePixel(x, y, maxColor);
		});
		return image = intermediate;
	}

	/**
	    Loops over the given image's pixels with a kernel, and replaces the center pixel of that kernel with the "minimum value" inside that kernel:

		**What does replacing with the minimum value mean?**

		Basically, if a nearby pixel is darker than the current pixel, the current pixel is replaced with the darker pixel.
		That check is applied to all neighboring pixels, resulting in each pixel's color being the darkest color in its surroundings. 
		
		**example:** an image being eroded with a square 5x5 kernel. You should see how each time the kernel moves, it picks the darkest colors inside of it, and continues.

		![example](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Grayscale_Morphological_Erosion.gif/220px-Grayscale_Morphological_Erosion.gif)

		| Original | Eroded |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-erode.png)|

		@param image The image to operate on.
		@param dilationRadius The radius of the kernel used for the erosion process. The radius does not include the center pixel, so a radius of `2` should give a `5x5` kernel. The higher this value, the further each pixel checks for a nearby darker pixel.
		@param colorImportanceOrder Since there may be conflicts when calculating the difference in darkness between colors with similar values in different color channels (e.g. `0xFF0000` and `0x0000FF` - channel values are "similar", colors are not), this parameter is used to favor the given color channels. The default is `RedGreenBlue` - `red` is the most important, and is considered the "darkest", followed by green, and blue is considered the "lightest".
		@param circularKernel When enabled, the kernel used to loop over the pixels becomes circular instead of being a square. This results in a slight performance increase, and a massive quality increase. Turned on by default.
		@return The eroded image. The original copy is not preserved.
	**/
	public static function erode(image:Image, ?erosionRadius:Int = 2, ?colorImportanceOrder:ColorImportanceOrder = RedGreenBlue, circularKernel:Bool = true):Image {
		var intermediate = image.clone();
		image.forEachPixelInView((x, y, c) -> {
			var minColor:Color = 0xFFFFFFFF;
			for (color in image.getNeighborsOfPixelIter(x, y, erosionRadius * 2 + 1, circularKernel)) {
				color &= colorImportanceOrder;
				final redSmaller = color.red < minColor.red ? 1 : 0;
				final greenSmaller = color.green < minColor.green ? 1 : 0;
				final blueSmaller = color.blue < minColor.blue ? 1 : 0;
				if (redSmaller + blueSmaller + greenSmaller >= 2) minColor = color;
			}
			intermediate.setUnsafePixel(x, y, minColor);
		});
		return image = intermediate;
	}

	/**
		Applies noise to an image, in a "salt & pepper" fashion:

		every `100 / percentage` pixels or so, a randomly generated mask bitmask is applied to the color, using **color interpolation**
		
		| Original | `percentage = 25` |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-saltAndPepperNoise.png)
		
		@param image The image to apply salt&pepper noise on.
		@param percentage How much of the image should be "corrupted", in percentages between 0 to 100 - 0 means no change, 100 means fully "corrupted". Default is 25.
		@return The noisy image. The original copy is not preserved.

		@see Color.interpolate()
	**/
	public static function saltAndPepperNoise(image:Image, percentage:Float = 25):Image {
		var translated = percentage / 100;
		image.forEachPixelInView((x, y, color) -> {
			//generate salt and pepper
			var multiplierCounter = 1;
			var multiplier = 1;
			var diff = color;
			while (multiplierCounter < 32) {
				if (Math.random() < translated) diff |= multiplier;
				multiplier *= 2;
				multiplierCounter++;
			}
			image.setUnsafePixel(x, y, Color.interpolate(color, diff));
		});
		return image;
	}

	/**
		Applies noise to an image, in a "drop-out" fashion:

		every `100 / percentage` pixels or so, a pixel is set to either black or white, 
		depending on the pixel it replaces - a lighter pixel is replaced by black, 
		while a darker pixel is replaced by white.
		
		| Original | Processed |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-dropOutNoise.png)
		
		@param image The image to apply salt&pepper noise on
		@param percentage How much of the image should be "corrupted", in percentages between 0 to 100 - 0 means no change, 100 means fully "corrupted". Default is 5
		@return The noisy image. The original copy is not preserved.
	**/
	public static function dropOutNoise(image:Image, percentage:Float = 5, threshold:Int = 128):Image {
		var translated = percentage / 100;
		image.forEachPixelInView((x, y, color) -> {
			if (Math.random() > translated) return;
			if (color.red > threshold || color.blue > threshold || color.green > threshold) {
				image.setUnsafePixel(x, y, 0);
				return;
			}
			image.setUnsafePixel(x, y, 0xFFFFFFFF);
		});
		return image;
	}

	/**
		Applies white noise to an image. White noise is the "snow" screen you see on televisions when they pick up unwanted electric/radiated electromagnetic signals instead of the channels you want to watch.

		Instead of applying white noise every couple of pixels, white noise is sort of "combined" with the image, according to `percentage`:
		
		| Original | Processed |
		|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-whiteNoise.png)
		
		@param image The image to apply salt&pepper noise on
		@param percentage How white-noisy the resulting image should be, or, the ratio between the contributions of each pixel from the original image and the white noise to the final image, from 0 to 100: a lower value will make the first image's pixels contribute more to the the final image, thus making the resulting image less noisy, and vice-versa.
		@param whiteNoiseRange The number of shades of gray used to generate the white noise. Shouldn't really effect performance, but you may want to change it to get a "higher/lower quality" white noise.
		@return The noisy image. The original copy is not preserved.
	**/
	public static function whiteNoise(image:Image, percentage:Float = 25, whiteNoiseRange:WhiteNoiseRange = RANGE_16) {
		var colorVector:Vector<Int> = new Vector(whiteNoiseRange);
		colorVector[0] = 0;
		colorVector[colorVector.length - 1] = 255;
		var step = MathTools.round(256 / whiteNoiseRange);
		for (i in 1...whiteNoiseRange - 1) {
			colorVector[i] = step * i;
		}
		final translated = percentage / 100;
		image.forEachPixelInView((x, y, first) -> {
			var randomAtRange = Math.floor(Math.random() * whiteNoiseRange);
			first.red = Math.round((first.red * (1 - translated) + colorVector[randomAtRange] * translated));
			first.blue = Math.round((first.blue * (1 - translated) + colorVector[randomAtRange] * translated));
			first.green = Math.round((first.green * (1 - translated) + colorVector[randomAtRange] * translated));
			image.setUnsafePixel(x, y, first);
		});
		return image;
	}

	/**
		Limits the range of colors on an image, by resizing the range of a given color channel, according to the values
		of `rangeStart`'s and `rangeEnd`'s color channels.
		
		### How Does this work?
		
		1. before calculating anything, you get the min & max values of each color channel from the two given colors.
		For example, if `rangeStart` is `0xFF05F243` and `rangeEnd` is `0x239A6262`, the min/max values of the `red` channel 
		will be set to (`0x05`, `0x9A`), the min/max values of the green channel will be set to (`0x62`, `0xF2`)...
		2. Loop over the pixels, and calculate the ratios between the the pixel's color channel's and the values (`0x00`, `0xFF`)
		3. Now, calculate the step between each color value of the new range, by dividing each channel's (`max` - `min`) by `255`. The
		default step between each color value is `1` by default (`(0xFF - 0x00) / 0xFF = 1`).
		4. Loop over the channels, and multiply their value by the value of the new `step` (for example, 4
		`newStep = (0x88 - 0x00) / 0xFF = 0.5`, `color.red = color.red * newStep`);
		5. enjoy your normalized image :)
		
		
		@param image The image to be normalized.
		@param rangeStart The start of the range of channels. By default, this value is `0x00000000`
		@param rangeEnd The end of the range of channels. By default, this value is `0xFFFFFFFF`
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

		image.forEachPixelInView((x, y, color) -> {
			color.redFloat *= step.redFloat;
			color.blueFloat *= step.blueFloat;
			color.greenFloat *= step.greenFloat;
			image.setUnsafePixel(x, y, color);
		});
		return image;
	}

	/**
		Limits the range of colors on an image, by limiting the range of a given color channel, according to the values
		of `rangeStart`'s and `rangeEnd`'s color channels.
		
		@param image The image to be li processed.
		@param rangeStart The start of the range of channels. By default, this value is `0x00000000`
		@param rangeEnd The end of the range of channels. By default, this value is `0xFFFFFFFF`
		@return The normalized image. The original copy is not preserved.
	**/
	public static function limitColorRanges(image:Image, rangeStart:Color = 0x00000000, rangeEnd:Color = 0xFFFFFFFF):Image {
		image.forEachPixelInView((x, y, color) -> {
			color.red = MathTools.boundInt(color.red, rangeStart.red, rangeEnd.red);
			color.blue = MathTools.boundInt(color.blue, rangeStart.blue, rangeEnd.blue);
			color.green = MathTools.boundInt(color.green, rangeStart.green, rangeEnd.green);
			image.setUnsafePixel(x, y, color);
		});
		return image;
	}

	/**
		Replaces the colors inside each range with the given color inside that range object:  
		```haxe
		[{rangeStart: 0x00000000, rangeEnd = 0x88888888, replacement: 0xFFFFFFFF}] 
		```
		will replace every pixel inside the given color range with the color `0xFFFFFFFF`
		
		@param image The image process.
		@param ranges array of color ranges & replacement colors.
		@return A processed version of the image. The original image is not preserved.
	**/
	public static function replaceColorRanges(image:Image, ?ranges:Array<{rangeStart:Color, rangeEnd:Color, replacement:Color}>):Image {
		if (ranges == null) return image;
		for (range in ranges) {
			final rangeStart = range.rangeStart;
			final rangeEnd = range.rangeEnd;
			final with = range.replacement;
			image.forEachPixelInView((x, y, color) -> {
				var original:Int = color;
				color.red = MathTools.isBetweenRanges(color.red, {start: rangeStart.red, end: rangeEnd.red}) ? color.red : with.red;
				color.blue = MathTools.isBetweenRanges(color.blue, {start: rangeStart.blue, end: rangeEnd.blue}) ? color.blue : with.blue;
				color.green = MathTools.isBetweenRanges(color.green, {start: rangeStart.green, end: rangeEnd.green}) ? color.green : with.green;
				if (color == original) image.setUnsafePixel(x, y, color) else image.setUnsafePixel(x, y, with);
			});
		}
		return image;
	}

	/**
		manipulates the image's pixel data by passing the pixels' value through a kernel.

		This is useful for many things, such as simple blurring, sharpening, noise maps, and more that comes to mind :).

		There are a couple of preexisting matrices you can use, and also a custom tool to let you create your own kernels from scratch using enums.

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
		@param kernel the type/value of the kernel. can be: **`Identity`**, **`BoxBlur`**, **`RidgeDetection`**, **`Sharpen`**, **`UnsharpMasking`**, **`Assemble3x3`**, **`Assemble5x5`**,
		or just a matrix: both `convolve(image, BoxBlur)` and `convolve(image, [[1,1,1],[1,1,1],[1,1,1]])` are valid ways to represent a box blur.
		@return A convolved version of the image. The original image is not preserved.
	**/
	public static function convolve(image:Image, kernel:EitherType<Kernel2D, Array<Array<Float>>> = Identity):Image {
		var matrix:Array<Array<Float>>;
		if (kernel is Array) {
			matrix = cast kernel;
		} else {
			matrix = switch cast(kernel, Kernel2D) {
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
				case Custom(kernel): kernel;
				case GaussianBlur(size, sigma): Gauss.create2DKernelOfSize(size, sigma).inner.raise(size);
				case LaplacianPositive: [[0, 1, 0], [1, -4, 1], [0, 1, 0]];
				case LaplacianNegative: [[0, -1, 0], [-1, 4, -1], [0, -1, 0]];
			}
		}

		var convolved = image.clone();
		var maxLength = -1;
		for (array in matrix) {
			if (array.length > maxLength)
				maxLength = array.length;
		};
		var flatMatrix = matrix.flatten();
		var denominator = 0.;
		for (number in flatMatrix)
			denominator += number;
		image.forEachPixelInView((x, y, _) -> {
			var i = 0;
			var red = 0., green = 0., blue = 0.;
			for (color in image.getNeighborsOfPixel(x, y, maxLength).inner) {
				red += flatMatrix[i] * color.red;
				blue += flatMatrix[i] * color.blue;
				green += flatMatrix[i] * color.green;
				i++;
			}
			red /= denominator;
			green /= denominator;
			blue /= denominator;
			convolved.setUnsafePixel(x, y, Color.fromRGBA(Std.int(red), Std.int(green), Std.int(blue)));
		});
		return image = convolved;
	}

	/**
		Manipulates the image's pixel data by applying the given transformation matrix - 
		a 3x3 "grid" used to Move the image's pixels from one position to another. 

		The given transformation matrix must be one that maps one parallel line to another. 
		The clearest indicator of this is an empty last row, aside from a `1` at the end.

		Differs from `Vision.convolve` in that it doesn't change the pixels color (like a `BoxBlur`, for example), but instead modifies the position of pixels within the image.  
		This makes it easy to rotate, scale or translate an image.

		A matrix can be a literal 2D array: `[[1, 0, 0], [0, 1, 0], [0, 0, 1]]`, an instance of `Array2D`, 
		an instance of `Matrix2D`, or one of our home-made matrices using the static properties on `Matrix2D` :).

		**Some things to note:**
		 - The matrix's size must be 3x3. If the matrix is not 3x3, an error will be thrown.
		 - Some transformations can move pixels outside of the image's original bounds 
		   (for example, rotation, translation)), so, depending on the value of `expandImageBounds`, the image may resize.
		 - If you want to know how the pixel position-manipulation is done, see `Matrix2D`'s documentation.

		Examples for some of the pre-made matrices:

		| Original | Shearing | Rotation | Rotation (`!expandImageBounds`) |
		|---|---|---|---| 
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![Sheared](https://spacebubble.io/vision/docs/valve-affineWarpShear.png)|![Rotated, expanded](https://spacebubble.io/vision/docs/valve-affineWarpRotate%28expandImageBounds%20=%20true%29.png)|![Rotated, original size](https://spacebubble.io/vision/docs/valve-affineWarpRotate%28expandImageBounds%20=%20false%29.png)|

		@param image The image to manipulate.
		@param matrix a transformation matrix to use when manipulating the image. expects a 3x3 matrix. any other size may throw an error.
		@param expansionMode how to expand the image if the matrix moves the image outside of its original bounds, or never reaches the original bounds. Defaults to `ImageExpansionMode.SAME_SIZE`.
		@param originPoint **OPTION 1**: the point in the image to use as the origin of the transformation matrix. Before a point is passed to the matrix, it's coordinates are incremented by this point, and after the matrix is applied, it's coordinates are decremented by this point. Useful for rotation transformations. Defaults to `(0, 0)`.
		@param originMode **OPTION 2**: To avoid code-bloat, you can provide a pre-made representation of the origin point, via `TransformationMatrixOrigination` enum. Defaults to `TransformationMatrixOrigination.TOP_LEFT`.
		@returns A new, manipulated image. The provided image remains unchanged.
		@throws MatrixMultiplicationError if the size of the given matrix is not 3x3.

		@see `Vision.convolve()` for color-manipulation matrices (or, kernels).
		@see `Vision.perspectiveWarp()` for "3d" manipulations.
	**/
	public static function affineTransform(image:Image, ?matrix:TransformationMatrix2D, expansionMode:ImageExpansionMode = RESIZE, ?originPoint:Point2D, ?originMode:TransformationMatrixOrigination = CENTER) {
		if (matrix == null) matrix = Matrix2D.IDENTITY();
		// Get the max values for bounds expansion
		var mix = MathTools.POSITIVE_INFINITY, max = MathTools.NEGATIVE_INFINITY, miy = MathTools.POSITIVE_INFINITY, may = MathTools.NEGATIVE_INFINITY;
		for (corner in [new Point2D(0, 0), new Point2D(0, image.height), new Point2D(image.width, 0), new Point2D(image.width, image.height)]) {
			var coords:Array<Array<Float>> = [[corner.x], [corner.y], [1]];
			coords = matrix.underlying * coords;
			var c = coords.flatten();
			if (c[0] > max) max = c[0];
			if (c[0] < mix) mix = c[0];
			if (c[1] > may) may = c[1];
			if (c[1] < miy) miy = c[1];
		}
		
		var img = switch expansionMode {
			case SAME_SIZE: new Image(image.width, image.height);
			case EXPAND: new Image(Math.max(image.width, max - mix.min(0) + 1).floor(), Math.max(image.height, may - miy.min(0) + 1).floor());
			case SHRINK: new Image(Math.min(image.width, max - mix + 1).floor(), Math.min(image.height, may - miy + 1).floor());
			case RESIZE: new Image((max - mix.min(0) + 1).floor(), (may - miy.min(0) + 1).floor());
		}
		var ratioX = image.width / (max - mix + 1), ratioY = image.height / (may - miy + 1);

		var offset = originPoint != null ? originPoint : switch (originMode) {
			case TOP_LEFT: new Point2D(0, 0);
			case TOP_RIGHT: new Point2D(image.width, 0);
			case BOTTOM_LEFT: new Point2D(0, image.height);
			case BOTTOM_RIGHT: new Point2D(image.width, image.height);
			case CENTER: new Point2D(image.width / 2, image.height / 2);
			case TOP_CENTER: new Point2D(image.width / 2, 0);
			case BOTTOM_CENTER: new Point2D(image.width / 2, image.height);
			case LEFT_CENTER: new Point2D(0, image.height / 2);
			case RIGHT_CENTER: new Point2D(image.width, image.height / 2);
		}

		var x = 0., y = 0.;
		while (x < image.width) {
			while(y < image.height) {
				// Center x & y so matrix positions make sense
				var coords = matrix.transformPoint(new Point2D(x - offset.x, y - offset.y));
				coords.x += offset.x * (1 / ratioX);
				coords.y += offset.y * (1 / ratioY);
				// Translate coordinates back to their original position
				img.setSafePixel(coords.x.round(), coords.y.round(), image.getFloatingPixel(x, y));
				y += ratioY;
			}
			x += ratioX;
			y = 0;
		}

		// Interpolate missing pixels, using bilinear interpolation. pixel radius is chosen by the ratio of the distance from `mix to max` to width, same for height.
		return img;
	}

	/**
	    Manipulates the image's pixel data by applying the given transformation matrix - 
		a 3x3 "grid" used to Move the image's pixels from one position to another. 

		Differs from `affineTransform()` in one, major way: while`affineTransform()` only supports two-dimensional, parallel-to-parallel transformations.
		`perspectiveWarp` supports transformations in all three dimensions.

		It also differs from `Vision.convolve` in that it doesn't change the pixels color (like a `BoxBlur`, for example), 
		but instead modifies the position of pixels within the image.

		A matrix can be a literal 2D array: `[[1, 0, 0], [0, 1, 0], [0, 0, 1]]`, an instance of `Array2D`, 
		an instance of `Matrix2D`, or one of our home-made matrices using the static properties on `Matrix2D` :).

		Examples for some of the pre-made matrices:

		| Original | Depth | Perspective | Rotation (`!expandImageBounds`) |
		|---|---|---|---| 
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![Sheared](https://spacebubble.io/vision/docs/valve-affineWarpShear.png)|![Rotated, expanded](https://spacebubble.io/vision/docs/valve-affineWarpRotate%28expandImageBounds%20=%20true%29.png)|![Rotated, original size](https://spacebubble.io/vision/docs/valve-affineWarpRotate%28expandImageBounds%20=%20false%29.png)|

		@param image The image to manipulate.
		@param matrix a transformation matrix to use when manipulating the image. expects a 3x3 matrix. any other size may throw an error.
		@param expansionMode How to expand the image's bounds when the resulting image after transformation canges dimensions. Defaults to `RESIZE`.
	**/
	public static function projectiveTransform(image:Image, ?matrix:TransformationMatrix2D, expansionMode:ImageExpansionMode = RESIZE):Image {

		if (matrix == null) matrix = Matrix2D.IDENTITY();
		// Get the max values for bounds expansion
		var mix = MathTools.POSITIVE_INFINITY, max = MathTools.NEGATIVE_INFINITY, miy = MathTools.POSITIVE_INFINITY, may = MathTools.NEGATIVE_INFINITY,
			miz = MathTools.POSITIVE_INFINITY, maz = MathTools.NEGATIVE_INFINITY;
		for (corner in [new Point3D(0, 0, 1), new Point3D(0, image.height, 1), new Point3D(image.width, 0, 1), new Point3D(image.width, image.height, 1)]) {
			var c = matrix.transformPoint(corner);
			c.x /= c.z;
			c.y /= c.z;
			if (c.x > max) max = c.x;
			if (c.x < mix) mix = c.x;
			if (c.y > may) may = c.y;
			if (c.y < miy) miy = c.y;
			if (c.z > maz) maz = c.z;
			if (c.z < miz) miz = c.z;
		}
		trace(mix, max, miy, may);
		var img = switch expansionMode {
			case SAME_SIZE: new Image(image.width, image.height);
			case EXPAND: new Image(Math.max(image.width, max - mix.min(0) + 1).floor(), Math.max(image.height, may - miy.min(0) + 1).floor());
			case SHRINK: new Image(Math.min(image.width, max - mix + 1).floor(), Math.min(image.height, may - miy + 1).floor());
			case RESIZE: new Image((max - mix.min(0) + 1).floor(), (may - miy.min(0) + 1).floor());
		}
		var ratioX = image.width / (max - mix.min(0) + 1) / maz.max(1), ratioY = image.height / (may - miy.min(0) + 1) / maz.max(1);
		var x = 0., y = 0.;
		while (x < image.width) {
			while(y < image.height) {
				// Center x & y so matrix positions make sense
				var coords = matrix.transformPoint(new Point3D(x, y, 1));
				coords.x /= coords.z;
				coords.y /= coords.z;
				// Translate coordinates back to their original position
				img.setSafePixel(coords.x.round(), coords.y.round(), image.getFloatingPixel(x, y));
				y += ratioY;
			}
			x += ratioX;
			y = 0;
		}

		// Interpolate missing pixels, using bilinear interpolation. pixel radius is chosen by the ratio of the distance from `mix to max` to width, same for height.
		return img;
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
		@param iterations The number of times the algorithm will be run. The more iterations, the more blurry the image will be, and the higher the "blur range". **For example:** a value of 3 will produce a blur range of 3 pixels on each object.

		@return A blurred version of the image. The original image is not preserved.
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
		
		| Original | `sigma = 0.5` | `sigma = 1`| `sigma = 1`, `fast = true` | `sigma = 2` |
		|---|---|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-gaussianBlur%28sigma%20=%200.5%29.png)|![After](https://spacebubble.io/vision/docs/valve-gaussianBlur%28sigma%20=%201%29.png)|![After](https://spacebubble.io/vision/docs/valve-gaussianBlur%28sigma%20=%201%47%20fast%20=%20true%29.png)|![After](https://spacebubble.io/vision/docs/valve-gaussianBlur%28sigma%20=%202%29.png)|

		@param image The image to be blurred.
		@param sigma The sigma value to use for the gaussian distribution on the kernel. a lower value will focus more on the center pixel, while a higher value will shift focus to the surrounding pixels more, effectively blurring it better.
		@param kernelSize The size of the kernel (`width` & `height`)
		@throws InvalidGaussianKernelSize if the kernel size is even, negative or `0`, this error is thrown.
		@return A blurred version of the image. The original image is not preserved.
	**/
	public static function gaussianBlur(image:Image, ?sigma:Float = 1, ?kernelSize:GaussianKernelSize = GaussianKernelSize.X5, ?fast:Bool = false):Image {
		if (fast) return Gauss.fastBlur(image, kernelSize, sigma);
		return convolve(image, GaussianBlur(kernelSize, sigma));
	}

	/**
		Applies a median filter to an image to reduce the amount of noise in that image.

		Median filter "blurs" the image by taking a pixel & its surrounding, 
		finding the median of that group, and setting the center pixel to that median.

		Example of the filter in action:

		| Original | `kernelSize = 5` | `kernelSize = 10` | `kernelSize = 15` |
		|---|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-medianBlur%28kernelRadius%20=%205%29.png)|![After](https://spacebubble.io/vision/docs/valve-medianBlur%28kernelRadius%20=%2010%29.png)|![After](https://spacebubble.io/vision/docs/valve-medianBlur%28kernelRadius%20=%2015%29.png)|

		@param image The image to apply median blurring to.
		@param kernelSize the width & height of the kernel in which we should search for the median. A radius of `9` will check in a `19x19` (`radius(9)` + `center(1)` + `radius(9)`) square around the center pixel.
		@return A filtered version of the image, using median blurring. The original image is not preserved.
	**/
	public static function medianBlur(image:Image, kernelSize:Int = 5):Image {
		var median = image.clone();
		image.forEachPixelInView((x, y, color) -> {
			var neighbors:Array<Int> = image.getNeighborsOfPixel(x, y, kernelSize).inner;
			ArraySort.sort(neighbors, (a, b) -> a - b);
			median.setUnsafePixel(x, y, neighbors[Std.int(neighbors.length / 2)]);
		});

		return image = median;
	}

	/**
		Uses a simple, partially recursive algorithm to detect line segments in an image.

		those lines can be partially incomplete, but they will be detected as lines.

		@param image The image to be line detected.
		@param accuracy When a line is detected, the algorithm checks how much of the line actually covers a  "line portion" of the image. `accuracy` is set to `50` by default - at least half of the line has to match with the image. To optimize for line count, `40` and below is recommended. Otherwise, `50` to `60` should be fine.
		@param minLineLength The minimum length of a line segment to be detected.
		@param speedToAccuracyRatio  If the algorithm is too slow/too inaccurate for you, you can change this setting.

		@return The line detected image.
	**/
	public static function simpleLine2DDetection(image:Image, accuracy:Float = 50, minLineLength:Float = 10, ?speedToAccuracyRatio:AlgorithmSettings = Medium_Intermediate):Array<Line2D> {
        final kernelSize = switch speedToAccuracyRatio {
            case VeryLow_VeryFast: X1;
            case Low_Fast: X3;
            case Medium_Intermediate: X5;
            case High_Slow: X7;
            case VeryHigh_VerySlow: X9;
        }
        var edgeDetected = cannyEdgeDetection(image, 1, kernelSize, 0.05, 0.16);
        var lines:Array<Line2D> = [];
		var actualLines:Array<Line2D> = [];
        for (x in 0...image.width) {
            for (y in 0...image.height) {
				lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, new Int16Point2D(x, y), minLineLength));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, new Int16Point2D(x, y), minLineLength, true));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, new Int16Point2D(x, y), minLineLength, false, true));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, new Int16Point2D(x, y), minLineLength, true, true));
            }
        }
        for (l in lines) {
            if (l == null) continue;
            if (SimpleLineDetector.lineCoveragePercentage(edgeDetected, l) < accuracy) continue;
            actualLines.push(l);
        }
		lines = [];
        //now, get a mirrored version
        edgeDetected = cannyEdgeDetection(image.mirror(), 1, kernelSize, 0.05, 0.16);
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, new Int16Point2D(x, y), minLineLength));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, new Int16Point2D(x, y), minLineLength, true));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, new Int16Point2D(x, y), minLineLength, false, true));
                lines.push(SimpleLineDetector.findLineFromPoint(edgeDetected, new Int16Point2D(x, y), minLineLength, true, true));
            }
        }
        for (l in lines) {
            if (l == null) continue;
            if (SimpleLineDetector.lineCoveragePercentage(edgeDetected, l) < accuracy) continue;
            actualLines.push(l.mirrorInsideRectangle({x: 0, y: 0, width: image.width, height: image.height}));
        }
        return SimpleLineDetector.correctLines(actualLines);
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
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-laplacianEdgeDiffOperator%28filterPositive%20=%20true%29.png)|![After](https://spacebubble.io/vision/docs/valve-laplacianEdgeDiffOperator%28filterPositive%20=%20false%29.png)|

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
		@param kernelSize This is used for the second step of the canny edge detection - gaussian blur. Unless you want to improve performance, this should remain unchanged.
		@param lowThreshold The low threshold value to be used in the hysteresis thresholding.
		@param highThreshold The high threshold value to be used in the hysteresis thresholding.

		@throws InvalidGaussianKernelSize thrown if the `kernelSize` is negative/divisible by `2`.
		@return The edge detected image.
	**/
	public static function cannyEdgeDetection(image:Image, sigma:Float = 1, kernelSize:GaussianKernelSize = X5, lowThreshold:Float = 0.05, highThreshold:Float = 0.2):Image {
		var cannyObject:CannyObject = image.clone().removeView();
		return blackAndWhite(cannyObject.grayscale()
			.applyGaussian(kernelSize, sigma)
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
		going over the image with a kernel. With the default settings. This algorithm is the fastest when working with smaller images.

		There's no need to pre-process the image, just throw it into the function it will do the rest
		(ie. the image doesn't need to be grayscale/black and white):

		| Original | After Filtering (Positive) | After Filtering (Negative) |
		|---|---|---|
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-laplacianOfGaussianEdgeDetection%28filterPositive%20=%20true%29.png)|![After](https://spacebubble.io/vision/docs/valve-laplacianOfGaussianEdgeDetection%28filterPositive%20=%20true%29.png)|

		@param image The image to be processed.
		@param threshold The threshold for detecting edges. The lower the value, the more pixels will be considered edges. Default is `5`.
		@param filterPositive Which version of the laplacian filter should the function use: the negative (detects "outward" edges), or the positive (detects "inward" edges). Default is positive (`true`).
		@param sigma The sigma value to use for the gaussian blur. A lower value will focus the kernel more on the center pixel, while a higher value will shift focus to the surrounding pixels more. **The higher the value, the blurrier the image.** Default is `1`.
		@param kernelSize The size of the kernel (`width` & `height`) - a kernel size of `7`/ will produce a `7x7` kernel. Default is `GaussianKernelSize.X3`.
		@return A new, black and white image, with white pixels being the detected edges.
	**/
	public static function laplacianOfGaussianEdgeDetection(image:Image, ?threshold:Int = 2, ?filterPositive:Bool = true, ?sigma:Float = 1, ?kernelSize:GaussianKernelSize = X3) {
		return Laplacian.laplacianOfGaussian(image, kernelSize, sigma, threshold, filterPositive);
	}

	/**
		Uses a fast, convolution-based method to detect ridges within an image.
		
		It does the detection by grayscaling & normalizing the image, and then
		convolving it with a ridge detection kernel.

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

		@param image the image to be ridge detected on.
		@param normalizationRangeStart Optional, if you want to change the normalization range's start color. `0x44444444` by default.
		@param normalizationRangeEnd Optional, if you want to change the normalization range's end color `0xBBBBBBBB` by default.
		@param refine Appends an iterative pixel check to the algorithm, which removes isolated ridge pixels. `false` by default for performance reasons.
		@return The ridge-highlighted version of the image. **The original copy is preserved**.
	**/
	public static function convolutionRidgeDetection(image:Image, ?normalizationRangeStart:Color = 0xFF444444, ?normalizationRangeEnd:Color = 0xFFBBBBBB, refine:Bool = false):Image {
		var clone = image.clone().removeView();
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
			if (count <= 1) clone.setUnsafePixel(x, y, 0);
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
		|![Before](https://spacebubble.io/vision/docs/valve-original.png)|![After](https://spacebubble.io/vision/docs/valve-sharpen.png)|![After](https://spacebubble.io/vision/docs/valve-bilateralDenoise.png)|

		@param image The image to operate on.
		@param gaussianSigma The sigma to use when generating the gaussian kernel. This also decides the size of the kernel (The size of the kernel is always `Math.round(6 * gaussianSigma)`, and gets incremented if the resulting size is even)
		@param intensitySigma The intensity sigma decides how hard should the algorithm "try" to reduce the noise inside the image. A higher value causes a pixel that has vastly different color than it's surrounding to weigh much less, and pretty much get "ignored and overwritten". **tl;dr - a higher value reduces more noise, but may blur the image if too high.**

	**/
	public static function bilateralDenoise(image:Image, gaussianSigma:Float = 0.8, intensitySigma:Float = 50):Image {
		return BilateralFilter.filter(image, gaussianSigma, intensitySigma);
	}
}
