package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Array2D;
import vision.exceptions.InvalidGaussianKernelSize;

/**
 * Gaussian kernel creation implementation, ported to Haxe by [Shahar Marcus](https://www.github.com/ShaharMS).
 */
class Gauss {

	public static function create2DKernelOfSize(size:Int, sigma:Float):Array2D<Float> {
		#if vision_quiet
		if (size < 0) size = -size;
		if (size % 2 == 0) size++;
		#else
		if (size % 2 == 0 || size <= 0) throw new InvalidGaussianKernelSize(size);
		#end
		var sum = 0.;
		var kernel = new Array2D<Float>(size, size);
		var radius = (size - 1) >> 1;

		// The common Gaussian prefactor cancels during normalization.
		for (x in -radius...radius + 1) {
			for (y in -radius...radius + 1) {
				var distance = Math.sqrt(x * 1.0 * x + y * 1.0 * y) / sigma;
				var weight = Math.exp(-0.5 * distance * distance);
				kernel.set(x + radius, y + radius, weight);
				sum += weight;
			}
		}

		// normalize the kernel
		for (i in 0...size) {
			for (j in 0...size) {
				kernel.set(i, j, kernel.get(i, j) / sum);
			}
		}

		return kernel;
	}

	public static function create1DKernelOfSize(size:Int, sigma:Float):Array<Float> {
		#if vision_quiet
		if (size <= 0) size = -size;
		if (size % 2 == 0) size++;
		#else
		if (size % 2 == 0 || size <= 0) throw new InvalidGaussianKernelSize(size);
		#end
		var r = Std.int(size / 2), sum = 0.;
		// kernel
		var kernel:Array<Float> = [];
		// compute kernel
		for (i in 0...size) {
			kernel[i] = Math.exp((i - r) * (i - r) / (-2 * sigma*sigma)) / (Math.sqrt(2 * Math.PI) * sigma);
			sum += kernel[i];
		}
		// normalize kernel
		for (i in 0...kernel.length) {
			kernel[i] /= sum;
		}
		return kernel;
	}

	public static function fastBlur(image:Image, size:Int, sigma:Float):Image {
		var preprocessed = image.clone();
		#if vision_quiet
		if (size <= 0) size = -size;
		if (size % 2 == 0) size++;
		#else
		if (size % 2 == 0 || size <= 0) throw new InvalidGaussianKernelSize(size);
		#end
		var radius = Std.int((size - 1) / 2);
		// first pass - vertical
		var kernel = create1DKernelOfSize(size, sigma);
		image.forEachPixelInView((x, y, color) -> {
			var red = 0., green = 0., blue = 0.;
			for (i in -radius...radius + 1) {
				var pixel = image.getSafePixel(x, y + i);
				red += pixel.red * kernel[i + radius];
				green += pixel.green * kernel[i + radius];
				blue += pixel.blue * kernel[i + radius];
			}
			preprocessed.setUnsafePixel(x, y, Color.fromRGBA(Std.int(red), Std.int(green), Std.int(blue)));
		});

		//second pass - horizontal
		var processed = image.clone();
		var kernel = create1DKernelOfSize(size, sigma);
		preprocessed.forEachPixelInView((x, y, color) -> {
			var red = 0., green = 0., blue = 0.;
			for (i in -radius...radius + 1) {
				var pixel = preprocessed.getSafePixel(x + i, y);
				red += pixel.red * kernel[i + radius];
				green += pixel.green * kernel[i + radius];
				blue += pixel.blue * kernel[i + radius];
			}
			processed.setUnsafePixel(x, y, Color.fromRGBA(Std.int(red), Std.int(green), Std.int(blue)));
		});

		return processed;
	}
}
