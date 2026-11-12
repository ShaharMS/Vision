package vision.formats._internal.images.avif.av1;

import vision.exceptions.Av1BitstreamError;

/** The one-dimensional kernels used on the axes of an AV1 transform. **/
enum abstract Av1TransformKernel(Int) {
	var Dct;
	var Adst;
	var FlipAdst;
	var Identity;
}

/** Integer inverse transforms and reconstruction for lossy AV1 blocks. **/
@:noCompletion
class Av1InverseTransform {
	static final cosine = [
		4096, 4095, 4091, 4085, 4076, 4065, 4052, 4036,
		4017, 3996, 3973, 3948, 3920, 3889, 3857, 3822,
		3784, 3745, 3703, 3659, 3612, 3564, 3513, 3461,
		3406, 3349, 3290, 3229, 3166, 3102, 3035, 2967,
		2896, 2824, 2751, 2675, 2598, 2520, 2440, 2359,
		2276, 2191, 2106, 2019, 1931, 1842, 1751, 1660,
		1567, 1474, 1380, 1285, 1189, 1092, 995, 897,
		799, 700, 601, 501, 401, 301, 201, 101, 0
	];

	/**
		Transforms dequantized coefficients into spatial residuals.
		For an axis of 64 samples, only the first 32 coefficients are coded.
	**/
	public static function inverse(coefficients:Array<Int>, width:Int, height:Int, depth:Int,
		horizontal:Av1TransformKernel, vertical:Av1TransformKernel):Array<Int> {
		final widthLog = sizeLog(width);
		final heightLog = sizeLog(height);
		final difference = Std.int(Math.abs(widthLog - heightLog));
		final codedWidth = width < 32 ? width : 32;
		final codedHeight = height < 32 ? height : 32;
		if (difference > 2 || coefficients.length != codedWidth * codedHeight || (depth != 8 && depth != 10 && depth != 12))
			throw new Av1BitstreamError("Invalid AV1 inverse transform parameters.");
		checkKernel(horizontal, widthLog);
		checkKernel(vertical, heightLog);
		final rowShift = width == height ? (widthLog < 4 ? widthLog - 2 : 2)
			: widthLog + heightLog < 6 ? 0 : widthLog + heightLog < 10 ? 1 : 2;
		final rowLimit = 1 << (depth + 7);
		final columnLimit = 1 << (depth > 10 ? depth + 5 : 15);
		final residual = [for (_ in 0...width * height) 0];
		for (y in 0...height) {
			final row = [for (x in 0...width) {
				final value = y < codedHeight && x < codedWidth ? coefficients[y * codedWidth + x] : 0;
				final clipped = clip(value, rowLimit);
				difference == 1 ? rounded(clipped * 2896.0, 12) : clipped;
			}];
			transform(row, widthLog, rowLimit, horizontal);
			for (x in 0...width) residual[y * width + x] = clip(rounded(row[x], rowShift), columnLimit);
		}
		for (x in 0...width) {
			final column = [for (y in 0...height) residual[y * width + x]];
			transform(column, heightLog, columnLimit, vertical);
			for (y in 0...height) residual[y * width + x] = rounded(column[y], 4);
		}
		return residual;
	}

	static function transform(samples:Array<Int>, log:Int, limit:Int, kernel:Av1TransformKernel):Void {
		switch kernel {
			case Dct: dct(samples, log, limit);
			case Adst, FlipAdst:
				adst(samples, log, limit);
				if (kernel == FlipAdst) samples.reverse();
			case Identity:
				for (i in 0...samples.length) samples[i] = switch log {
					case 2: rounded(samples[i] * 5793.0, 12);
					case 3: samples[i] * 2;
					case 4: rounded(samples[i] * 11586.0, 12);
					case _: samples[i] * 4;
				};
		}
	}

	static function dct(t:Array<Int>, n:Int, limit:Int):Void {
		final original = t.copy();
		for (i in 0...t.length) t[i] = original[reverseBits(n, i)];
		// Butterfly stages follow AV1 section 7.13.2.3. Each size shares the lower stages.
		if (n == 6) for (i in 0...16) rotate(t, 32 + i, 63 - i, 63 - 4 * reverseBits(4, i), false);
		if (n >= 5) for (i in 0...8) rotate(t, 16 + i, 31 - i, 6 + (reverseBits(3, 7 - i) << 3), false);
		if (n == 6) for (i in 0...16) sumDifference(t, 32 + i * 2, 33 + i * 2, (i & 1) != 0, limit);
		if (n >= 4) for (i in 0...4) rotate(t, 8 + i, 15 - i, 12 + (reverseBits(2, 3 - i) << 4), false);
		if (n >= 5) for (i in 0...8) sumDifference(t, 16 + 2 * i, 17 + 2 * i, (i & 1) != 0, limit);
		if (n == 6) for (i in 0...4) for (j in 0...2)
			rotate(t, 62 - i * 4 - j, 33 + i * 4 + j, 60 - 16 * reverseBits(2, i) + 64 * j, true);
		if (n >= 3) for (i in 0...2) rotate(t, 4 + i, 7 - i, 56 - 32 * i, false);
		if (n >= 4) for (i in 0...4) sumDifference(t, 8 + 2 * i, 9 + 2 * i, (i & 1) != 0, limit);
		if (n >= 5) for (i in 0...2) for (j in 0...2)
			rotate(t, 30 - 4 * i - j, 17 + 4 * i + j, 24 + (j << 6) + ((1 - i) << 5), true);
		if (n == 6) for (i in 0...8) for (j in 0...2)
			sumDifference(t, 32 + i * 4 + j, 35 + i * 4 - j, (i & 1) != 0, limit);
		rotate(t, 0, 1, 32, true);
		rotate(t, 2, 3, 48, false);
		if (n >= 3) for (i in 0...2) sumDifference(t, 4 + 2 * i, 5 + 2 * i, i != 0, limit);
		if (n >= 4) for (i in 0...2) rotate(t, 14 - i, 9 + i, 48 + 64 * i, true);
		if (n >= 5) for (i in 0...4) for (j in 0...2)
			sumDifference(t, 16 + 4 * i + j, 19 + 4 * i - j, (i & 1) != 0, limit);
		if (n == 6) for (i in 0...2) for (j in 0...4)
			rotate(t, 61 - i * 8 - j, 34 + i * 8 + j, 56 - i * 32 + (j >> 1) * 64, true);
		for (i in 0...2) sumDifference(t, i, 3 - i, false, limit);
		if (n >= 3) rotate(t, 6, 5, 32, true);
		if (n >= 4) for (i in 0...2) for (j in 0...2)
			sumDifference(t, 8 + 4 * i + j, 11 + 4 * i - j, i != 0, limit);
		if (n >= 5) for (i in 0...4) rotate(t, 29 - i, 18 + i, 48 + (i >> 1) * 64, true);
		if (n == 6) for (i in 0...4) for (j in 0...4)
			sumDifference(t, 32 + 8 * i + j, 39 + 8 * i - j, (i & 1) != 0, limit);
		if (n >= 3) for (i in 0...4) sumDifference(t, i, 7 - i, false, limit);
		if (n >= 4) for (i in 0...2) rotate(t, 13 - i, 10 + i, 32, true);
		if (n >= 5) for (i in 0...2) for (j in 0...4)
			sumDifference(t, 16 + i * 8 + j, 23 + i * 8 - j, i != 0, limit);
		if (n == 6) for (i in 0...8) rotate(t, 59 - i, 36 + i, i < 4 ? 48 : 112, true);
		if (n >= 4) for (i in 0...8) sumDifference(t, i, 15 - i, false, limit);
		if (n >= 5) for (i in 0...4) rotate(t, 27 - i, 20 + i, 32, true);
		if (n == 6) for (i in 0...8) {
			sumDifference(t, 32 + i, 47 - i, false, limit);
			sumDifference(t, 48 + i, 63 - i, true, limit);
		}
		if (n >= 5) for (i in 0...16) sumDifference(t, i, 31 - i, false, limit);
		if (n == 6) {
			for (i in 0...8) rotate(t, 55 - i, 40 + i, 32, true);
			for (i in 0...32) sumDifference(t, i, 63 - i, false, limit);
		}
	}

	static function adst(t:Array<Int>, n:Int, limit:Int):Void {
		if (n == 2) {
			final first = 1321.0 * t[0] + 3803.0 * t[2] + 2482.0 * t[3];
			final second = 2482.0 * t[0] - 1321.0 * t[2] - 3803.0 * t[3];
			final third = 3344.0 * t[1];
			final fourth = 3344.0 * (t[0] - t[2] + t[3]);
			t[0] = rounded(first + third, 12);
			t[1] = rounded(second + third, 12);
			t[2] = rounded(fourth, 12);
			t[3] = rounded(first + second - third, 12);
			return;
		}
		final length = t.length;
		final original = t.copy();
		for (i in 0...length) t[i] = original[(i & 1) != 0 ? i - 1 : length - i - 1];
		if (n == 3) {
			for (i in 0...4) rotate(t, 2 * i, 2 * i + 1, 60 - 16 * i, true);
			for (i in 0...4) sumDifference(t, i, 4 + i, false, limit);
		} else {
			for (i in 0...8) rotate(t, 2 * i, 2 * i + 1, 62 - 8 * i, true);
			for (i in 0...8) sumDifference(t, i, 8 + i, false, limit);
			for (i in 0...2) {
				rotate(t, 8 + 2 * i, 9 + 2 * i, 56 - 32 * i, true);
				rotate(t, 13 + 2 * i, 12 + 2 * i, 8 + 32 * i, true);
			}
			for (i in 0...4) for (j in 0...2) sumDifference(t, 8 * j + i, 4 + 8 * j + i, false, limit);
		}
		for (i in 0...2) for (j in 0...(length >> 3))
			rotate(t, 4 + 8 * j + 3 * i, 5 + 8 * j + i, 48 - 32 * i, true);
		for (i in 0...2) for (j in 0...(length >> 2)) sumDifference(t, 4 * j + i, 2 + 4 * j + i, false, limit);
		for (i in 0...(length >> 2)) rotate(t, 2 + 4 * i, 3 + 4 * i, 32, true);
		for (i in 0...length) original[i] = t[i];
		for (i in 0...length) {
			final index = reverseBits(n, i ^ (i >> 1));
			t[i] = (i & 1) == 0 ? original[index] : -original[index];
		}
	}

	static function rotate(t:Array<Int>, a:Int, b:Int, angle:Int, swap:Bool):Void {
		final x = t[a];
		final y = t[b];
		final c:Float = cos(angle);
		final s:Float = cos(angle - 64);
		final first = rounded(x * c - y * s, 12);
		final second = rounded(x * s + y * c, 12);
		t[a] = swap ? second : first;
		t[b] = swap ? first : second;
	}

	static function sumDifference(t:Array<Int>, a:Int, b:Int, swap:Bool, limit:Int):Void {
		final first = t[a];
		final second = t[b];
		final sum = clip(first + second, limit);
		t[a] = swap ? clip(second - first, limit) : sum;
		t[b] = swap ? sum : clip(first - second, limit);
	}

	static function reverseBits(count:Int, value:Int):Int {
		var result = 0;
		for (i in 0...count) result = (result << 1) | ((value >>> i) & 1);
		return result;
	}

	static function cos(angle:Int):Int {
		final index = angle & 255;
		return if (index <= 64) cosine[index]
			else if (index <= 128) -cosine[128 - index]
			else if (index <= 192) -cosine[index - 128]
			else cosine[256 - index];
	}

	static function sizeLog(value:Int):Int {
		return switch value {
			case 4: 2;
			case 8: 3;
			case 16: 4;
			case 32: 5;
			case 64: 6;
			case _: throw new Av1BitstreamError("Invalid AV1 transform axis length.");
		};
	}

	static function checkKernel(kernel:Av1TransformKernel, log:Int):Void {
		if ((kernel == Adst || kernel == FlipAdst) && log > 4 || kernel == Identity && log > 5)
			throw new Av1BitstreamError("Invalid AV1 transform kernel for its axis length.");
	}

	static inline function clip(value:Int, limit:Int):Int return value < -limit ? -limit : value >= limit ? limit - 1 : value;
	static inline function rounded(value:Float, bits:Int):Int
		return bits == 0 ? Std.int(value) : Math.floor((value + (1 << (bits - 1))) / (1 << bits));
}
