package vision.algorithms;

import vision.ds.HarrisCorner2D;
import vision.ds.Image;
import vision.ds.Matrix2D;
import vision.ds.specifics.HarrisCornerOptions;
import vision.ds.specifics.HarrisResponseOptions;

class Harris {
	public static function createResponseMap(width:Int, height:Int):Matrix2D {
		var response = new Matrix2D(width, height);
		response.fill(0);
		return response;
	}

	public static function computeResponse(image:Image, ?options:HarrisResponseOptions):Matrix2D {
		var resolvedOptions = resolveResponseOptions(options);
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

	public static function detectCorners(image:Image, ?options:HarrisCornerOptions):Array<HarrisCorner2D> {
		var resolvedOptions = resolveCornerOptions(options);
		var response = computeResponse(image, resolvedOptions);
		return detectCornersFromResponse(response, resolvedOptions);
	}

	public static function detectCornersFromResponse(response:Matrix2D, ?options:HarrisCornerOptions):Array<HarrisCorner2D> {
		var resolvedOptions = resolveCornerOptions(options);
		return HarrisCorners.detect(response, resolvedOptions);
	}

	static inline function resolveResponseOptions(?options:HarrisResponseOptions):HarrisResponseOptions {
		return options == null ? new HarrisResponseOptions() : options;
	}

	static inline function resolveCornerOptions(?options:HarrisCornerOptions):HarrisCornerOptions {
		return options == null ? new HarrisCornerOptions() : options;
	}

	static inline function normalizeApertureSize(apertureSize:Int):Int {
		if (apertureSize <= 1) return 1;
		return apertureSize % 2 == 0 ? apertureSize + 1 : apertureSize;
	}

	static inline function normalizeBlockSize(blockSize:Int):Int {
		return blockSize < 1 ? 1 : blockSize;
	}

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

	static function createSmoothingKernel(apertureSize:Int):Array<Float> {
		if (apertureSize == 1) return [1.0];
		return normalizeKernel(buildBinomialKernel(apertureSize));
	}

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

	static function normalizeKernel(kernel:Array<Float>):Array<Float> {
		var sum = 0.0;
		for (value in kernel) sum += value;
		if (sum == 0) return kernel;
		return [for (value in kernel) value / sum];
	}

	static function normalizeAbsKernel(kernel:Array<Float>):Array<Float> {
		var sum = 0.0;
		for (value in kernel) sum += Math.abs(value);
		if (sum == 0) return kernel;
		return [for (value in kernel) value / sum];
	}

	static function convolveSeparable(source:Matrix2D, kernelX:Array<Float>, kernelY:Array<Float>):Matrix2D {
		var horizontal = convolveHorizontal(source, kernelX);
		return convolveVertical(horizontal, kernelY);
	}

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

	static function sampleMatrix(matrix:Matrix2D, x:Int, y:Int):Float {
		var clampedX = x < 0 ? 0 : x >= matrix.width ? matrix.width - 1 : x;
		var clampedY = y < 0 ? 0 : y >= matrix.height ? matrix.height - 1 : y;
		return matrix.get(clampedX, clampedY);
	}

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

	static function multiplyMatrices(left:Matrix2D, right:Matrix2D):Matrix2D {
		var result = new Matrix2D(left.width, left.height);
		for (y in 0...left.height) {
			for (x in 0...left.width) result.set(x, y, left.get(x, y) * right.get(x, y));
		}
		return result;
	}

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
}