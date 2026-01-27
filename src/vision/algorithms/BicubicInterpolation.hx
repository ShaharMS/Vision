package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
using vision.tools.MathTools;

class BicubicInterpolation {
	public static function interpolate(image:Image, width:Int, height:Int):Image {
		final resized = new Image(width, height);
		final xMultiplier = image.width / width - 1 / width;
		final yMultiplier = image.height / height - 1 / height;
		resized.forEachPixel((x, y, c) -> {
			final color = sample(image, x * xMultiplier, y * yMultiplier);
			resized.setPixel(x, y, color);
		});
		return resized;
	}

	static inline function sample(image:Image, x:Float, y:Float):Color {
		if (!image.hasPixel(Math.ceil(x), Math.ceil(y)) || !image.hasPixel(Math.floor(x), Math.floor(y))) {
			x = x.boundFloat(0, image.width - 1);
			y = y.boundFloat(0, image.height - 1);
		}
		final x0 = Std.int(Math.floor(x));
		final y0 = Std.int(Math.floor(y));
		final tx = x - x0;
		final ty = y - y0;

		inline function cubic(p0:Float, p1:Float, p2:Float, p3:Float, t:Float):Float {
			var a0 = -0.5 * p0 + 1.5 * p1 - 1.5 * p2 + 0.5 * p3;
			var a1 = p0 - 2.5 * p1 + 2 * p2 - 0.5 * p3;
			var a2 = -0.5 * p0 + 0.5 * p2;
			var a3 = p1;
			return ((a0 * t + a1) * t + a2) * t + a3;
		}

		inline function channelAt(dx:Int, dy:Int, getter:Color->Int):Float {
			return getter(image.getSafePixel(x0 + dx, y0 + dy));
		}

		inline function sampleChannel(getter:Color->Int):Int {
			var row0 = cubic(
				channelAt(-1, -1, getter),
				channelAt(0, -1, getter),
				channelAt(1, -1, getter),
				channelAt(2, -1, getter),
				tx
			);
			var row1 = cubic(
				channelAt(-1, 0, getter),
				channelAt(0, 0, getter),
				channelAt(1, 0, getter),
				channelAt(2, 0, getter),
				tx
			);
			var row2 = cubic(
				channelAt(-1, 1, getter),
				channelAt(0, 1, getter),
				channelAt(1, 1, getter),
				channelAt(2, 1, getter),
				tx
			);
			var row3 = cubic(
				channelAt(-1, 2, getter),
				channelAt(0, 2, getter),
				channelAt(1, 2, getter),
				channelAt(2, 2, getter),
				tx
			);
			var value = cubic(row0, row1, row2, row3, ty);
			return Std.int(value.boundFloat(0, 255));
		}

		return Color.fromRGBA(
			sampleChannel(c -> c.red),
			sampleChannel(c -> c.green),
			sampleChannel(c -> c.blue),
			sampleChannel(c -> c.alpha)
		);
	}
}
