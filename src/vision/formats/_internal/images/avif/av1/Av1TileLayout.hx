package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** One tile's entropy payload and its bounds in 4x4 units. **/
typedef Av1Tile = {
	final offset:Int;
	final length:Int;
	final columnStart:Int;
	final columnEnd:Int;
	final rowStart:Int;
	final rowEnd:Int;
}

/** Frame tile boundaries and tile-group byte ranges. **/
@:noCompletion
class Av1TileLayout {
	public final columnStarts:Array<Int>;
	public final rowStarts:Array<Int>;
	public final columnBits:Int;
	public final rowBits:Int;
	public final sizeBytes:Int;
	public final contextUpdateTile:Int;

	/** Reads the tile layout from the frame header. **/
	public function new(bits:Av1RawBits, width:Int, height:Int, superblockSize:Int) {
		final sbColumns = Std.int((width + superblockSize - 1) / superblockSize);
		final sbRows = Std.int((height + superblockSize - 1) / superblockSize);
		final maxWidth = Std.int(4096 / superblockSize);
		final maxArea = Std.int(4096 * 2304 / (superblockSize * superblockSize));
		final minColumns = log2(maxWidth, sbColumns);
		final minTiles = max(minColumns, log2(maxArea, sbColumns * sbRows));
		final unitsPerSb = superblockSize >> 2;
		final miColumns = ((width + 7) >> 3) << 1;
		final miRows = ((height + 7) >> 3) << 1;
		if (bits.flag()) {
			columnBits = increment(bits, minColumns, log2(1, min(sbColumns, 64)));
			rowBits = increment(bits, max(minTiles - columnBits, 0), log2(1, min(sbRows, 64)));
			columnStarts = uniformStarts(sbColumns, columnBits, unitsPerSb, miColumns);
			rowStarts = uniformStarts(sbRows, rowBits, unitsPerSb, miRows);
		} else {
			columnStarts = [];
			var start = 0;
			var widest = 0;
			while (start < sbColumns) {
				if (columnStarts.length == 64) throw new Av1BitstreamError("Too many AV1 tile columns.");
				columnStarts.push(start * unitsPerSb);
				final extent = bits.nonSymmetric(min(sbColumns - start, maxWidth)) + 1;
				widest = max(widest, extent);
				start += extent;
			}
			columnBits = log2(1, columnStarts.length);
			columnStarts.push(miColumns);
			final area = minTiles > 0 ? (sbRows * sbColumns) >> (minTiles + 1) : sbRows * sbColumns;
			final maxHeight = max(Std.int(area / widest), 1);
			rowStarts = [];
			start = 0;
			while (start < sbRows) {
				if (rowStarts.length == 64) throw new Av1BitstreamError("Too many AV1 tile rows.");
				rowStarts.push(start * unitsPerSb);
				start += bits.nonSymmetric(min(sbRows - start, maxHeight)) + 1;
			}
			rowBits = log2(1, rowStarts.length);
			rowStarts.push(miRows);
		}
		final tileBits = columnBits + rowBits;
		contextUpdateTile = bits.read(tileBits);
		sizeBytes = tileBits > 0 ? bits.read(2) + 1 : 0;
		if (contextUpdateTile >= (columnStarts.length - 1) * (rowStarts.length - 1))
			throw new Av1BitstreamError("Invalid AV1 tile context update index.");
	}

	/** Locates each entropy payload in a bounded Tile Group OBU payload. **/
	public function readGroup(bytes:Bytes, offset:Int, length:Int):Array<Av1Tile> {
		final bits = new Av1RawBits(bytes, offset, length);
		final columns = columnStarts.length - 1;
		final count = columns * (rowStarts.length - 1);
		final explicitRange = count > 1 && bits.flag();
		final tileBits = columnBits + rowBits;
		final start = explicitRange ? bits.read(tileBits) : 0;
		final end = explicitRange ? bits.read(tileBits) : count - 1;
		if (start > end || end >= count) throw new Av1BitstreamError("Invalid AV1 tile group range.");
		var position = bits.align();
		final limit = offset + length;
		final tiles = [];
		for (index in start...end + 1) {
			var size = limit - position;
			if (index != end) {
				if (sizeBytes > size) throw new Av1BitstreamError("Truncated AV1 tile size.");
				var sizeMinusOne = 0.0;
				for (i in 0...sizeBytes) sizeMinusOne += bytes.get(position++) * Math.pow(256, i);
				if (sizeMinusOne >= limit - position) throw new Av1BitstreamError("Truncated AV1 tile payload.");
				size = Std.int(sizeMinusOne) + 1;
			}
			if (size == 0) throw new Av1BitstreamError("Empty AV1 tile payload.");
			final column = index % columns;
			final row = Std.int(index / columns);
			tiles.push({
				offset: position, length: size,
				columnStart: columnStarts[column], columnEnd: columnStarts[column + 1],
				rowStart: rowStarts[row], rowEnd: rowStarts[row + 1]
			});
			position += size;
		}
		return tiles;
	}

	static function uniformStarts(count:Int, shift:Int, unit:Int, end:Int):Array<Int> {
		final span = (count + (1 << shift) - 1) >> shift;
		final starts = [];
		var position = 0;
		while (position < count) {
			starts.push(position * unit);
			position += span;
		}
		starts.push(end);
		return starts;
	}

	static function increment(bits:Av1RawBits, start:Int, limit:Int):Int {
		while (start < limit && bits.flag()) start++;
		return start;
	}

	static function log2(block:Int, target:Int):Int {
		var value = 0;
		while ((block << value) < target) value++;
		return value;
	}

	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function max(a:Int, b:Int):Int return a > b ? a : b;
}
