package vision.formats._internal.fonts;

import haxe.ds.IntMap;
import vision.exceptions.FontLoadingError;
import vision.formats._internal.fonts.otf.CffOutline;
import vision.formats._internal.fonts.otf.GposKerning;
import vision.formats._internal.fonts.ttf.TrueTypeOutline;

typedef FontPoint = {
	final x:Float;
	final y:Float;
	final onCurve:Bool;
}

/** OpenType name-table identifiers used to label a font face. **/
enum abstract FontNameId(Int) to Int {
	var FAMILY = 1;
	var SUBFAMILY = 2;
	var TYPOGRAPHIC_FAMILY = 16;
	var TYPOGRAPHIC_SUBFAMILY = 17;
}

typedef FontLigature = {
	final following:Array<Int>;
	final replacement:Int;
}

/** Decoded metrics, character mappings, and outlines shared by the font readers. **/
@:noCompletion
class FontData {
	final family:String;
	public final unitsPerEm:Int;
	public final ascent:Int;
	public final descent:Int;
	public final lineGap:Int;
	final tables:Map<String, FontTable>;
	final cmap:FontTable;
	public final glyphCount:Int;
	final advances:Array<Int>;
	final trueType:Null<TrueTypeOutline>;
	final cff:Null<CffOutline>;
	final outlines = new IntMap<Array<Array<FontPoint>>>();
	public final ligatures = new IntMap<Array<FontLigature>>();
	final positioning:Null<GposKerning>;
	final kerning = new IntMap<Int>();

	public function new(tables:Map<String, FontTable>, family:String) {
		this.family = family;
		this.tables = tables;
		final head = table("head");
		final hhea = table("hhea");
		final maxp = table("maxp");
		final hmtx = table("hmtx");
		final indexFormat = head.i16(50);
		unitsPerEm = head.u16(18);
		ascent = hhea.i16(4);
		descent = hhea.i16(6);
		lineGap = hhea.i16(8);
		glyphCount = maxp.u16(4);
		final metricCount = hhea.u16(34);
		if (unitsPerEm < 16 || unitsPerEm > 16384 || glyphCount == 0 || metricCount == 0 || metricCount > glyphCount
			|| (indexFormat != 0 && indexFormat != 1))
			throw invalid("Invalid font metrics.");
		advances = [for (i in 0...metricCount) hmtx.u16(i * 4)];
		if (tables.exists("CFF ")) {
			cff = new CffOutline(table("CFF "), family, glyphCount);
			trueType = null;
		} else {
			if (tables.exists("CFF2")) throw invalid("CFF2 outlines are unavailable.");
			cff = null;
			trueType = new TrueTypeOutline(family, table("glyf"), table("loca"), glyphCount, indexFormat);
		}
		cmap = readCharacterMap(table("cmap"));
		if (tables.exists("GSUB")) readLigatures(table("GSUB"));
		positioning = tables.exists("GPOS") ? new GposKerning(table("GPOS")) : null;
		if (tables.exists("kern")) readKerning(table("kern"));
	}

	function readCharacterMap(map:FontTable):FontTable {
		var best:FontTable = null;
		var bestFormat = 0;
		for (i in 0...map.u16(2)) {
			final entry = 4 + i * 8;
			final platform = map.u16(entry);
			final encoding = map.u16(entry + 2);
			if (platform != 0 && !(platform == 3 && (encoding == 1 || encoding == 10))) continue;
			final start = map.u32(entry + 4);
			final format = map.u16(start);
			if ((format == 4 || format == 12) && format > bestFormat) {
				best = map.slice(start, format == 12 ? map.u32(start + 4) : map.u16(start + 2));
				bestFormat = format;
			}
		}
		if (best == null) throw invalid("No supported Unicode character map.");
		if (bestFormat == 12 && best.u32(12) > Std.int((best.length - 16) / 12))
			throw invalid("Invalid Unicode character map group count.");
		return best;
	}

	public function glyph(code:Int):Int {
		var id = 0;
		if (cmap.u16(0) == 12) {
			var left = 0;
			var right = cmap.u32(12) - 1;
			while (left <= right) {
				final mid = (left + right) >>> 1;
				final row = 16 + mid * 12;
				final start = cmap.u32(row);
				if (code < start) right = mid - 1;
				else if (code > cmap.u32(row + 4)) left = mid + 1;
				else {
					id = cmap.u32(row + 8) + code - start;
					break;
				}
			}
		} else if (code <= 0xffff) {
			final count = cmap.u16(6) >> 1;
			var left = 0;
			var right = count - 1;
			while (left <= right) {
				final i = (left + right) >>> 1;
				if (code > cmap.u16(14 + i * 2)) {
					left = i + 1;
					continue;
				}
				final start = cmap.u16(16 + count * 2 + i * 2);
				if (code < start) {
					right = i - 1;
					continue;
				}
				final delta = cmap.i16(16 + count * 4 + i * 2);
				final row = 16 + count * 6 + i * 2;
				final range = cmap.u16(row);
				id = range == 0 ? code : cmap.u16(row + range + (code - start) * 2);
				if (id != 0 || range == 0) id = (id + delta) & 0xffff;
				break;
			}
		}
		return id >= 0 && id < glyphCount ? id : 0;
	}

	public function codePoints():Array<Int> {
		final result = [];
		if (cmap.u16(0) == 12) {
			for (i in 0...cmap.u32(12)) {
				final row = 16 + i * 12;
				final start = cmap.u32(row);
				final end = cmap.u32(row + 4);
				final firstGlyph = cmap.u32(row + 8);
				if (start > end || end > 0x10ffff || firstGlyph >= glyphCount || end - start >= glyphCount - firstGlyph)
					throw invalid("Invalid Unicode character map range.");
				for (code in start...end + 1)
					if (firstGlyph + code - start != 0 && (code < 0xd800 || code > 0xdfff)) result.push(code);
			}
		} else {
			final count = cmap.u16(6) >> 1;
			var previous = -1;
			for (i in 0...count) {
				final start = cmap.u16(16 + count * 2 + i * 2);
				final end = cmap.u16(14 + i * 2);
				if (start <= previous || end < start) throw invalid("Invalid Unicode character map range.");
				previous = end;
				for (code in start...end + 1)
					if ((code < 0xd800 || code > 0xdfff) && glyph(code) != 0) result.push(code);
			}
		}
		return result;
	}

	public function name(preferred:Int, fallback:Int):Null<String> {
		final data = tables.get("name");
		if (data == null) return null;
		final strings = data.u16(4);
		var best:Null<String> = null;
		var priority = 0;
		for (i in 0...data.u16(2)) {
			final record = 6 + i * 12;
			final platform = data.u16(record);
			final encoding = data.u16(record + 2);
			final language = data.u16(record + 4);
			final id = data.u16(record + 6);
			if ((id != preferred && id != fallback) || (platform != 0 && !(platform == 3 && (encoding == 1 || encoding == 10)))) continue;
			final score = (id == preferred ? 4 : 2) + (language == 0x409 ? 1 : 0);
			if (score <= priority) continue;
			final bytes = data.slice(strings + data.u16(record + 10), data.u16(record + 8));
			final text = new StringBuf();
			var at = 0;
			while (at + 1 < bytes.length) {
				var code = bytes.u16(at);
				at += 2;
				if (code >= 0xd800 && code <= 0xdbff && at + 1 < bytes.length) {
					final low = bytes.u16(at);
					if (low >= 0xdc00 && low <= 0xdfff) {
						code = 0x10000 + ((code - 0xd800) << 10) + low - 0xdc00;
						at += 2;
					}
				}
				if (code != 0 && (code < 0xd800 || code > 0xdfff)) text.add(character(code));
			}
			final decoded = text.toString();
			if (decoded.length == 0) continue;
			best = decoded;
			priority = score;
		}
		return best;
	}

	public static inline function character(code:Int):String {
		return String.fromCharCode(code);
	}

	public function advance(id:Int):Int {
		return advances[id < advances.length ? id : advances.length - 1];
	}

	function readKerning(data:FontTable):Void {
		if (data.u16(0) != 0) return;
		var offset = 4;
		for (_ in 0...data.u16(2)) {
			var length = data.u16(offset + 2);
			final coverage = data.u16(offset + 4);
			final horizontal = (coverage >> 8) == 0 && (coverage & 7) == 1;
			if (horizontal) {
				final expected = 14 + data.u16(offset + 6) * 6;
				// Some large legacy kern tables wrap the 16-bit length field.
				if (expected > length && (expected & 0xffff) == length) length = expected;
			}
			final subtable = data.slice(offset, length);
			offset += length;
			if (!horizontal) continue;
			for (i in 0...subtable.u16(6)) {
				final entry = 14 + i * 6;
				final key = (subtable.u16(entry) << 16) | subtable.u16(entry + 2);
				final prior = kerning.get(key);
				final delta = subtable.i16(entry + 4);
				kerning.set(key, prior == null || (coverage & 8) != 0 ? delta : prior + delta);
			}
		}
	}

	public function pairAdjustment(left:Int, right:Int):Int {
		final adjustment = positioning == null ? null : positioning.adjustment(left, right);
		if (adjustment != null) return adjustment;
		final value = kerning.get((left << 16) | right);
		return value == null ? 0 : value;
	}

	function readLigatures(gsub:FontTable):Void {
		final features = gsub.u16(6);
		final lookups = gsub.u16(8);
		final visited = new IntMap<Bool>();
		for (i in 0...gsub.u16(features)) {
			final entry = features + 2 + i * 6;
			if (gsub.tag(entry) != "liga") continue;
			final feature = features + gsub.u16(entry + 4);
			for (j in 0...gsub.u16(feature + 2)) {
				final index = gsub.u16(feature + 4 + j * 2);
				if (index >= gsub.u16(lookups) || visited.exists(index)) continue;
				visited.set(index, true);
				final lookup = lookups + gsub.u16(lookups + 2 + index * 2);
				final type = gsub.u16(lookup);
				for (k in 0...gsub.u16(lookup + 4)) {
					final sub = lookup + gsub.u16(lookup + 6 + k * 2);
					if (type == 4) readLigatureSet(gsub, sub);
					else if (type == 7 && gsub.u16(sub) == 1 && gsub.u16(sub + 2) == 4)
						readLigatureSet(gsub, sub + gsub.u32(sub + 4));
				}
			}
		}
		for (set in ligatures) set.sort((a, b) -> b.following.length - a.following.length);
	}

	function readLigatureSet(data:FontTable, sub:Int):Void {
		if (data.u16(sub) != 1) return;
		final coverage = sub + data.u16(sub + 2);
		final glyphs:Array<Int> = [];
		switch data.u16(coverage) {
			case 1:
				for (i in 0...data.u16(coverage + 2)) glyphs.push(data.u16(coverage + 4 + i * 2));
			case 2:
				for (i in 0...data.u16(coverage + 2)) {
					final row = coverage + 4 + i * 6;
					final start = data.u16(row);
					final end = data.u16(row + 2);
					final first = data.u16(row + 4);
					if (first != glyphs.length || end < start || glyphs.length + end - start >= glyphCount)
						throw invalid("Invalid ligature coverage.");
					for (id in start...end + 1) glyphs.push(id);
				}
			default: return;
		}
		for (i in 0...data.u16(sub + 4)) {
			if (i >= glyphs.length) throw invalid("Invalid ligature set.");
			final set = sub + data.u16(sub + 6 + i * 2);
			final first = glyphs[i];
			var rules = ligatures.get(first);
			if (rules == null) {
				rules = [];
				ligatures.set(first, rules);
			}
			for (j in 0...data.u16(set)) {
				final row = set + data.u16(set + 2 + j * 2);
				final replacement = data.u16(row);
				final count = data.u16(row + 2);
				if (replacement < glyphCount && count > 1)
					rules.push({replacement: replacement, following: [for (k in 1...count) data.u16(row + 2 + k * 2)]});
			}
		}
	}

	public function outline(id:Int):Array<Array<FontPoint>> {
		if (id < 0 || id >= glyphCount) throw invalid("Invalid glyph index.");
		final saved = outlines.get(id);
		if (saved != null) return saved;
		final contours = cff != null ? cff.outline(id) : trueType.read(id);
		outlines.set(id, contours);
		return contours;
	}

	function table(tag:String):FontTable {
		final result = tables.get(tag);
		if (result == null) throw invalid('Missing "$tag" table.');
		return result;
	}

	inline function invalid(reason:String):FontLoadingError {
		return new FontLoadingError(family, reason);
	}
}
