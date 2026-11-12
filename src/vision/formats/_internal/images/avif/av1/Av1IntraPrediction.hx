package vision.formats._internal.images.avif.av1;

import vision.exceptions.Av1BitstreamError;

/** Reconstructed references, including any available right and lower extensions. **/
typedef Av1IntraEdges = {
	final above:Array<Int>;
	final left:Array<Int>;
	final corner:Null<Int>;
}

/** AV1 intra prediction modes in bitstream order. **/
enum abstract Av1IntraMode(Int) from Int to Int {
	var Dc;
	var Vertical;
	var Horizontal;
	var Diagonal45;
	var Diagonal135;
	var Diagonal113;
	var Diagonal157;
	var Diagonal203;
	var Diagonal67;
	var Smooth;
	var SmoothVertical;
	var SmoothHorizontal;
	var Paeth;
}

/** Predicts intra transform blocks from their reconstructed references. **/
@:noCompletion
class Av1IntraPrediction {
	static final angles = [0, 90, 180, 45, 135, 113, 157, 203, 67];
	static final derivative = [
		0, 0, 0, 1023, 0, 0, 547, 0, 0, 372, 0, 0, 0, 0, 273, 0, 0, 215, 0, 0, 178, 0, 0,
		151, 0, 0, 132, 0, 0, 116, 0, 0, 102, 0, 0, 0, 90, 0, 0, 80, 0, 0, 71, 0, 0,
		64, 0, 0, 57, 0, 0, 51, 0, 0, 45, 0, 0, 0, 40, 0, 0, 35, 0, 0, 31, 0, 0, 27, 0, 0,
		23, 0, 0, 19, 0, 0, 15, 0, 0, 0, 0, 11, 0, 0, 7, 0, 0, 3, 0, 0
	];
	static final smoothWeights = [
		[255, 149, 85, 64],
		[255, 197, 146, 105, 73, 50, 37, 32],
		[255, 225, 196, 170, 145, 123, 102, 84, 68, 54, 43, 33, 26, 20, 17, 16],
		[255, 240, 225, 210, 196, 182, 169, 157, 145, 133, 122, 111, 101, 92, 83, 74,
			66, 59, 52, 45, 39, 34, 29, 25, 21, 17, 14, 12, 10, 9, 8, 8],
		[255, 248, 240, 233, 225, 218, 210, 203, 196, 189, 182, 176, 169, 163, 156, 150,
			144, 138, 133, 127, 121, 116, 111, 106, 101, 96, 91, 86, 82, 77, 73, 69,
			65, 61, 57, 54, 50, 47, 44, 41, 38, 35, 32, 29, 27, 25, 22, 20,
			18, 16, 15, 13, 12, 10, 9, 8, 7, 6, 6, 5, 5, 4, 4, 4]
	];
	static final edgeKernels = [[0, 4, 8, 4, 0], [0, 5, 6, 5, 0], [2, 4, 4, 4, 2]];
	static final filterTaps = [
		[
			[-6, 10, 0, 0, 0, 12, 0], [-5, 2, 10, 0, 0, 9, 0], [-3, 1, 1, 10, 0, 7, 0], [-3, 1, 1, 2, 10, 5, 0],
			[-4, 6, 0, 0, 0, 2, 12], [-3, 2, 6, 0, 0, 2, 9], [-3, 2, 2, 6, 0, 2, 7], [-3, 1, 2, 2, 6, 3, 5]
		],
		[
			[-10, 16, 0, 0, 0, 10, 0], [-6, 0, 16, 0, 0, 6, 0], [-4, 0, 0, 16, 0, 4, 0], [-2, 0, 0, 0, 16, 2, 0],
			[-10, 16, 0, 0, 0, 0, 10], [-6, 0, 16, 0, 0, 0, 6], [-4, 0, 0, 16, 0, 0, 4], [-2, 0, 0, 0, 16, 0, 2]
		],
		[
			[-8, 8, 0, 0, 0, 16, 0], [-8, 0, 8, 0, 0, 16, 0], [-8, 0, 0, 8, 0, 16, 0], [-8, 0, 0, 0, 8, 16, 0],
			[-4, 4, 0, 0, 0, 0, 16], [-4, 0, 4, 0, 0, 0, 16], [-4, 0, 0, 4, 0, 0, 16], [-4, 0, 0, 0, 4, 0, 16]
		],
		[
			[-2, 8, 0, 0, 0, 10, 0], [-1, 3, 8, 0, 0, 6, 0], [-1, 2, 3, 8, 0, 4, 0], [0, 1, 2, 3, 8, 2, 0],
			[-1, 4, 0, 0, 0, 3, 10], [-1, 3, 4, 0, 0, 4, 6], [-1, 2, 3, 4, 0, 4, 4], [-1, 2, 2, 3, 4, 3, 3]
		],
		[
			[-12, 14, 0, 0, 0, 14, 0], [-10, 0, 14, 0, 0, 12, 0], [-9, 0, 0, 14, 0, 11, 0], [-8, 0, 0, 0, 14, 10, 0],
			[-10, 12, 0, 0, 0, 0, 14], [-9, 1, 12, 0, 0, 0, 12], [-8, 0, 0, 12, 0, 1, 11], [-7, 0, 0, 1, 12, 1, 9]
		]
	];

	/**
		Returns a row-major prediction for one transform block.
		An empty reference edge means the neighboring block is unavailable.
	**/
	public static function predict(width:Int, height:Int, depth:Int, mode:Av1IntraMode, edges:Av1IntraEdges,
		angleDelta:Int = 0, edgeFilter:Bool = false, smoothNeighbors:Bool = false, filterMode:Int = -1):Array<Int> {
		if (!validSize(width) || !validSize(height) || (depth != 8 && depth != 10 && depth != 12)
			|| (mode:Int) < 0 || (mode:Int) > 12 || angleDelta < -3 || angleDelta > 3 || filterMode < -1 || filterMode > 4)
			throw new Av1BitstreamError("Invalid AV1 intra prediction parameters.");
		final midpoint = 1 << (depth - 1);
		final haveAbove = edges.above.length > 0;
		final haveLeft = edges.left.length > 0;
		final corner = haveAbove && haveLeft && edges.corner != null ? edges.corner
			: haveAbove ? edges.above[0] : haveLeft ? edges.left[0] : midpoint;
		final above = expandEdge(edges.above, width + height, corner, haveLeft ? edges.left[0] : midpoint - 1);
		final left = expandEdge(edges.left, width + height, corner, haveAbove ? edges.above[0] : midpoint + 1);
		if (filterMode >= 0) return recursive(width, height, depth, above, left, filterTaps[filterMode]);
		if (mode == Dc) return dc(width, height, midpoint, above, left, haveAbove, haveLeft);
		if (mode == Paeth) return [for (y in 0...height) for (x in 0...width) paeth(above[x + 1], left[y + 1], corner)];
		if (mode == Smooth || mode == SmoothVertical || mode == SmoothHorizontal)
			return smooth(width, height, mode, above, left);
		return directional(width, height, depth, angles[mode] + 3 * angleDelta, above, left, edges, edgeFilter, smoothNeighbors);
	}

	/**
		Applies chroma-from-luma prediction to an existing DC prediction.
		Each luma entry is the reconstructed sample average in Q3 for one chroma pixel.
	**/
	public static function chromaFromLuma(dc:Array<Int>, lumaQ3:Array<Int>, alpha:Int, depth:Int):Array<Int> {
		if (dc.length == 0 || dc.length != lumaQ3.length || alpha < -16 || alpha > 16 || (depth != 8 && depth != 10 && depth != 12))
			throw new Av1BitstreamError("Invalid AV1 chroma-from-luma inputs.");
		var sum = 0;
		for (sample in lumaQ3) sum += sample;
		final average = Std.int((sum + (dc.length >> 1)) / dc.length);
		final maximum = (1 << depth) - 1;
		return [for (i in 0...dc.length) clip(dc[i] + roundSigned(alpha * (lumaQ3[i] - average), 6), 0, maximum)];
	}

	static function directional(width:Int, height:Int, depth:Int, angle:Int, above:Array<Int>, left:Array<Int>,
		edges:Av1IntraEdges, enableFilter:Bool, smoothNeighbors:Bool):Array<Int> {
		if (angle == 90) return [for (_ in 0...height) for (x in 0...width) above[x + 1]];
		if (angle == 180) return [for (y in 0...height) for (_ in 0...width) left[y + 1]];
		final deltaAbove = abs(angle - 90);
		final deltaLeft = abs(angle - 180);
		final aboveSpan = width + (angle < 90 ? height : 0);
		final leftSpan = height + (angle > 180 ? width : 0);
		final size = width + height;
		final upsampleAbove = enableFilter && upsampleAllowed(size, deltaAbove, smoothNeighbors);
		final upsampleLeft = enableFilter && upsampleAllowed(size, deltaLeft, smoothNeighbors);
		if (enableFilter) {
			if (angle > 90 && angle < 180 && size >= 24) {
				final corner = (5 * left[1] + 6 * above[0] + 5 * above[1] + 8) >> 4;
				above[0] = left[0] = corner;
			}
			if (edges.above.length > 0)
				filterEdge(above, min(width, edges.above.length) + aboveSpan - width, filterStrength(size, deltaAbove, smoothNeighbors));
			if (edges.left.length > 0)
				filterEdge(left, min(height, edges.left.length) + leftSpan - height, filterStrength(size, deltaLeft, smoothNeighbors));
		}
		final maximum = (1 << depth) - 1;
		final top = upsampleAbove ? upsample(above, aboveSpan, maximum) : above;
		final side = upsampleLeft ? upsample(left, leftSpan, maximum) : left;
		final stepX = upsampleAbove ? 1 : 0;
		final stepY = upsampleLeft ? 1 : 0;
		final result = [];
		if (angle < 90) {
			final dx = derivative[angle];
			for (y in 0...height) {
				final index = (y + 1) * dx;
				final base = index >> (6 - stepX);
				final fraction = ((index << stepX) >> 1) & 31;
				for (x in 0...width) result.push(interpolate(top, base + (x << stepX), fraction, 1 << stepX));
			}
		} else if (angle < 180) {
			final dx = derivative[180 - angle];
			final dy = derivative[angle - 90];
			for (y in 0...height) for (x in 0...width) {
				final index = (x << 6) - (y + 1) * dx;
				final base = index >> (6 - stepX);
				if (base >= -(1 << stepX))
					result.push(interpolate(top, base, ((index << stepX) >> 1) & 31, 1 << stepX));
				else {
					final vertical = (y << 6) - (x + 1) * dy;
					result.push(interpolate(side, vertical >> (6 - stepY), ((vertical << stepY) >> 1) & 31, 1 << stepY));
				}
			}
		} else {
			final dy = derivative[270 - angle];
			for (y in 0...height) for (x in 0...width) {
				final index = (x + 1) * dy;
				final base = (index >> (6 - stepY)) + (y << stepY);
				result.push(interpolate(side, base, ((index << stepY) >> 1) & 31, 1 << stepY));
			}
		}
		return result;
	}

	static function recursive(width:Int, height:Int, depth:Int, above:Array<Int>, left:Array<Int>, taps:Array<Array<Int>>):Array<Int> {
		final output = [for (_ in 0...width * height) 0];
		final maximum = (1 << depth) - 1;
		for (blockY in 0...(height >> 1)) for (blockX in 0...(width >> 2)) {
			final x = blockX * 4;
			final y = blockY * 2;
			final refs = [for (i in 0...5) {
				if (y == 0) above[x + i];
				else if (x == 0 && i == 0) left[y];
				else output[(y - 1) * width + x + i - 1];
			}];
			for (i in 0...2) refs.push(x == 0 ? left[y + i + 1] : output[(y + i) * width + x - 1]);
			for (i in 0...8) {
				var value = 0;
				for (j in 0...7) value += refs[j] * taps[i][j];
				output[(y + (i >> 2)) * width + x + (i & 3)] = clip(roundSigned(value, 4), 0, maximum);
			}
		}
		return output;
	}

	static function dc(width:Int, height:Int, midpoint:Int, above:Array<Int>, left:Array<Int>, haveAbove:Bool, haveLeft:Bool):Array<Int> {
		var sum = 0;
		if (haveAbove) for (i in 1...width + 1) sum += above[i];
		if (haveLeft) for (i in 1...height + 1) sum += left[i];
		final count = (haveAbove ? width : 0) + (haveLeft ? height : 0);
		final value = count == 0 ? midpoint : Std.int((sum + (count >> 1)) / count);
		return [for (_ in 0...width * height) value];
	}

	static function smooth(width:Int, height:Int, mode:Av1IntraMode, above:Array<Int>, left:Array<Int>):Array<Int> {
		final wx = weights(width);
		final wy = weights(height);
		return [for (y in 0...height) for (x in 0...width) {
			final vertical = wy[y] * above[x + 1] + (256 - wy[y]) * left[height];
			final horizontal = wx[x] * left[y + 1] + (256 - wx[x]) * above[width];
			mode == Smooth ? (vertical + horizontal + 256) >> 9
				: mode == SmoothVertical ? (vertical + 128) >> 8 : (horizontal + 128) >> 8;
		}];
	}

	static function weights(size:Int):Array<Int> {
		return smoothWeights[size == 4 ? 0 : size == 8 ? 1 : size == 16 ? 2 : size == 32 ? 3 : 4];
	}

	static function paeth(top:Int, left:Int, corner:Int):Int {
		final estimate = top + left - corner;
		final dl = abs(estimate - left);
		final dt = abs(estimate - top);
		final dc = abs(estimate - corner);
		return dl <= dt && dl <= dc ? left : dt <= dc ? top : corner;
	}

	static function filterStrength(size:Int, delta:Int, smooth:Bool):Int {
		if (smooth) {
			if (size <= 8) return delta >= 64 ? 2 : delta >= 40 ? 1 : 0;
			if (size <= 16) return delta >= 48 ? 2 : delta >= 20 ? 1 : 0;
			return size > 24 || delta >= 4 ? 3 : 0;
		}
		if (size <= 8) return delta >= 56 ? 1 : 0;
		if (size <= 16) return delta >= 40 ? 1 : 0;
		if (size <= 24) return delta >= 32 ? 3 : delta >= 16 ? 2 : delta >= 8 ? 1 : 0;
		if (size <= 32) return delta >= 32 ? 3 : delta >= 4 ? 2 : 1;
		return 3;
	}

	static function filterEdge(edge:Array<Int>, samples:Int, strength:Int):Void {
		if (strength == 0) return;
		final source = edge.copy();
		final kernel = edgeKernels[strength - 1];
		for (i in 1...samples + 1) {
			var sum = 0;
			for (j in 0...5) sum += source[clip(i - 2 + j, 0, samples)] * kernel[j];
			edge[i] = (sum + 8) >> 4;
		}
	}

	static function upsample(edge:Array<Int>, samples:Int, maximum:Int):Array<Int> {
		final result = [edge[0]];
		for (i in 0...samples) {
			final a = edge[i == 0 ? 0 : i - 1];
			final b = edge[i];
			final c = edge[i + 1];
			final d = edge[min(i + 2, samples)];
			result.push(clip((-a + 9 * b + 9 * c - d + 8) >> 4, 0, maximum));
			result.push(c);
		}
		return result;
	}

	static function expandEdge(edge:Array<Int>, count:Int, corner:Int, fallback:Int):Array<Int> {
		final result = [corner];
		for (i in 0...count) result.push(edge.length == 0 ? fallback : edge[min(i, edge.length - 1)]);
		return result;
	}

	static inline function interpolate(edge:Array<Int>, base:Int, fraction:Int, offset:Int):Int {
		final index = clip(base + offset, 0, edge.length - 1);
		return (edge[index] * (32 - fraction) + edge[min(index + 1, edge.length - 1)] * fraction + 16) >> 5;
	}

	static inline function upsampleAllowed(size:Int, delta:Int, smooth:Bool):Bool
		return delta > 0 && delta < 40 && size <= (smooth ? 8 : 16);
	static inline function validSize(size:Int):Bool return size >= 4 && size <= 64 && (size & (size - 1)) == 0;
	static inline function roundSigned(value:Int, shift:Int):Int {
		final magnitude = (abs(value) + (1 << (shift - 1))) >> shift;
		return value < 0 ? -magnitude : magnitude;
	}
	static inline function abs(value:Int):Int return value < 0 ? -value : value;
	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function clip(value:Int, low:Int, high:Int):Int return value < low ? low : value > high ? high : value;
}
