package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1PartitionTree.Av1Partition;
import vision.formats._internal.images.avif.av1.Av1TileLayout.Av1Tile;

/** Reads and writes independent 8-bit 4:4:4 RGB still pictures using palette prediction. **/
@:noCompletion
class Av1PalettePicture {
	public static inline final LEVEL = 13;
	static inline final BLOCK = 8;
	static inline final MAX_COLORS = 8;

	/**
		Reconstructs a lossless RGB intra frame with palette prediction.
		The result contains green, blue and red planes at the displayed dimensions.
	**/
	public static function decode(bytes:Bytes, sequence:Av1SequenceHeader, frame:Av1StillFrameHeader, tiles:Array<Av1Tile>):Array<Bytes> {
		if (sequence.bitDepth != 8 || sequence.monochrome || sequence.subsamplingX || sequence.subsamplingY
			|| sequence.matrixCoefficients != 0 || !sequence.fullRange
			|| !frame.lossless || frame.width != frame.upscaledWidth || frame.segments != null || frame.intraBlockCopy
			|| frame.width > 4096 || frame.height > 4096 || frame.width * frame.height > 4096 * 2304)
			throw new Av1BitstreamError("Unsupported AV1 palette picture parameters.");
		final width = (frame.width + 7) & ~7;
		final height = (frame.height + 7) & ~7;
		final planes = [for (_ in 0...3) Bytes.alloc(width * height)];
		final columns = frame.tiles.columnStarts;
		final rows = frame.tiles.rowStarts;
		final tileColumns = columns.length - 1;
		if (tiles.length != tileColumns * (rows.length - 1)) throw new Av1BitstreamError("Incomplete AV1 tile groups.");
		for (index in 0...tiles.length) {
			final tile = tiles[index];
			final column = index % tileColumns;
			final row = Std.int(index / tileColumns);
			if (tile.columnStart != columns[column] || tile.columnEnd != columns[column + 1]
				|| tile.rowStart != rows[row] || tile.rowEnd != rows[row + 1])
				throw new Av1BitstreamError("Out-of-order AV1 tile groups.");
			decodeTile(bytes, sequence, frame, tile, width, planes);
		}
		final displayed = [for (_ in 0...3) Bytes.alloc(frame.width * frame.height)];
		for (i in 0...planes.length)
			for (y in 0...frame.height) displayed[i].blit(y * frame.width, planes[i], y * width, frame.width);
		return displayed;
	}

	static function decodeTile(bytes:Bytes, sequence:Av1SequenceHeader, frame:Av1StillFrameHeader, tile:Av1Tile, stride:Int, planes:Array<Bytes>):Void {
		final symbols = new Av1SymbolDecoder(bytes, tile.offset, tile.length, frame.updateCdf);
		final palettes = new Av1Palette();
		final contexts = new PaletteBlockContexts(tile.columnStart, tile.rowStart);
		final partition = new Av1PartitionTree(tile.columnStart, tile.rowStart, tile.columnEnd, tile.rowEnd, sequence.superblockSize);
		partition.decode(symbols, (x, y, width, height) -> {
			if (width < 2 || height < 2 || width > 16 || height > 16)
				throw new Av1BitstreamError("Unsupported AV1 palette coding block size.");
			final neighbor = contexts.neighbors(x, y);
			if (symbols.readSymbol(contexts.skip[neighbor.skip]) != 1)
				throw new Av1BitstreamError("AV1 transform coefficients are unsupported in this picture.");
			if (symbols.readSymbol(contexts.yMode) != 0 || symbols.readSymbol(contexts.uvMode) != 0)
				throw new Av1BitstreamError("Unsupported AV1 intra prediction mode.");
			final context = sizeLog2(width) + sizeLog2(height) - 2;
			final yColors = frame.screenContent && symbols.readSymbol(contexts.yPaletteMode[context][neighbor.luma]) != 0
				? Av1Palette.readColors(symbols, symbols.readSymbol(contexts.ySizes[context]) + 2, 8, neighbor.yCache, true) : [];
			final uColors = frame.screenContent && symbols.readSymbol(contexts.uvPaletteMode[yColors.length != 0 ? 1 : 0]) != 0
				? Av1Palette.readColors(symbols, symbols.readSymbol(contexts.uvSizes[context]) + 2, 8, neighbor.uvCache, false) : [];
			final vColors = uColors.length != 0 ? Av1Palette.readRedDifference(symbols, uColors.length, 8) : [];
			final pixelWidth = min(width, tile.columnEnd - x) * 4;
			final pixelHeight = min(height, tile.rowEnd - y) * 4;
			if (yColors.length == 0 || uColors.length == 0)
				throw new Av1BitstreamError("Expected palette prediction for both AV1 color maps.");
			final yIndices = palettes.readMap(symbols, pixelWidth, pixelHeight, yColors.length, true);
			final uvIndices = palettes.readMap(symbols, pixelWidth, pixelHeight, uColors.length, false);
			putSamples(planes[0], stride, x * 4, y * 4, pixelWidth, pixelHeight, yColors, yIndices);
			putSamples(planes[1], stride, x * 4, y * 4, pixelWidth, pixelHeight, uColors, uvIndices);
			putSamples(planes[2], stride, x * 4, y * 4, pixelWidth, pixelHeight, vColors, uvIndices);
			contexts.update(x, y, width, height, yColors, uColors);
		});
		symbols.finish();
	}

	static function putSamples(plane:Bytes, stride:Int, x:Int, y:Int, width:Int, height:Int, colors:Array<Int>, indices:Bytes):Void {
		for (row in 0...height)
			for (column in 0...width) plane.set((y + row) * stride + x + column, colors[indices.get(row * width + column)]);
	}

	static function sizeLog2(value:Int):Int {
		var count = 0;
		while (value > 1) {
			value >>= 1;
			count++;
		}
		return count;
	}

	static inline function min(a:Int, b:Int):Int return a < b ? a : b;

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
		final contexts = new PaletteBlockContexts(0, 0);
		partition.encode(symbols, (_, _, size) -> size == 2 ? Av1Partition.None : Av1Partition.Split, (x, y, _, _) -> {
			final neighbor = contexts.neighbors(x, y);
			symbols.writeSymbol(1, contexts.skip[neighbor.skip]);
			symbols.writeSymbol(0, contexts.yMode);
			symbols.writeSymbol(0, contexts.uvMode);
			final luma = samples(width, height, x * 4, y * 4, green, null);
			final chroma = samples(width, height, x * 4, y * 4, blue, red);
			symbols.writeSymbol(1, contexts.yPaletteMode[0][neighbor.luma]);
			symbols.writeSymbol(luma.colors.length - 2, contexts.ySizes[0]);
			Av1Palette.writeColors(symbols, luma.colors, 8, neighbor.yCache, true);
			symbols.writeSymbol(1, contexts.uvPaletteMode[1]);
			final blueColors = [for (color in chroma.colors) color >>> 8];
			symbols.writeSymbol(blueColors.length - 2, contexts.uvSizes[0]);
			Av1Palette.writeColors(symbols, blueColors, 8, neighbor.uvCache, false);
			Av1Palette.writeRedDifference(symbols, [for (color in chroma.colors) color & 255], 8);
			palettes.writeMap(symbols, luma.indices, BLOCK, BLOCK, luma.colors.length, true);
			palettes.writeMap(symbols, chroma.indices, BLOCK, BLOCK, blueColors.length, false);
			contexts.update(x, y, 2, 2, luma.colors, blueColors);
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

private class PaletteBlockContexts {
	public final skip = [[31671, 32768, 0], [16515, 32768, 0], [4576, 32768, 0]];
	public final yMode = [15588, 17027, 19338, 20218, 20682, 21110, 21825, 23244, 24189, 28165, 29093, 30466, 32768, 0];
	public final uvMode = [22631, 24152, 25378, 25661, 25986, 26520, 27055, 27923, 28244, 30059, 30941, 31961, 32768, 0];
	public final yPaletteMode = [
		[[31676, 32768, 0], [3419, 32768, 0], [1261, 32768, 0]],
		[[31912, 32768, 0], [2859, 32768, 0], [980, 32768, 0]],
		[[31823, 32768, 0], [3400, 32768, 0], [781, 32768, 0]],
		[[32030, 32768, 0], [3561, 32768, 0], [904, 32768, 0]],
		[[32309, 32768, 0], [7337, 32768, 0], [1462, 32768, 0]],
		[[32265, 32768, 0], [4015, 32768, 0], [1521, 32768, 0]],
		[[32450, 32768, 0], [7946, 32768, 0], [129, 32768, 0]]
	];
	public final uvPaletteMode = [[32461, 32768, 0], [21488, 32768, 0]];
	public final ySizes = [
		[7952, 13000, 18149, 21478, 25527, 29241, 32768, 0],
		[7139, 11421, 16195, 19544, 23666, 28073, 32768, 0],
		[7788, 12741, 17325, 20500, 24315, 28530, 32768, 0],
		[8271, 14064, 18246, 21564, 25071, 28533, 32768, 0],
		[12725, 19180, 21863, 24839, 27535, 30120, 32768, 0],
		[9711, 14888, 16923, 21052, 25661, 27875, 32768, 0],
		[14940, 20797, 21678, 24186, 27033, 28999, 32768, 0]
	];
	public final uvSizes = [
		[8713, 19979, 27128, 29609, 31331, 32272, 32768, 0],
		[5839, 15573, 23581, 26947, 29848, 31700, 32768, 0],
		[4426, 11260, 17999, 21483, 25863, 29430, 32768, 0],
		[3228, 9464, 14993, 18089, 22523, 27420, 32768, 0],
		[3768, 8886, 13091, 17852, 22495, 27207, 32768, 0],
		[2464, 8451, 12861, 21632, 25525, 28555, 32768, 0],
		[1269, 5435, 10433, 18963, 21700, 25865, 32768, 0]
	];
	final left:Int;
	final top:Int;
	final yAbove:Array<Array<Int>> = [];
	final uvAbove:Array<Array<Int>> = [];
	final yLeft:Array<Array<Int>> = [];
	final uvLeft:Array<Array<Int>> = [];

	public function new(left:Int, top:Int) {
		this.left = left;
		this.top = top;
	}

	public function neighbors(x:Int, y:Int):{skip:Int, luma:Int, yCache:Array<Int>, uvCache:Array<Int>} {
		final hasLeft = x > left;
		final hasAbove = y > top;
		final yAtLeft = hasLeft ? yLeft[y - top] : null;
		final yAtTop = hasAbove ? yAbove[x - left] : null;
		final cacheAbove = hasAbove && (y & 15) != 0;
		return {
			skip: (hasLeft ? 1 : 0) + (hasAbove ? 1 : 0),
			luma: (yAtLeft != null && yAtLeft.length > 0 ? 1 : 0) + (yAtTop != null && yAtTop.length > 0 ? 1 : 0),
			yCache: cache(yAtLeft, cacheAbove ? yAtTop : null),
			uvCache: cache(hasLeft ? uvLeft[y - top] : null, cacheAbove ? uvAbove[x - left] : null)
		};
	}

	public function update(x:Int, y:Int, width:Int, height:Int, luma:Array<Int>, chroma:Array<Int>):Void {
		for (column in x - left...x - left + width) {
			yAbove[column] = luma;
			uvAbove[column] = chroma;
		}
		for (row in y - top...y - top + height) {
			yLeft[row] = luma;
			uvLeft[row] = chroma;
		}
	}

	static function cache(left:Null<Array<Int>>, above:Null<Array<Int>>):Array<Int> {
		final result = [];
		if (left != null) for (color in left) if (result.indexOf(color) < 0) result.push(color);
		if (above != null) for (color in above) if (result.indexOf(color) < 0) result.push(color);
		result.sort((a, b) -> a - b);
		return result;
	}
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
