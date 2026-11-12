package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** Loop restoration unit syntax and filtering for 8-bit AV1 still pictures. **/
@:noCompletion
class Av1Restoration {
	static final sgr = [
		[2, 12, 1, 4], [2, 15, 1, 6], [2, 18, 1, 8], [2, 21, 1, 9],
		[2, 24, 1, 10], [2, 29, 1, 11], [2, 36, 1, 12], [2, 45, 1, 13],
		[2, 56, 1, 14], [2, 68, 1, 15], [0, 0, 1, 5], [0, 0, 1, 8],
		[0, 0, 1, 11], [0, 0, 1, 14], [2, 30, 0, 0], [2, 75, 0, 0]
	];
	static final wienerMin = [-5, -23, -17];
	static final wienerMax = [10, 8, 46];
	static final sgrMin = [-96, -32];
	static final sgrMax = [31, 95];

	final planes:Array<RestorationPlane>;

	/** Creates restoration-unit storage for the current frame. **/
	public function new(frame:Av1StillFrameHeader, planeCount:Int, subX:Int, subY:Int) {
		planes = [for (plane in 0...planeCount) {
			final sx = plane == 0 ? 0 : subX;
			final sy = plane == 0 ? 0 : subY;
			new RestorationPlane(frame.restorationTypes[plane], plane == 0 ? frame.restorationUnitSize : frame.chromaRestorationUnitSize,
				(frame.width + sx) >> sx, (frame.height + sy) >> sy, sx, sy);
		}];
	}

	/** Starts the tile-local restoration CDFs and differential references. **/
	public function tileReader(symbols:Av1SymbolDecoder, superblockSize:Int):(Int, Int) -> Void {
		final wiener = [11570, 32768, 0];
		final selfGuided = [16855, 32768, 0];
		final switchable = [9413, 22581, 32768, 0];
		final taps = [for (_ in planes) [[3, -7, 15], [3, -7, 15]]];
		final weights = [for (_ in planes) [-32, 31]];
		return (x, y) -> {
			for (planeIndex in 0...planes.length) {
				final plane = planes[planeIndex];
				if (plane.type == 0) continue;
				final unit = plane.unitSize;
				final px = (x * 4) >> plane.subX;
				final py = (y * 4) >> plane.subY;
				final colEnd = min(plane.columns, ceilDiv(px + (superblockSize >> plane.subX), unit));
				final rowEnd = min(plane.rows, ceilDiv(py + (superblockSize >> plane.subY), unit));
				for (row in ceilDiv(py, unit)...rowEnd) for (column in ceilDiv(px, unit)...colEnd) {
					final type = switch plane.type {
						case 1: symbols.readSymbol(wiener);
						case 2: symbols.readSymbol(selfGuided) * 2;
						case _: symbols.readSymbol(switchable);
					};
					var entry:RestorationUnit = None;
					if (type == 1) {
						for (pass in 0...2) {
							if (planeIndex != 0) taps[planeIndex][pass][0] = 0;
							for (tap in (planeIndex == 0 ? 0 : 1)...3)
								taps[planeIndex][pass][tap] = signedSubexp(symbols, wienerMin[tap], wienerMax[tap], tap + 1, taps[planeIndex][pass][tap]);
						}
						entry = Wiener(kernel(taps[planeIndex][0]), kernel(taps[planeIndex][1]));
					} else if (type == 2) {
						final set = symbols.readLiteral(4);
						for (pass in 0...2) {
							weights[planeIndex][pass] = sgr[set][pass * 2] != 0
								? signedSubexp(symbols, sgrMin[pass], sgrMax[pass], 4, weights[planeIndex][pass])
								: pass == 0 ? 0 : clamp(128 - weights[planeIndex][0], sgrMin[1], sgrMax[1]);
						}
						entry = Guided(set, weights[planeIndex][0], weights[planeIndex][1]);
					}
					plane.units[row * plane.columns + column] = entry;
				}
			}
		};
	}

	/** Filters the CDEF output using the deblocked rows at stripe boundaries. **/
	public function apply(deblocked:Array<Bytes>, enhanced:Array<Bytes>, lumaStride:Int):Array<Bytes> {
		return [for (i in 0...planes.length) restorePlane(planes[i], deblocked[i], enhanced[i], lumaStride >> planes[i].subX)];
	}

	static function restorePlane(plane:RestorationPlane, deblocked:Bytes, enhanced:Bytes, stride:Int):Bytes {
		if (plane.type == 0) return enhanced;
		final output = enhanced.sub(0, enhanced.length);
		final stripeHeight = 64 >> plane.subY;
		final stripeOffset = 8 >> plane.subY;
		var stripe = -stripeOffset;
		while (stripe < plane.height) {
			final top = max(0, stripe);
			final bottom = min(plane.height, stripe + stripeHeight);
			final unitRow = min(plane.rows - 1, Std.int((top + stripeOffset) / plane.unitSize));
			final stripeStart = stripe;
			final stripeEnd = stripe + stripeHeight - 1;
			function reference(x:Int, y:Int):Int {
				x = clamp(x, 0, plane.width - 1);
				y = clamp(y, 0, plane.height - 1);
				if (y < stripeStart) return deblocked.get(max(stripeStart - 2, y) * stride + x);
				if (y > stripeEnd) return deblocked.get(min(stripeEnd + 2, y) * stride + x);
				return enhanced.get(y * stride + x);
			}
			for (column in 0...plane.columns) {
				final x = column * plane.unitSize;
				final width = (column == plane.columns - 1 ? plane.width : x + plane.unitSize) - x;
				switch plane.units[unitRow * plane.columns + column] {
					case Wiener(vertical, horizontal):
						filterWiener(output, stride, x, top, width, bottom - top, vertical, horizontal, reference);
					case Guided(set, first, original):
						filterGuided(enhanced, output, stride, x, top, width, bottom - top, sgr[set], first, original, reference);
					case None:
					case null: throw new Av1BitstreamError("Missing AV1 loop restoration unit.");
				}
			}
			stripe += stripeHeight;
		}
		return output;
	}

	static function filterWiener(output:Bytes, stride:Int, x:Int, y:Int, width:Int, height:Int, vertical:Array<Int>,
		horizontal:Array<Int>, sample:(Int, Int) -> Int):Void {
		final intermediate = [];
		for (row in 0...height + 6) for (column in 0...width) {
			var sum = 0;
			for (tap in 0...7) sum += horizontal[tap] * sample(x + column + tap - 3, y + row - 3);
			intermediate.push(clamp(round(sum, 3), -2048, 6143));
		}
		for (row in 0...height) for (column in 0...width) {
			var sum = 0;
			for (tap in 0...7) sum += vertical[tap] * intermediate[(row + tap) * width + column];
			output.set((y + row) * stride + x + column, clamp(round(sum, 11), 0, 255));
		}
	}

	static function filterGuided(enhanced:Bytes, output:Bytes, stride:Int, x:Int, y:Int, width:Int, height:Int,
		parameters:Array<Int>, firstWeight:Int, originalWeight:Int, sample:(Int, Int) -> Int):Void {
		final first = guidedBox(enhanced, stride, x, y, width, height, parameters[0], parameters[1], true, sample);
		final second = guidedBox(enhanced, stride, x, y, width, height, parameters[2], parameters[3], false, sample);
		final secondWeight = 128 - firstWeight - originalWeight;
		for (row in 0...height) for (column in 0...width) {
			final offset = (y + row) * stride + x + column;
			final index = row * width + column;
			final original = enhanced.get(offset) << 4;
			final a = first == null ? original : first[index];
			final b = second == null ? original : second[index];
			output.set(offset, clamp(round(firstWeight * a + originalWeight * original + secondWeight * b, 11), 0, 255));
		}
	}

	static function guidedBox(enhanced:Bytes, stride:Int, x:Int, y:Int, width:Int, height:Int, radius:Int,
		epsilon:Int, sparse:Bool, sample:(Int, Int) -> Int):Null<Array<Int>> {
		if (radius == 0) return null;
		final area = (radius * 2 + 1) * (radius * 2 + 1);
		final scaleDivisor = area * area * epsilon;
		final scale = Std.int((1048576 + (scaleDivisor >> 1)) / scaleDivisor);
		final reciprocal = Std.int((4096 + (area >> 1)) / area);
		final a = [];
		final b = [];
		for (row in -1...height + 1) for (column in -1...width + 1) {
			var sum = 0;
			var squared = 0;
			for (dy in -radius...radius + 1) for (dx in -radius...radius + 1) {
				final value = sample(x + column + dx, y + row + dy);
				sum += value;
				squared += value * value;
			}
			final variance = max(0, squared * area - sum * sum);
			final z = round(variance * scale, 20);
			final gain = z >= 255 ? 256 : z == 0 ? 1 : Std.int(((z << 8) + (z >> 1)) / (z + 1));
			a.push(gain);
			b.push(round((256 - gain) * sum * reciprocal, 12));
		}
		final result = [];
		for (row in 0...height) for (column in 0...width) {
			var sumA = 0;
			var sumB = 0;
			for (dy in -1...2) for (dx in -1...2) {
				final weight = sparse ? ((row + dy) & 1) == 0 ? 0 : dx == 0 ? 6 : 5 : dx == 0 || dy == 0 ? 4 : 3;
				final index = (row + dy + 1) * (width + 2) + column + dx + 1;
				sumA += weight * a[index];
				sumB += weight * b[index];
			}
			final shift = sparse && (row & 1) != 0 ? 8 : 9;
			result.push(round(sumA * enhanced.get((y + row) * stride + x + column) + sumB, shift));
		}
		return result;
	}

	static function signedSubexp(symbols:Av1SymbolDecoder, low:Int, high:Int, k:Int, reference:Int):Int {
		final count = high - low + 1;
		var offset = 0;
		var width = k;
		var value = 0;
		while (true) {
			final span = 1 << width;
			if (count <= offset + 3 * span) {
				final remaining = count - offset;
				var bits = 0;
				while ((1 << bits) < remaining) bits++;
				final shortCodes = (1 << bits) - remaining;
				final prefix = bits == 0 ? 0 : symbols.readLiteral(bits - 1);
				value = offset + (prefix < shortCodes ? prefix : (prefix << 1) - shortCodes + symbols.readLiteral(1));
				break;
			}
			if (symbols.readLiteral(1) == 0) {
				value = offset + symbols.readLiteral(width);
				break;
			}
			if (offset != 0) width++;
			offset += span;
		}
		final center = reference - low;
		return low + (2 * center <= count ? recenter(center, value) : count - 1 - recenter(count - 1 - center, value));
	}

	static function recenter(reference:Int, value:Int):Int {
		return value > 2 * reference ? value : (value & 1) != 0 ? reference - ((value + 1) >> 1) : reference + (value >> 1);
	}

	static function kernel(taps:Array<Int>):Array<Int> {
		return [taps[0], taps[1], taps[2], 128 - 2 * (taps[0] + taps[1] + taps[2]), taps[2], taps[1], taps[0]];
	}

	static inline function round(value:Int, bits:Int):Int return (value + (1 << (bits - 1))) >> bits;
	static inline function ceilDiv(value:Int, divisor:Int):Int return Std.int((value + divisor - 1) / divisor);
	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function max(a:Int, b:Int):Int return a > b ? a : b;
	static inline function clamp(value:Int, low:Int, high:Int):Int return value < low ? low : value > high ? high : value;
}

private enum RestorationUnit {
	None;
	Wiener(vertical:Array<Int>, horizontal:Array<Int>);
	Guided(set:Int, firstWeight:Int, originalWeight:Int);
}

private class RestorationPlane {
	public final type:Int;
	public final unitSize:Int;
	public final width:Int;
	public final height:Int;
	public final subX:Int;
	public final subY:Int;
	public final columns:Int;
	public final rows:Int;
	public final units:Array<RestorationUnit>;

	public function new(type:Int, unitSize:Int, width:Int, height:Int, subX:Int, subY:Int) {
		this.type = type;
		this.unitSize = unitSize;
		this.width = width;
		this.height = height;
		this.subX = subX;
		this.subY = subY;
		columns = type == 0 ? 0 : count(width, unitSize);
		rows = type == 0 ? 0 : count(height, unitSize);
		units = [for (_ in 0...columns * rows) null];
	}

	static function count(extent:Int, unit:Int):Int {
		final count = Std.int((extent + (unit >> 1)) / unit);
		return count < 1 ? 1 : count;
	}
}
