package vision.formats._internal.fonts;

import vision.formats._internal.fonts.TextShaper.ShapedGlyph;

typedef GlyphPlacement = {
	final id:Int;
	var advance:Int;
	var x:Int;
	var y:Int;
}

/** Applies OpenType mark attachments in font units. */
@:noCompletion
class OpenTypePositioning {
	final layout:OpenTypeLookups;
	static inline var MARK_CLASS = 3;

	public function new(gpos:FontTable, gdef:Null<FontTable>, script:String) {
		layout = new OpenTypeLookups(gpos, gdef, script);
	}

	public function position(glyphs:Array<ShapedGlyph>, font:FontData):Array<GlyphPlacement> {
		final placements:Array<GlyphPlacement> = [for (glyph in glyphs) {
			id: glyph.id,
			advance: layout.glyphClass(glyph.id) == MARK_CLASS ? 0 : font.advance(glyph.id),
			x: 0, y: 0
		}];
		final ids = [for (glyph in glyphs) glyph.id];
		final parents = [for (_ in glyphs) -1];
		final origins = [];
		for (lookup in layout.feature("kern"))
			for (i in 0...glyphs.length)
				attach(lookup, glyphs, ids, placements, origins, parents, i, 0, true);
		var pen = 0;
		for (i in 0...glyphs.length) {
			if (i > 0) pen += font.pairAdjustment(glyphs[i - 1].id, glyphs[i].id);
			origins.push(pen);
			pen += placements[i].advance;
		}
		final order = [for (tag in ["mark", "abvm", "blwm", "mkmk"]) for (lookup in layout.feature(tag)) lookup];
		for (lookup in order) {
			for (j in 0...glyphs.length) {
				final i = glyphs[0].rtl ? glyphs.length - 1 - j : j;
				attach(lookup, glyphs, ids, placements, origins, parents, i, 0);
			}
		}
		// Resolve attachments in logical order.
		for (j in 0...glyphs.length) {
			final i = glyphs[j].rtl ? glyphs.length - 1 - j : j;
			final parent = parents[i];
			if (parent < 0) continue;
			placements[i].x += placements[parent].x;
			placements[i].y += placements[parent].y;
		}
		return placements;
	}

	function attach(id:Int, glyphs:Array<ShapedGlyph>, ids:Array<Int>, placements:Array<GlyphPlacement>,
		origins:Array<Int>, parents:Array<Int>, index:Int, depth:Int, single:Bool = false):Bool {
		if (depth >= 8) return false;
		final table = layout.table;
		final lookup = layout.lookup(id);
		if (lookup == 0) return false;
		final flags = table.u16(lookup + 2);
		if ((flags & 0xfff0) != 0 || layout.ignored(ids[index], flags)) return false;
		// The run is stored in visual order, so forward logical traversal walks left.
		function next(from:Int, step:Int, flags:Int):Int {
			final delta = glyphs[index].rtl ? -step : step;
			var i = from + delta;
			while (i >= 0 && i < ids.length && glyphs[i].script == glyphs[index].script) {
				if (!layout.ignored(ids[i], flags)) return i;
				i += delta;
			}
			return -1;
		}
		for (i in 0...table.u16(lookup + 4)) {
			var sub = lookup + table.u16(lookup + 6 + i * 2);
			var type = table.u16(lookup);
			if (type == 9 && table.u16(sub) == 1) {
				type = table.u16(sub + 2);
				sub += table.u32(sub + 4);
			}
			if (type == 8 && table.u16(sub) == 3) {
				final match = layout.context(sub, ids, index, flags, next);
				if (match == null) continue;
				for (j in 0...table.u16(match.records)) {
					final record = match.records + 2 + j * 4;
					final input = table.u16(record);
					if (input < match.inputs.length)
						attach(table.u16(record + 2), glyphs, ids, placements, origins, parents, match.inputs[input], depth + 1, single);
				}
				return true;
			}
			if (single && type == 1) {
				final covered = layout.coverage(sub + table.u16(sub + 2), ids[index]);
				if (covered < 0) continue;
				final format = table.u16(sub);
				final fields = table.u16(sub + 4);
				var value = sub + 6;
				if (format == 2) {
					if (covered >= table.u16(value)) continue;
					value += 2 + covered * valueSize(fields);
				} else if (format != 1) continue;
				applyValue(placements[index], value, fields);
				return true;
			}
			if (single && type == 2 && glyphs[index].rtl) {
				final following = next(index, 1, flags);
				if (following < 0) continue;
				final covered = layout.coverage(sub + table.u16(sub + 2), ids[index]);
				if (covered < 0) continue;
				final first = table.u16(sub + 4);
				final second = table.u16(sub + 6);
				final width = valueSize(first) + valueSize(second);
				var value = -1;
				switch table.u16(sub) {
					case 1:
						if (covered >= table.u16(sub + 8)) continue;
						final set = sub + table.u16(sub + 10 + covered * 2);
						for (j in 0...table.u16(set)) {
							final record = set + 2 + j * (2 + width);
							if (table.u16(record) == ids[following]) {
								value = record + 2;
								break;
							}
						}
					case 2:
						final a = layout.classAt(sub + table.u16(sub + 8), ids[index]);
						final b = layout.classAt(sub + table.u16(sub + 10), ids[following]);
						final columns = table.u16(sub + 14);
						if (a < table.u16(sub + 12) && b < columns) value = sub + 16 + (a * columns + b) * width;
					default:
				}
				if (value < 0) continue;
				applyValue(placements[index], value, first);
				applyValue(placements[following], value + valueSize(first), second);
				return true;
			}
			if (single) continue;
			if ((type < 4 || type > 6) || table.u16(sub) != 1) continue;
			final markIndex = layout.coverage(sub + table.u16(sub + 2), ids[index]);
			if (markIndex < 0) continue;
			var base = next(index, -1, flags);
			if (type != 6)
				while (base >= 0 && layout.glyphClass(ids[base]) == MARK_CLASS) base = next(base, -1, flags);
			if (base < 0) continue;
			final baseIndex = layout.coverage(sub + table.u16(sub + 4), ids[base]);
			if (baseIndex < 0) continue;
			if (type == 6 && glyphs[index].component != glyphs[base].component) continue;
			final classes = table.u16(sub + 6);
			final markArray = sub + table.u16(sub + 8);
			final baseArray = sub + table.u16(sub + 10);
			if (markIndex >= table.u16(markArray) || baseIndex >= table.u16(baseArray)) continue;
			final markRecord = markArray + 2 + markIndex * 4;
			final markClass = table.u16(markRecord);
			if (markClass >= classes) continue;
			final markOffset = table.u16(markRecord + 2);
			var anchorTable = baseArray;
			var row = baseIndex;
			if (type == 5) {
				anchorTable += table.u16(baseArray + 2 + baseIndex * 2);
				final count = table.u16(anchorTable);
				if (count == 0) continue;
				final component = glyphs[index].component;
				row = component < 0 || component >= count ? count - 1 : component;
			}
			final baseOffset = table.u16(anchorTable + 2 + (row * classes + markClass) * 2);
			if (markOffset == 0 || baseOffset == 0) continue;
			final markAnchor = markArray + markOffset;
			final baseAnchor = anchorTable + baseOffset;
			placements[index].x = origins[base] - origins[index] + table.i16(baseAnchor + 2) - table.i16(markAnchor + 2);
			placements[index].y = table.i16(baseAnchor + 4) - table.i16(markAnchor + 4);
			parents[index] = base;
			return true;
		}
		return false;
	}

	static function valueSize(fields:Int):Int {
		var width = 0;
		for (bit in 0...8) if ((fields & (1 << bit)) != 0) width += 2;
		return width;
	}

	function applyValue(placement:GlyphPlacement, offset:Int, fields:Int):Void {
		final table = layout.table;
		var value = offset;
		if ((fields & 1) != 0) {
			placement.x += table.i16(value);
			value += 2;
		}
		if ((fields & 2) != 0) {
			placement.y += table.i16(value);
			value += 2;
		}
		if ((fields & 4) != 0) placement.advance += table.i16(value);
	}
}
