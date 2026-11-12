package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** AV1 partition symbols in bitstream order. **/
enum abstract Av1Partition(Int) from Int to Int {
	var None;
	var Horizontal;
	var Vertical;
	var Split;
	var HorizontalA;
	var HorizontalB;
	var VerticalA;
	var VerticalB;
	var HorizontalFour;
	var VerticalFour;
}

/** Visits AV1 coding blocks in bitstream order, tracking partition contexts within a tile. **/
@:noCompletion
class Av1PartitionTree {
	// Default partition CDFs from the AV1 specification, indexed by block size and context.
	static final defaults = [
		[
			[19132, 25510, 30392, 32768, 0],
			[13928, 19855, 28540, 32768, 0],
			[12522, 23679, 28629, 32768, 0],
			[9896, 18783, 25853, 32768, 0]
		],
		[
			[15597, 20929, 24571, 26706, 27664, 28821, 29601, 30571, 31902, 32768, 0],
			[7925, 11043, 16785, 22470, 23971, 25043, 26651, 28701, 29834, 32768, 0],
			[5414, 13269, 15111, 20488, 22360, 24500, 25537, 26336, 32117, 32768, 0],
			[2662, 6362, 8614, 20860, 23053, 24778, 26436, 27829, 31171, 32768, 0]
		],
		[
			[18462, 20920, 23124, 27647, 28227, 29049, 29519, 30178, 31544, 32768, 0],
			[7689, 9060, 12056, 24992, 25660, 26182, 26951, 28041, 29052, 32768, 0],
			[6015, 9009, 10062, 24544, 25409, 26545, 27071, 27526, 32047, 32768, 0],
			[1394, 2208, 2796, 28614, 29061, 29466, 29840, 30185, 31899, 32768, 0]
		],
		[
			[20137, 21547, 23078, 29566, 29837, 30261, 30524, 30892, 31724, 32768, 0],
			[6732, 7490, 9497, 27944, 28250, 28515, 28969, 29630, 30104, 32768, 0],
			[5945, 7663, 8348, 28683, 29117, 29749, 30064, 30298, 32238, 32768, 0],
			[870, 1212, 1487, 31198, 31394, 31574, 31743, 31881, 32332, 32768, 0]
		],
		[
			[27899, 28219, 28529, 32484, 32539, 32619, 32639, 32768, 0],
			[6607, 6990, 8268, 32060, 32219, 32338, 32371, 32768, 0],
			[5429, 6676, 7122, 32027, 32227, 32531, 32582, 32768, 0],
			[711, 966, 1172, 32448, 32538, 32617, 32664, 32768, 0]
		]
	];

	final left:Int;
	final top:Int;
	final right:Int;
	final bottom:Int;
	final superblock:Int;
	final aboveWidths:Bytes;
	final leftHeights:Bytes;
	final distributions = [for (size in defaults) [for (cdf in size) cdf.copy()]];

	/** The tile bounds are measured in 4x4 units. The superblock size is in pixels. **/
	public function new(left:Int, top:Int, right:Int, bottom:Int, superblockSize:Int) {
		if (left < 0 || top < 0 || right > 16384 || bottom > 16384 || right <= left || bottom <= top
			|| ((left | top | right | bottom) & 1) != 0 || (superblockSize != 64 && superblockSize != 128))
			throw new Av1BitstreamError("Invalid AV1 partition tile geometry.");
		this.left = left;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
		superblock = superblockSize >> 2;
		aboveWidths = Bytes.alloc(right - left);
		leftHeights = Bytes.alloc(bottom - top);
	}

	/** Reads partition symbols and lets the caller decode each coding block before continuing. **/
	public function decode(symbols:Av1SymbolDecoder, block:(Int, Int, Int, Int) -> Void, ?beforeSuperblock:(Int, Int) -> Void):Void {
		walk((_, _, _, cdf, edge) -> {
			final symbol:Av1Partition = symbols.readSymbol(cdf);
			return edge == None ? symbol : symbol == None ? edge : Split;
		}, block, beforeSuperblock);
	}

	/** Writes partitions selected by the caller and visits the resulting coding blocks. **/
	public function encode(symbols:Av1SymbolEncoder, partition:(Int, Int, Int) -> Av1Partition, block:(Int, Int, Int, Int) -> Void):Void {
		walk((x, y, size, cdf, edge) -> {
			final selected = partition(x, y, size);
			if (edge != None && selected != edge && selected != Split)
				throw new Av1BitstreamError("Invalid AV1 partition at a clipped frame edge.");
			symbols.writeSymbol(edge == None ? (selected:Int) : selected == edge ? 0 : 1, cdf);
			return selected;
		}, block);
	}

	function walk(select:PartitionSelection, block:(Int, Int, Int, Int) -> Void, ?beforeSuperblock:(Int, Int) -> Void):Void {
		var y = top;
		while (y < bottom) {
			var x = left;
			while (x < right) {
				if (beforeSuperblock != null) beforeSuperblock(x, y);
				visit(x, y, superblock, select, block);
				x += superblock;
			}
			y += superblock;
		}
	}

	function visit(x:Int, y:Int, size:Int, select:PartitionSelection, block:(Int, Int, Int, Int) -> Void):Void {
		if (x >= right || y >= bottom) return;
		final half = size >> 1;
		final hasRight = x + half < right;
		final hasBottom = y + half < bottom;
		var partition:Av1Partition = None;
		if (size > 1) {
			if (!hasRight && !hasBottom) partition = Split;
			else {
				final above = y > top && aboveWidths.get(x - left) < size;
				final leftBlock = x > left && leftHeights.get(y - top) < size;
				final context = (above ? 1 : 0) + (leftBlock ? 2 : 0);
				final cdf = distributions[sizeIndex(size)][context];
				if (hasRight && hasBottom) partition = select(x, y, size, cdf, None);
				else {
					final edge:Av1Partition = hasRight ? Horizontal : Vertical;
					partition = select(x, y, size, edgeDistribution(cdf, edge, size), edge);
				}
			}
		}
		switch partition {
			case None: leaf(x, y, size, size, block);
			case Horizontal:
				leaf(x, y, size, half, block);
				leaf(x, y + half, size, half, block);
			case Vertical:
				leaf(x, y, half, size, block);
				leaf(x + half, y, half, size, block);
			case Split:
				visit(x, y, half, select, block);
				visit(x + half, y, half, select, block);
				visit(x, y + half, half, select, block);
				visit(x + half, y + half, half, select, block);
			case HorizontalA:
				leaf(x, y, half, half, block);
				leaf(x + half, y, half, half, block);
				leaf(x, y + half, size, half, block);
			case HorizontalB:
				leaf(x, y, size, half, block);
				leaf(x, y + half, half, half, block);
				leaf(x + half, y + half, half, half, block);
			case VerticalA:
				leaf(x, y, half, half, block);
				leaf(x, y + half, half, half, block);
				leaf(x + half, y, half, size, block);
			case VerticalB:
				leaf(x, y, half, size, block);
				leaf(x + half, y, half, half, block);
				leaf(x + half, y + half, half, half, block);
			case HorizontalFour:
				final quarter = half >> 1;
				for (i in 0...4) leaf(x, y + i * quarter, size, quarter, block);
			case VerticalFour:
				final quarter = half >> 1;
				for (i in 0...4) leaf(x + i * quarter, y, quarter, size, block);
		}
	}

	function leaf(x:Int, y:Int, width:Int, height:Int, block:(Int, Int, Int, Int) -> Void):Void {
		if (x >= right || y >= bottom) return;
		block(x, y, width, height);
		final columns = width < right - x ? width : right - x;
		final rows = height < bottom - y ? height : bottom - y;
		aboveWidths.fill(x - left, columns, width);
		leftHeights.fill(y - top, rows, height);
	}

	static function edgeDistribution(cdf:Array<Int>, edge:Av1Partition, size:Int):Array<Int> {
		final splitSymbols:Array<Av1Partition> = edge == Horizontal
			? [Vertical, Split, HorizontalA, VerticalA, VerticalB]
			: [Horizontal, Split, HorizontalA, HorizontalB, VerticalA];
		if (size < 32) splitSymbols.push(edge == Horizontal ? VerticalFour : HorizontalFour);
		var splitProbability = 0;
		for (symbol in splitSymbols) splitProbability += cdf[symbol] - cdf[(symbol:Int) - 1];
		return [32768 - splitProbability, 32768, 0];
	}

	static function sizeIndex(size:Int):Int {
		var index = 0;
		while (size > 2) {
			size >>= 1;
			index++;
		}
		return index;
	}
}

private typedef PartitionSelection = (Int, Int, Int, Array<Int>, Av1Partition) -> Av1Partition;
