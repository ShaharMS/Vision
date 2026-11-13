package vision;

import vision.algorithms.Dithering;
import vision.algorithms.GaussianNoise;
import vision.algorithms.ImageMatching;
import vision.algorithms.NonLocalMeans;
import vision.ds.ImageMatch;
import vision.ds.specifics.DitheringAlgorithm;
import vision.ds.specifics.ImageMatchingTechnique;
import vision.exceptions.VisionError;
import vision.algorithms.ImageHashing;
import vision.algorithms.SeamCarving;
import vision.ds.ByteArray;
import vision.ds.kmeans.ColorCluster;
import haxe.io.Bytes;
import haxe.crypto.Sha256;
import vision.exceptions.Unimplemented;
import vision.ds.specifics.SimilarityScoringMechanism;
import vision.algorithms.KMeans;
import vision.algorithms.EMeans;
import vision.algorithms.PatternSynthesis;
import vision.algorithms.TextureSynthesis;
import vision.algorithms.Panorama;
import vision.algorithms.Rescale;
import vision.ds.specifics.ColorChannel;
import vision.ds.Transform2D;
import vision.exceptions.VisionException;
import vision.exceptions.MatrixShapeError;
import vision.ds.specifics.TransformationMatrixOrigination;
import vision.ds.Point3D;
import vision.ds.specifics.ImageExpansionMode;
import vision.ds.specifics.ProbabilisticHoughLineOptions;
import vision.algorithms.PerspectiveWarp;
import vision.ds.specifics.PointTransformationPair;
import vision.algorithms.BilinearInterpolation;
import vision.ds.Matrix2D;
import vision.ds.Int16Point2D;
import haxe.ds.Vector;
import vision.ds.specifics.WhiteNoiseRange;
import vision.algorithms.Laplace;
import vision.ds.specifics.ColorImportanceOrder;
import vision.algorithms.BilateralFilter;
import vision.algorithms.RobertsCross;
import vision.ds.IntPoint2D;
import vision.algorithms.Radix;
import haxe.ds.ArraySort;
import vision.ds.Histogram;
import vision.ds.specifics.AlgorithmSettings;
import vision.algorithms.Perwitt;
import vision.algorithms.Sobel;
import vision.ds.Kernels;
import vision.ds.canny.CannyObject;
import vision.algorithms.Harris;
import vision.algorithms.Hough;
import vision.ds.Circle2D;
import vision.ds.IntPoint2D;
import vision.algorithms.SimpleLineDetector;
import vision.ds.gaussian.GaussianKernelSize;
import vision.ds.Ray2D;
import vision.algorithms.Gauss;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.native.ImageBackend;
import vision.native.ImageBackend.ImageOperation;
import vision.ds.specifics.HarrisCornerOptions;
import vision.ds.specifics.HoughCircleOptions;
import vision.tools.MathTools;
import vision.tools.MathTools.*;

using vision.tools.MathTools;
using vision.tools.ArrayTools;
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
		Shrinks an image by removing connected paths of least significant pixels (seam carving).

		Uses the gradient-energy algorithm from [Avidan and Shamir (2007)](https://www.merl.com/publications/TR2007-087).
		Each pixel's energy is the sum of absolute RGB differences between its horizontal
		and vertical neighbors, clamped at image borders. Dynamic programming finds the
		minimum-total-energy 8-connected path from one edge to the opposite edge.
		Energy is recalculated after every removal. Vertical seams (top to bottom) reduce
		width first, then horizontal seams (left to right) reduce height. Ties select the
		leftmost predecessor and endpoint (topmost for horizontal seams).

		Returns a **new image**, leaving the source unchanged, even for unchanged dimensions.
		Surviving pixels retain their exact colors and alpha; alpha does not affect energy.
		This preserves strong edges better than uniform resizing in many images, but can
		distort subjects in busy scenes or after large reductions. Use `Image.resize()`
		for interpolation or enlargement. No seam insertion or object-protection mask is applied.

		```haxe
		var narrower = Vision.carve(image, 112, image.height);
		var shorter = Vision.carve(image, image.width, 84);
		```

		Time is `O(width * height * removedSeams)`; auxiliary memory is `O(width * height)`.

		| Before | After (Width reduced) | After (Height reduced) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Width reduced](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-carve-width.png) | ![Height reduced](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-carve-height.png) |

		@param image The source image, which is not modified.
		@param width Target width in pixels, between 1 and the source width (inclusive).
		@param height Target height in pixels, between 1 and the source height (inclusive).
		@return A new content-aware image with exactly the requested dimensions.
		@throws InvalidCarveSize If either target dimension is nonpositive or exceeds the source dimension, including with `vision_quiet` enabled.
	**/
	public static function carve(image:Image, width:Int, height:Int):Image {
		return SeamCarving.compute(image, width, height);
	}


	/**
			    Combines two images by averaging out the values of each pixel's color channels, according to `percentage`.

		The images can be of different sizes.

		The example blends the source with its horizontally mirrored copy at equal weight.

		| Before | After (50% mirrored copy) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![50% mirrored copy](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-combine.png) |

		@param image The image to combine on. When this function returns, that image should be modified
		@param with The second image to combine with. That image is preserved throughout the function.
		@param percentage The ratio between the contributions of each pixel within the two images, from 0 to 100: a lower value will make the first image's pixels contribute more to the the final image, thus making that image more similar to the first image, and vice-versa.
		@return The combined image. The original copy (The first parameter) is modified.
	**/
	public static function combine(image:Image, ?with:Image, percentage:Float = 50):Image {
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
		Overlays a color on an image, according to `percentage`, as well as the color's `alpha` channel.

		| Before | After (Amethyst at 50%) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Amethyst at 50%](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-tint.png) |

		@param image The image to tint
		@param withColor The color to tint the image with. Each channel is considered separately, so a color with `alpha` of 0 won't affect other color channels. Default is `Color.BLACK`
		@param percentage The amount by which to tint. `100` yields an image completely colored with `withColor`, while `0` yields the original image. Default is `50`
		@return The tinted image. The original image is modified.
	**/
	public static function tint(image:Image, withColor:Color = Color.BLACK, percentage:Float = 50):Image {
		final translated = percentage / 100;
		image.forEachPixelInView((x, y, pixel) -> {
			pixel.red = Math.round((pixel.red * (1 - translated) + withColor.red * translated));
			pixel.blue = Math.round((pixel.blue * (1 - translated) + withColor.blue * translated));
			pixel.green = Math.round((pixel.green * (1 - translated) + withColor.green * translated));
			pixel.alpha = Math.round((pixel.alpha * (1 - translated) + withColor.alpha * translated));
			image.setUnsafePixel(x, y, pixel);
		});
		return image;
	}


	/**
		Grayscales an image, by averaging the color channels of each pixel.

		If for some reason, you want to get a lower quality grayscale, set `simpleGrayscale` to `true`.

		| Before | After (Weighted luminance) | After (Channel average) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Weighted luminance](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-grayscale.png) | ![Channel average](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-grayscale-average.png) |

		@param image The image to be grayscaled.
		@param simpleGrayscale When enabled, gets the gray by averaging pixel's color-channel values, instead of using a special ratio for more accurate grayscaling. Default is `false`.
		@return The grayscaled image. The original image is modified.
	**/
	public static function grayscale(image:Image, simpleGrayscale:Bool = false):Image {
		ImageBackend.apply(image, simpleGrayscale ? ImageOperation.SimpleGrayscale : ImageOperation.Grayscale);
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

		| Before | After (Inverted RGB) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Inverted RGB](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-invert.png) |

		@param image The image to be inverted.

		@return The inverted image. The original image is modified.
	**/
	public static function invert(image:Image):Image {
		ImageBackend.apply(image, ImageOperation.Invert);
		return image;
	}

	/**
		Makes an image look "old".

		Does so by interpolating each pixel with `Color.SEPIA`.

		| Before | After (Strength 0.25) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Strength 0.25](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-sepia.png) |

		@param image The image to be tinted.
		@param strength The amount of sepia to apply. The higher the value, the older the image looks. Default is `0.25`.
		@return The tinted image. The original image is modified.
	**/
	public static function sepia(image:Image, strength:Float = 0.25):Image {
		image.forEachPixelInView((x, y, pixel) -> {
			image.setUnsafePixel(x, y, Color.interpolate(pixel, Color.SEPIA, strength));
		});
		return image;
	}

	/**
		Converts an image to COMPLETE black and white.

		It does so by taking the color channel with the highest value, and checking if that maximum surpasses `threshold`.

		| Before | After (Threshold 128) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Threshold 128](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-blackAndWhite.png) |

		@param image The image to be converted.
		@param threshold The highest RGB channel value that is still considered black. Defaults to 128.
		@return The converted image. The original image is modified.
	**/
	public static function blackAndWhite(image:Image, threshold:Int = 128):Image {
		ImageBackend.apply(image, ImageOperation.BlackAndWhite, threshold);
		return image;
	}

	/**
		Gets a contrast-enhanced version of an image,
		with more exaggerated colors.

		| Before | After (Contrast kernel) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Contrast kernel](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-contrast.png) |

		@param image The image to be contrasted.
		@return The contrasted image. The original image is modified.
	**/
	public static function contrast(image:Image):Image {
		return convolve(image, Kernels.unsharpMasking());
	}

	/**
			    Smooths out an image, by averaging the pixel values around each pixel, and
		interpolating it with the currently processed pixel.

		This is a lower quality, but faster alternative to `Vision.bilateralDenoise`.

		The example uses a radius of 2 and four passes at strength 0.5.

		| Before | After (Four passes) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Four passes](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-smooth.png) |

		@param image The image to be smoothed.
		@param strength The strength of the smoothing. Higher values will result in more smoothing. Ranges from 0 to 1. Default is `0.1`.
		@param affectAlpha If `true`, the alpha channel will be smoothed as well. Default is `false`.
		@param kernelRadius The radius of the smoothing kernel. Higher values will result in more smoothing. Default is `1`, which uses a 3x3 kernel.
		@param circularKernel If `true`, the kernel will be circular. If `false`, the kernel will be square. Default is `true`.
		@param iterations The number of times the smoothing should be applied. Higher values will result in more smoothing. Default is `1`.
		@return The smoothed image. The original image is modified.
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
		"Pixel-art"ifies an image, by "skipping" every `pixelSize` pixels, and filling
		in the missing space by either averaging out the remaining pixel and the
		missing ones, or just using the original.

		| Before | After (8-pixel blocks) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![8-pixel blocks](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-pixelate.png) |

		@param image The image to pixelate
		@param averagePixels Whether to use pixel averaging to get resulting pixels, or just use the original, remaining pixel. Default is `true`.
		@param pixelSize the new "pixel size". Default is `2`.
		@param affectAlpha Whether this effect applies to the alpha channel of each pixel or not. Default is `true`.
		@return The given image, pixelated. The original image is modified.
	**/
	public static function pixelate(image:Image, averagePixels:Bool = true, pixelSize:Int = 2, affectAlpha:Bool = true):Image {
		var blockSize = pixelSize * pixelSize;
		image.forEachPixelInView((x, y, pixel) -> {
			if (x % pixelSize != 0 || y % pixelSize != 0) return;
			var r = 0., g = 0., b = 0., a = 0.;
			for (offX in 0...pixelSize) {
				for (offY in 0...pixelSize) {
					var c = image.getSafePixel(x + offX, y + offY);
					r += c.red;
					g += c.green;
					b += c.blue;
					if (affectAlpha) a += c.alpha;
				}
			}

			r /= blockSize;
			g /= blockSize;
			b /= blockSize;
			if (affectAlpha) a /= blockSize else a = pixel.alpha;
			var color = Color.fromRGBA(Std.int(r), Std.int(g), Std.int(b), Std.int(a));
			for (offX in 0...pixelSize) {
				for (offY in 0...pixelSize) {
					if (affectAlpha) color.alpha = image.getSafePixel(x + offX, y + offY).alpha;
					image.setSafePixel(x + offX, y + offY, color);
				}
			}
		});

		return image;
	}

	
	/**
		"Posterizes" an image - reduces the amount of colors an image uses by reducing
		the amount of bits each color channel uses. Usually, a color is represented
		using 4 channels of 8 bits, resulting in an integer, containing the red, green,
		blue and alpha channel. This functions reduces the amount of bits used by
		each channel for each pixel.

		It is important to note that this function does not reduce the amount of memory
		used by the image. Each color still takes up 4 bytes.

		| Before | After (2 bits per channel) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![2 bits per channel](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-posterize.png) |

		@param image The image to be posterized.
		@param bitsPerChannel The number of bits per channel. Default is `4`. Ranges from `1` to `8`.
		@param affectAlpha If `true`, the alpha channel will be posterized as well. Default is `true`.
		@return The given image, posterized. The original image is modified.
	**/
	public static function posterize(image:Image, bitsPerChannel:Int = 4, affectAlpha:Bool = true):Image {
		var denominator = (256 / bitsPerChannel).floor(); // Is an integer anyways.
		image.forEachPixelInView((x, y, pixel) -> {
			var r = (pixel.red / denominator).round() * denominator;
			var g = (pixel.green / denominator).round() * denominator;
			var b = (pixel.blue / denominator).round() * denominator;
			var a = affectAlpha ? (pixel.alpha / denominator).round() * denominator : pixel.alpha;
			image.setUnsafePixel(x, y, Color.fromRGBA(r, g, b, a));
		});

		return image;
	}

	/**
		Returns a sharpened version of the provided image.

		When an image is sharpened. it's color differences are exaggerated. The more times
		the image is sharpened, the more "deepfried" it'll look.

		| Before | After (Sharpened) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Sharpened](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-sharpen.png) |

		@param image The image to be contrasted.
		@return A new sharpened image.
	**/
	public static function sharpen(image:Image):Image {
		return convolve(image, Kernels.sharpen());
	}

	/**
		Exaggerates contrast around edges by repeatedly sharpening the image.


		Each pass further exaggerates local differences.

		| Before | After (One pass) | After (Two passes) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![One pass](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-deepfry-one.png) | ![Two passes](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-deepfry-two.png) |

		@param image The image to be deepfried.
		@param iterations The amount of times the image gets sharpened. Default is `2`.
		@return The sharpened result. Zero passes return the input.
	**/
	public static function deepfry(image:Image, iterations:Int = 2):Image {
		for (i in 0...iterations)
			image = sharpen(image);
		return image;
	}
	
	/**
		Applies a vignette effect to the image.

		Vignette is a visual effect that makes the edges of the image gradually become
		of a certain color, usually to draw attention to the center.

		| Before | After (Aspect dependent) | After (Aspect independent) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Aspect dependent](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-vignette-aspect.png) | ![Aspect independent](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-vignette.png) |

		@param image The image to apply vignette on
		@param strength in percentage, the amount of the image that has vignette, from the edge. Ranges from `0` to `1`. Default is `0.2`.
		@param intensity Determines how quickly vignette sets in when a pixel is supposed to be affected. The higher the value,
		the quicker it turns to the target color. The closer the value is to `0`, the slower it
		turns into the target color, and the less effected the edges. Default is `1`.
		@param ratioDependent DEtermines if the effect should always treat the image as a square,
		and thus be circular (`false`) or if it should consider different dimensions,
		and appear "elliptical" (`true`). Default is `false`.
		@param color The target color for the vignette effect. Default is `Color.BLACK`
		@return the given image, with vignette applied. The original image is modified.
	**/
	public static function vignette(image:Image, ?strength:Float = 0.2, ?intensity:Float = 1, ratioDependent:Bool = false, color:Color = Color.BLACK):Image {
		var center = image.center();
		var maxDistance = center.distanceTo({x: ratioDependent ? image.width : image.width.min(image.height), y: ratioDependent ? image.height : image.width.min(image.height)});
		var minDistance = maxDistance * (1 - strength);
		var denominator = maxDistance - minDistance;
		image.forEachPixelInView((x, y, pixel) -> {
			var distance = center.distanceTo({x: x, y: y});
			if (distance > minDistance) {
				var color = Color.interpolate(pixel, color, ((distance - minDistance) / denominator) * intensity);
				image.setUnsafePixel(x, y, color);
			}
		});
		
		return image;
	}

	/**
			Applies a fish-eye effect centered on the image.

		The distortion bends the image within a circle and leaves the area outside it transparent.

		| Before | After (Strength 1.5) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Strength 1.5](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-fisheye.png) |

		@param image The image to apply the distortion to
		@param strength The "amount" of warping done to the image. A higher value means pixels closer to the center are more distorted. Default is `1.5`.
		@return the given image, with fish-eye effect. The original image is preserved.
	**/
	public static function fisheyeDistortion(image:Image, ?strength:Float = 1.5):Image {
		var centerX = image.width / 2,
			centerY = image.height / 2;
		
		var processed = new Image(image.width, image.height);
		processed.copyViewFrom(image);
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

	/**
		Applies a perspective perception change, such that the pixels closer to the
		center of the image appear closer, and pixels that are closer to the corners appear further.

		This causes a bulging effect on straight lines, as seen in the following graph image:

		The example uses a strength of 0.35.

		| Before | After (Strength 0.35) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Strength 0.35](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-barrel.png) |

		@param image The image to distort
		@param strength The amount of distortion to apply. The higher the value the more distortion
		there is. A negative value implies `Vision.pincushionDistortion`.
		Values converging to 0 distort the image less and less. Default is `0.2`.
		@return The given image, with barrel distortion applied. The original image is preserved.
	**/
	public static function barrelDistortion(image:Image, ?strength:Float = 0.2):Image {
		var centerX = image.width / 2,
			centerY = image.height / 2;
		var maxRadius = Math.min(centerX, centerY);
		var processed = new Image(image.width, image.height);
		processed.copyViewFrom(image);

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

	/**
		Applies a perspective perception change, such that the pixels closer to the
		center of the image appear further, and pixels that are closer to the corners appear closer,
		similar to when taking an image of the inside of a spherical object.

		This causes an inward rounding effect on straight lines, as seen in the following graph image:

		The example uses a strength of 0.35.

		| Before | After (Strength 0.35) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Strength 0.35](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-pincushion.png) |

		@param image The image to distort
		@param strength The amount of distortion to apply. The higher the value, the more distortion
		there is. A negative value implies `Vision.barrelDistortion`.
		Values converging to 0 distort the image less and less. Default is `0.2`.
		@return The given image, with pincushion distortion applied. The original image is preserved.
	**/
	public static function pincushionDistortion(image:Image, ?strength:Float = 0.2):Image {
		return barrelDistortion(image, -strength);
	}

	/**
		A combination of `Vision.barrelDistortion` & `Vision.pincushionDistortion`, where the former
		affects the portion closer to the center of the image, and the latter affects the edges:

		For reference, here are the two mentioned distortions, held in reference to this one:

		| Before | After (Amplitude 0.35) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Amplitude 0.35](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-mustache.png) |

		@param image The image to distort
		@param amplitude The amount of distortion to apply. The higher the value, the more distortion
		there is. A negative value flips the effect.
		Values converging to 0 distort the image less and less. Default is `0.2`.
		@return The given image, with mustache distortion applied. The original image is preserved.
	**/
	public static function mustacheDistortion(image:Image, amplitude:Float = 0.2):Image {
		var centerX = image.width / 2,
			centerY = image.height / 2;
		var maxRadius = Math.min(centerX, centerY);
		var maxDistance = {
			var dx = (image.width - centerX) / maxRadius;
			var dy = (image.height - centerY) / maxRadius;
			Math.sqrt(dx * dx + dy * dy);
		};
		var processed = new Image(image.width, image.height);
		processed.copyViewFrom(image);

		image.forEachPixelInView((x, y, color) -> {
			var dx = (x - centerX) / maxRadius;
            var dy = (y - centerY) / maxRadius;
            var distance = Math.sqrt(dx * dx + dy * dy);
			var strength = (-distance + maxDistance / 2) * amplitude;

			var r = Math.pow(distance, distance * strength);

            var srcX = centerX + r * dx * maxRadius;
            var srcY = centerY + r * dy * maxRadius;

			if (!image.hasPixel(srcX, srcY)) return;
            var color = image.getFloatingPixel(srcX, srcY);
            processed.setPixel(x, y, color);
		});

		return processed;
	}

	/**
			    Loops over the given image's pixels with a kernel, and replaces the center pixel of that kernel with the "maximum value" inside that kernel:

		**What does replacing with the maximum value mean?**

		Basically, if a nearby pixel is lighter than the current pixel, the current pixel is replaced with the lighter pixel.
		That check is applied to all neighboring pixels, resulting in each pixel's color being the lightest color in its surroundings.

		**example:** an image being dilated with a 5x5 square kernel. you should see how each time the kernel moves, it picks the lightest colors inside of it, and continues.

		| Before | After (Radius 3) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Radius 3](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-dilate.png) |

		@param image The image to operate on.
		@param dilationRadius The radius of the kernel used for the dilation process.
		The radius does not include the center pixel, so a radius of `2` should give a `5x5` kernel.
		The higher this value, the further each pixel checks for a nearby lighter pixel. Default is `2`.
		@param colorImportanceOrder Since there may be conflicts when calculating the difference in lightness
		between colors with similar values in different color channels
		(e.g. `0xFF0000` and `0x0000FF` - channel values are "similar", colors are not),
		this parameter is used to favor the given color channels. Default is `RedGreenBlue` -
		`red` is the most important, and is considered the "lightest", followed by green,
		and blue is considered the "darkest".
		@param circularKernel When enabled, the kernel used to loop over the pixels becomes circular instead of being a
		square. This results in a slight performance increase, and a great quality increase. Default is `true`.
		@return The dilated image. The original copy is modified.
	**/
	public static function dilate(image:Image, dilationRadius:Int = 2, colorImportanceOrder:ColorImportanceOrder = RedGreenBlue, circularKernel:Bool = true):Image {
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

		| Before | After (Radius 3) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Radius 3](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-erode.png) |

		@param image The image to operate on.
		@param dilationRadius The radius of the kernel used for the erosion process.
		The radius does not include the center pixel, so a radius of `2` should give a `5x5` kernel.
		The higher this value, the further each pixel checks for a nearby darker pixel. Default is `2`.
		@param colorImportanceOrder Since there may be conflicts when calculating the difference in darkness between
		colors with similar values in different color channels
		(e.g. `0xFF0000` and `0x0000FF` - channel values are "similar", colors are not), this parameter is used to
		favor the given color channels. The default is `RedGreenBlue` - `red` is the most important, and is considered
		the "darkest", followed by green, and blue is considered the "lightest".
		@param circularKernel When enabled, the kernel used to loop over the pixels becomes circular instead of being a
		square. This results in a slight performance increase, and a massive quality increase. Default is `true`.
		@return The eroded image. The original copy is modified.
	**/
	public static function erode(image:Image, erosionRadius:Int = 2, colorImportanceOrder:ColorImportanceOrder = RedGreenBlue, circularKernel:Bool = true):Image {
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

		| Before | After (25% probability) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![25% probability](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-salt-pepper.png) |

		@param image The image to apply salt&pepper noise on.
		@param percentage How much of the image should be "corrupted", in percentages between `0` to `100` - `0`
		means no change, `100` means fully "corrupted". Default is `25`.
		@return The noisy image. The original copy is modified.

		@see **`Color.interpolate()`**
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

		| Before | After (15% probability) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![15% probability](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-dropout.png) |

		@param image The image to apply drop-out noise on
		@param percentage How much of the image should be "corrupted", in percentages between `0` to `100` -
		`0` means no change, `100` means fully "corrupted". Default is `5`.
		@param threshold The threshold at which a pixel is considered "black" or "white". A color measures against
		this threshold by grabbing the largest color channel value, and comparing it. Default is `128`.
		@return The noisy image. The original copy is modified.
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
		Adds Gaussian noise to the RGB channels of an image.

		Samples are added in 8-bit channel units, rounded, and clamped to 0–255.
		The operation preserves alpha and processes the full image.

		| Before | After (Sigma 22) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Sigma 22](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-gaussian-noise.png) |

		@param image The source image.
		@param sigma Standard deviation of the noise, in channel units.
		@param mean Mean offset of the noise, in channel units.
		@param monochrome Reuse one sample for all three channels of each pixel.
		@param seed Optional repeatable seed. A zero seed is treated as 1.
		@return A new noisy image with the same dimensions.
		@throws VisionError If the mean or sigma is nonfinite or sigma is negative.
	**/
	public static function gaussianNoise(image:Image, sigma:Float = 15, mean:Float = 0, monochrome:Bool = false, ?seed:Int):Image {
		if (!Math.isFinite(sigma) || sigma < 0 || !Math.isFinite(mean))
			throw new VisionError("Use a finite mean and a finite nonnegative sigma.", "GaussianNoise");
		return GaussianNoise.apply(image, sigma, mean, monochrome, seed);
	}

	/**
		Applies white noise to an image. White noise is the "snow" screen you see on televisions when they pick up unwanted electric/radiated electromagnetic signals instead of the channels you want to watch.

		Instead of applying white noise every couple of pixels, white noise is sort of "combined" with the image, according to `percentage`:

		| Before | After (Default noise range) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Default noise range](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-white-noise.png) |

		@param image The image to apply salt&pepper noise on
		@param percentage How white-noisy the resulting image should be, or, the ratio between the contributions of each pixel from the original image and the white noise to the final image, from 0 to 100: a lower value will make the first image's pixels contribute more to the the final image, thus making the resulting image less noisy, and vice-versa.
		@param whiteNoiseRange The number of shades of gray used to generate the white noise. Shouldn't really effect performance, but you may want to change it to get a "higher/lower quality" white noise.
		@return The noisy image. The original copy is modified.
	**/
	public static function whiteNoise(image:Image, percentage:Float = 25, whiteNoiseRange:WhiteNoiseRange = RANGE_16):Image {
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
		Linearly maps each RGB channel from its observed range to the requested range.

		The extrema are measured within the image view. Channels with a constant value and pixel alpha are preserved.

		| Before | After (RGB range 48–208) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![RGB range 48–208](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-normalize.png) |

		@param image The image to be normalized.
		@param rangeStart The start of the range of channels. By default, this value is `0x00000000`
		@param rangeEnd The end of the range of channels. By default, this value is `0xFFFFFFFF`
		@return The modified input image.
	**/
	public static function normalize(image:Image, rangeStart:Color = 0x00000000, rangeEnd:Color = 0xFFFFFFFF):Image {
		// Find current min/max values in the image
		var curMinRed = 255, curMaxRed = 0;
		var curMinGreen = 255, curMaxGreen = 0;
		var curMinBlue = 255, curMaxBlue = 0;
		
		image.forEachPixelInView((x, y, color) -> {
			if (color.red < curMinRed) curMinRed = color.red;
			if (color.red > curMaxRed) curMaxRed = color.red;
			if (color.green < curMinGreen) curMinGreen = color.green;
			if (color.green > curMaxGreen) curMaxGreen = color.green;
			if (color.blue < curMinBlue) curMinBlue = color.blue;
			if (color.blue > curMaxBlue) curMaxBlue = color.blue;
		});
		
		// Calculate target range
		var targetMinRed = MathTools.min(rangeStart.red, rangeEnd.red);
		var targetMaxRed = MathTools.max(rangeStart.red, rangeEnd.red);
		var targetMinGreen = MathTools.min(rangeStart.green, rangeEnd.green);
		var targetMaxGreen = MathTools.max(rangeStart.green, rangeEnd.green);
		var targetMinBlue = MathTools.min(rangeStart.blue, rangeEnd.blue);
		var targetMaxBlue = MathTools.max(rangeStart.blue, rangeEnd.blue);
		
		// Scale each pixel to the new range
		image.forEachPixelInView((x, y, color) -> {
			if (curMaxRed != curMinRed)
				color.red = Math.round((color.red - curMinRed) / (curMaxRed - curMinRed) * (targetMaxRed - targetMinRed) + targetMinRed);
			if (curMaxGreen != curMinGreen)
				color.green = Math.round((color.green - curMinGreen) / (curMaxGreen - curMinGreen) * (targetMaxGreen - targetMinGreen) + targetMinGreen);
			if (curMaxBlue != curMinBlue)
				color.blue = Math.round((color.blue - curMinBlue) / (curMaxBlue - curMinBlue) * (targetMaxBlue - targetMinBlue) + targetMinBlue);
			image.setUnsafePixel(x, y, color);
		});
		return image;
	}

	/**
		Clamps the red, green, and blue channels to the supplied bounds.

		The bounds are applied independently to each channel within the image view. Pixel alpha is preserved.

		| Before | After (RGB clamped to 80–176) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![RGB clamped to 80–176](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-limit.png) |

		@param image The image to clamp.
		@param rangeStart The start of the range of channels. By default, this value is `0x00000000`
		@param rangeEnd The end of the range of channels. By default, this value is `0xFFFFFFFF`
		@return The modified input image.
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
		Replaces a pixel when one or more RGB channels fall outside the supplied inclusive range.

		Ranges are applied in array order within the image view. A replacement color is used as supplied, including its alpha.

		The example replaces pixels that have an RGB channel outside the range 0–176 with cyan.

		| Before | After (Highlight replacement) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Highlight replacement](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-replace.png) |

		@param image The image to process.
		@param ranges The ordered color ranges and replacement colors.
		@return A processed version of the image. The original image is modified.
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
		Returns a grayscaled image containing only the values of a given color channel.

		| Before | After (Red channel) | After (Green channel) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Red channel](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-channel-red.png) | ![Green channel](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-channel-green.png) |

		@param image The image to be processed
		@param channel The color channel to be isolated
		@return The processed image. The original image is modified
	**/
	public static function filterForColorChannel(image:Image, channel:ColorChannel = ColorChannel.RED):Image {
		var output = image.clone();

		image.forEachPixelInView((x, y, color) -> {
			var colorValue = switch channel {
				case RED: Color.fromRGBA(color.red, 0, 0, color.alpha);
				case GREEN: Color.fromRGBA(0, color.green, 0, color.alpha);
				case BLUE: Color.fromRGBA(0, 0, color.blue, color.alpha);
				case ALPHA: Color.from8Bit(color.alpha);
				case CYAN: Color.fromFloat(color.cyan);
				case MAGENTA: Color.fromFloat(color.magenta);
				case YELLOW: Color.fromFloat(color.yellow);
				case HUE: Color.fromHSB(color.hue, 1, 1);
				case SATURATION: Color.fromFloat(color.saturation);
				case BRIGHTNESS: Color.fromFloat(color.brightness);
			}

			output.setUnsafePixel(x, y, colorValue);
		});

		return output;
	}

	/**
		Applies kernel weights to the RGB channels and returns a new image. The
		source and its alpha channel are preserved. The default kernel is identity.

		The kernel must have positive odd width and height. Its center is the anchor,
		and weights are applied in row order without flipping or normalization.
		Samples beyond the image bounds repeat the nearest border pixel. Output
		channels are clamped to [0, 255] and rounded to the nearest integer.

		| Before | After (5×5 Gaussian kernel) | After (Sharpening kernel) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![5×5 Gaussian kernel](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-convolve-gaussian.png) | ![Sharpening kernel](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-convolve-sharpen.png) |

		@param image The source image. The active view limits the output region.
		@param kernel The odd-sized matrix of finite RGB weights. Defaults to identity.
		@return A new image with the filtered RGB channels and source alpha.
		@throws MatrixShapeError If the kernel dimensions are invalid.
		@throws VisionException If any weight is nonfinite.
	**/
	public static function convolve(image:Image, ?kernel:Matrix2D):Image {
		if (kernel == null) kernel = Kernels.identity();
		var width = kernel.width;
		var height = kernel.height;
		if (width <= 0 || height <= 0 || width % 2 == 0 || height % 2 == 0 || kernel.underlying.length != width * height)
			throw new MatrixShapeError("Kernel dimensions must be positive and odd.", "Kernel Error");
		for (weight in kernel.underlying.inner) {
			if (weight == null || !Math.isFinite(weight))
				throw new VisionException("Kernel weights must be finite numbers.", "Kernel Error");
		}

		var result = image.clone();
		var anchorX = width >> 1;
		var anchorY = height >> 1;
		image.forEachPixelInView((x, y, pixel) -> {
			var red = 0., green = 0., blue = 0.;
			for (ky in 0...height) {
				for (kx in 0...width) {
					var sample = image.getSafePixel(x + kx - anchorX, y + ky - anchorY);
					var weight = kernel.get(kx, ky);
					red += sample.red * weight;
					green += sample.green * weight;
					blue += sample.blue * weight;
				}
			}
			result.setUnsafePixel(x, y, Color.fromRGBA(
				Math.round(boundFloat(red, 0, 255)), Math.round(boundFloat(green, 0, 255)), Math.round(boundFloat(blue, 0, 255)), pixel.alpha
			));
		});
		return result;
	}

	/**
		Applies an affine `Transform2D` and returns a new image. Defaults to the
		identity transform and `RESIZE` expansion.

		`originPoint` overrides `originMode`, which defaults to `CENTER`.
		Throws if the transform has a nonconstant or zero homogeneous denominator.
		Use `Transform2D.fromMatrix` to supply custom coefficients.

		| Before | After (30° rotation) | After (Shear) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![30° rotation](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-affine-rotation.png) | ![Shear](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-affine-shear.png) |

		@param image The source image.
		@param matrix The affine coordinate mapping.
		@param expansionMode How the result canvas fits the transformed image.
		@param originPoint An explicit origin in image coordinates.
		@param originMode The preset origin used when no point is supplied.
		@return A new transformed image.
		@throws VisionException If the supplied mapping is not affine.
	**/
	public static function affineTransform(image:Image, ?matrix:Transform2D, expansionMode:ImageExpansionMode = RESIZE, ?originPoint:Point2D, ?originMode:TransformationMatrixOrigination = CENTER):Image {
		if (matrix == null) matrix = Transform2D.identity();
		if (!matrix.isAffine()) throw new VisionException("An affine transform requires a constant nonzero homogeneous denominator.", "Transform Error");
		// Get the max values for bounds expansion
		var mix = MathTools.POSITIVE_INFINITY, max = MathTools.NEGATIVE_INFINITY, miy = MathTools.POSITIVE_INFINITY, may = MathTools.NEGATIVE_INFINITY;
		for (corner in [new Point2D(0, 0), new Point2D(0, image.height - 1), new Point2D(image.width - 1, 0), new Point2D(image.width - 1, image.height - 1)]) {
			var c = matrix.apply(corner);
			if (c.x > max) max = c.x;
			if (c.x < mix) mix = c.x;
			if (c.y > may) may = c.y;
			if (c.y < miy) miy = c.y;
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
				var coords = matrix.apply(new Point2D(x - offset.x, y - offset.y));
				coords.x += offset.x * (1 / ratioX);
				coords.y += offset.y * (1 / ratioY);
				// Translate coordinates back to their original position
				img.setSafePixel(coords.x.round(), coords.y.round(), image.getFloatingPixel(x, y));
				y += ratioY;
			}
			x += ratioX;
			y = 0;
		}

		return img;
	}

	/**
		Applies a projective `Transform2D` and returns a new image. Defaults to
		the identity transform and `RESIZE` expansion. The source image must
		map to finite coordinates without crossing the projective horizon. Each output
		pixel is mapped back to the source for bilinear sampling. Pixels outside
		the projected source stay transparent.

		| Before | After (Perspective skew) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Perspective skew](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-projective-inverse.png) |

		@param image The source image.
		@param matrix The projective coordinate mapping.
		@param expansionMode How the result canvas fits the transformed image.
		@return A new warped image.
	**/
	public static function projectiveTransform(image:Image, ?matrix:Transform2D, expansionMode:ImageExpansionMode = RESIZE):Image {

		if (matrix == null) matrix = Transform2D.identity();
		if (image.width == 0 || image.height == 0) return image.clone();
		// Get the max values for bounds expansion
		var mix = MathTools.POSITIVE_INFINITY, max = MathTools.NEGATIVE_INFINITY, miy = MathTools.POSITIVE_INFINITY, may = MathTools.NEGATIVE_INFINITY,
			miz = MathTools.POSITIVE_INFINITY, maz = MathTools.NEGATIVE_INFINITY;
		for (corner in [new Point3D(0, 0, 1), new Point3D(0, image.height - 1, 1), new Point3D(image.width - 1, 0, 1), new Point3D(image.width - 1, image.height - 1, 1)]) {
			var homogeneous = matrix.applyHomogeneous(corner);
			var c = Transform2D.project(homogeneous);
			if (c.x > max) max = c.x;
			if (c.x < mix) mix = c.x;
			if (c.y > may) may = c.y;
			if (c.y < miy) miy = c.y;
			if (homogeneous.z > maz) maz = homogeneous.z;
			if (homogeneous.z < miz) miz = homogeneous.z;
		}
		if (miz < 0 && maz > 0)
			throw new VisionException("The image crosses the projective horizon.", "Transform Error");
		// Inverse mapping visits every output pixel, so expanding the image leaves no holes.
		final inverse = matrix.inverse();
		final left = expansionMode == SHRINK ? Math.floor(mix) : (expansionMode == SAME_SIZE ? 0 : Math.floor(Math.min(0, mix)));
		final top = expansionMode == SHRINK ? Math.floor(miy) : (expansionMode == SAME_SIZE ? 0 : Math.floor(Math.min(0, miy)));
		final mappedWidth = Math.ceil(max) - left + 1;
		final mappedHeight = Math.ceil(may) - top + 1;
		final img = switch expansionMode {
			case SAME_SIZE: new Image(image.width, image.height);
			case EXPAND: new Image(Std.int(Math.max(image.width, mappedWidth)), Std.int(Math.max(image.height, mappedHeight)));
			case SHRINK: new Image(Std.int(Math.min(image.width, mappedWidth)), Std.int(Math.min(image.height, mappedHeight)));
			case RESIZE: new Image(mappedWidth, mappedHeight);
		};
		final epsilon = 1e-8;
		for (y in 0...img.height)
			for (x in 0...img.width) {
				final sample = inverse.applyHomogeneous(new Point3D(x + left, y + top, 1));
				if (sample.z == 0) continue;
				final sx = sample.x / sample.z;
				final sy = sample.y / sample.z;
				if (sx >= -epsilon && sx <= image.width - 1 + epsilon && sy >= -epsilon && sy <= image.height - 1 + epsilon)
					img.setUnsafePixel(x, y, image.getFloatingPixel(sx, sy));
			}

		return img;
	}

	/**
		Uses an iterative, nearest-neighbor style algorithm to blur an image.

		The algorithm is very simple and quite fast, but also very sensitive
		performance-wise. The maximum value recommended to use for the
		`iterations` property is 100, altho you shouldn't really find yourself using more than `25`.

		| Before | After (One pass) | After (Four passes) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![One pass](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-nearest-one.png) | ![Four passes](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-nearest-four.png) |

		@param image The image to be blurred.
		@param iterations The number of times the algorithm will be run. The more iterations, the more blurry the image will be, and the higher the "blur range". **For example:** a value of 3 will produce a blur range of 3 pixels on each object.

		@return The blurred result. Zero passes return the input.
	**/
	public static function nearestNeighborBlur(image:Image, iterations:Int = 1):Image {
		for (i in 0...iterations) image = convolve(image, Kernels.boxBlur());
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

		| Before | After (Sigma 1) | After (Sigma 2, 9×9 kernel) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Sigma 1](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-gaussian-one.png) | ![Sigma 2, 9×9 kernel](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-gaussian-two.png) |

		@param image The image to be blurred.
		@param sigma The sigma value to use for the gaussian distribution on the kernel. a lower value will focus more on the center pixel, while a higher value will shift focus to the surrounding pixels more, effectively blurring it better.
		@param kernelSize The width and height of the square kernel.
		@param fast Use the separable Gaussian implementation.
		@throws InvalidGaussianKernelSize if the kernel size is even, negative or `0`, this error is thrown.
		@return A new blurred image.
	**/
	public static function gaussianBlur(image:Image, ?sigma:Float = 1, ?kernelSize:GaussianKernelSize = GaussianKernelSize.X5, ?fast:Bool = false):Image {
		if (fast) return Gauss.fastBlur(image, kernelSize, sigma);
		return convolve(image, Kernels.gaussian(kernelSize, sigma));
	}

	/**
		Applies a median filter to an image to reduce the amount of noise in that image.

		Median filter "blurs" the image by taking a pixel & its surrounding,
		finding the median of that group, and setting the center pixel to that median.

		| Before | After (5 × 5 kernel) | After (10 rounded to 11) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![5 × 5 kernel](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-median-corrected-five.png) | ![10 rounded to 11](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-median-corrected-ten.png) |

		@param image The image to apply median blurring to.
		@param kernelSize The side length in pixels. An even size rounds up to the next odd size. Sizes of 1 or less return a copy.
		@return A new image with median filtering applied.
	**/
	public static function medianBlur(image:Image, kernelSize:Int = 5):Image {
		final median = image.clone();
		if (kernelSize <= 1) return median;
		final radius = kernelSize >> 1;
		final neighbors:Array<Int> = [];
		image.forEachPixelInView((x, y, color) -> {
			neighbors.resize(0);
			for (dy in -radius...radius + 1)
				for (dx in -radius...radius + 1)
					neighbors.push(image.getSafePixel(x + dx, y + dy));
			ArraySort.sort(neighbors, (a, b) -> a < b ? -1 : (a > b ? 1 : 0));
			median.setUnsafePixel(x, y, neighbors[neighbors.length >> 1]);
		});
		return median;
	}

	/**
		Uses a simple, partially recursive algorithm to detect line segments in an image.

		This legacy image-space segment finder is separate from the newer Hough family:
		use `vision.algorithms.Hough.detectLines(...)` for standard theta/rho lines and
		`Vision.houghLineSegmentDetection(...)` for probabilistic Hough segments. `SimpleHough`
		now remains only as a compatibility shim that converts standard parameter lines back to rays.

		The detector can join partially interrupted line segments.

		The cyan overlay shows the returned segments drawn with `Image.drawLine2D()`.

		| Before | After (Detected segments) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Detected segments](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-simple-lines.png) |

		@param image The image to be line detected.
		@param accuracy When a line is detected, the algorithm checks how much of the line actually covers a  "line portion" of the image. `accuracy` is set to `50` by default - at least half of the line has to match with the image. To optimize for line count, `40` and below is recommended. Otherwise, `50` to `60` should be fine.
		@param minLineLength The minimum length of a line segment to be detected.
		@param speedToAccuracyRatio  If the algorithm is too slow/too inaccurate for you, you can change this setting.

		@return The detected line segments.
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
		Detects bounded Hough line segments in an image.

		This is the probabilistic Hough family member: it starts from the same standard
		theta/rho candidate lines as `vision.algorithms.Hough.detectLines(...)`, then clips
		supported runs back to bounded `Line2D` segments.

		By default, this wrapper derives a Canny edge image before voting. Pass `edgeImage`
		when you already have a reusable binary edge map and want to avoid recomputing it.
		Custom edge maps must match `image.width` and `image.height`; mismatched inputs are rejected
		so returned segments stay bounded to the source image.

		The cyan overlay uses a vote threshold of 18, a minimum length of 18 pixels, and a maximum gap of 4 pixels.

		| Before | After (Detected segments) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Detected segments](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-hough-lines.png) |

		@param image The image whose bounds define the returned `Line2D` segments.
		@param candidateThreshold The minimum accumulator votes required before a candidate line is converted into one or more bounded segments.
		@param minLineLength The minimum accepted segment length, in pixels, after gap linking. Shorter segments are discarded.
		@param maxLineGap The maximum gap length, in pixels, that can still be bridged while extending a single returned segment.
		@param edgeImage An optional precomputed edge image to reuse instead of running Canny again. When provided, it must match the source image dimensions.

		@return The detected Hough line segments.
	**/
	public static function houghLineSegmentDetection(image:Image, candidateThreshold:Int = 20, minLineLength:Float = 10, maxLineGap:Float = 2, ?edgeImage:Image):Array<Line2D> {
		var options = new ProbabilisticHoughLineOptions();
		options.candidateThreshold = candidateThreshold;
		options.minLineLength = minLineLength;
		options.maxLineGap = maxLineGap;
		options.voteThreshold = 1;
		var sourceEdges = edgeImage == null ? cannyEdgeDetection(image, 1, X5, 0.05, 0.16) : edgeImage;
		return Hough.detectLineSegments(image, options, sourceEdges);
	}

	/**
		Detects circles in an image using the dedicated Hough circle path.

		Circle voting is a separate Hough family member with its own center/radius search
		space; it does not reuse the line accumulator or the probabilistic segment path.

		The detector works from grayscale, denoised image content and applies a Canny-style
		edge pass internally before voting for circle centers and radii.

		The example uses a radius range of 16–34 pixels on two solid disks. The overlay is drawn separately with `Image.drawCircle()` and `Image.setPixel()`.

		| Before | After (Detected circles) |
		| --- | --- |
		| ![Two disks with known radii](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-circle-input.png) | ![Detected circles](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-hough-circles.png) |

		@param image The source image to analyze.
		@param options Optional circle-detection controls such as radius bounds, center threshold, `dp`, and `minimumDistance`.

		@return The detected circles.
	**/
	public static function houghCircleDetection(image:Image, ?options:HoughCircleOptions):Array<Circle2D> {
		return Hough.detectCircles(image, options);
	}

	/**
		Finds corners where image brightness changes strongly in two directions.

		The detector scores each pixel, then returns strong local peaks that meet
		the requested spacing and threshold. Use `Harris.computeResponse()` to
		inspect the scores directly.

		Each returned corner is marked with a cyan square on a copy of the input.

		| Before | After (Corners marked in cyan) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Corners marked in cyan](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-harris.png) |

		@param image The image in which to detect corners
		@param options Optional settings for scoring and selecting corners
		@return The corner positions, ordered from strongest to weakest
	**/
	public static function harrisCornerDetection(image:Image, ?options:HarrisCornerOptions):Array<IntPoint2D> {
		return Harris.detectCorners(image, options);
	}

	/**
		Applies the sobel filter to an image.

		The image doesn't have to get grayscaled before being passed
		to this function.

		It is different from the `sobelEdgeDetection` function, since
		it doesn't try to threshold the resulting image to extract the strong edges,
		and leaves that information in. Example of this filter in action:

		| Before | After (Sobel response) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Sobel response](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-sobel-response.png) |

		@param image The image to be operated on
		@return A new image, containing the gradients of the edges as whitened pixels.
	**/
	public static function sobelEdgeDiffOperator(image:Image):Image {
		return Sobel.convolveWithSobelOperator(grayscale(image.clone()));
	}

	/**
		Applies the perwitt filter to an image.

		The image doesn't have to get grayscaled before being passed
		to this function.

		It is different from the `perwittEdgeDetection` function, since
		it doesn't try to threshold the resulting image to extract the strong edges,
		and leaves that information in. Example of this filter in action:

		| Before | After (Prewitt response) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Prewitt response](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-prewitt-response.png) |

		@param image The image to be operated on
		@return A new image, containing the gradients of the edges as whitened pixels.
	**/
	public static function perwittEdgeDiffOperator(image:Image):Image {
		return Perwitt.convolveWithPerwittOperator(grayscale(image.clone()));
	}

	/**
		Applies the Robert's Cross operator to an image.

		The image doesn't have to get grayscaled before being passed
		to this function.

		While being the one of the oldest forms of edge gradient operators (dates back to 1963!),
		Its one of the fastest, if not *the* fastest.

		It does have its caveats though: while generally being 2x faster, its *way* more sensitive to noise, and may produce a more "jagged" image.

		| Before | After (Roberts response) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Roberts response](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-roberts-response.png) |

		@param image The image to be operated on
		@return A new image, containing the gradients of the edges as whitened pixels.
	**/
	public static function robertEdgeDiffOperator(image:Image):Image {
		return RobertsCross.convolveWithRobertsCross(grayscale(image.clone()));
	}

	/**
		Applies the laplacian filter to an image.

		The image doesn't have to get grayscaled before being passed
		to this function.

		It is different from the `perwittEdgeDetection` function, since
		it doesn't try to threshold the resulting image to extract the strong edges,
		and leaves that information in. Example of this filter in action:

		| Before | After (Positive response) | After (Negative response) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Positive response](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-laplace-positive.png) | ![Negative response](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-laplace-negative.png) |

		@param image The image to be operated on
		@param filterPositive Which version of the laplacian filter should the function use: the negative (detects "outward" edges), or the positive (detects "inward" edges). Default is positive (`true`).
		@return A new image, containing the gradients of the edges as whitened pixels.
	**/
	public static function laplacianEdgeDiffOperator(image:Image, filterPositive:Bool = true):Image {
		return Laplace.convolveWithLaplacianOperator(image.clone(), filterPositive);
	}

	/**
		Uses Canny's edge multi stage edge detection algorithm to detect edges in an image,
		while reducing noise.

		This algorithm works by first applying a gaussian blur to the image, and then
		applying more filters to differentiate between strong edges, weak edges and non-edges.

		| Before | After (Detected edges) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Detected edges](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-canny.png) |

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

		| Before | After (Detected edges) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Detected edges](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-sobel.png) |

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

		| Before | After (Detected edges) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Detected edges](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-prewitt.png) |

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

		| Before | After (Positive response) | After (Negative response) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Positive response](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-log-positive-mask.png) | ![Negative response](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-log-negative-mask.png) |

		@param image The image to be processed.
		@param threshold The threshold for detecting edges. The lower the value, the more pixels will be considered edges. Default is `5`.
		@param filterPositive Which version of the laplacian filter should the function use: the negative (detects "outward" edges), or the positive (detects "inward" edges). Default is positive (`true`).
		@param sigma The sigma value to use for the gaussian blur. A lower value will focus the kernel more on the center pixel, while a higher value will shift focus to the surrounding pixels more. **The higher the value, the blurrier the image.** Default is `1`.
		@param kernelSize The size of the kernel (`width` & `height`) - a kernel size of `7`/ will produce a `7x7` kernel. Default is `GaussianKernelSize.X3`.
		@return A new, black and white image, with white pixels being the detected edges.
	**/
	public static function laplacianOfGaussianEdgeDetection(image:Image, threshold:Int = 2, filterPositive:Bool = true, sigma:Float = 1, kernelSize:GaussianKernelSize = X3):Image {
		return Laplace.laplacianOfGaussian(image, kernelSize, sigma, threshold, filterPositive);
	}

	/**
		Detects ridges using a convolution response and intensity normalization.

		The response highlights narrow structures and edges. Enable refinement to threshold the response and remove isolated pixels.

		| Before | After (Ridge response) |
		| --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Ridge response](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-ridge.png) |

		@param image the image to be ridge detected on.
		@param normalizationRangeStart Optional, if you want to change the normalization range's start color. `0xFF444444` by default.
		@param normalizationRangeEnd Optional, if you want to change the normalization range's end color `0xFFBBBBBB` by default.
		@param refine Appends an iterative pixel check to the algorithm, which removes isolated ridge pixels. `false` by default for performance reasons.
		@return The ridge-highlighted version of the image. **The original copy is preserved**.
	**/
	public static function convolutionRidgeDetection(image:Image, ?normalizationRangeStart:Color = 0xFF444444, ?normalizationRangeEnd:Color = 0xFFBBBBBB, refine:Bool = false):Image {
		var clone = image.clone().removeView();
		Vision.grayscale(clone);
		Vision.normalize(clone, normalizationRangeStart, normalizationRangeEnd);
		clone = Vision.convolve(clone, Kernels.ridgeDetectionAggressive());
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

		The example filters the noisy valve with spatial sigma 2 and intensity sigma 45.

		| Before | After (Bilateral filter) |
		| --- | --- |
		| ![Valve with Gaussian noise](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-noisy-input.png) | ![Bilateral filter](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-bilateral.png) |

		@param image The image to operate on.
		@param gaussianSigma The sigma to use when generating the gaussian kernel. This also decides the size of the kernel (The size of the kernel is always `Math.round(6 * gaussianSigma)`, and gets incremented if the resulting size is even)
		@param intensitySigma The intensity sigma decides how hard should the algorithm "try" to reduce the noise inside the image. A higher value causes a pixel that has vastly different color than it's surrounding to weigh much less, and pretty much get "ignored and overwritten". **tl;dr - a higher value reduces more noise, but may blur the image if too high.**
		@return A new filtered image.
	**/
	public static function bilateralDenoise(image:Image, gaussianSigma:Float = 0.8, intensitySigma:Float = 50):Image {
		return BilateralFilter.filter(image, gaussianSigma, intensitySigma);
	}


	/**
		Reduces noise by averaging pixels whose surrounding RGB patches are similar.

		The filter processes the full image and preserves each pixel's alpha.
		Reference patches are cropped at the image edges. Shifted samples beyond
		the image repeat the nearest border pixel. Runtime grows with the search area.

		The example uses strength 26, a patch radius of 2, and a search radius of 3 on the noisy valve.

		| Before | After (Non-local means) |
		| --- | --- |
		| ![Valve with Gaussian noise](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-noisy-input.png) | ![Non-local means](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-nonlocal.png) |

		@param image The source image.
		@param strength Filtering strength in 8-bit RGB units. Higher values average less similar patches.
		@param patchRadius Radius of the square patch used for comparison, in pixels.
		@param searchRadius Radius of the square neighborhood searched for similar patches, in pixels.
		@return A new image with the same dimensions. Zero strength or search radius returns a copy.
		@throws VisionError If a radius is negative or strength is negative or nonfinite.
	**/
	public static function nonLocalMeansDenoise(image:Image, strength:Float = 15, patchRadius:Int = 1, searchRadius:Int = 3):Image {
		if (!Math.isFinite(strength) || strength < 0 || patchRadius < 0 || searchRadius < 0)
			throw new VisionError("Use finite nonnegative strength and nonnegative radii.", "NonLocalMeans");
		return NonLocalMeans.denoise(image, strength, patchRadius, searchRadius);
	}

	/**
		Compares two images by resizing both to 4 × 4 and scoring the corresponding colors.

		The output is a number from 0 to 1, with 1 for identical inputs. The table shows the two inputs used in the comparison. The second image was tinted with amethyst at 50%.

		| Before | Compared image | After (scores) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Valve tinted amethyst](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-tint.png) | Highest color difference: `0.94109`<br>Average color difference: `0.85996`<br>Sum baseline overshoots: `0.69478` |

		@param image The first image to compare
		@param compared The second image to compare. If not provided, the first image will be compared to itself
		@param scoringMechanism The mechanism by which the similarity is calculated. Default is `AVERAGE_COLOR_DIFFERENCE`
		@return A number between 0 and 1 representing the similarity. `0` is the least similar, `1` means identical.
	**/
	public static function simpleImageSimilarity(image:Image, ?compared:Image, scoringMechanism:SimilarityScoringMechanism = AVERAGE_COLOR_DIFFERENCE):Float {
		var image1 = image.clone(), image2 = (compared == null ? image : compared).clone();
		image1.resize(4, 4, BilinearInterpolation);
		image2.resize(4, 4, BilinearInterpolation);
		var array1 = image1.toArray(), array2 = image2.toArray();
		var distances = [];
		for (i in 0...16) {
			distances.push(1 - Color.differenceBetween(array1[i], array2[i], false));
		}
		
		return switch scoringMechanism {
			case HIGHEST_COLOR_DIFFERENCE: distances.max();
			case AVERAGE_COLOR_DIFFERENCE: distances.average();
			case SUM_BASELINE_OVERSHOOTS: {
				var averages = distances.average();
				var overshoot = 1.;
				for (i in 0...16) {
					overshoot -= Math.max(0, distances[i] - averages);
				}
				overshoot;
			}
		}
		
	}

	/**
		Finds a template image within a larger source image.

		Checks positions where the entire template fits at its original size
		and orientation. The search uses both full images. Overlapping matches
		are allowed. Results are ordered by descending score, with ties in
		top-to-bottom, left-to-right order.

		```haxe
		var matches = Vision.find(screenshot, icon, ColorDifference, 0.97, 5);
		if (matches.length > 0) trace(matches[0].bounds);
		```

		![Plus icon used as the template](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-find-template.png)

		The scene contains an exact copy of the template, a one-pixel edit, a brighter copy, and a decoy. The examples mark every match at thresholds of 1 for exact, 0.99 for color difference, and 0.999 for normalized correlation.

		| Before | After (Exact) | After (Color difference) | After (Normalized correlation) |
		| --- | --- | --- | --- |
		| ![Exact icon, one edited pixel, brighter icon, and a decoy](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-find-input.png) | ![Exact](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-find-exact.png) | ![Color difference](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-find-color.png) | ![Normalized correlation](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-find-correlation.png) |

		@param image The source image to search.
		@param template The image to look for.
		@param technique How candidates are compared and scored. Defaults to exact RGBA matching.
		@param minimumScore Minimum accepted score, inclusive, from 0 to 1.
		@param maxMatches Maximum number of results. Zero returns all qualifying positions.
		@return Matching bounds and scores. An empty or oversized template yields an empty array.
		@throws VisionError If the score is outside [0, 1] or maxMatches is negative.
	**/
	public static function find(image:Image, template:Image, technique:ImageMatchingTechnique = Exact, minimumScore:Float = 0.95,
			maxMatches:Int = 0):Array<ImageMatch> {
		if (!Math.isFinite(minimumScore) || minimumScore < 0 || minimumScore > 1 || maxMatches < 0)
			throw new VisionError("Use a minimum score from 0 to 1 and a nonnegative match limit.", "ImageMatching");
		return ImageMatching.find(image, template, technique, minimumScore, maxMatches);
	}

	/**
		Uses K-Means image color clustering to posterize an image.

		This type of posteriztion is different from the default `posterize` method,
		as it reduces the amount of colors used by the image, instead of the
		amount of bits used by each color channel.

		K-means is a clustering algorithm that groups similar pixels together,
		by picking a couple of colors from the image, and iteratively seeing
		which are the most similar to each of those colors,
		and optimizing these colors to be the most similar to those pixels.

		| Before | After (4 colors) | After (8 colors) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![4 colors](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-kmeans-four.png) | ![8 colors](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-kmeans-eight.png) |

		@param image The image to posterize
		@param maxColorCount The amount of colors to use for the resulting image. At the algorithm's level, this also means the amount of color clusters to calculate. Default is `16`
		@return A posterized version of the image. The original image is preserved
	**/
	public static function kmeansPosterize(image:Image, maxColorCount:Int = 16):Image {
		var clusters = KMeans.getImageColorClusters(image, maxColorCount);
		var posterized = new Image(image.width, image.height);
		image.forEachPixelInView((x, y, _) -> {
			var color = image.getUnsafePixel(x, y);
			for (cluster in clusters) {
				if (cluster.items.contains(color) || color == cluster.centroid) {
					posterized.setUnsafePixel(x, y, cluster.centroid);
					break;
				}
			}
		});

		return posterized;
	}

	/**
		Uses K-Means image color clustering to group the colors of an image.

		K-means is a clustering algorithm that groups similar pixels together,
		by picking a couple of colors from the image, and iteratively seeing
		which are the most similar to each of those colors,
		and optimizing these colors to be the most similar to those pixels.


		Each swatch shows one returned cluster centroid. The swatches have equal widths for comparison.

		| Before | After (4 cluster centroids) | After (8 cluster centroids) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![4 cluster centroids](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-kmeans-palette-four.png) | ![8 cluster centroids](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-kmeans-palette-eight.png) |

		@param image The image to try color grouping on
		@param groupCount The amount of color groups we want to find. The more groups, the more accurate the grouping will be, but only to a certain point (an image with only 4 distinct colors won't have more than 4 groups). Default is `16`
		@param considerTransparency Retained for compatibility. The wrapper currently uses the clustering implementation’s default alpha handling.
		@return An array of color clusters. Each cluster contains both it's colors and the centroid used to group them.
	**/
	public static function kmeansGroupImageColors(image:Image, groupCount:Int = 16, considerTransparency:Bool = false):Array<ColorCluster> {
		return KMeans.getImageColorClusters(image, groupCount);
	}
	/**
		Reduces an image to a palette learned with e-means.

		Each distinct RGBA color contributes equally when learning the palette.
		The resulting image uses the mean color of each group.

		| Before | After (4 colors) | After (8 colors) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![4 colors](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-emeans-four.png) | ![8 colors](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-emeans-eight.png) |

		@param image The image to posterize
		@param maxColorCount The maximum number of palette colors
		@param epochs The number of training passes over the distinct colors
		@return A new image using the learned palette
	**/
	public static function emeansPosterize(image:Image, maxColorCount:Int = 16, epochs:Int = 5):Image {
		final groups = EMeans.getImageColorClusters(image, maxColorCount, epochs);
		final palette = new haxe.ds.IntMap<Color>();
		for (group in groups)
			for (color in group.items) palette.set(color, group.centroid);
		final posterized = new Image(image.width, image.height);
		image.forEachPixelInView((x, y, color) -> {
			final replacement = palette.get(color);
			posterized.setUnsafePixel(x, y, replacement == null ? color : replacement);
		});
		return posterized;
	}

	/**
		Groups distinct RGBA colors with e-means, using mini-batch updates to learn a palette.

		Each swatch shows one returned cluster centroid. The swatches have equal widths for comparison.

		| Before | After (4 cluster centroids) | After (8 cluster centroids) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![4 cluster centroids](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-emeans-palette-four.png) | ![8 cluster centroids](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-emeans-palette-eight.png) |

		@param image The image whose colors to group
		@param groupCount The maximum number of color groups
		@param epochs The number of training passes over the distinct colors
		@return The nonempty groups and the mean RGBA color of each group
	**/
	public static function emeansGroupImageColors(image:Image, groupCount:Int = 16, epochs:Int = 5):Array<ColorCluster> {
		return EMeans.getImageColorClusters(image, groupCount, epochs);
	}
	/**
		Reduces an image to an RGB palette while using a pixel pattern to preserve
		the appearance of intermediate shades.

		Colors are chosen by squared RGB distance, with ties resolved in palette
		order. Source alpha is preserved and fully transparent pixels are copied.
		The operation processes the full image, including pixels outside an image view.

		Both examples use the same five-color RGB palette.

		| Before | After (Floyd–Steinberg) | After (Ordered Bayer) |
		| --- | --- | --- |
		| ![Original valve image](https://spacebubble.io/vision/docs/valve-original.png) | ![Floyd–Steinberg](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-dither-floyd.png) | ![Ordered Bayer](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-dither-bayer.png) |

		@param image The source image.
		@param palette The palette colors. Defaults to black and white. Palette alpha is ignored.
		@param algorithm The dithering method. Defaults to Floyd–Steinberg.
		@return A new image with the same dimensions.
		@throws VisionError If the palette is empty.
	**/
	public static function dither(image:Image, ?palette:Array<Color>, algorithm:DitheringAlgorithm = FloydSteinberg):Image {
		if (palette == null) palette = [Color.BLACK, Color.WHITE];
		if (palette.length == 0) throw new VisionError("Provide at least one palette color.", "Dithering");
		return Dithering.apply(image, palette, algorithm);
	}

	/**
		Generates a new image from overlapping patterns found in a sample.

		Every complete square patch in the output comes from the sample. Patterns that appear
		more often in the sample are more likely to be chosen.

		The circuit sample demonstrates how local joins carry over into a larger layout. The mosaic sample shows how the model preserves local tile shapes and spacing. Both outputs are 66 × 39 pixels, generated with 3 × 3 patches and up to 20 attempts. Images are enlarged for display.

		```haxe
		var layout = Vision.synthesizePattern(sample, 66, 39, 3, 20);
		```

		| Before | After |
		| --- | --- |
		| ![Circuit sample](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-pattern-circuit-input.png) | ![New circuit layout](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-pattern-circuit-result.png) |
		| ![Mosaic sample](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-pattern-mosaic-input.png) | ![New mosaic layout](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-pattern-mosaic-result.png) |

		@param sample The image to learn patterns from
		@param width The output width in pixels
		@param height The output height in pixels
		@param patternSize The side length of each square patch
		@param attempts The maximum number of generation attempts
		@return A new image assembled from the learned patterns
		@throws PatternSynthesisError If the dimensions are invalid or no attempt succeeds
	**/
	public static function synthesizePattern(sample:Image, width:Int, height:Int, patternSize:Int = 2, attempts:Int = 8):Image {
		return PatternSynthesis.synthesize(sample, width, height, patternSize, attempts);
	}
	/**
		Generates a texture from a sample using Metropolis sampling.

		The sampler favors square patterns that occur often in the sample and can
		produce patterns absent from it. Pattern matching wraps around image edges.

		The stone sample has broad warm bands. The blue stipple sample has scattered highlights. Both outputs are 66 × 39 pixels, sampled with 3 × 3 patterns, 45 iterations, and temperature 1. Images are enlarged for display.

		```haxe
		var texture = Vision.synthesizeTexture(sample, 66, 39, 3, 45, 1);
		```

		| Before | After |
		| --- | --- |
		| ![Warm stone sample](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-texture-stone-input.png) | ![New warm stone texture](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-texture-stone-result.png) |
		| ![Cool stipple sample](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-texture-stipple-input.png) | ![New cool stipple texture](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-texture-stipple-result.png) |

		@param sample The texture to learn from
		@param width The output width in pixels
		@param height The output height in pixels
		@param patternSize The side length of the square patterns
		@param iterations The number of passes, each proposing one change per output pixel on average
		@param temperature A positive value controlling how readily rare patterns are accepted
		@return A new texture using the sample's colors
	**/
	public static function synthesizeTexture(sample:Image, width:Int, height:Int, patternSize:Int = 3, iterations:Int = 20, temperature:Float = 1):Image {
		return TextureSynthesis.synthesize(sample, width, height, patternSize, iterations, temperature);
	}

	/**
		Stitches a sequence of overlapping photos into a planar panorama.

		Place the photos in capture order with textured overlap between each pair.
		Photos should have similar scale and orientation. Overlapping pixels are
		blended, and gaps in the resulting bounds are transparent.

		[Source photos from OpenCV](https://github.com/opencv/opencv_extra/tree/4.x/testdata/stitching)

		| Before | After (Stitched panorama) |
		| --- | --- |
		| ![Three overlapping photos in capture order](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-panorama-input.png) | ![Stitched panorama](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-panorama-result.png) |

		@param images The ordered photos to stitch
		@return A new image containing the panorama
		@throws PanoramaError If adjacent images cannot be aligned
	**/
	public static function stitchPanorama(images:Array<Image>):Image {
		return Panorama.stitch(images);
	}
	/**
		Doubles the size of pixel art with the Scale2x algorithm.

		Two side neighbors must agree before extending an edge. With corner support,
		a third color at the diagonal keeps the center color in place.

		[Pixel art by Kenney](https://opengameart.org/content/roguelike-caves-dungeons-pack)

		All three panels use the same display scale relative to the original sprite. The original uses nearest-neighbor enlargement for comparison.

		| Before | After (Standard Scale2x) | After (Corner protection) |
		| --- | --- | --- |
		| ![Original sprite enlarged with nearest-neighbor for display](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-rescale-input.png) | ![Standard Scale2x](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-rescale-standard.png) | ![Corner protection](https://raw.githubusercontent.com/ShaharMS/spacebubble.io/ce9e3fb51e7b4568771bc3603cddd968882875bd/vision/docs/vision3-api-rescale-corners.png) |

		@param image The image to enlarge
		@param includeCorners Whether diagonal neighbors protect three-color junctions. Set to `false` for standard Scale2x
		@return A new image with twice the width and height
	**/
	public static function rescale(image:Image, includeCorners:Bool = true):Image {
		return Rescale.rescale(image, includeCorners);
	}
}
