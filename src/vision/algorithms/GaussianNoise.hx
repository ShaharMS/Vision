package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;

using vision.tools.MathTools;

/** Adds normally distributed noise using Box–Muller sampling. **/
class GaussianNoise {
	public static function apply(image:Image, sigma:Float, mean:Float, monochrome:Bool, seed:Null<Int>):Image {
		final output = image.clone();
		var state = seed == null || seed == 0 ? 1 : seed;
		var spare:Null<Float> = null;

		function uniform():Float {
			if (seed == null) return 1 - Math.random();
			state ^= state << 13;
			state ^= state >>> 17;
			state ^= state << 5;
			return ((state >>> 1) + 1.0) / 2147483648.0;
		}

		function sample():Float {
			if (sigma == 0) return mean;
			if (spare != null) {
				final value = spare;
				spare = null;
				return mean + sigma * value;
			}
			final radius = Math.sqrt(-2 * Math.log(uniform()));
			final angle = 2 * Math.PI * uniform();
			spare = radius * Math.sin(angle);
			return mean + sigma * radius * Math.cos(angle);
		}

		for (y in 0...image.height)
			for (x in 0...image.width) {
				final color = image.getUnsafePixel(x, y);
				final red = sample();
				final green = monochrome ? red : sample();
				final blue = monochrome ? red : sample();
				output.setUnsafePixel(x, y, Color.fromRGBA(Math.round((color.red + red).boundFloat(0, 255)),
					Math.round((color.green + green).boundFloat(0, 255)), Math.round((color.blue + blue).boundFloat(0, 255)), color.alpha));
			}
		return output;
	}
}
