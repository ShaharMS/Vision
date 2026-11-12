package vision.formats._internal.images.heic.hevc;

import vision.exceptions.HevcBitstreamError;

/** HEVC 4-by-4 integer transforms with the standard 15-bit coefficient range. **/
@:noCompletion
class HevcTransform4 {
	static final cosine = [
		[64, 64, 64, 64], [83, 36, -36, -83], [64, -64, -64, 64], [36, -83, 83, -36]
	];
	static final sine = [
		[29, 55, 74, 84], [74, 74, 0, -74], [84, -29, -74, 55], [55, -84, 74, -29]
	];

	/**
		Applies the reference encoder's integer transform to a residual block.

		Use the sine transform for eligible 4-by-4 luma intra blocks.
		The returned coefficients are in row order, before quantization.
	**/
	public static function forward(residual:Array<Int>, bitDepth:Int, intraLuma:Bool):Array<Int> {
		validate(residual, bitDepth);
		final max = (1 << bitDepth) - 1;
		for (value in residual)
			if (value < -max || value > max) throw new HevcBitstreamError("Residual exceeds the sample range.");
		final matrix = intraLuma ? sine : cosine;
		final first = pass(residual, matrix, bitDepth - 7, false, false);
		return pass(first, matrix, 8, true, false);
	}

	/**
		Reconstructs a residual block from dequantized 4-by-4 coefficients.

		The first inverse pass is vertical and uses a seven-bit shift. The
		second is horizontal and uses a shift derived from the sample bit depth.
	**/
	public static function inverse(coefficients:Array<Int>, bitDepth:Int, intraLuma:Bool):Array<Int> {
		validate(coefficients, bitDepth);
		for (value in coefficients)
			if (value < -32768 || value > 32767) throw new HevcBitstreamError("Coefficient exceeds the standard transform range.");
		final matrix = intraLuma ? sine : cosine;
		final first = pass(coefficients, matrix, 7, true, true);
		return pass(first, matrix, 20 - bitDepth, false, true);
	}

	static function pass(input:Array<Int>, matrix:Array<Array<Int>>, shift:Int, vertical:Bool, inverse:Bool):Array<Int> {
		final output:Array<Int> = [];
		final round = 1 << (shift - 1);
		for (y in 0...4)
			for (x in 0...4) {
				final coordinate = vertical ? y : x;
				var sum = 0;
				for (i in 0...4) {
					final sample = vertical ? input[i * 4 + x] : input[y * 4 + i];
					sum += sample * (inverse ? matrix[i][coordinate] : matrix[coordinate][i]);
				}
				final value = (sum + round) >> shift;
				output.push(!inverse ? value : value < -32768 ? -32768 : value > 32767 ? 32767 : value);
			}
		return output;
	}

	static inline function validate(block:Array<Int>, bitDepth:Int):Void {
		if (block.length != 16 || bitDepth < 8 || bitDepth > 12)
			throw new HevcBitstreamError("Expected a 4-by-4 transform block with an 8-to-12-bit sample depth.");
	}
}
