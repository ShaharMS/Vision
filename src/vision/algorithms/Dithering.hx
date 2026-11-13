package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.specifics.DitheringAlgorithm;

using vision.tools.MathTools;

/** Palette quantization with error diffusion or an ordered threshold. **/
class Dithering {
	static final BAYER = [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5];

	public static function apply(image:Image, palette:Array<Color>, algorithm:DitheringAlgorithm):Image {
		final output = image.clone();
		final diffuse = algorithm == FloydSteinberg;
		final rowSize = (image.width + 2) * 3;
		var current = diffuse ? [for (_ in 0...rowSize) 0.0] : [];
		var next = current.copy();

		for (y in 0...image.height) {
			for (x in 0...image.width) {
				final source = image.getUnsafePixel(x, y);
				if (source.alpha == 0) continue;
				final index = (x + 1) * 3;
				final threshold = diffuse ? 0.0 : (BAYER[(y & 3) * 4 + (x & 3)] - 7.5) * 8;
				final r = (source.red + (diffuse ? current[index] : threshold)).boundFloat(0, 255);
				final g = (source.green + (diffuse ? current[index + 1] : threshold)).boundFloat(0, 255);
				final b = (source.blue + (diffuse ? current[index + 2] : threshold)).boundFloat(0, 255);
				final color = nearest(palette, r, g, b);
				output.setUnsafePixel(x, y, Color.fromRGBA(color.red, color.green, color.blue, source.alpha));
				if (diffuse) {
					spread(current, next, index, (r - color.red) / 16);
					spread(current, next, index + 1, (g - color.green) / 16);
					spread(current, next, index + 2, (b - color.blue) / 16);
				}
			}
			if (diffuse) {
				final previous = current;
				current = next;
				next = previous;
				for (i in 0...rowSize) next[i] = 0;
			}
		}
		return output;
	}

	static function nearest(palette:Array<Color>, red:Float, green:Float, blue:Float):Color {
		var nearest = palette[0];
		var best = Math.POSITIVE_INFINITY;
		for (color in palette) {
			final r = red - color.red;
			final g = green - color.green;
			final b = blue - color.blue;
			final distance = r * r + g * g + b * b;
			if (distance < best) {
				best = distance;
				nearest = color;
			}
		}
		return nearest;
	}

	static inline function spread(current:Array<Float>, next:Array<Float>, index:Int, error:Float) {
		current[index + 3] += error * 7;
		next[index - 3] += error * 3;
		next[index] += error * 5;
		next[index + 3] += error;
	}
}
