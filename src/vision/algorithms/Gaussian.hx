package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Array2D;
import vision.exceptions.InvalidGaussianKernalSize;

/**
 * Gaussian kernal creation implementation, ported to Haxe by [Shahar Marcus](https://www.github.com/ShaharMS).
 */
class Gaussian {

	@:deprecated("Gaussian.create1x1Kernal() is deprecated, use Gaussian.create2DKernelOfSize() instead") 
	public static function create1x1Kernal(sigma:Float):Array<Array<Float>> {
		return [[1]];
	}

	@:deprecated("Gaussian.create3x3Kernal() is deprecated, use Gaussian.create2DKernelOfSize() instead") 
	public static function create3x3Kernal(sigma:Float):Array<Array<Float>> {
		var r, s = 2.0 * sigma * sigma;
		var kernal:Array<Array<Float>> = [[], [], [], []];
		// sum is for normalization
		var sum = 0.0;

		// generating 3x3 kernel
		for (x in -1...2) {
			for (y in -1...2) {
				r = Math.sqrt(x * x + y * y);
				kernal[x + 1][y + 1] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
				sum += kernal[x + 1][y + 1];
			}
		}

		// normalizing the kernel
		for (i in 0...3) {
			for (j in 0...3) {
				kernal[i][j] /= sum;
			}
		}
		return kernal;
	}

	@:deprecated("Gaussian.create5x5Kernal() is deprecated, use Gaussian.create2DKernelOfSize() instead") 
	public static function create5x5Kernal(sigma:Float):Array<Array<Float>> {
		var r, s = 2.0 * sigma * sigma;
		var kernal:Array<Array<Float>> = [[], [], [], [], [], []];
		// sum is for normalization
		var sum = 0.0;

		// generating 5x5 kernel
		for (x in -2...3) {
			for (y in -2...3) {
				r = Math.sqrt(x * x + y * y);
				kernal[x + 2][y + 2] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
				sum += kernal[x + 2][y + 2];
			}
		}

		// normalizing the Kernel
		for (i in 0...5) {
			for (j in 0...5) {
				kernal[i][j] /= sum;
			}
		}
		return kernal;
	}

	@:deprecated("Gaussian.create7x7Kernal() is deprecated, use Gaussian.create2DKernelOfSize() instead") 
	public static function create7x7Kernal(sigma:Float):Array<Array<Float>> {
		var r, s = 2.0 * sigma * sigma;
		var kernal:Array<Array<Float>> = [[], [], [], [], [], [], [], []];
		// sum is for normalization
		var sum = 0.0;

		// generating 7x7 kernel
		for (x in -3...4) {
			for (y in -3...4) {
				r = Math.sqrt(x * x + y * y);
				kernal[x + 3][y + 3] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
				sum += kernal[x + 3][y + 3];
			}
		}

		// normalizing the Kernel
		for (i in 0...7) {
			for (j in 0...7) {
				kernal[i][j] /= sum;
			}
		}
		return kernal;
	}

	@:deprecated("Gaussian.create9x9Kernal() is deprecated, use Gaussian.create2DKernelOfSize() instead") 
	public static function create9x9Kernal(sigma:Float):Array<Array<Float>> {
		var r, s = 2.0 * sigma * sigma;
		var kernal:Array<Array<Float>> = [[], [], [], [], [], [], [], [], [], []];
		// sum is for normalization
		var sum = 0.0;

		// generating 9x9 kernel
		for (x in -4...5) {
			for (y in -4...5) {
				r = Math.sqrt(x * x + y * y);
				kernal[x + 4][y + 4] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
				sum += kernal[x + 4][y + 4];
			}
		}

		// normalizing the Kernel
		for (i in 0...9) {
			for (j in 0...9) {
				kernal[i][j] /= sum;
			}
		}
		return kernal;
	}
	@:deprecated("Gaussian.createKernalOfSize() is deprecated. use Gaussian.create2DKernalOfSize() instead")
	public static function createKernalOfSize(size:Int, sigma:Int) {
		return create2DKernelOfSize(size, sigma);
	}
	
	public static function create2DKernelOfSize(size:Int, sigma:Float):Array2D<Float> {
		#if vision_quiet
		if (size <= 0) size = -size;
		if (size % 2 == 0) size++;
		#else
		if (size % 2 == 0 || size <= 0) throw new InvalidGaussianKernalSize(size);
		#end
		var r, s = 2.0 * sigma * sigma, sum = 0.;
		var kernal:Array2D<Float> = new Array2D<Float>(size, size);
		// get the average of the parameter size, rounded down
		var avg = Std.int((size - 1) / 2);

		// generate the kernal
		for (x in -avg...avg + 1) {
			for (y in -avg...avg + 1) {
				r = Math.sqrt(x * x + y * y);
				kernal.set(x + avg, y + avg, (Math.exp(-(r * r) / s)) / (Math.PI * s));
				sum += kernal.get(x + avg, y + avg);
			}
		}

		// normalize the kernal
		for (i in 0...size) {
			for (j in 0...size) {
				kernal.set(i, j, kernal.get(i, j) / sum);
			}
		}

		return kernal;
	}

	public static function create1DKernelOfSize(size:Int, sigma:Float):Array<Float> {
		#if vision_quiet
		if (size <= 0) size = -size;
		if (size % 2 == 0) size++;
		#else
		if (size % 2 == 0 || size <= 0) throw new InvalidGaussianKernalSize(size);
		#end
		var r = size / 2, sum = 0.;
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

	public static function fastBlur(image:Image, size:Int, sigma:Float) {
		var preprocessed = image.clone();
		#if vision_quiet
		if (size <= 0) size = -size;
		if (size % 2 == 0) size++;
		#else
		if (size % 2 == 0 || size <= 0) throw new InvalidGaussianKernalSize(size);
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
