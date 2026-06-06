package vision.algorithms;

import haxe.ds.ArraySort;
import vision.ds.Image;
import vision.ds.IntPoint2D;
import vision.ds.Matrix2D;
import vision.ds.harris.HarrisCornerCandidate;
import vision.ds.specifics.HarrisCornerOptions;
import vision.ds.specifics.HarrisResponseOptions;

/**
	Harris corner detection.

	The pipeline has two layers:

	1. **Response map** — convert the image to gradients, smooth structure-tensor terms
	   inside a local window, then score every pixel with
	   `det(M) - k * trace(M)^2`, where `M` is the summed gradient covariance.
	2. **Corner extraction** — threshold the response map, keep local maxima, sort by
	   strength, and apply minimum-distance / `maxCorners` filtering.

	Use `computeResponse(...)` when you want the raw score surface for custom selection or
	visualization. Use `detectCorners(...)` or `Vision.harrisCorners(...)` when you want
	ready-to-use corner positions as `IntPoint2D`.
**/
class Harris {

	/**
		Allocates a zero-filled Harris response map with the given dimensions.
	**/
	public static function createResponseMap(width:Int, height:Int):Matrix2D {
		var response = new Matrix2D(width, height);
		response.fill(0);
		return response;
	}

	/**
		Computes the Harris corner-response map for an image.

		The image is converted to grayscale intensity, differentiated with separable
		binomial kernels, then windowed to produce `Ix^2`, `Iy^2`, and `Ix*Iy` sums.
		Each pixel score is `det - k * trace^2`.
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

	/** Forces derivative aperture to a positive odd size (OpenCV-style Sobel sizing). **/
	static inline function normalizeApertureSize(apertureSize:Int):Int {
		if (apertureSize <= 1) return 1;
		return apertureSize % 2 == 0 ? apertureSize + 1 : apertureSize;
	}

	/** Clamps structure-tensor window size to at least 1. **/
	static inline function normalizeBlockSize(blockSize:Int):Int {
		return blockSize < 1 ? 1 : blockSize;
	}

	/** Converts RGB input to a single-channel luminance map for gradient computation. **/
	static function createIntensityMap(image:Image):Matrix2D {
		var intensity = new Matrix2D(image.width, image.height);
		for (y in 0...image.height) {
			for (x in 0...image.width) {
				var pixel = image.getPixel(x, y);
				intensity.set(x, y, 0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue);
			}
		}
		return intensity;
	}

	/** Builds the separable smoothing kernel paired with the derivative kernel. **/
	static function createSmoothingKernel(apertureSize:Int):Array<Float> {
		if (apertureSize == 1) return [1.0];
		return normalizeKernel(buildBinomialKernel(apertureSize));
	}

	/** Builds a 1D derivative kernel (central difference or binomial-smoothed variant). **/
	static function createDerivativeKernel(apertureSize:Int):Array<Float> {
		if (apertureSize == 1) return [-0.5, 0.0, 0.5];
		var smoothingKernel = buildBinomialKernel(apertureSize);
		var derivativeKernel:Array<Float> = [];
		var center = (smoothingKernel.length - 1) / 2.0;
		for (index in 0...smoothingKernel.length) {
			derivativeKernel.push((index - center) * smoothingKernel[index]);
		}
		return normalizeAbsKernel(derivativeKernel);
	}

	/** Expands Pascal's triangle row into a normalized 1D binomial kernel. **/
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

	/** Window weights for summing gradient products (box or Gaussian). **/
	static function createWindowKernel(blockSize:Int, useGaussianWindow:Bool):Array<Float> {
		var size = normalizeBlockSize(blockSize);
		if (size == 1) return [1.0];
		if (!useGaussianWindow) return [for (_ in 0...size) 1.0 / size];
		var kernel:Array<Float> = [];
		var center = (size - 1) / 2.0;
		var sigma = Math.max(0.5, size / 3.0);
		for (index in 0...size) {
			var distance = index - center;
			kernel.push(Math.exp(-(distance * distance) / (2 * sigma * sigma)));
		}
		return normalizeKernel(kernel);
	}

	/** Normalizes kernel weights to sum to 1. **/
	static function normalizeKernel(kernel:Array<Float>):Array<Float> {
		var sum = 0.0;
		for (value in kernel) sum += value;
		if (sum == 0) return kernel;
		return [for (value in kernel) value / sum];
	}

	/** Normalizes derivative kernel by sum of absolute values. **/
	static function normalizeAbsKernel(kernel:Array<Float>):Array<Float> {
		var sum = 0.0;
		for (value in kernel) sum += Math.abs(value);
		if (sum == 0) return kernel;
		return [for (value in kernel) value / sum];
	}

	/** Applies a separable 2D convolution (horizontal then vertical). **/
	static function convolveSeparable(source:Matrix2D, kernelX:Array<Float>, kernelY:Array<Float>):Matrix2D {
		var horizontal = convolveHorizontal(source, kernelX);
		return convolveVertical(horizontal, kernelY);
	}

	/** 1D horizontal convolution with edge clamping. **/
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

	/** 1D vertical convolution with edge clamping. **/
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

	/** Reads a matrix sample, clamping out-of-bounds coordinates to the nearest edge. **/
	static function sampleMatrix(matrix:Matrix2D, x:Int, y:Int):Float {
		var clampedX = x < 0 ? 0 : x >= matrix.width ? matrix.width - 1 : x;
		var clampedY = y < 0 ? 0 : y >= matrix.height ? matrix.height - 1 : y;
		return matrix.get(clampedX, clampedY);
	}

	/** Element-wise square (used for Ix^2 and Iy^2 terms). **/
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

	/** Element-wise product (used for the Ix*Iy cross term). **/
	static function multiplyMatrices(left:Matrix2D, right:Matrix2D):Matrix2D {
		var result = new Matrix2D(left.width, left.height);
		for (y in 0...left.height) {
			for (x in 0...left.width) result.set(x, y, left.get(x, y) * right.get(x, y));
		}
		return result;
	}

	/** Combines windowed structure-tensor sums into the Harris score `det - k * trace^2`. **/
	static function createHarrisScores(sumIx2:Matrix2D, sumIy2:Matrix2D, sumIxIy:Matrix2D, k:Float):Matrix2D {
		var response = createResponseMap(sumIx2.width, sumIx2.height);
		for (y in 0...response.height) {
			for (x in 0...response.width) {
				var det = sumIx2.get(x, y) * sumIy2.get(x, y) - sumIxIy.get(x, y) * sumIxIy.get(x, y);
				var trace = sumIx2.get(x, y) + sumIy2.get(x, y);
				response.set(x, y, det - k * trace * trace);
			}
		}
		return response;
	}

	/** Non-maximum suppression: pixel must beat its 8-neighborhood with stable tie-breaking. **/
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

	/** Sorts corner candidates by score (desc), then by position for determinism. **/
	static function compareCornerCandidates(left:HarrisCornerCandidate, right:HarrisCornerCandidate):Int {
		if (left.score != right.score) return left.score > right.score ? -1 : 1;
		if (left.point.y != right.point.y) return left.point.y < right.point.y ? -1 : 1;
		return left.point.x < right.point.x ? -1 : (left.point.x > right.point.x ? 1 : 0);
	}
}
