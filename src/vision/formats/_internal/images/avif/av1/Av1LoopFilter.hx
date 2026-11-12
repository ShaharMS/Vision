package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;

/** In-loop deblocking for reconstructed 8-bit AV1 intra pictures. **/
@:noCompletion
class Av1LoopFilter {
	/** Applies vertical edges before horizontal edges, using the coded transform sizes. **/
	public static function apply(samples:Bytes, stride:Int, width:Int, height:Int, transformWidths:Bytes, transformHeights:Bytes,
		chroma:Bool, verticalLevel:Int, horizontalLevel:Int, sharpness:Int, referenceDelta:Null<Int>):Void {
		if (verticalLevel == 0 && horizontalLevel == 0) return;
		final transformStride = stride >> 2;
		for (pass in 0...2) {
			final vertical = pass == 0;
			final level = strength(vertical ? verticalLevel : horizontalLevel, referenceDelta);
			if (level == 0) continue;
			final shift = sharpness > 4 ? 2 : sharpness > 0 ? 1 : 0;
			final limit = sharpness == 0 ? max(1, level) : clamp(level >> shift, 1, 9 - sharpness);
			final boundaryLimit = 2 * (level + 2) + limit;
			final threshold = level >> 4;
			final dimensions = vertical ? transformWidths : transformHeights;
			final adjacent = vertical ? 1 : transformStride;
			final step = vertical ? 1 : stride;
			final line = vertical ? stride : 1;
			var y = vertical ? 0 : 4;
			while (y < height) {
				var x = vertical ? 4 : 0;
				while (x < width) {
					final cell = (y >> 2) * transformStride + (x >> 2);
					final length = dimensions.get(cell);
					if (length != 0 && ((vertical ? x : y) & (length - 1)) == 0) {
						final previous = dimensions.get(cell - adjacent);
						final size = min(chroma ? 8 : 16, min(length, previous));
						if (size >= 4) {
							final offset = y * stride + x;
							for (i in 0...4) filter(samples, offset + i * line, step, size, chroma, limit, boundaryLimit, threshold);
						}
					}
					x += 4;
				}
				y += 4;
			}
		}
	}

	static function filter(samples:Bytes, offset:Int, step:Int, size:Int, chroma:Bool, limit:Int, boundaryLimit:Int, threshold:Int):Void {
		final p0 = samples.get(offset - step);
		final p1 = samples.get(offset - step * 2);
		final q0 = samples.get(offset);
		final q1 = samples.get(offset + step);
		final pVariance = abs(p1 - p0);
		final qVariance = abs(q1 - q0);
		if (pVariance > limit || qVariance > limit || abs(p0 - q0) * 2 + (abs(p1 - q1) >> 1) > boundaryLimit) return;
		if (size > 4) {
			final innerTaps = chroma ? 3 : 4;
			var previousP = p1;
			var previousQ = q1;
			var flat = pVariance <= 1 && qVariance <= 1;
			for (i in 2...innerTaps) {
				final p = samples.get(offset - step * (i + 1));
				final q = samples.get(offset + step * i);
				if (abs(p - previousP) > limit || abs(q - previousQ) > limit) return;
				if (abs(p - p0) > 1 || abs(q - q0) > 1) flat = false;
				previousP = p;
				previousQ = q;
			}
			if (flat) {
				var flatOuter = size == 16;
				if (flatOuter) for (i in 4...7) {
					if (abs(samples.get(offset - step * (i + 1)) - p0) > 1 || abs(samples.get(offset + step * i) - q0) > 1)
						flatOuter = false;
				}
				wide(samples, offset, step, flatOuter ? 6 : chroma ? 2 : 3, flatOuter || chroma ? 1 : 0, flatOuter ? 4 : 3);
				return;
			}
		}
		final highVariance = pVariance > threshold || qVariance > threshold;
		final outer = highVariance ? clamp(p1 - q1, -128, 127) : 0;
		final amount = clamp(outer + 3 * (q0 - p0), -128, 127);
		final adjustmentQ = clamp(amount + 4, -128, 127) >> 3;
		final adjustmentP = clamp(amount + 3, -128, 127) >> 3;
		samples.set(offset, clamp(q0 - adjustmentQ, 0, 255));
		samples.set(offset - step, clamp(p0 + adjustmentP, 0, 255));
		if (!highVariance) {
			final adjustment = (adjustmentQ + 1) >> 1;
			samples.set(offset + step, clamp(q1 - adjustment, 0, 255));
			samples.set(offset - step * 2, clamp(p1 + adjustment, 0, 255));
		}
	}

	static function wide(samples:Bytes, offset:Int, step:Int, radius:Int, doubleRadius:Int, shift:Int):Void {
		final values = [];
		for (i in -radius...radius) {
			var sum = 0;
			for (j in -radius...radius + 1) {
				final position = clamp(i + j, -radius - 1, radius);
				sum += samples.get(offset + position * step) * (abs(j) <= doubleRadius ? 2 : 1);
			}
			values.push((sum + (1 << (shift - 1))) >> shift);
		}
		for (i in -radius...radius) samples.set(offset + i * step, values[i + radius]);
	}

	static function strength(level:Int, delta:Null<Int>):Int {
		return delta == null ? level : clamp(level + (delta << (level >> 5)), 0, 63);
	}

	static inline function abs(value:Int):Int return value < 0 ? -value : value;
	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function max(a:Int, b:Int):Int return a > b ? a : b;
	static inline function clamp(value:Int, low:Int, high:Int):Int return value < low ? low : value > high ? high : value;
}
