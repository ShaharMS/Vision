package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
using vision.tools.MathTools;

class KernelResampler {
	public static function resize(image:Image, width:Int, height:Int, kernelRadius:Int, kernel:Float->Float):Image {
		final resized = new Image(width, height);
		final xMultiplier = image.width / width - 1 / width;
		final yMultiplier = image.height / height - 1 / height;
		resized.forEachPixel((x, y, c) -> {
			final color = sample(image, x * xMultiplier, y * yMultiplier, kernelRadius, kernel);
			resized.setPixel(x, y, color);
		});
		return resized;
	}

	public static function cubicKernel(t:Float, b:Float, c:Float):Float {
		var x = Math.abs(t);
		if (x < 1) {
			return ((12 - 9 * b - 6 * c) * x * x * x + (-18 + 12 * b + 6 * c) * x * x + (6 - 2 * b)) / 6;
		} else if (x < 2) {
			return ((-b - 6 * c) * x * x * x + (6 * b + 30 * c) * x * x + (-12 * b - 48 * c) * x + (8 * b + 24 * c)) / 6;
		}
		return 0;
	}

	static inline function sample(image:Image, x:Float, y:Float, kernelRadius:Int, kernel:Float->Float):Color {
		if (!image.hasPixel(Math.ceil(x), Math.ceil(y)) || !image.hasPixel(Math.floor(x), Math.floor(y))) {
			x = x.boundFloat(0, image.width - 1);
			y = y.boundFloat(0, image.height - 1);
		}
		final baseX = Std.int(Math.floor(x));
		final baseY = Std.int(Math.floor(y));

		final startX = baseX - kernelRadius + 1;
		final endX = baseX + kernelRadius;
		final startY = baseY - kernelRadius + 1;
		final endY = baseY + kernelRadius;

		var sumR = 0.0;
		var sumG = 0.0;
		var sumB = 0.0;
		var sumA = 0.0;
		var sumW = 0.0;

		for (ix in startX...endX + 1) {
			final wx = kernel(x - ix);
			if (wx == 0) continue;
			for (iy in startY...endY + 1) {
				final wy = kernel(y - iy);
				if (wy == 0) continue;
				final weight = wx * wy;
				if (weight == 0) continue;
				final color = image.getSafePixel(ix, iy);
				sumR += color.red * weight;
				sumG += color.green * weight;
				sumB += color.blue * weight;
				sumA += color.alpha * weight;
				sumW += weight;
			}
		}

		if (sumW == 0) {
			return image.getSafePixel(baseX, baseY);
		}

		return Color.fromRGBA(
			Std.int((sumR / sumW).boundFloat(0, 255)),
			Std.int((sumG / sumW).boundFloat(0, 255)),
			Std.int((sumB / sumW).boundFloat(0, 255)),
			Std.int((sumA / sumW).boundFloat(0, 255))
		);
	}
}
