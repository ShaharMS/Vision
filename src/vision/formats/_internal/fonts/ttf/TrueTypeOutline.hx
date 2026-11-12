package vision.formats._internal.fonts.ttf;

import haxe.ds.IntMap;
import vision.exceptions.FontLoadingError;
import vision.formats._internal.fonts.FontTable;
import vision.formats._internal.fonts.FontData.FontPoint;

/** Decodes simple and composite glyph outlines from TrueType tables. **/
@:noCompletion
class TrueTypeOutline {
	final family:String;
	final glyf:FontTable;
	final offsets:Array<Int>;
	final outlines = new IntMap<Array<Array<FontPoint>>>();

	public function new(family:String, glyf:FontTable, loca:FontTable, glyphCount:Int, indexFormat:Int) {
		this.family = family;
		this.glyf = glyf;
		offsets = [for (i in 0...glyphCount + 1) indexFormat == 0 ? loca.u16(i * 2) * 2 : loca.u32(i * 4)];
		for (i in 0...glyphCount)
			if (offsets[i] > offsets[i + 1] || offsets[i + 1] > glyf.length)
				throw invalid("Invalid glyph offsets.");
	}

	public function read(id:Int, depth:Int = 0):Array<Array<FontPoint>> {
		final saved = outlines.get(id);
		if (saved != null) return saved;
		if (id < 0 || id >= offsets.length - 1 || depth > 16) throw invalid("Invalid composite glyph.");
		final length = offsets[id + 1] - offsets[id];
		if (length == 0) return [];
		final data = glyf.slice(offsets[id], length);
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
			final part = read(id, depth + 1);
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

	inline function invalid(reason:String):FontLoadingError {
		return new FontLoadingError(family, reason);
	}
}
