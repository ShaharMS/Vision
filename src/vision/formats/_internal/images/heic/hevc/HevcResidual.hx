package vision.formats._internal.images.heic.hevc;

import vision.exceptions.HevcBitstreamError;

/** Inverse quantization and residual reconstruction for HEVC Main transform blocks. **/
@:noCompletion
class HevcResidual {
	static final scales = [40, 45, 51, 57, 64, 72];
	static final cosine = [
		90, 90, 90, 90, 89, 88, 87, 85, 83, 82, 80, 78, 75, 73, 70, 67,
		64, 61, 57, 54, 50, 46, 43, 38, 36, 31, 25, 22, 18, 13, 9, 4, 0
	];

	/**
		Reconstructs an 8-bit residual from signed coefficient levels in raster order.
		An omitted scaling matrix uses flat weights of 16.
	**/
	public static function inverse(levels:Array<Int>, size:Int, qp:Int, intraLuma:Bool,
		transformSkip:Bool = false, ?weights:Array<Int>):Array<Int> {
		final log = switch size {
			case 4: 2;
			case 8: 3;
			case 16: 4;
			case 32: 5;
			default: throw new HevcBitstreamError("Invalid HEVC transform block size.");
		};
		if (levels.length != size * size || qp < 0 || qp > 51 || (weights != null && weights.length != levels.length)
			|| (transformSkip && size != 4))
			throw new HevcBitstreamError("Invalid HEVC residual parameters.");
		final multiplier = scales[qp % 6] * (1 << Std.int(qp / 6));
		final shift = log + 3;
		final coefficients = [];
		for (i in 0...levels.length) {
			final level = levels[i];
			final weight = weights == null ? 16 : weights[i];
			if (level < -32768 || level > 32767 || weight < 1 || weight > 255)
				throw new HevcBitstreamError("Invalid HEVC coefficient level or scaling weight.");
			final scaled = Math.floor((level * 1.0 * weight * multiplier + (1 << (shift - 1))) / (1 << shift));
			coefficients.push(clip(scaled));
		}
		if (transformSkip) return [for (value in coefficients) (value + 16) >> 5];
		if (size == 4) return HevcTransform4.inverse(coefficients, 8, intraLuma);

		final matrix = [for (frequency in 0...size) [for (position in 0...size)
			kernel(frequency, position, 32 >> log)]];
		final columns = pass(coefficients, matrix, size, true, 7);
		return pass(columns, matrix, size, false, 12);
	}

	/** Maps a luma-domain chroma QP to its 4:2:0 quantizer index. **/
	public static function chromaQp(qp:Int, offset:Int):Int {
		final index = qp + offset;
		if (index < 0) return 0;
		if (index < 30) return index;
		final nonlinear = [29, 30, 31, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37, 37];
		return index < 44 ? nonlinear[index - 30] : index > 57 ? 51 : index - 6;
	}

	static function pass(input:Array<Int>, matrix:Array<Array<Int>>, size:Int, vertical:Bool, shift:Int):Array<Int> {
		final output = [];
		final rounding = 1 << (shift - 1);
		for (y in 0...size) for (x in 0...size) {
			final position = vertical ? y : x;
			var sum = 0;
			for (i in 0...size) {
				final sample = vertical ? input[i * size + x] : input[y * size + i];
				sum += sample * matrix[i][position];
			}
			output.push(clip((sum + rounding) >> shift));
		}
		return output;
	}

	static function kernel(frequency:Int, position:Int, step:Int):Int {
		if (frequency == 0) return 64;
		var angle = ((2 * position + 1) * frequency * step) & 127;
		if (angle > 64) angle = 128 - angle;
		return angle <= 32 ? cosine[angle] : -cosine[64 - angle];
	}

	static inline function clip(value:Int):Int return value < -32768 ? -32768 : value > 32767 ? 32767 : value;
}
