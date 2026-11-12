package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** Reads and writes AV1 palette entries and color maps. Each instance owns one tile's color CDFs. **/
@:noCompletion
class Av1Palette {
	static final contexts = [-1, -1, 0, -1, -1, 4, 3, 2, 1];
	final luma = copyTables(Av1PaletteTables.luma);
	final chroma = copyTables(Av1PaletteTables.chroma);
	final order = [0, 1, 2, 3, 4, 5, 6, 7];
	final scores = [0, 0, 0, 0, 0, 0, 0, 0];

	public function new() {}

	/** Reads a sorted luma or Cb palette, with optional references to neighboring colors. **/
	public static function readColors(symbols:Av1SymbolDecoder, count:Int, depth:Int, cache:Array<Int>, isLuma:Bool):Array<Int> {
		checkColors(count, depth);
		final colors = [];
		for (entry in cache) {
			if (colors.length == count) break;
			if (symbols.readLiteral(1) != 0) colors.push(entry);
		}
		if (colors.length < count) {
			final maximum = (1 << depth) - 1;
			final step = isLuma ? 1 : 0;
			var color = symbols.readLiteral(depth);
			colors.push(color);
			if (colors.length < count) {
				var bits = depth - 3 + symbols.readLiteral(2);
				while (colors.length < count) {
					color = min(maximum, color + symbols.readLiteral(bits) + step);
					colors.push(color);
					bits = min(bits, ceilLog2(maximum + 1 - color - step));
				}
			}
		}
		colors.sort((a, b) -> a - b);
		return colors;
	}

	/** Writes sorted luma or Cb entries explicitly, without using cache references. **/
	public static function writeColors(symbols:Av1SymbolEncoder, colors:Array<Int>, depth:Int, cache:Array<Int>, isLuma:Bool):Void {
		checkColors(colors.length, depth);
		final step = isLuma ? 1 : 0;
		final maximum = (1 << depth) - 1;
		if (colors[0] < 0 || colors[colors.length - 1] > maximum)
			throw new Av1BitstreamError("AV1 palette sample is outside its bit depth.");
		for (i in 1...colors.length) {
			if (colors[i] - colors[i - 1] < step) throw new Av1BitstreamError("AV1 palette colors are out of order.");
		}
		for (_ in cache) symbols.writeLiteral(0, 1);
		symbols.writeLiteral(colors[0], depth);
		symbols.writeLiteral(3, 2);
		var bits = depth;
		for (i in 1...colors.length) {
			symbols.writeLiteral(colors[i] - colors[i - 1] - step, bits);
			bits = min(bits, ceilLog2(maximum + 1 - colors[i] - step));
		}
	}

	/** Reads the Cr entries corresponding to the Cb palette. **/
	public static function readRedDifference(symbols:Av1SymbolDecoder, count:Int, depth:Int):Array<Int> {
		checkColors(count, depth);
		if (symbols.readLiteral(1) == 0) return [for (_ in 0...count) symbols.readLiteral(depth)];
		final mask = (1 << depth) - 1;
		final bits = depth - 4 + symbols.readLiteral(2);
		final colors = [symbols.readLiteral(depth)];
		for (i in 1...count) {
			var delta = symbols.readLiteral(bits);
			if (delta != 0 && symbols.readLiteral(1) != 0) delta = -delta;
			colors.push((colors[i - 1] + delta) & mask);
		}
		return colors;
	}

	/** Writes explicit Cr entries in the order of the Cb palette. **/
	public static function writeRedDifference(symbols:Av1SymbolEncoder, colors:Array<Int>, depth:Int):Void {
		checkColors(colors.length, depth);
		symbols.writeLiteral(0, 1);
		for (color in colors) symbols.writeLiteral(color, depth);
	}

	/** Decodes an on-screen color index map in raster order. **/
	public function readMap(symbols:Av1SymbolDecoder, width:Int, height:Int, count:Int, isLuma:Bool):Bytes {
		checkMap(width, height, count);
		final indices = Bytes.alloc(width * height);
		final cdfs = (isLuma ? luma : chroma)[count - 2];
		indices.set(0, readFirstIndex(symbols, count));
		for (diagonal in 1...width + height - 1) {
			final end = diagonal < height ? 0 : diagonal - height + 1;
			var x = min(diagonal, width - 1);
			while (x >= end) {
				final y = diagonal - x;
				final index = y * width + x;
				final context = colorContext(indices, width, x, y, count);
				indices.set(index, order[symbols.readSymbol(cdfs[context])]);
				x--;
			}
		}
		return indices;
	}

	/** Encodes an on-screen color index map supplied in raster order. **/
	public function writeMap(symbols:Av1SymbolEncoder, indices:Bytes, width:Int, height:Int, count:Int, isLuma:Bool):Void {
		checkMap(width, height, count);
		if (indices.length != width * height) throw new Av1BitstreamError("Invalid AV1 palette index map length.");
		for (i in 0...indices.length) if (indices.get(i) >= count) throw new Av1BitstreamError("Invalid AV1 palette index.");
		final cdfs = (isLuma ? luma : chroma)[count - 2];
		final bits = ceilLog2(count);
		final shortCodes = (1 << bits) - count;
		final first = indices.get(0);
		if (first < shortCodes) symbols.writeLiteral(first, bits - 1);
		else symbols.writeLiteral(first + shortCodes, bits);
		for (diagonal in 1...width + height - 1) {
			final end = diagonal < height ? 0 : diagonal - height + 1;
			var x = min(diagonal, width - 1);
			while (x >= end) {
				final y = diagonal - x;
				final context = colorContext(indices, width, x, y, count);
				final color = indices.get(y * width + x);
				symbols.writeSymbol(order.indexOf(color), cdfs[context]);
				x--;
			}
		}
	}

	function colorContext(indices:Bytes, width:Int, x:Int, y:Int, count:Int):Int {
		for (i in 0...count) {
			scores[i] = 0;
			order[i] = i;
		}
		final offset = y * width + x;
		if (x > 0) scores[indices.get(offset - 1)] += 2;
		if (y > 0) {
			scores[indices.get(offset - width)] += 2;
			if (x > 0) scores[indices.get(offset - width - 1)]++;
		}
		final ranked = min(3, count);
		for (i in 0...ranked) {
			var best = i;
			for (j in i + 1...count) if (scores[order[j]] > scores[order[best]]) best = j;
			final color = order[best];
			while (best > i) {
				order[best] = order[best - 1];
				best--;
			}
			order[i] = color;
		}
		var hash = scores[order[0]] + 2 * scores[order[1]];
		if (ranked == 3) hash += 2 * scores[order[2]];
		return contexts[hash];
	}

	static function readFirstIndex(symbols:Av1SymbolDecoder, count:Int):Int {
		final bits = ceilLog2(count);
		final shortCodes = (1 << bits) - count;
		final first = symbols.readLiteral(bits - 1);
		return first < shortCodes ? first : (first << 1) - shortCodes + symbols.readLiteral(1);
	}

	static function checkColors(count:Int, depth:Int):Void {
		if (count < 2 || count > 8 || (depth != 8 && depth != 10 && depth != 12))
			throw new Av1BitstreamError("Invalid AV1 palette size or sample bit depth.");
	}

	static function checkMap(width:Int, height:Int, count:Int):Void {
		if (width < 1 || height < 1 || width > 64 || height > 64 || count < 2 || count > 8)
			throw new Av1BitstreamError("Invalid AV1 palette map dimensions or color count.");
	}

	static function copyTables(tables:Array<Array<Array<Int>>>):Array<Array<Array<Int>>> {
		return [for (size in tables) [for (cdf in size) cdf.copy()]];
	}

	static function ceilLog2(value:Int):Int {
		var count = 0;
		while ((1 << count) < value) count++;
		return count;
	}

	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
}
