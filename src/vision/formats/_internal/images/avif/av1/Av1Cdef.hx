package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;

/** Constrained directional enhancement filtering for 8-bit AV1 pictures. **/
@:noCompletion
class Av1Cdef {
	static final directions = [
		[[-1, 1], [-2, 2]], [[0, 1], [-1, 2]], [[0, 1], [0, 2]], [[0, 1], [1, 2]],
		[[1, 1], [2, 2]], [[1, 0], [2, 1]], [[1, 0], [2, 0]], [[1, 0], [2, -1]]
	];
	static final chromaDirections = [
		[0, 1, 2, 3, 4, 5, 6, 7], [1, 2, 2, 2, 3, 4, 6, 0],
		[7, 0, 2, 4, 5, 6, 6, 6], [0, 1, 2, 3, 4, 5, 6, 7]
	];
	static final divisors = [0, 840, 420, 280, 210, 168, 140, 120, 105];

	final strengths:Array<Array<Int>>;
	final damping:Int;
	final width:Int;
	final height:Int;
	final regionStride:Int;
	final indices:Bytes;
	final codedBlocks:Bytes;
	final indexBits:Int;
	final active:Bool;

	/** Starts the filter state for a frame padded to an 8-sample boundary. **/
	public function new(width:Int, height:Int, frame:Av1StillFrameHeader) {
		this.width = width;
		this.height = height;
		strengths = frame.cdefStrengths;
		damping = frame.cdefDamping;
		indexBits = log2(strengths.length);
		var enabled = false;
		for (entry in strengths) for (strength in entry) if (strength != 0) enabled = true;
		active = enabled;
		regionStride = (width + 63) >> 6;
		indices = Bytes.alloc(regionStride * ((height + 63) >> 6));
		indices.fill(0, indices.length, 255);
		codedBlocks = Bytes.alloc((width >> 3) * (height >> 3));
	}

	/** Reads the region index at the first non-skipped block and marks its filter blocks. **/
	public function readBlock(symbols:Av1SymbolDecoder, x:Int, y:Int, blockWidth:Int, blockHeight:Int, skip:Bool):Void {
		if (skip || strengths.length == 0) return;
		final region = (y >> 6) * regionStride + (x >> 6);
		if (indices.get(region) == 255) {
			final index = symbols.readLiteral(indexBits);
			var row = y & ~63;
			while (row < min(height, y + blockHeight)) {
				var column = x & ~63;
				while (column < min(width, x + blockWidth)) {
					indices.set((row >> 6) * regionStride + (column >> 6), index);
					column += 64;
				}
				row += 64;
			}
		}
		if (!active) return;
		final stride = width >> 3;
		final first = x >> 3;
		final end = (min(width, x + blockWidth) + 7) >> 3;
		for (row in (y >> 3)...((min(height, y + blockHeight) + 7) >> 3))
			codedBlocks.fill(row * stride + first, end - first, 1);
	}

	/** Returns the enhanced planes, keeping the original references for every filter tap. **/
	public function apply(planes:Array<Bytes>, subX:Int, subY:Int):Array<Bytes> {
		if (!active) return planes;
		final output = [for (plane in planes) plane.sub(0, plane.length)];
		final stride = width >> 3;
		for (row in 0...(height >> 3)) for (column in 0...stride) {
			if (codedBlocks.get(row * stride + column) == 0) continue;
			final index = indices.get((row >> 3) * regionStride + (column >> 3));
			if (index == 255) continue;
			final strength = strengths[index];
			final x = column << 3;
			final y = row << 3;
			final luma = direction(planes[0], width, x, y);
			final varianceStrength = min(log2(luma.variance >> 6), 12);
			final primary = luma.variance == 0 ? 0 : (strength[0] * (4 + varianceStrength) + 8) >> 4;
			filter(planes[0], output[0], width, height, x, y, 8, 8, primary, strength[1], damping, strength[0] == 0 ? 0 : luma.index);
			if (planes.length > 1) {
				final dir = strength[2] == 0 ? 0 : chromaDirections[(subX << 1) | subY][luma.index];
				for (plane in 1...3)
					filter(planes[plane], output[plane], width >> subX, height >> subY, x >> subX, y >> subY,
						8 >> subX, 8 >> subY, strength[2], strength[3], damping - 1, dir);
			}
		}
		return output;
	}

	static function direction(samples:Bytes, stride:Int, x:Int, y:Int):{index:Int, variance:Int} {
		final sums = [for (_ in 0...8) [for (_ in 0...15) 0]];
		for (row in 0...8) for (column in 0...8) {
			final sample = samples.get((y + row) * stride + x + column) - 128;
			sums[0][row + column] += sample;
			sums[1][row + (column >> 1)] += sample;
			sums[2][row] += sample;
			sums[3][3 + row - (column >> 1)] += sample;
			sums[4][7 + row - column] += sample;
			sums[5][3 - (row >> 1) + column] += sample;
			sums[6][column] += sample;
			sums[7][(row >> 1) + column] += sample;
		}
		final costs = [for (_ in 0...8) 0];
		var best = 0;
		for (dir in 0...8) {
			var cost = 0;
			for (line in 0...15) {
				final count = if (dir == 2 || dir == 6) (line < 8 ? 8 : 0)
					else if ((dir & 1) == 0) min(line + 1, 15 - line)
					else if (line < 3) 2 * (line + 1)
					else if (line < 8) 8
					else if (line < 11) 2 * (11 - line)
					else 0;
				final value = sums[dir][line];
				cost += value * value * divisors[count];
			}
			costs[dir] = cost;
			if (cost > costs[best]) best = dir;
		}
		return {index: best, variance: (costs[best] - costs[(best + 4) & 7]) >> 10};
	}

	static function filter(source:Bytes, output:Bytes, stride:Int, height:Int, x:Int, y:Int, blockWidth:Int, blockHeight:Int,
		primary:Int, secondary:Int, damping:Int, dir:Int):Void {
		if (primary == 0 && secondary == 0) return;
		final primaryShift = max(0, damping - log2(primary));
		final secondaryShift = max(0, damping - log2(secondary));
		final pri = (primary & 1) == 0 ? [4, 2] : [3, 3];
		for (row in y...y + blockHeight) for (column in x...x + blockWidth) {
			final offset = row * stride + column;
			final center = source.get(offset);
			var low = center;
			var high = center;
			var sum = 0;
			for (distance in 0...2) {
				for (axis in -1...2) {
					final delta = directions[(dir + axis * 2) & 7][distance];
					final tap = axis == 0 ? pri[distance] : 2 - distance;
					final strength = axis == 0 ? primary : secondary;
					final shift = axis == 0 ? primaryShift : secondaryShift;
					for (side in 0...2) {
						final sign = side * 2 - 1;
						final sy = row + sign * delta[0];
						final sx = column + sign * delta[1];
						if (sx < 0 || sy < 0 || sx >= stride || sy >= height) continue;
						final neighbor = source.get(sy * stride + sx);
						final difference = neighbor - center;
						final magnitude = difference < 0 ? -difference : difference;
						final constrained = max(0, min(magnitude, strength - (magnitude >> shift)));
						sum += (difference < 0 ? -constrained : constrained) * tap;
						low = min(low, neighbor);
						high = max(high, neighbor);
					}
				}
			}
			final sample = center + ((8 + sum - (sum < 0 ? 1 : 0)) >> 4);
			output.set(offset, max(low, min(high, sample)));
		}
	}

	static function log2(value:Int):Int {
		var result = 0;
		while (value > 1) {
			value >>= 1;
			result++;
		}
		return result;
	}

	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function max(a:Int, b:Int):Int return a > b ? a : b;
}
