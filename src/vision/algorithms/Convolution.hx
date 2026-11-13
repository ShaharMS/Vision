package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Matrix2D;
import vision.ds.accelerate.PixelStorage;
import vision.exceptions.VisionException;
import vision.exceptions.MatrixShapeError;

using vision.tools.MathTools;

/** Packed RGB filtering shared by the CPU executor and browser reference path. **/
@:noCompletion
class Convolution {
	public static function validate(kernel:Matrix2D):Void {
		final width = kernel.width;
		final height = kernel.height;
		if (width <= 0 || height <= 0 || width % 2 == 0 || height % 2 == 0 || kernel.underlying.length != width * height)
			throw new MatrixShapeError("Kernel dimensions must be positive and odd.", "Kernel Error");
		for (weight in kernel.underlying.inner)
			if (#if !static weight == null || #end !Math.isFinite(weight))
				throw new VisionException("Kernel weights must be finite numbers.", "Kernel Error");
	}

	public static function apply(image:Image, kernel:Matrix2D, truncate:Bool = false):Image {
		final result = image.clone();
		final width = image.width;
		final height = image.height;
		final source = image.backend().readPixels();
		final output = result.backend().writePixels();
		final stride = width * 4;
		final offset = PixelStorage.PIXEL_OFFSET;
		final view = image.hasView() ? image.getView() : null;
		final weights = kernel.underlying.inner;
		final kernelWidth = kernel.width;
		final kernelHeight = kernel.height;
		final columns = [for (x in 0...width) for (kx in 0...kernelWidth)
			(x + kx - (kernelWidth >> 1)).clamp(0, width - 1) * 4];
		for (y in 0...height) {
			final rows = [for (ky in 0...kernelHeight)
				offset + (y + ky - (kernelHeight >> 1)).clamp(0, height - 1) * stride];
			for (x in 0...width) {
				if (view != null && !image.hasPixelInView(x, y, view)) continue;
				var red = 0.0;
				var green = 0.0;
				var blue = 0.0;
				var tap = 0;
				for (row in rows) {
					var column = x * kernelWidth;
					for (_ in 0...kernelWidth) {
						final sample = row + columns[column++];
						final weight = weights[tap++];
						red += source[sample + 1] * weight;
						green += source[sample + 2] * weight;
						blue += source[sample + 3] * weight;
					}
				}
				final pixel = offset + y * stride + x * 4;
				if (truncate) output[pixel] = 255;
				output[pixel + 1] = quantize(red, truncate);
				output[pixel + 2] = quantize(green, truncate);
				output[pixel + 3] = quantize(blue, truncate);
			}
		}
		return result;
	}

	static inline function quantize(value:Float, truncate:Bool):Int {
		final bounded = value.boundFloat(0, 255);
		return truncate ? Std.int(bounded) : Math.round(bounded);
	}
}
