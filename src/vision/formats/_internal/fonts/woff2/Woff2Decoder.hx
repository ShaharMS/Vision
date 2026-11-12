package vision.formats._internal.fonts.woff2;

import vision.formats._internal.fonts.FontTable;

import haxe.io.BytesOutput;
import vision.exceptions.FontLoadingError;
import vision.formats._internal.zip.brotli.decode.Decode;
import vision.formats._internal.zip.brotli.decode.streams.BrotliOutput;

private typedef Woff2Entry = {
	final tag:String;
	final originalLength:Int;
	final length:Int;
}

private typedef GlyphPoint = {
	final x:Int;
	final y:Int;
	final onCurve:Bool;
}

/** Reads a single WOFF2 font and reconstructs the tables used by Font. **/
@:noCompletion
class Woff2Decoder {
	static inline var MAX_BYTES = 64 * 1024 * 1024;

	static final tags = [
		"cmap", "head", "hhea", "hmtx", "maxp", "name", "OS/2", "post", "cvt ", "fpgm", "glyf", "loca", "prep", "CFF ", "VORG",
		"EBDT", "EBLC", "gasp", "hdmx", "kern", "LTSH", "PCLT", "VDMX", "vhea", "vmtx", "BASE", "GDEF", "GPOS", "GSUB", "EBSC",
		"JSTF", "MATH", "CBDT", "CBLC", "COLR", "CPAL", "SVG ", "sbix", "acnt", "avar", "bdat", "bloc", "bsln", "cvar", "fdsc",
		"feat", "fmtx", "fvar", "gvar", "hsty", "just", "lcar", "mort", "morx", "opbd", "prop", "trak", "Zapf", "Silf", "Glat",
		"Gloc", "Feat", "Sill"
	];

	public static function read(source:FontTable):Map<String, FontTable> {
		final flavor = source.u32(4);
		if (flavor != 0x00010000 && flavor != 0x4f54544f && flavor != 0x74727565)
			throw invalid("Expected a single TrueType or OpenType font.");
		final count = source.u16(12);
		final compressedSize = source.u32(20);
		if (source.u32(8) != source.length || count == 0)
			throw invalid("Invalid WOFF2 header.");
		final directory = new Woff2Reader(source, 48);
		final entries:Array<Woff2Entry> = [];
		final seen = new Map<String, Bool>();
		var size = 0;
		var sfntSize = 12 + count * 16;
		for (_ in 0...count) {
			final flags = directory.u8();
			final index = flags & 63;
			final tag = index == 63 ? directory.tag() : tags[index];
			final version = flags >> 6;
			final outline = tag == "glyf" || tag == "loca";
			final transformed = outline ? version == 0 : version != 0;
			if (seen.exists(tag) || (outline && version != 0 && version != 3) || (transformed && !outline && !(tag == "hmtx" && version == 1)))
				throw invalid('Invalid or unsupported transform for "$tag".');
			seen.set(tag, transformed);
			final originalLength = directory.base128();
			final length = transformed ? directory.base128() : originalLength;
			if (length > MAX_BYTES - size || originalLength > MAX_BYTES - sfntSize
				|| (tag == "loca" && transformed && length != 0))
				throw invalid("Invalid WOFF2 table length.");
			size += length;
			sfntSize += (originalLength + 3) & ~3;
			entries.push({tag: tag, originalLength: originalLength, length: length});
		}
		if (size == 0 || seen.get("glyf") != seen.get("loca"))
			throw invalid("Inconsistent WOFF2 table directory.");
		final output = new BrotliOutput(size);
		final compressed = directory.take(compressedSize).toBytes();
		if (Decode.BrotliDecompress(compressed, output) != 1 || output.total != size)
			throw invalid("Invalid WOFF2 Brotli data.");
		final decoded = output.getBytes();
		final tables = new Map<String, FontTable>();
		var offset = 0;
		var locaLength = 0;
		var hmtxLength = 0;
		for (entry in entries) {
			tables.set(entry.tag, new FontTable(decoded, offset, entry.length));
			if (entry.tag == "loca") locaLength = entry.originalLength;
			if (entry.tag == "hmtx") hmtxLength = entry.originalLength;
			offset += entry.length;
		}
		if (seen.get("glyf") == true) rebuildGlyphs(tables, locaLength);
		if (seen.get("hmtx") == true) rebuildMetrics(tables, hmtxLength);
		return tables;
	}

	static function rebuildGlyphs(tables:Map<String, FontTable>, locaLength:Int):Void {
		final data = table(tables, "glyf");
		final flags = data.u16(2);
		final count = data.u16(4);
		final indexFormat = data.u16(6);
		final head = table(tables, "head");
		if (data.u16(0) != 0 || (flags & ~1) != 0 || count != table(tables, "maxp").u16(4) || indexFormat > 1
			|| indexFormat != head.i16(50) || locaLength != (count + 1) * (indexFormat == 0 ? 2 : 4))
			throw invalid("Invalid WOFF2 glyph transform header.");
		final reader = new Woff2Reader(data, 36);
		final streams = [for (i in 0...7) new Woff2Reader(reader.take(data.u32(8 + i * 4)))];
		final contours = streams[0], counts = streams[1], pointFlags = streams[2], glyphs = streams[3];
		final components = streams[4], boxes = streams[5], instructions = streams[6];
		final boundsBitmap = boxes.take(((count + 31) >> 5) * 4);
		final overlap = (flags & 1) != 0 ? reader.take((count + 7) >> 3) : null;
		reader.finish();

		final outlines = output();
		final locations = output();
		for (id in 0...count) {
			locations.writeInt32(outlines.length);
			final contourCount = contours.i16();
			final hasBox = hasBit(boundsBitmap, id);
			if (contourCount == 0) {
				if (hasBox) throw invalid("An empty WOFF2 glyph has a bounding box.");
				continue;
			}
			outlines.writeInt16(contourCount);
			if (contourCount == -1) {
				if (!hasBox) throw invalid("A composite WOFF2 glyph has no bounding box.");
				outlines.write(boxes.take(8).toBytes());
				writeComposite(outlines, components, glyphs, instructions, count);
			} else if (contourCount > 0) {
				final ends = [];
				var points = 0;
				for (_ in 0...contourCount) {
					final length = counts.uint255();
					points += length;
					if (length == 0 || points > 65536) throw invalid("Invalid WOFF2 glyph contour.");
					ends.push(points - 1);
				}
				final coordinates = readPoints(points, pointFlags, glyphs);
				if (hasBox) outlines.write(boxes.take(8).toBytes()); else writeBounds(outlines, coordinates);
				for (end in ends) outlines.writeUInt16(end);
				writeInstructions(outlines, glyphs, instructions);
				for (i in 0...coordinates.length) {
					final flag = coordinates[i].onCurve ? 1 : 0;
					outlines.writeByte(flag | (i == 0 && overlap != null && hasBit(overlap, id) ? 0x40 : 0));
				}
				var last = 0;
				for (point in coordinates) {
					writeDelta(outlines, point.x - last);
					last = point.x;
				}
				last = 0;
				for (point in coordinates) {
					writeDelta(outlines, point.y - last);
					last = point.y;
				}
			} else {
				throw invalid("Invalid WOFF2 contour count.");
			}
			if (outlines.length > MAX_BYTES) throw invalid("Reconstructed WOFF2 glyphs are too large.");
		}
		for (stream in streams) stream.finish();
		locations.writeInt32(outlines.length);
		// The internal glyph representation uses long offsets because the
		// reconstructed point deltas can take more space than the source.
		final header = head.toBytes();
		header.set(50, 0);
		header.set(51, 1);
		tables.set("head", new FontTable(header, 0, header.length));
		tables.set("glyf", asTable(outlines));
		tables.set("loca", asTable(locations));
	}

	static function readPoints(count:Int, flags:Woff2Reader, glyphs:Woff2Reader):Array<GlyphPoint> {
		final points:Array<GlyphPoint> = [];
		var x = 0, y = 0;
		for (_ in 0...count) {
			final raw = flags.u8();
			final flag = raw & 127;
			var dx = 0, dy = 0;
			if (flag < 10) {
				dy = signed(flag, ((flag & 14) << 7) + glyphs.u8());
			} else if (flag < 20) {
				dx = signed(flag, (((flag - 10) & 14) << 7) + glyphs.u8());
			} else if (flag < 84) {
				final kind = flag - 20;
				final packed = glyphs.u8();
				dx = signed(flag, 1 + (kind & 48) + (packed >> 4));
				dy = signed(flag >> 1, 1 + ((kind & 12) << 2) + (packed & 15));
			} else if (flag < 120) {
				final kind = flag - 84;
				dx = signed(flag, 1 + (Std.int(kind / 12) << 8) + glyphs.u8());
				dy = signed(flag >> 1, 1 + (((kind % 12) >> 2) << 8) + glyphs.u8());
			} else if (flag < 124) {
				final a = glyphs.u8(), b = glyphs.u8(), c = glyphs.u8();
				dx = signed(flag, (a << 4) | (b >> 4));
				dy = signed(flag >> 1, ((b & 15) << 8) | c);
			} else {
				dx = signed(flag, glyphs.u16());
				dy = signed(flag >> 1, glyphs.u16());
			}
			x += dx;
			y += dy;
			if (x < -32768 || x > 32767 || y < -32768 || y > 32767)
				throw invalid("WOFF2 glyph coordinate is out of range.");
			points.push({x: x, y: y, onCurve: (raw & 128) == 0});
		}
		return points;
	}

	static function writeComposite(out:BytesOutput, components:Woff2Reader, glyphs:Woff2Reader, instructions:Woff2Reader, glyphCount:Int):Void {
		var flags:Int;
		var hasInstructions = false;
		do {
			flags = components.u16();
			final id = components.u16();
			if (id >= glyphCount) throw invalid("Invalid WOFF2 composite glyph index.");
			out.writeUInt16(flags);
			out.writeUInt16(id);
			final arguments = (flags & 1) != 0 ? 4 : 2;
			final scale = (flags & 8) != 0 ? 2 : (flags & 64) != 0 ? 4 : (flags & 128) != 0 ? 8 : 0;
			out.write(components.take(arguments + scale).toBytes());
			hasInstructions = hasInstructions || (flags & 256) != 0;
		} while ((flags & 32) != 0);
		if (hasInstructions) writeInstructions(out, glyphs, instructions);
	}

	static function rebuildMetrics(tables:Map<String, FontTable>, originalLength:Int):Void {
		final glyphCount = table(tables, "maxp").u16(4);
		final metricCount = table(tables, "hhea").u16(34);
		final metrics = new Woff2Reader(table(tables, "hmtx"));
		final flags = metrics.u8();
		if (flags < 1 || flags > 3 || metricCount == 0 || metricCount > glyphCount || originalLength != (glyphCount + metricCount) * 2)
			throw invalid("Invalid WOFF2 horizontal metrics.");
		final advances = [for (_ in 0...metricCount) metrics.u16()];
		final head = table(tables, "head");
		final locations = table(tables, "loca");
		final glyphs = table(tables, "glyf");
		final format = head.i16(50);
		if (format != 0 && format != 1) throw invalid("Invalid WOFF2 glyph location format.");
		final out = output();
		for (id in 0...glyphCount) {
			final proportional = id < metricCount;
			if (proportional) out.writeUInt16(advances[id]);
			final hasBearing = (flags & (proportional ? 1 : 2)) == 0;
			if (hasBearing) {
				out.writeInt16(metrics.i16());
			} else {
				final start = format == 0 ? locations.u16(id * 2) * 2 : locations.u32(id * 4);
				final end = format == 0 ? locations.u16((id + 1) * 2) * 2 : locations.u32((id + 1) * 4);
				out.writeInt16(start == end ? 0 : glyphs.slice(start, end - start).i16(2));
			}
		}
		metrics.finish();
		tables.set("hmtx", asTable(out));
	}

	static function writeBounds(out:BytesOutput, points:Array<GlyphPoint>):Void {
		var minX = points[0].x, maxX = minX, minY = points[0].y, maxY = minY;
		for (point in points) {
			if (point.x < minX) minX = point.x;
			if (point.x > maxX) maxX = point.x;
			if (point.y < minY) minY = point.y;
			if (point.y > maxY) maxY = point.y;
		}
		for (value in [minX, minY, maxX, maxY]) out.writeInt16(value);
	}

	static inline function writeDelta(out:BytesOutput, delta:Int):Void {
		if (delta < -32768 || delta > 32767) throw invalid("WOFF2 glyph delta is out of range.");
		out.writeInt16(delta);
	}

	static function writeInstructions(out:BytesOutput, glyphs:Woff2Reader, instructions:Woff2Reader):Void {
		final size = glyphs.uint255();
		out.writeUInt16(size);
		out.write(instructions.take(size).toBytes());
	}

	static inline function signed(flag:Int, value:Int):Int {
		return (flag & 1) != 0 ? value : -value;
	}

	static inline function hasBit(bitmap:FontTable, index:Int):Bool {
		return (bitmap.u8(index >> 3) & (128 >> (index & 7))) != 0;
	}

	static function output():BytesOutput {
		final out = new BytesOutput();
		out.bigEndian = true;
		return out;
	}

	static function asTable(out:BytesOutput):FontTable {
		final bytes = out.getBytes();
		return new FontTable(bytes, 0, bytes.length);
	}

	static function table(tables:Map<String, FontTable>, tag:String):FontTable {
		final result = tables.get(tag);
		if (result == null) throw invalid('Missing "$tag" table.');
		return result;
	}

	static inline function invalid(message:String):FontLoadingError {
		return new FontLoadingError("WOFF2", message);
	}
}

private class Woff2Reader {
	final data:FontTable;
	var position:Int;

	public function new(data:FontTable, position:Int = 0) {
		this.data = data;
		this.position = position;
	}

	public function u8():Int {
		return data.u8(position++);
	}

	public function u16():Int {
		final value = data.u16(position);
		position += 2;
		return value;
	}

	public function i16():Int {
		final value = data.i16(position);
		position += 2;
		return value;
	}

	public function tag():String {
		final value = data.tag(position);
		position += 4;
		return value;
	}

	public function take(length:Int):FontTable {
		final result = data.slice(position, length);
		position += length;
		return result;
	}

	public function uint255():Int {
		return switch u8() {
			case 253: u16();
			case 254: 506 + u8();
			case 255: 253 + u8();
			case value: value;
		}
	}

	public function base128():Int {
		var value = 0;
		for (i in 0...5) {
			final byte = u8();
			if ((i == 0 && byte == 128) || value > 0xffffff)
				throw new FontLoadingError("WOFF2", "Invalid table size encoding.");
			value = (value << 7) | (byte & 127);
			if ((byte & 128) == 0) return value;
		}
		throw new FontLoadingError("WOFF2", "Invalid table size encoding.");
	}

	public function finish():Void {
		if (position != data.length) throw new FontLoadingError("WOFF2", "Unexpected data at the end of a glyph stream.");
	}
}
