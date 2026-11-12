package vision.formats._internal.images.avif.av1;

import vision.exceptions.Av1BitstreamError;

/** Converts AV1 quantized coefficients to the inputs of the inverse transform. **/
@:noCompletion
class Av1Dequantization {
	/**
		Applies the plane's DC and AC offsets to the block quantizer index.
		If present, matrix weights are supplied in coefficient order with five fractional bits.
	**/
	public static function dequantize(coefficients:Array<Int>, width:Int, height:Int, depth:Int,
		quantizer:Int, dcDelta:Int, acDelta:Int, ?matrix:Array<Int>):Array<Int> {
		final codedWidth = width < 32 ? width : 32;
		final codedHeight = height < 32 ? height : 32;
		if (!validSize(width) || !validSize(height) || width > height * 4 || height > width * 4
			|| coefficients.length != codedWidth * codedHeight || (depth != 8 && depth != 10 && depth != 12)
			|| quantizer < 0 || quantizer > 255 || dcDelta < -64 || dcDelta > 63 || acDelta < -64 || acDelta > 63
			|| (matrix != null && matrix.length != coefficients.length))
			throw new Av1BitstreamError("Invalid AV1 dequantization parameters.");
		final table = (depth - 8) >> 1;
		final dc = Av1QuantizerTables.dc[table][index(quantizer + dcDelta)];
		final ac = Av1QuantizerTables.ac[table][index(quantizer + acDelta)];
		final area = width * height;
		final divisor = area >= 2048 ? 4 : area >= 512 ? 2 : 1;
		final limit = 1 << (depth + 7);
		final result = [];
		for (i in 0...coefficients.length) {
			var scale = i == 0 ? dc : ac;
			if (matrix != null) {
				final weight = matrix[i];
				if (weight < 0 || weight > 255) throw new Av1BitstreamError("Invalid AV1 quantization matrix weight.");
				scale = (scale * weight + 16) >> 5;
			}
			final coefficient = coefficients[i];
			final magnitude = Std.int(((Math.abs(coefficient) * scale) % 16777216.0) / divisor);
			final value = coefficient < 0 ? -magnitude : magnitude;
			result.push(value < -limit ? -limit : value >= limit ? limit - 1 : value);
		}
		return result;
	}

	static inline function validSize(size:Int):Bool return size >= 4 && size <= 64 && (size & (size - 1)) == 0;
	static inline function index(value:Int):Int return value < 0 ? 0 : value > 255 ? 255 : value;
}
