package vision.formats._internal.fonts.otf;

import haxe.ds.IntMap;
import vision.formats._internal.fonts.FontTable;

/** Horizontal advance adjustments from OpenType kern lookups. **/
@:noCompletion
class GposKerning {
	final lookups:Array<Array<PairPosition>> = [];

	public function new(data:FontTable) {
		if (data.u16(0) != 1) return;
		final features = data.u16(6);
		final lookupList = data.u16(8);
		final indices = new IntMap<Bool>();
		for (i in 0...data.u16(features)) {
			final record = features + 2 + i * 6;
			if (data.tag(record) != "kern") continue;
			final feature = features + data.u16(record + 4);
			for (j in 0...data.u16(feature + 2)) indices.set(data.u16(feature + 4 + j * 2), true);
		}
		for (i in 0...data.u16(lookupList)) {
			if (!indices.exists(i)) continue;
			final lookup = lookupList + data.u16(lookupList + 2 + i * 2);
			final type = data.u16(lookup);
			if (type != 2 && type != 9) continue;
			final pairs = [];
			for (j in 0...data.u16(lookup + 4)) {
				var subtable = lookup + data.u16(lookup + 6 + j * 2);
				if (type == 9) {
					if (data.u16(subtable) != 1 || data.u16(subtable + 2) != 2) continue;
					subtable += data.u32(subtable + 4);
				}
				final format = data.u16(subtable);
				if (format == 1 || format == 2) pairs.push(new PairPosition(data, subtable, format));
			}
			if (pairs.length > 0) lookups.push(pairs);
		}
	}

	public function adjustment(left:Int, right:Int):Null<Int> {
		if (lookups.length == 0) return null;
		var total = 0;
		for (lookup in lookups) {
			for (subtable in lookup) {
				final value = subtable.adjustment(left, right);
				if (value == null) continue;
				total += value;
				break;
			}
		}
		return total;
	}
}

private class PairPosition {
	final data:FontTable;
	final start:Int;
	final format:Int;
	final coverage:Int;
	final firstValueFormat:Int;
	final recordSize:Int;

	public function new(data:FontTable, start:Int, format:Int) {
		this.data = data;
		this.start = start;
		this.format = format;
		coverage = start + data.u16(start + 2);
		firstValueFormat = data.u16(start + 4);
		recordSize = valueSize(firstValueFormat) + valueSize(data.u16(start + 6));
	}

	public function adjustment(left:Int, right:Int):Null<Int> {
		final index = coverageIndex(left);
		if (index < 0) return null;
		if (format == 1) {
			if (index >= data.u16(start + 8)) return null;
			final set = start + data.u16(start + 10 + index * 2);
			var low = 0;
			var high = data.u16(set) - 1;
			while (low <= high) {
				final middle = (low + high) >>> 1;
				final row = set + 2 + middle * (2 + recordSize);
				final glyph = data.u16(row);
				if (glyph < right) low = middle + 1;
				else if (glyph > right) high = middle - 1;
				else return advance(row + 2);
			}
			return null;
		}
		final leftClass = glyphClass(start + data.u16(start + 8), left);
		final rightClass = glyphClass(start + data.u16(start + 10), right);
		final columns = data.u16(start + 14);
		if (leftClass >= data.u16(start + 12) || rightClass >= columns || recordSize == 0) return 0;
		return advance(start + 16 + (leftClass * columns + rightClass) * recordSize);
	}

	inline function advance(offset:Int):Int {
		return (firstValueFormat & 4) == 0 ? 0 : data.i16(offset + valueSize(firstValueFormat & 3));
	}

	function coverageIndex(glyph:Int):Int {
		if (data.u16(coverage) == 1) {
			var low = 0;
			var high = data.u16(coverage + 2) - 1;
			while (low <= high) {
				final middle = (low + high) >>> 1;
				final value = data.u16(coverage + 4 + middle * 2);
				if (value < glyph) low = middle + 1;
				else if (value > glyph) high = middle - 1;
				else return middle;
			}
		} else if (data.u16(coverage) == 2) {
			final row = findRange(coverage + 4, data.u16(coverage + 2), glyph);
			if (row != -1) return data.u16(row + 4) + glyph - data.u16(row);
		}
		return -1;
	}

	function glyphClass(offset:Int, glyph:Int):Int {
		switch data.u16(offset) {
			case 1:
				final index = glyph - data.u16(offset + 2);
				if (index >= 0 && index < data.u16(offset + 4)) return data.u16(offset + 6 + index * 2);
			case 2:
				final row = findRange(offset + 4, data.u16(offset + 2), glyph);
				if (row != -1) return data.u16(row + 4);
			default:
		}
		return 0;
	}

	function findRange(offset:Int, count:Int, glyph:Int):Int {
		var low = 0;
		var high = count - 1;
		while (low <= high) {
			final middle = (low + high) >>> 1;
			final row = offset + middle * 6;
			if (glyph < data.u16(row)) high = middle - 1;
			else if (glyph > data.u16(row + 2)) low = middle + 1;
			else return row;
		}
		return -1;
	}

	static function valueSize(format:Int):Int {
		var size = 0;
		for (bit in 0...8) if ((format & (1 << bit)) != 0) size += 2;
		return size;
	}
}
