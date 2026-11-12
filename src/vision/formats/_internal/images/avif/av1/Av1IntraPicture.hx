package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1IntraBlockReader.Av1IntraBlock;
import vision.formats._internal.images.avif.av1.Av1IntraBlockReader.Av1IntraTransform;
import vision.formats._internal.images.avif.av1.Av1IntraPrediction.Av1IntraEdges;
import vision.formats._internal.images.avif.av1.Av1IntraPrediction.Av1IntraMode;
import vision.formats._internal.images.avif.av1.Av1TileLayout.Av1Tile;

/** Reconstructs intra-coded AV1 frames with transform residuals. **/
@:noCompletion
class Av1IntraPicture {
	/** Returns raster-order sample planes, cropped to the displayed image dimensions. **/
	public static function decode(bytes:Bytes, sequence:Av1SequenceHeader, frame:Av1StillFrameHeader, tiles:Array<Av1Tile>):Array<Bytes> {
		if (sequence.bitDepth != 8 || frame.width != frame.upscaledWidth || frame.screenContent || frame.intraBlockCopy
			|| frame.segments != null || frame.quantizerMatrices != null || frame.deltaQuantizerShift != null
			|| frame.width > 8192 || frame.height > 8192 || frame.width * 1.0 * frame.height > 8912896)
			throw new Av1BitstreamError("Unsupported AV1 intra picture parameters.");
		for (type in frame.restorationTypes) if (type != 0) throw new Av1BitstreamError("Unsupported AV1 loop restoration.");
		if (frame.cdefStrengths.length > 1) throw new Av1BitstreamError("Unsupported AV1 CDEF index signaling.");
		for (strength in frame.cdefStrengths)
			for (value in strength) if (value != 0) throw new Av1BitstreamError("Unsupported AV1 directional enhancement filter.");
		final width = (frame.width + 7) & ~7;
		final height = (frame.height + 7) & ~7;
		final subX = sequence.subsamplingX ? 1 : 0;
		final subY = sequence.subsamplingY ? 1 : 0;
		final planes = [new IntraPlane(width, height)];
		if (!sequence.monochrome) {
			planes.push(new IntraPlane(width >> subX, height >> subY));
			planes.push(new IntraPlane(width >> subX, height >> subY));
		}
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
			decodeTile(bytes, sequence, frame, tile, planes, subX, subY);
		}
		final chromaWidth = (frame.width + subX) >> subX;
		final chromaHeight = (frame.height + subY) >> subY;
		final levels = frame.loopFilterLevels;
		final delta = frame.loopFilterDeltas == null ? null : frame.loopFilterDeltas[0];
		for (plane in 0...planes.length)
			planes[plane].deblock(plane == 0 ? frame.width : chromaWidth, plane == 0 ? frame.height : chromaHeight,
				plane != 0, levels[plane == 0 ? 0 : plane + 1], levels[plane == 0 ? 1 : plane + 1], frame.loopFilterSharpness, delta);
		return [for (i in 0...planes.length) planes[i].crop(i == 0 ? frame.width : chromaWidth, i == 0 ? frame.height : chromaHeight)];
	}

	static function decodeTile(bytes:Bytes, sequence:Av1SequenceHeader, frame:Av1StillFrameHeader, tile:Av1Tile,
		planes:Array<IntraPlane>, subX:Int, subY:Int):Void {
		final symbols = new Av1SymbolDecoder(bytes, tile.offset, tile.length, frame.updateCdf);
		final blockReader = new Av1IntraBlockReader(symbols, sequence, frame, tile.columnStart, tile.rowStart);
		final coefficients = new Av1Coefficients(symbols, frame.baseQuantizer);
		final partition = new Av1PartitionTree(tile.columnStart, tile.rowStart, tile.columnEnd, tile.rowEnd, sequence.superblockSize);
		final contexts = [for (i in 0...planes.length) new ResidualNeighbors(tile, i == 0 ? 0 : subX, i == 0 ? 0 : subY)];
		partition.decode(symbols, (x, y, width4, height4) -> {
			final chroma = !sequence.monochrome
				&& (subX == 0 || width4 != 1 || (x & 1) != 0) && (subY == 0 || height4 != 1 || (y & 1) != 0);
			final width = width4 * 4;
			final height = height4 * 4;
			final block = blockReader.read(x, y, width, height, chroma);
			final chunksX = max(1, width >> 6);
			final chunksY = max(1, height >> 6);
			for (chunkY in 0...chunksY) for (chunkX in 0...chunksX) {
				final chunkWidth = chunksX > 1 || chunksY > 1 ? 64 : width;
				final chunkHeight = chunksX > 1 || chunksY > 1 ? 64 : height;
				for (plane in 0...(chroma ? 3 : 1)) {
					final sx = plane == 0 ? 0 : subX;
					final sy = plane == 0 ? 0 : subY;
					final baseX = (x >> sx) * 4;
					final baseY = (y >> sy) * 4;
					final px = baseX + ((chunkX * 64) >> sx);
					final py = baseY + ((chunkY * 64) >> sy);
					final planeWidth = max(4, chunkWidth >> sx);
					final planeHeight = max(4, chunkHeight >> sy);
					final txWidth = frame.lossless ? 4 : plane == 0 ? block.transformWidth : min(32, max(4, width >> sx));
					final txHeight = frame.lossless ? 4 : plane == 0 ? block.transformHeight : min(32, max(4, height >> sy));
					decodeChunk(planes, plane, px, py, planeWidth, planeHeight, txWidth, txHeight,
						baseX, baseY, width, height, sx, sy, block, contexts[plane], coefficients, blockReader, sequence, frame);
				}
			}
		});
		symbols.finish();
	}

	static function decodeChunk(planes:Array<IntraPlane>, plane:Int, chunkX:Int, chunkY:Int, width:Int, height:Int,
		txWidth:Int, txHeight:Int, baseX:Int, baseY:Int, lumaWidth:Int, lumaHeight:Int, sx:Int, sy:Int,
		block:Av1IntraBlock, contexts:ResidualNeighbors, coefficients:Av1Coefficients, modes:Av1IntraBlockReader,
		sequence:Av1SequenceHeader, frame:Av1StillFrameHeader):Void {
		final buffer = planes[plane];
		final cfl = plane != 0 && block.chromaMode == 13;
		final mode:Av1IntraMode = plane == 0 ? block.lumaMode : cfl ? Dc : block.chromaMode;
		final angle = plane == 0 ? block.lumaAngle : block.chromaAngle;
		final filter = plane == 0 ? block.filter : -1;
		final dcDelta = frame.quantizerDeltas[plane == 0 ? 0 : plane == 1 ? 1 : 3];
		final acDelta = plane == 0 ? 0 : frame.quantizerDeltas[plane == 1 ? 2 : 4];
		final bw = max(4, lumaWidth >> sx);
		final bh = max(4, lumaHeight >> sy);
		final smoothNeighbor = contexts.hasSmoothNeighbor(baseX, baseY);
		var y = chunkY;
		while (y < chunkY + height && y < contexts.bottom) {
			var x = chunkX;
			while (x < chunkX + width && x < contexts.right) {
				final edges = buffer.edges(x, y, txWidth, txHeight, contexts);
				var predicted = Av1IntraPrediction.predict(txWidth, txHeight, 8, mode, edges,
					angle, sequence.intraEdgeFilter, smoothNeighbor, filter);
				if (cfl) {
					final samples = planes[0].chromaReferences(x, y, txWidth, txHeight, sx, sy,
						min(planes[0].width, (baseX << sx) + lumaWidth), min(planes[0].height, (baseY << sy) + lumaHeight));
					predicted = Av1IntraPrediction.chromaFromLuma(predicted, samples, plane == 1 ? block.alphaU : block.alphaV, 8);
				}
				var level = 0;
				var dc = 0;
				if (!block.skip) {
					var transform:Av1IntraTransform = null;
					final neighbor = contexts.read(x, y, txWidth, txHeight, bw, bh, plane != 0);
					final quantized = coefficients.read(txWidth, txHeight, plane, neighbor.zero, neighbor.sign, () -> {
						transform = modes.readTransform(block, plane, txWidth, txHeight);
						return transform.scan;
					});
					level = quantized.cumulativeLevel;
					dc = quantized.dcCategory;
					if (quantized.endOfBlock != 0) {
						final scaled = Av1Dequantization.dequantize(quantized.values, txWidth, txHeight, 8, frame.baseQuantizer, dcDelta, acDelta);
						final residual = frame.lossless ? Av1LosslessTransform.inverse(scaled, 8)
							: Av1InverseTransform.inverse(scaled, txWidth, txHeight, 8, transform.horizontal, transform.vertical);
						for (i in 0...residual.length) predicted[i] = clip(predicted[i] + residual[i]);
					}
				}
				buffer.put(x, y, txWidth, txHeight, predicted, contexts);
				contexts.update(x, y, txWidth, txHeight, level, dc);
				x += txWidth;
			}
			y += txHeight;
		}
		contexts.updateMode(chunkX, chunkY, width, height, mode);
	}

	static inline function clip(value:Int):Int return value < 0 ? 0 : value > 255 ? 255 : value;
	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function max(a:Int, b:Int):Int return a > b ? a : b;
}

private class IntraPlane {
	public final width:Int;
	public final height:Int;
	final data:Bytes;
	final transformWidths:Bytes;
	final transformHeights:Bytes;

	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;
		data = Bytes.alloc(width * height);
		transformWidths = Bytes.alloc((width >> 2) * (height >> 2));
		transformHeights = Bytes.alloc(transformWidths.length);
	}

	public function crop(width:Int, height:Int):Bytes {
		final result = Bytes.alloc(width * height);
		for (y in 0...height) result.blit(y * width, data, y * this.width, width);
		return result;
	}

	public function put(x:Int, y:Int, w:Int, h:Int, samples:Array<Int>, bounds:ResidualNeighbors):Void {
		final right = min(x + w, bounds.right);
		final bottom = min(y + h, bounds.bottom);
		for (row in y...bottom) for (column in x...right)
			data.set(row * width + column, samples[(row - y) * w + column - x]);
		for (row in (y >> 2)...(bottom >> 2)) {
			final offset = row * (width >> 2) + (x >> 2);
			final length = (right - x) >> 2;
			transformWidths.fill(offset, length, w);
			transformHeights.fill(offset, length, h);
		}
	}

	public function deblock(width:Int, height:Int, chroma:Bool, vertical:Int, horizontal:Int, sharpness:Int, delta:Null<Int>):Void {
		Av1LoopFilter.apply(data, this.width, width, height, transformWidths, transformHeights, chroma, vertical, horizontal, sharpness, delta);
	}

	public function edges(x:Int, y:Int, w:Int, h:Int, bounds:ResidualNeighbors):Av1IntraEdges {
		final hasAbove = y > bounds.top;
		final hasLeft = x > bounds.left;
		final aboveRight = hasAbove && x + w < bounds.right && isDecoded(x + w, y - 1);
		final belowLeft = hasLeft && y + h < bounds.bottom && isDecoded(x - 1, y + h);
		final above = hasAbove ? [for (column in x...min(bounds.right, x + (aboveRight ? 2 * w : w))) data.get((y - 1) * width + column)] : [];
		final left = hasLeft ? [for (row in y...min(bounds.bottom, y + (belowLeft ? 2 * h : h))) data.get(row * width + x - 1)] : [];
		return {above: above, left: left, corner: hasAbove && hasLeft ? data.get((y - 1) * width + x - 1) : null};
	}

	public function chromaReferences(x:Int, y:Int, w:Int, h:Int, sx:Int, sy:Int, right:Int, bottom:Int):Array<Int> {
		return [for (row in y...y + h) for (column in x...x + w) {
			final sampleX = min(right - (1 << sx), column << sx);
			final sampleY = min(bottom - (1 << sy), row << sy);
			var sample = 0;
			for (dy in 0...sy + 1) for (dx in 0...sx + 1)
				sample += data.get((sampleY + dy) * width + sampleX + dx);
			sample << (3 - sx - sy);
		}];
	}

	inline function isDecoded(x:Int, y:Int):Bool return transformWidths.get((y >> 2) * (width >> 2) + (x >> 2)) != 0;
	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
}

private class ResidualNeighbors {
	public final left:Int;
	public final top:Int;
	public final right:Int;
	public final bottom:Int;
	final aboveLevel:Bytes;
	final leftLevel:Bytes;
	final aboveDc:Bytes;
	final leftDc:Bytes;
	final aboveMode:Bytes;
	final leftMode:Bytes;

	public function new(tile:Av1Tile, sx:Int, sy:Int) {
		left = (tile.columnStart >> sx) * 4;
		right = (tile.columnEnd >> sx) * 4;
		top = (tile.rowStart >> sy) * 4;
		bottom = (tile.rowEnd >> sy) * 4;
		aboveLevel = Bytes.alloc((right - left) >> 2);
		leftLevel = Bytes.alloc((bottom - top) >> 2);
		aboveDc = Bytes.alloc(aboveLevel.length);
		leftDc = Bytes.alloc(leftLevel.length);
		aboveMode = Bytes.alloc(aboveLevel.length);
		leftMode = Bytes.alloc(leftLevel.length);
	}

	public function read(x:Int, y:Int, width:Int, height:Int, blockWidth:Int, blockHeight:Int, chroma:Bool):{zero:Int, sign:Int} {
		var a = 0;
		var l = 0;
		var sign = 0;
		for (column in ((x - left) >> 2)...((min(x + width, right) - left) >> 2)) {
			final dc = aboveDc.get(column);
			sign += dc == 0 ? 0 : dc == 1 ? -1 : 1;
			a = max(a, aboveLevel.get(column) | (chroma ? dc : 0));
		}
		for (row in ((y - top) >> 2)...((min(y + height, bottom) - top) >> 2)) {
			final dc = leftDc.get(row);
			sign += dc == 0 ? 0 : dc == 1 ? -1 : 1;
			l = max(l, leftLevel.get(row) | (chroma ? dc : 0));
		}
		final zero = if (chroma) 7 + (a != 0 ? 1 : 0) + (l != 0 ? 1 : 0) + (blockWidth * blockHeight > width * height ? 3 : 0)
			else if (width == blockWidth && height == blockHeight) 0
			else if (a == 0 && l == 0) 1
			else if (a == 0 || l == 0) max(a, l) > 3 ? 3 : 2
			else if (max(a, l) <= 3) 4
			else min(a, l) <= 3 ? 5 : 6;
		return {zero: zero, sign: sign < 0 ? 1 : sign > 0 ? 2 : 0};
	}

	public function update(x:Int, y:Int, width:Int, height:Int, level:Int, dc:Int):Void {
		final column = (x - left) >> 2;
		final row = (y - top) >> 2;
		final columns = (min(x + width, right) - x) >> 2;
		final rows = (min(y + height, bottom) - y) >> 2;
		aboveLevel.fill(column, columns, level);
		aboveDc.fill(column, columns, dc);
		leftLevel.fill(row, rows, level);
		leftDc.fill(row, rows, dc);
	}

	public function hasSmoothNeighbor(x:Int, y:Int):Bool {
		return (y > top && smooth(aboveMode.get((x - left) >> 2))) || (x > left && smooth(leftMode.get((y - top) >> 2)));
	}

	public function updateMode(x:Int, y:Int, width:Int, height:Int, mode:Av1IntraMode):Void {
		if (x >= right || y >= bottom) return;
		aboveMode.fill((x - left) >> 2, (min(x + width, right) - x) >> 2, mode);
		leftMode.fill((y - top) >> 2, (min(y + height, bottom) - y) >> 2, mode);
	}

	static inline function smooth(mode:Int):Bool return mode >= 9 && mode <= 11;
	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function max(a:Int, b:Int):Int return a > b ? a : b;
}
