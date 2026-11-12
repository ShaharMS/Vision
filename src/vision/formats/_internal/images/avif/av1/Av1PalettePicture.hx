package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1PartitionTree.Av1Partition;

/** Encodes independent 8-bit 4:4:4 RGB still pictures using palette prediction. **/
@:noCompletion
class Av1PalettePicture {
	public static inline final LEVEL = 13;
	static inline final BLOCK = 8;
	static inline final MAX_COLORS = 8;

	/** Writes a reduced sequence header OBU and one combined Frame OBU. **/
	public static function encode(width:Int, height:Int, green:Bytes, blue:Bytes, red:Bytes):Bytes {
		if (width < 1 || height < 1 || width > 4096 || height > 4096 || width * height > 4096 * 2304
			|| green.length != width * height || blue.length != green.length || red.length != green.length)
			throw new Av1BitstreamError("Invalid AV1 palette picture dimensions.");
		final paddedWidth = (width + 7) & ~7;
		final paddedHeight = (height + 7) & ~7;
		if (((paddedWidth + 63) & ~63) * ((paddedHeight + 63) & ~63) > 4096 * 2304)
			throw new Av1BitstreamError("AV1 picture exceeds the single tile size limit.");
		final bytes = new BytesBuffer();
		addObu(bytes, 1, sequence(width, height));
		final frame = new BytesBuffer();
		frame.add(frameHeader(width, height));
		frame.add(tile(width, height, paddedWidth, paddedHeight, green, blue, red));
		addObu(bytes, 6, frame.getBytes());
		return bytes.getBytes();
	}

	static function sequence(width:Int, height:Int):Bytes {
		final bits = new PaletteHeaderBits();
		bits.write(1, 3); // High profile.
		bits.write(3, 2); // Still picture and reduced header.
		bits.write(LEVEL, 5);
		final widthBits = fieldWidth(width - 1);
		final heightBits = fieldWidth(height - 1);
		bits.write(widthBits - 1, 4);
		bits.write(heightBits - 1, 4);
		bits.write(width - 1, widthBits);
		bits.write(height - 1, heightBits);
		bits.write(0, 6); // 64x64 superblocks, no intra edge filters, superres, CDEF or restoration.
		bits.write(1, 2); // Eight-bit samples and explicit color description.
		bits.write(1, 8); // BT.709 primaries.
		bits.write(13, 8); // sRGB transfer.
		bits.write(0, 8); // Identity matrix, full range, no subsampling.
		bits.write(0, 2); // Shared chroma QP deltas, no film grain.
		bits.write(1, 1); // Sequence trailing bit.
		return bits.align();
	}

	static function frameHeader(width:Int, height:Int):Bytes {
		final bits = new PaletteHeaderBits();
		bits.write(8, 5); // Adapt CDFs, enable screen tools, default render size and disable intra block copy.
		bits.write(1, 1); // Uniform tile spacing.
		if (width > 64) bits.write(0, 1); // One column.
		if (height > 64) bits.write(0, 1); // One row.
		bits.write(0, 8); // Lossless base quantizer.
		bits.write(0, 6); // No QP deltas, matrices or segments, full transform set.
		return bits.align();
	}

	static function tile(width:Int, height:Int, paddedWidth:Int, paddedHeight:Int, green:Bytes, blue:Bytes, red:Bytes):Bytes {
		final symbols = new Av1SymbolEncoder();
		final palettes = new Av1Palette();
		final partition = new Av1PartitionTree(0, 0, paddedWidth >> 2, paddedHeight >> 2, 64);
		final skip = [[31671, 32768, 0], [16515, 32768, 0], [4576, 32768, 0]];
		final yMode = [15588, 17027, 19338, 20218, 20682, 21110, 21825, 23244, 24189, 28165, 29093, 30466, 32768, 0];
		final uvMode = [22631, 24152, 25378, 25661, 25986, 26520, 27055, 27923, 28244, 30059, 30941, 31961, 32768, 0];
		final yPaletteMode = [[31676, 32768, 0], [3419, 32768, 0], [1261, 32768, 0]];
		final uvPaletteMode = [21488, 32768, 0];
		final ySizes = [7952, 13000, 18149, 21478, 25527, 29241, 32768, 0];
		final uvSizes = [8713, 19979, 27128, 29609, 31331, 32272, 32768, 0];
		final yAbove:Array<Array<Int>> = [];
		final uvAbove:Array<Array<Int>> = [];
		final yLeft:Array<Array<Int>> = [];
		final uvLeft:Array<Array<Int>> = [];
		partition.encode(symbols, (_, _, size) -> size == 2 ? Av1Partition.None : Av1Partition.Split, (x, y, _, _) -> {
			final column = x >> 1;
			final row = y >> 1;
			final context = (column > 0 ? 1 : 0) + (row > 0 ? 1 : 0);
			symbols.writeSymbol(1, skip[context]);
			symbols.writeSymbol(0, yMode);
			symbols.writeSymbol(0, uvMode);
			final luma = samples(width, height, x * 4, y * 4, green, null);
			final chroma = samples(width, height, x * 4, y * 4, blue, red);
			final yCache = cache(column > 0 ? yLeft[row] : null, (row & 7) != 0 ? yAbove[column] : null);
			final uvCache = cache(column > 0 ? uvLeft[row] : null, (row & 7) != 0 ? uvAbove[column] : null);
			symbols.writeSymbol(1, yPaletteMode[context]);
			symbols.writeSymbol(luma.colors.length - 2, ySizes);
			Av1Palette.writeColors(symbols, luma.colors, 8, yCache, true);
			symbols.writeSymbol(1, uvPaletteMode);
			final blueColors = [for (color in chroma.colors) color >>> 8];
			symbols.writeSymbol(blueColors.length - 2, uvSizes);
			Av1Palette.writeColors(symbols, blueColors, 8, uvCache, false);
			Av1Palette.writeRedDifference(symbols, [for (color in chroma.colors) color & 255], 8);
			palettes.writeMap(symbols, luma.indices, BLOCK, BLOCK, luma.colors.length, true);
			palettes.writeMap(symbols, chroma.indices, BLOCK, BLOCK, blueColors.length, false);
			yAbove[column] = yLeft[row] = luma.colors;
			uvAbove[column] = uvLeft[row] = blueColors;
		});
		return symbols.finish();
	}

	static function samples(width:Int, height:Int, x:Int, y:Int, primary:Bytes, secondary:Null<Bytes>):PaletteSamples {
		final source = [];
		for (row in y...y + BLOCK) {
			final offset = (row < height ? row : height - 1) * width;
			for (column in x...x + BLOCK) {
				final index = offset + (column < width ? column : width - 1);
				source.push(secondary == null ? primary.get(index) : (primary.get(index) << 8) | secondary.get(index));
			}
		}
		final unique = source.copy();
		unique.sort((a, b) -> a - b);
		var distinct = 1;
		for (i in 1...unique.length) {
			if (unique[i] != unique[distinct - 1]) unique[distinct++] = unique[i];
		}
		final colors = distinct <= MAX_COLORS ? unique.slice(0, distinct)
			: [for (i in 0...MAX_COLORS) unique[Std.int(i * (distinct - 1) / (MAX_COLORS - 1))]];
		if (distinct == 1) {
			if (secondary != null) colors.push(colors[0]);
			else if (colors[0] == 255) colors.unshift(254);
			else colors.push(colors[0] + 1);
		}
		final indices = Bytes.alloc(source.length);
		for (i in 0...source.length) {
			var closest = 0;
			var best = 0x7fffffff;
			for (j in 0...colors.length) {
				final high = secondary == null ? source[i] - colors[j] : (source[i] >>> 8) - (colors[j] >>> 8);
				final low = secondary == null ? 0 : (source[i] & 255) - (colors[j] & 255);
				final distance = high * high + low * low;
				if (distance < best) {
					best = distance;
					closest = j;
				}
			}
			indices.set(i, closest);
		}
		return {colors: colors, indices: indices};
	}

	static function cache(left:Null<Array<Int>>, above:Null<Array<Int>>):Array<Int> {
		final result = left == null ? [] : left.copy();
		if (above != null) for (color in above) if (result.indexOf(color) < 0) result.push(color);
		var i = result.length - 1;
		result.sort((a, b) -> a - b);
		while (i > 0) {
			if (result[i] == result[i - 1]) result.splice(i, 1);
			i--;
		}
		return result;
	}

	static function addObu(output:BytesBuffer, type:Int, payload:Bytes):Void {
		output.addByte((type << 3) | 2);
		var remaining = payload.length;
		while (remaining >= 128) {
			output.addByte((remaining & 127) | 128);
			remaining >>>= 7;
		}
		output.addByte(remaining);
		output.add(payload);
	}

	static function fieldWidth(value:Int):Int {
		var width = 1;
		while (value > 1) {
			value >>>= 1;
			width++;
		}
		return width;
	}
}

private typedef PaletteSamples = {
	final colors:Array<Int>;
	final indices:Bytes;
}

private class PaletteHeaderBits {
	final bytes = new BytesBuffer();
	var pending = 0;
	var count = 0;

	public function new() {}

	public function write(value:Int, length:Int):Void {
		var shift = length;
		while (shift > 0) {
			pending = (pending << 1) | ((value >>> --shift) & 1);
			if (++count == 8) {
				bytes.addByte(pending);
				pending = 0;
				count = 0;
			}
		}
	}

	public function align():Bytes {
		if (count != 0) write(0, 8 - count);
		return bytes.getBytes();
	}
}
