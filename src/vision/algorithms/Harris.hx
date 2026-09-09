package vision.algorithms;

import haxe.ds.ArraySort;
import vision.ds.Image;
import vision.ds.IntPoint2D;
import vision.ds.Matrix2D;
import vision.ds.harris.HarrisCornerCandidate;
import vision.ds.specifics.HarrisCornerOptions;
import vision.ds.specifics.HarrisResponseOptions;
import vision.tools.MathTools;
import vision.Vision;

/**
	Finds corner-like points in an image.

	A corner is a small area where the picture changes in more than one direction, such as
	the corner of a window or a book. Use `computeResponse(...)` when you want a score for
	every pixel, or `detectCorners(...)` when you want ready-to-use point positions.
**/
class Harris {
	// A central difference compares the immediate pixels on either side of the current pixel.
	static inline var CENTRAL_DIFFERENCE_WEIGHT = 0.5;
	// A Gaussian window needs a non-zero spread; half a pixel is the smallest useful spread here.
	static inline var MINIMUM_GAUSSIAN_SIGMA = 0.5;
	// Three standard deviations span the requested window, keeping most of the weight inside it.
	static inline var GAUSSIAN_WINDOW_SIGMA_SPAN = 3.0;

	/**
		Measures how strongly each pixel resembles a corner.

		The detector:

		1. Converts the image to grayscale so brightness is easier to compare.
		2. Looks for brightness changes from left to right and top to bottom.
		3. Combines nearby changes into one score for each pixel.

		A high positive score means that pixel is likely to be at a corner. Internally, the
		score is calculated from this small change matrix:

		```txt
		┌ Iₓ²   IₓIᵧ ┐
		│ IₓIᵧ Iᵧ²  │
		└             ┘

		score = det(M) − k × trace(M)²
		```
	**/
	public static function computeResponse(image:Image, ?options:HarrisResponseOptions):Matrix2D {
		var resolvedOptions = options == null ? new HarrisResponseOptions() : options;
		var intensity = createIntensityMap(image);
		var apertureSize = normalizeApertureSize(resolvedOptions.apertureSize);
		var smoothingKernel = createSmoothingKernel(apertureSize);
		var derivativeKernel = createDerivativeKernel(apertureSize);
		var gradientX = convolveSeparable(intensity, derivativeKernel, smoothingKernel);
		var gradientY = convolveSeparable(intensity, smoothingKernel, derivativeKernel);
		var windowKernel = createWindowKernel(resolvedOptions.blockSize, resolvedOptions.useGaussianWindow);
		var sumIx2 = convolveSeparable(squareMatrix(gradientX), windowKernel, windowKernel);
		var sumIy2 = convolveSeparable(squareMatrix(gradientY), windowKernel, windowKernel);
		var sumIxIy = convolveSeparable(multiplyMatrices(gradientX, gradientY), windowKernel, windowKernel);
		return createHarrisScores(sumIx2, sumIy2, sumIxIy, resolvedOptions.k);
	}

	/**
		Detects Harris corners directly from an image.

		This runs `computeResponse(...)` and then applies thresholding, non-maximum
		suppression, sorting, and spacing filters from `HarrisCornerOptions`.
	**/
	public static function detectCorners(image:Image, ?options:HarrisCornerOptions):Array<IntPoint2D> {
		// First score every pixel, then keep only the strongest well-spaced peaks.
		var resolvedOptions = options == null ? new HarrisCornerOptions() : options;
		return detectCornersFromResponse(computeResponse(image, resolvedOptions), resolvedOptions);
	}

	/**
		Detects Harris corners from a precomputed response map.

		Use this when the same response surface should seed multiple selection passes.
	**/
	public static function detectCornersFromResponse(response:Matrix2D, ?options:HarrisCornerOptions):Array<IntPoint2D> {
		var resolvedOptions = options == null ? new HarrisCornerOptions() : options;

		var strongest = 0.0;
		for (y in 0...response.height) {
			for (x in 0...response.width) {
				var value = response.get(x, y);
				if (value > strongest) strongest = value;
			}
		}
		if (strongest <= 0) return [];

		var relativeThreshold = resolvedOptions.relativeThreshold < 0 ? 0.0 : resolvedOptions.relativeThreshold;
		var threshold = strongest * relativeThreshold;
		var margin = resolvedOptions.borderMargin < 0 ? 0 : resolvedOptions.borderMargin;
		if (margin * 2 >= response.width || margin * 2 >= response.height) return [];

		var candidates:Array<HarrisCornerCandidate> = [];
		for (y in margin...response.height - margin) {
			for (x in margin...response.width - margin) {
				var value = response.get(x, y);
				if (value <= 0 || value < threshold || !isLocalMaximum(response, x, y, value)) continue;
				candidates.push({point: new IntPoint2D(x, y), score: value});
			}
		}

		ArraySort.sort(candidates, compareCornerCandidates);

		var corners:Array<HarrisCornerCandidate> = [];
		var minimumDistanceSquared = resolvedOptions.minimumDistance > 0 ? resolvedOptions.minimumDistance * resolvedOptions.minimumDistance : 0.0;
		for (candidate in candidates) {
			if (minimumDistanceSquared > 0) {
				var tooClose = false;
				for (accepted in corners) {
					var deltaX = accepted.point.x - candidate.point.x;
					var deltaY = accepted.point.y - candidate.point.y;
					if (deltaX * deltaX + deltaY * deltaY < minimumDistanceSquared) {
						tooClose = true;
						break;
					}
				}
				if (tooClose) continue;
			}
			corners.push(candidate);
			if (resolvedOptions.maxCorners > 0 && corners.length >= resolvedOptions.maxCorners) break;
		}

		return [for (corner in corners) corner.point];
	}

	/** Makes the brightness-change stencil positive and odd, so it has one center pixel. **/
	static inline function normalizeApertureSize(apertureSize:Int):Int {
		if (apertureSize <= 1) return 1;
		return apertureSize % 2 == 0 ? apertureSize + 1 : apertureSize;
	}

	/** Keeps the nearby comparison area at least one pixel wide. **/
	static inline function normalizeBlockSize(blockSize:Int):Int {
		return blockSize < 1 ? 1 : blockSize;
	}

	/**
		Converts the image through the public grayscale API before calculating changes.

		This deliberately reuses `Vision.grayscale(...)` instead of repeating its luminance
		weights here, so Harris sees brightness exactly as the rest of the library does.
	**/
	static function createIntensityMap(image:Image):Matrix2D {
		var grayscale = Vision.grayscale(image.clone());
		var intensity = new Matrix2D(image.width, image.height);
		for (y in 0...image.height) {
			for (x in 0...image.width) {
				intensity.set(x, y, grayscale.getPixel(x, y).red);
			}
		}
		return intensity;
	}

	/** Builds the gentle blur paired with the brightness-change kernel. **/
	static function createSmoothingKernel(apertureSize:Int):Array<Float> {
		if (apertureSize == 1) return [1.0];
		return normalizeKernel(buildBinomialKernel(apertureSize));
	}

	/**
		Builds a one-dimensional brightness-change kernel.

		A one-pixel aperture uses the standard central difference: half the change from the
		left neighbor to the right neighbor. Larger apertures add binomial smoothing first,
		which makes the detector less sensitive to isolated noisy pixels.
	**/
	static function createDerivativeKernel(apertureSize:Int):Array<Float> {
		if (apertureSize == 1) return [-CENTRAL_DIFFERENCE_WEIGHT, 0.0, CENTRAL_DIFFERENCE_WEIGHT];
		var smoothingKernel = buildBinomialKernel(apertureSize);
		var derivativeKernel:Array<Float> = [];
		var center = (smoothingKernel.length - 1) / 2.0;
		for (index in 0...smoothingKernel.length) {
			derivativeKernel.push((index - center) * smoothingKernel[index]);
		}
		return normalizeAbsKernel(derivativeKernel);
	}

	/** Expands Pascal's triangle into weights that emphasize nearby pixels without adding a hard edge. **/
	static function buildBinomialKernel(size:Int):Array<Float> {
		var kernel:Array<Float> = [1.0];
		for (_ in 1...size) {
			var next:Array<Float> = [];
			for (index in 0...kernel.length + 1) {
				var left = index > 0 ? kernel[index - 1] : 0.0;
				var right = index < kernel.length ? kernel[index] : 0.0;
				next.push(left + right);
			}
			kernel = next;
		}
		return kernel;
	}

	/**
		Builds the weights for combining nearby brightness changes.

		The default box window gives every nearby pixel equal influence. A Gaussian window
		favors pixels near the center; its spread is chosen so three standard deviations fit
		across the requested window.
	**/
	static function createWindowKernel(blockSize:Int, useGaussianWindow:Bool):Array<Float> {
		var size = normalizeBlockSize(blockSize);
		if (size == 1) return [1.0];
		if (!useGaussianWindow) return [for (_ in 0...size) 1.0 / size];
		var kernel:Array<Float> = [];
		var center = (size - 1) / 2.0;
		var sigma = Math.max(MINIMUM_GAUSSIAN_SIGMA, size / GAUSSIAN_WINDOW_SIGMA_SPAN);
		for (index in 0...size) {
			var distance = index - center;
			kernel.push(Math.exp(-(distance * distance) / (2 * sigma * sigma)));
		}
		return normalizeKernel(kernel);
	}

	/** Scales weights so smoothing keeps an even-brightness image at the same brightness. **/
	static function normalizeKernel(kernel:Array<Float>):Array<Float> {
		var sum = 0.0;
		for (value in kernel) sum += value;
		if (sum == 0) return kernel;
		return [for (value in kernel) value / sum];
	}

	/** Scales brightness-change weights so aperture size does not inflate the response by itself. **/
	static function normalizeAbsKernel(kernel:Array<Float>):Array<Float> {
		var sum = 0.0;
		for (value in kernel) sum += Math.abs(value);
		if (sum == 0) return kernel;
		return [for (value in kernel) value / sum];
	}

	/** Applies one horizontal pass and one vertical pass, which is faster than a full 2D pass. **/
	static function convolveSeparable(source:Matrix2D, kernelX:Array<Float>, kernelY:Array<Float>):Matrix2D {
		var horizontal = convolveHorizontal(source, kernelX);
		return convolveVertical(horizontal, kernelY);
	}

	/** Applies one horizontal kernel while reusing the nearest edge pixel beyond the image. **/
	static function convolveHorizontal(source:Matrix2D, kernel:Array<Float>):Matrix2D {
		var result = new Matrix2D(source.width, source.height);
		var start = -Std.int(kernel.length / 2);
		for (y in 0...source.height) {
			for (x in 0...source.width) {
				var sum = 0.0;
				for (index in 0...kernel.length) sum += sampleMatrix(source, x + start + index, y) * kernel[index];
				result.set(x, y, sum);
			}
		}
		return result;
	}

	/** Applies one vertical kernel while reusing the nearest edge pixel beyond the image. **/
	static function convolveVertical(source:Matrix2D, kernel:Array<Float>):Matrix2D {
		var result = new Matrix2D(source.width, source.height);
		var start = -Std.int(kernel.length / 2);
		for (y in 0...source.height) {
			for (x in 0...source.width) {
				var sum = 0.0;
				for (index in 0...kernel.length) sum += sampleMatrix(source, x, y + start + index) * kernel[index];
				result.set(x, y, sum);
			}
		}
		return result;
	}

	/** Reads a matrix value; requests outside the image use the nearest edge value. **/
	static function sampleMatrix(matrix:Matrix2D, x:Int, y:Int):Float {
		var clampedX = MathTools.clamp(x, 0, matrix.width - 1);
		var clampedY = MathTools.clamp(y, 0, matrix.height - 1);
		return matrix.get(clampedX, clampedY);
	}

	/** Squares every brightness-change value so opposite directions contribute equally. **/
	static function squareMatrix(source:Matrix2D):Matrix2D {
		var result = new Matrix2D(source.width, source.height);
		for (y in 0...source.height) {
			for (x in 0...source.width) {
				var value = source.get(x, y);
				result.set(x, y, value * value);
			}
		}
		return result;
	}

	/** Multiplies horizontal and vertical brightness changes to capture diagonal change. **/
	static function multiplyMatrices(left:Matrix2D, right:Matrix2D):Matrix2D {
		var result = new Matrix2D(left.width, left.height);
		for (y in 0...left.height) {
			for (x in 0...left.width) result.set(x, y, left.get(x, y) * right.get(x, y));
		}
		return result;
	}

	/**
		Combines nearby brightness changes into one corner score per pixel.

		The response starts explicitly filled with zero, which keeps the result portable even
		on targets whose default array entries are `null`; every score is then written below.
	**/
	static function createHarrisScores(sumIx2:Matrix2D, sumIy2:Matrix2D, sumIxIy:Matrix2D, k:Float):Matrix2D {
		var response = new Matrix2D(sumIx2.width, sumIx2.height, 0);
		for (y in 0...response.height) {
			for (x in 0...response.width) {
				var det = sumIx2.get(x, y) * sumIy2.get(x, y) - sumIxIy.get(x, y) * sumIxIy.get(x, y);
				var trace = sumIx2.get(x, y) + sumIy2.get(x, y);
				response.set(x, y, det - k * trace * trace);
			}
		}
		return response;
	}

	/** Accepts only a peak that is stronger than its eight neighbors, with a stable tie-breaker. **/
	static function isLocalMaximum(response:Matrix2D, x:Int, y:Int, value:Float):Bool {
		for (neighborY in (y > 0 ? y - 1 : 0)...(y + 1 < response.height ? y + 2 : response.height)) {
			for (neighborX in (x > 0 ? x - 1 : 0)...(x + 1 < response.width ? x + 2 : response.width)) {
				if (neighborX == x && neighborY == y) continue;
				var neighborValue = response.get(neighborX, neighborY);
				if (neighborValue > value) return false;
				if (neighborValue == value && (neighborY < y || (neighborY == y && neighborX < x))) return false;
			}
		}
		return true;
	}

	/** Orders stronger corners first, then uses position to keep equal scores predictable. **/
	static function compareCornerCandidates(left:HarrisCornerCandidate, right:HarrisCornerCandidate):Int {
		if (left.score != right.score) return left.score > right.score ? -1 : 1;
		if (left.point.y != right.point.y) return left.point.y < right.point.y ? -1 : 1;
		return left.point.x < right.point.x ? -1 : (left.point.x > right.point.x ? 1 : 0);
	}
}
