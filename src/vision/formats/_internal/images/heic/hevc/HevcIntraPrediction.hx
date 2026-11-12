package vision.formats._internal.images.heic.hevc;

import vision.exceptions.HevcBitstreamError;

/** Predicts square HEVC intra blocks from prepared reference samples. **/
@:noCompletion
class HevcIntraPrediction {
	static final angles = [0, 2, 5, 9, 13, 17, 21, 26, 32];
	static final inverseAngles = [0, 4096, 1638, 910, 630, 482, 390, 315, 256];

	/**
		Applies planar, DC, or angular prediction to a square block.

		@param size Block side length, 4, 8, 16, or 32
		@param mode HEVC intra mode, 0 through 34
		@param top The 2 * size prepared reference samples above the block, excluding the corner
		@param left The 2 * size prepared reference samples to the left, excluding the corner
		@param corner The shared top-left reference sample
		@param bitDepth Bit depth of this sample plane
		@param filterLumaEdges Whether to apply the luma edge filter to eligible modes
		@return Row-major predicted samples
	**/
	public static function predict(size:Int, mode:Int, top:Array<Int>, left:Array<Int>, corner:Int, bitDepth:Int,
		filterLumaEdges:Bool = false):Array<Int> {
		final max = validate(size, bitDepth);
		if (mode < 0 || mode > 34 || top.length != 2 * size || left.length != 2 * size || corner < 0 || corner > max)
			throw new HevcBitstreamError("Invalid intra prediction references or mode.");
		for (i in 0...2 * size)
			if (top[i] < 0 || top[i] > max || left[i] < 0 || left[i] > max)
				throw new HevcBitstreamError("Intra reference sample exceeds the bit depth.");

		final result:Array<Int> = [];
		final filter = filterLumaEdges && size < 32;
		switch mode {
			case 0:
				final divisor = 2 * size;
				for (y in 0...size)
					for (x in 0...size)
						result.push(Std.int(((size - 1 - x) * left[y] + (x + 1) * top[size]
							+ (size - 1 - y) * top[x] + (y + 1) * left[size] + size) / divisor));
			case 1:
				var sum = size;
				for (i in 0...size) sum += top[i] + left[i];
				final mean = Std.int(sum / (2 * size));
				for (y in 0...size)
					for (x in 0...size) {
						final value = if (!filter || (x > 0 && y > 0)) mean
							else if (x == 0 && y == 0) (left[0] + 2 * mean + top[0] + 2) >> 2
							else ((x == 0 ? left[y] : top[x]) + 3 * mean + 2) >> 2;
						result.push(value);
					}
			default:
				final vertical = mode >= 18;
				final direction = vertical ? mode - 26 : 10 - mode;
				final magnitude = direction < 0 ? -direction : direction;
				final angle = direction < 0 ? -angles[magnitude] : angles[magnitude];
				final primary = vertical ? top : left;
				final secondary = vertical ? left : top;
				final first = angle < 0 ? ((size * angle) >> 5) + 1 : 0;
				final reference = [];
				for (index in first...0) {
					final side = (128 - index * inverseAngles[magnitude]) >> 8;
					reference.push(side == 0 ? corner : secondary[side - 1]);
				}
				reference.push(corner);
				for (sample in primary) reference.push(sample);

				for (y in 0...size)
					for (x in 0...size) {
						final along = vertical ? x : y;
						final across = vertical ? y : x;
						final delta = (across + 1) * angle;
						final fraction = delta & 31;
						final index = along + 1 + (delta >> 5) - first;
						var value = reference[index];
						if (fraction != 0) value = ((32 - fraction) * value + fraction * reference[index + 1] + 16) >> 5;
						if (filter && angle == 0 && along == 0)
							value = clip(value + ((secondary[across] - corner) >> 1), max);
						result.push(value);
					}
		}
		return result;
	}

	/** Adds an inverse-transformed residual block to its prediction. **/
	public static function reconstruct(size:Int, prediction:Array<Int>, residual:Array<Int>, bitDepth:Int):Array<Int> {
		final max = validate(size, bitDepth);
		if (prediction.length != size * size || residual.length != size * size)
			throw new HevcBitstreamError("Prediction and residual dimensions differ.");
		return [for (i in 0...prediction.length) clip(prediction[i] + residual[i], max)];
	}

	static function validate(size:Int, bitDepth:Int):Int {
		if ((size != 4 && size != 8 && size != 16 && size != 32) || bitDepth < 8 || bitDepth > 16)
			throw new HevcBitstreamError("Invalid intra block size or bit depth.");
		return (1 << bitDepth) - 1;
	}

	static inline function clip(value:Int, max:Int):Int return value < 0 ? 0 : value > max ? max : value;
}
