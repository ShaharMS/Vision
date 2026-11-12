package vision.formats._internal.images.avif.av1;

import vision.exceptions.Av1BitstreamError;

/** Reversible 4-by-4 transform used by AV1 lossless blocks. **/
@:noCompletion
class Av1LosslessTransform {
	/**
		Transforms a row-major residual block into scaled coefficients.

		The forward lifting steps reverse the normative inverse transform.
		The returned coefficients include the factor of four expected by the decoder.
	**/
	public static function forward(residual:Array<Int>, bitDepth:Int):Array<Int> {
		final max = sampleMaximum(bitDepth);
		checkLength(residual);
		for (value in residual)
			if (value < -max || value > max) throw new Av1BitstreamError("Lossless residual exceeds the sample range.");
		final result = residual.copy();
		for (x in 0...4) forwardLine(result, x, 4);
		for (y in 0...4) forwardLine(result, y * 4, 1);
		for (i in 0...16) result[i] <<= 2;
		return result;
	}

	/**
		Inverts a row-major block of dequantized lossless coefficients.

		The row pass removes coefficient scaling and clamps the intermediate
		values before the column pass, as specified in AV1 section 7.13.3.
	**/
	public static function inverse(coefficients:Array<Int>, bitDepth:Int):Array<Int> {
		sampleMaximum(bitDepth);
		checkLength(coefficients);
		final result = coefficients.copy();
		for (y in 0...4) inverseLine(result, y * 4, 1, 2);
		final limit = 1 << (bitDepth == 12 ? 17 : 15);
		for (i in 0...16) {
			final value = result[i];
			result[i] = value < -limit ? -limit : value >= limit ? limit - 1 : value;
		}
		for (x in 0...4) inverseLine(result, x, 4, 0);
		return result;
	}

	/** Adds a decoded lossless residual to its prediction and clips samples to the bit depth. **/
	public static function reconstruct(prediction:Array<Int>, coefficients:Array<Int>, bitDepth:Int):Array<Int> {
		final max = sampleMaximum(bitDepth);
		checkLength(prediction);
		final result = inverse(coefficients, bitDepth);
		for (i in 0...16) {
			if (prediction[i] < 0 || prediction[i] > max) throw new Av1BitstreamError("Invalid lossless prediction sample.");
			final value = prediction[i] + result[i];
			result[i] = value < 0 ? 0 : value > max ? max : value;
		}
		return result;
	}

	static function inverseLine(values:Array<Int>, offset:Int, stride:Int, shift:Int):Void {
		final first = (values[offset] >> shift) + (values[offset + stride] >> shift);
		final last = (values[offset + 2 * stride] >> shift) - (values[offset + 3 * stride] >> shift);
		final middle = (first - last) >> 1;
		final second = middle - (values[offset + 3 * stride] >> shift);
		final third = middle - (values[offset + stride] >> shift);
		values[offset] = first - second;
		values[offset + stride] = second;
		values[offset + 2 * stride] = third;
		values[offset + 3 * stride] = last + third;
	}

	static function forwardLine(values:Array<Int>, offset:Int, stride:Int):Void {
		final first = values[offset] + values[offset + stride];
		final last = values[offset + 3 * stride] - values[offset + 2 * stride];
		final middle = (first - last) >> 1;
		final second = middle - values[offset + stride];
		final third = middle - values[offset + 2 * stride];
		values[offset] = first - third;
		values[offset + stride] = third;
		values[offset + 2 * stride] = last + second;
		values[offset + 3 * stride] = second;
	}

	static inline function checkLength(block:Array<Int>):Void {
		if (block.length != 16) throw new Av1BitstreamError("A lossless AV1 transform requires 16 samples.");
	}

	static inline function sampleMaximum(bitDepth:Int):Int {
		if (bitDepth != 8 && bitDepth != 10 && bitDepth != 12)
			throw new Av1BitstreamError("Invalid AV1 sample bit depth.");
		return (1 << bitDepth) - 1;
	}
}
