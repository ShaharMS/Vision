package vision.formats._internal.images.avif.av1;

import vision.exceptions.Av1BitstreamError;

/** The coefficient scan class derived from the transform type. **/
enum abstract Av1CoefficientClass(Int) from Int to Int {
	var TwoDimensional;
	var Horizontal;
	var Vertical;
}

/** Quantized samples and the contexts passed to neighboring transforms. **/
typedef Av1CoefficientBlock = {
	final values:Array<Int>;
	final endOfBlock:Int;
	final cumulativeLevel:Int;
	final dcCategory:Int;
}

/** Reads transform coefficients using one tile's adaptive probability tables. **/
@:noCompletion
class Av1Coefficients {
	static final widths = [2, 3, 4, 5, 6, 2, 3, 3, 4, 4, 5, 5, 6, 2, 4, 3, 5, 4, 6];
	static final heights = [2, 3, 4, 5, 6, 3, 2, 4, 3, 5, 4, 6, 5, 4, 2, 5, 3, 6, 4];
	static final magnitudeNeighbors = [
		[[0, 1], [1, 0], [1, 1]],
		[[0, 1], [1, 0], [0, 2]],
		[[0, 1], [1, 0], [2, 0]]
	];
	static final significanceNeighbors = [
		[[0, 1], [1, 0], [1, 1], [0, 2], [2, 0]],
		[[0, 1], [1, 0], [0, 2], [0, 3], [0, 4]],
		[[0, 1], [1, 0], [2, 0], [3, 0], [4, 0]]
	];

	final symbols:Av1SymbolDecoder;
	final zero:Array<Array<Int>>;
	final end:Array<Array<Array<Int>>>;
	final extra:Array<Array<Int>>;
	final sign:Array<Array<Int>>;
	final baseEnd:Array<Array<Int>>;
	final base:Array<Array<Int>>;
	final range:Array<Array<Int>>;
	final scans:Map<Int, Array<Int>> = [];

	/** Starts the coefficient contexts for a tile using the frame's base quantizer index. **/
	public function new(symbols:Av1SymbolDecoder, baseQuantizer:Int) {
		if (baseQuantizer < 0 || baseQuantizer > 255) throw new Av1BitstreamError("Invalid AV1 base quantizer.");
		this.symbols = symbols;
		final group = baseQuantizer <= 20 ? 0 : baseQuantizer <= 60 ? 1 : baseQuantizer <= 120 ? 2 : 3;
		zero = Av1CoefficientTables.unpack(Av1CoefficientTables.zero[group], 2);
		end = [
			Av1CoefficientTables.unpack(Av1CoefficientTables.eob16[group], 5),
			Av1CoefficientTables.unpack(Av1CoefficientTables.eob32[group], 6),
			Av1CoefficientTables.unpack(Av1CoefficientTables.eob64[group], 7),
			Av1CoefficientTables.unpack(Av1CoefficientTables.eob128[group], 8),
			Av1CoefficientTables.unpack(Av1CoefficientTables.eob256[group], 9),
			Av1CoefficientTables.unpack(Av1CoefficientTables.eob512[group], 10),
			Av1CoefficientTables.unpack(Av1CoefficientTables.eob1024[group], 11)
		];
		extra = Av1CoefficientTables.unpack(Av1CoefficientTables.extra[group], 2);
		sign = Av1CoefficientTables.unpack(Av1CoefficientTables.sign[group], 2);
		baseEnd = Av1CoefficientTables.unpack(Av1CoefficientTables.baseEob[group], 3);
		base = Av1CoefficientTables.unpack(Av1CoefficientTables.base[group], 4);
		range = Av1CoefficientTables.unpack(Av1CoefficientTables.range[group], 4);
	}

	/**
		Reads a transform block in raster coefficient order. The caller provides
		the neighboring skip and DC sign contexts. The callback reads or derives the
		transform type only after an all-zero block has been ruled out.
	**/
	public function read(width:Int, height:Int, plane:Int, zeroContext:Int, signContext:Int,
		selectClass:() -> Av1CoefficientClass):Av1CoefficientBlock {
		if (plane < 0 || plane > 2 || zeroContext < 0 || zeroContext > 12 || signContext < 0 || signContext > 2)
			throw new Av1BitstreamError("Invalid AV1 coefficient neighbor contexts.");
		final transform = transformIndex(width, height);
		final sizeContext = (widths[transform] + heights[transform] - 3) >> 1;
		final planeType = plane == 0 ? 0 : 1;
		final widthLog = min(widths[transform], 5);
		final heightLog = min(heights[transform], 5);
		final codedWidth = 1 << widthLog;
		final codedHeight = 1 << heightLog;
		final area = codedWidth * codedHeight;
		final values = [for (_ in 0...area) 0];
		if (symbols.readSymbol(zero[sizeContext * 13 + zeroContext]) != 0)
			return {values: values, endOfBlock: 0, cumulativeLevel: 0, dcCategory: 0};

		final txClass = selectClass();
		if ((txClass:Int) < 0 || (txClass:Int) > 2 || ((width == 64 || height == 64) && txClass != TwoDimensional))
			throw new Av1BitstreamError("Invalid AV1 coefficient scan class.");
		final order = scan(transform, txClass, codedWidth, codedHeight);
		final endSize = widthLog + heightLog - 4;
		final eob = readEnd(endSize, planeType, sizeContext, txClass);
		if (eob > area) throw new Av1BitstreamError("AV1 coefficient end position exceeds the transform area.");
		final cdfGroup = sizeContext * 2 + planeType;
		final rangeGroup = min(sizeContext, 3) * 2 + planeType;
		var index = eob;
		while (index > 0) {
			index--;
			final position = order[index];
			final row = position >> widthLog;
			final column = position & (codedWidth - 1);
			var level:Int;
			if (index == eob - 1) {
				final ctx = index == 0 ? 0 : index <= (area >> 3) ? 1 : index <= (area >> 2) ? 2 : 3;
				level = symbols.readSymbol(baseEnd[cdfGroup * 4 + ctx]) + 1;
			} else {
				final ctx = baseContext(values, transform, txClass, codedWidth, codedHeight, row, column);
				level = symbols.readSymbol(base[cdfGroup * 42 + ctx]);
			}
			if (level > 2) {
				final ctx = rangeContext(values, txClass, codedWidth, codedHeight, row, column);
				for (_ in 0...4) {
					final increment = symbols.readSymbol(range[rangeGroup * 21 + ctx]);
					level += increment;
					if (increment < 3) break;
				}
			}
			values[position] = level;
		}
		var cumulative = 0;
		var dcCategory = 0;
		for (i in 0...eob) {
			final position = order[i];
			var level = values[position];
			if (level == 0) continue;
			final negative = (i == 0 ? symbols.readSymbol(sign[planeType * 3 + signContext]) : symbols.readLiteral(1)) != 0;
			if (level == 15) level = readGolomb() + 14;
			if (position == 0) dcCategory = negative ? 1 : 2;
			level &= 0xfffff;
			cumulative = min(63, cumulative + level);
			values[position] = negative ? -level : level;
		}
		return {values: values, endOfBlock: eob, cumulativeLevel: cumulative, dcCategory: dcCategory};
	}

	function readEnd(size:Int, plane:Int, context:Int, txClass:Av1CoefficientClass):Int {
		final endContext = size >= 5 ? plane : plane * 2 + (txClass == TwoDimensional ? 0 : 1);
		final point = symbols.readSymbol(end[size][endContext]) + 1;
		if (point <= 2) return point;
		final lowBits = point - 3;
		final highBit = symbols.readSymbol(extra[(context * 2 + plane) * 9 + lowBits]);
		return (1 << (point - 2)) + 1 + (highBit << lowBits) + symbols.readLiteral(lowBits);
	}

	function readGolomb():Int {
		var zeroes = 0;
		while (symbols.readLiteral(1) == 0) {
			if (++zeroes >= 20) throw new Av1BitstreamError("Invalid AV1 coefficient Golomb length.");
		}
		return (1 << zeroes) + symbols.readLiteral(zeroes);
	}

	function scan(transform:Int, txClass:Av1CoefficientClass, width:Int, height:Int):Array<Int> {
		final key = transform * 3 + (txClass:Int);
		final cached = scans.get(key);
		if (cached != null) return cached;
		final order = [];
		switch txClass {
			case Horizontal:
				for (x in 0...width) for (y in 0...height) order.push(y * width + x);
			case Vertical:
				for (index in 0...width * height) order.push(index);
			case TwoDimensional:
				for (diagonal in 0...width + height - 1) {
					final left = max(0, diagonal - height + 1);
					final right = min(width - 1, diagonal);
					final ascending = width > height || (width == height && (diagonal & 1) == 0);
					for (offset in 0...right - left + 1) {
						final x = ascending ? left + offset : right - offset;
						order.push((diagonal - x) * width + x);
					}
				}
		}
		scans.set(key, order);
		return order;
	}

	static function baseContext(values:Array<Int>, transform:Int, txClass:Av1CoefficientClass, width:Int, height:Int,
		row:Int, column:Int):Int {
		if (txClass == TwoDimensional && row == 0 && column == 0) return 0;
		final magnitude = neighborMagnitude(values, width, height, row, column, significanceNeighbors[txClass], 3);
		final context = min((magnitude + 1) >> 1, 4);
		if (txClass == TwoDimensional)
			return context + Av1CoefficientTables.baseContextOffsets[transform][min(row, 4) * 5 + min(column, 4)];
		final axis = txClass == Vertical ? row : column;
		return context + 26 + min(axis, 2) * 5;
	}

	static function rangeContext(values:Array<Int>, txClass:Av1CoefficientClass, width:Int, height:Int, row:Int, column:Int):Int {
		final magnitude = neighborMagnitude(values, width, height, row, column, magnitudeNeighbors[txClass], 15);
		final context = min((magnitude + 1) >> 1, 6);
		if (row == 0 && column == 0) return context;
		final near = txClass == TwoDimensional ? row < 2 && column < 2 : txClass == Horizontal ? column == 0 : row == 0;
		return context + (near ? 7 : 14);
	}

	static function neighborMagnitude(values:Array<Int>, width:Int, height:Int, row:Int, column:Int, neighbors:Array<Array<Int>>, limit:Int):Int {
		var magnitude = 0;
		for (delta in neighbors) {
			final y = row + delta[0];
			final x = column + delta[1];
			if (y < height && x < width) magnitude += min(values[y * width + x], limit);
		}
		return magnitude;
	}

	static function transformIndex(width:Int, height:Int):Int {
		for (i in 0...widths.length) if (width == (1 << widths[i]) && height == (1 << heights[i])) return i;
		throw new Av1BitstreamError("Invalid AV1 coefficient block dimensions.");
	}

	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function max(a:Int, b:Int):Int return a > b ? a : b;
}
