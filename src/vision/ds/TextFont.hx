package vision.ds;

import haxe.ds.IntMap;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.InflateImpl;
import vision.exceptions.FontLoadingError;
import vision.formats.__internal.FontTable;
import vision.formats.__internal.Woff2;
import vision.formats.__internal.CffOutline;

typedef FontPoint = {
	final x:Float;
	final y:Float;
	final onCurve:Bool;
}

private typedef FontLigature = {
	final following:Array<Int>;
	final replacement:Int;
}

/** An outline font that can be drawn without a platform text backend. **/
@:allow(vision.algorithms.TextDrawing)
class TextFont {
	final family:String;
	final unitsPerEm:Int;
	final ascent:Int;
	final tables:Map<String, FontTable>;
	final cmap:FontTable;
	final glyphCount:Int;
	final advances:Array<Int>;
	final offsets:Array<Int>;
	final cff:Null<CffOutline>;
	final outlines = new IntMap<Array<Array<FontPoint>>>();
	final ligatures = new IntMap<Array<FontLigature>>();
	final kerning = new IntMap<Int>();

	/**
		Reads TrueType or CFF outlines from TTF, OpenType, WOFF, or WOFF2 bytes.

		@param bytes The font data
		@param family The name to use in font-loading errors
		@return A reusable font
	**/
	public static function fromBytes(bytes:Bytes, family:String = "Font"):TextFont {
		try {
			return new TextFont(bytes, family);
		} catch (error:FontLoadingError) {
			throw error;
		} catch (error:Dynamic) {
			throw new FontLoadingError(family, Std.string(error));
		}
	}

	function new(bytes:Bytes, family:String) {
		this.family = family;
		tables = readTables(bytes.sub(0, bytes.length));
		final head = table("head");
		final hhea = table("hhea");
		final maxp = table("maxp");
		final hmtx = table("hmtx");
		final indexFormat = head.i16(50);
		unitsPerEm = head.u16(18);
		ascent = hhea.i16(4);
		glyphCount = maxp.u16(4);
		final metricCount = hhea.u16(34);
		if (unitsPerEm < 16 || unitsPerEm > 16384 || glyphCount == 0 || metricCount == 0 || metricCount > glyphCount
			|| (indexFormat != 0 && indexFormat != 1))
			throw invalid("Invalid font metrics.");
		advances = [for (i in 0...metricCount) hmtx.u16(i * 4)];
		if (tables.exists("CFF ")) {
			cff = new CffOutline(table("CFF "), family, glyphCount);
			offsets = [];
		} else {
			if (tables.exists("CFF2")) throw invalid("CFF2 outlines are unavailable.");
			cff = null;
			final loca = table("loca");
			final glyf = table("glyf");
			offsets = [for (i in 0...glyphCount + 1) indexFormat == 0 ? loca.u16(i * 2) * 2 : loca.u32(i * 4)];
			for (i in 0...glyphCount)
				if (offsets[i] > offsets[i + 1] || offsets[i + 1] > glyf.length) throw invalid("Invalid glyph offsets.");
		}
		cmap = readCharacterMap(table("cmap"));
		if (tables.exists("GSUB")) readLigatures(table("GSUB"));
		if (tables.exists("kern")) readKerning(table("kern"));
	}

	function readTables(bytes:Bytes):Map<String, FontTable> {
		final source = new FontTable(bytes, 0, bytes.length);
		final signature = source.u32(0);
		final woff = signature == 0x774F4646;
		if (signature == 0x774F4632) return Woff2.read(source);
		final flavor = woff ? source.u32(4) : signature;
		if (flavor != 0x00010000 && flavor != 0x74727565 && flavor != 0x4F54544F) throw invalid("Unknown font format.");
		final count = source.u16(woff ? 12 : 4);
		final result = new Map<String, FontTable>();
		var expanded = 0.0;
		for (i in 0...count) {
			final entry = woff ? 44 + i * 20 : 12 + i * 16;
			final tag = source.tag(entry);
			final start = source.u32(entry + (woff ? 4 : 8));
			final stored = source.u32(entry + (woff ? 8 : 12));
			final length = woff ? source.u32(entry + 12) : stored;
			expanded += length;
			if (expanded > 64 * 1024 * 1024 || stored > length) throw invalid("Invalid font table length.");
			final block = source.slice(start, stored);
			if (stored == length) {
				result.set(tag, block);
			} else {
				final data = Bytes.alloc(length);
				final inflate = new InflateImpl(new BytesInput(bytes, start, stored));
				if (inflate.readBytes(data, 0, length) != length || inflate.readBytes(Bytes.alloc(1), 0, 1) != 0)
					throw invalid("Invalid compressed font table.");
				result.set(tag, new FontTable(data, 0, length));
			}
		}
		return result;
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

	function glyph(code:Int):Int {
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
			for (i in 0...count) {
				if (code > cmap.u16(14 + i * 2)) continue;
				final start = cmap.u16(16 + count * 2 + i * 2);
				if (code < start) break;
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

	function advance(id:Int):Int {
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

	function pairAdjustment(left:Int, right:Int):Int {
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

	function outline(id:Int, depth:Int = 0):Array<Array<FontPoint>> {
		final saved = outlines.get(id);
		if (saved != null) return saved;
		if (id < 0 || id >= glyphCount || depth > 16) throw invalid("Invalid composite glyph.");
		if (cff != null) {
			final contours = cff.outline(id);
			outlines.set(id, contours);
			return contours;
		}
		final length = offsets[id + 1] - offsets[id];
		if (length == 0) return [];
		final data = table("glyf").slice(offsets[id], length);
		final count = data.i16(0);
		final contours = count >= 0 ? simpleOutline(data, count) : compositeOutline(data, depth);
		outlines.set(id, contours);
		return contours;
	}

	function simpleOutline(data:FontTable, count:Int):Array<Array<FontPoint>> {
		if (count == 0) return [];
		final ends = [for (i in 0...count) data.u16(10 + i * 2) + 1];
		var pos = 10 + count * 2;
		pos += 2 + data.u16(pos);
		final size = ends[count - 1];
		final flags:Array<Int> = [];
		while (flags.length < size) {
			final flag = data.u8(pos++);
			final repeat = (flag & 8) != 0 ? data.u8(pos++) + 1 : 1;
			if (flags.length + repeat > size) throw invalid("Invalid glyph point flags.");
			for (_ in 0...repeat) flags.push(flag);
		}
		final coordinates:Array<Array<Int>> = [];
		for (axis in 0...2) {
			final shortMask = 2 << axis;
			final sameMask = 16 << axis;
			final values:Array<Int> = [];
			var value = 0;
			for (flag in flags) {
				if ((flag & shortMask) != 0) {
					final delta = data.u8(pos++);
					value += (flag & sameMask) != 0 ? delta : -delta;
				} else if ((flag & sameMask) == 0) {
					value += data.i16(pos);
					pos += 2;
				}
				values.push(value);
			}
			coordinates.push(values);
		}
		var start = 0;
		final contours = [];
		for (end in ends) {
			if (end <= start || end > size) throw invalid("Invalid glyph contour.");
			final contour:Array<FontPoint> = [
				for (i in start...end) {x: coordinates[0][i], y: coordinates[1][i], onCurve: (flags[i] & 1) != 0}
			];
			contours.push(contour);
			start = end;
		}
		return contours;
	}

	function compositeOutline(data:FontTable, depth:Int):Array<Array<FontPoint>> {
		final contours:Array<Array<FontPoint>> = [];
		final points:Array<FontPoint> = [];
		var pos = 10;
		var flags:Int;
		do {
			flags = data.u16(pos);
			final id = data.u16(pos + 2);
			pos += 4;
			final words = (flags & 1) != 0;
			final offset = (flags & 2) != 0;
			final first = words ? (offset ? data.i16(pos) : data.u16(pos)) : (offset ? data.i8(pos) : data.u8(pos));
			pos += words ? 2 : 1;
			final second = words ? (offset ? data.i16(pos) : data.u16(pos)) : (offset ? data.i8(pos) : data.u8(pos));
			pos += words ? 2 : 1;
			var a = 1.0, b = 0.0, c = 0.0, d = 1.0;
			if ((flags & 8) != 0) {
				a = d = data.i16(pos) / 16384;
				pos += 2;
			} else if ((flags & 64) != 0) {
				a = data.i16(pos) / 16384;
				d = data.i16(pos + 2) / 16384;
				pos += 4;
			} else if ((flags & 128) != 0) {
				a = data.i16(pos) / 16384;
				b = data.i16(pos + 2) / 16384;
				c = data.i16(pos + 4) / 16384;
				d = data.i16(pos + 6) / 16384;
				pos += 8;
			}
			final part = outline(id, depth + 1);
			final transformed:Array<FontPoint> = [];
			for (contour in part)
				for (p in contour) transformed.push({x: a * p.x + c * p.y, y: b * p.x + d * p.y, onCurve: p.onCurve});
			var x:Float = first, y:Float = second;
			if (!offset) {
				if (first >= points.length || second >= transformed.length) throw invalid("Invalid composite glyph attachment.");
				x = points[first].x - transformed[second].x;
				y = points[first].y - transformed[second].y;
			} else if ((flags & 0x0800) != 0) {
				x = a * first + c * second;
				y = b * first + d * second;
			}
			if (points.length + transformed.length > 65536) throw invalid("Composite glyph has too many points.");
			var index = 0;
			for (contour in part) {
				final translated = [];
				for (_ in contour) {
					final p = transformed[index++];
					final point:FontPoint = {x: p.x + x, y: p.y + y, onCurve: p.onCurve};
					translated.push(point);
					points.push(point);
				}
				contours.push(translated);
			}
		} while ((flags & 32) != 0);
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
