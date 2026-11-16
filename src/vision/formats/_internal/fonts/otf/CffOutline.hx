package vision.formats._internal.fonts.otf;

import vision.formats._internal.fonts.FontTable;

import haxe.ds.IntMap;
import vision.formats._internal.fonts.FontData.FontPoint;
import vision.exceptions.FontLoadingError;

private typedef CffIndex = {
	final entries:Array<FontTable>;
	final end:Int;
}

/** Reads CFF Type 2 and default-instance CFF2 charstrings. **/
@:noCompletion
class CffOutline {
	final family:String;
	final charStrings:Array<FontTable>;
	final global:Array<FontTable>;
	final local:Array<Array<FontTable>>;
	final selection:Array<Int>;
	final cff2:Bool;
	final regions:Array<Array<Bool>>;
	final variationIndices:Array<Int>;

	public function new(data:FontTable, family:String, glyphCount:Int) {
		this.family = family;
		final version = data.u8(0);
		cff2 = version == 2;
		final header = data.u8(2);
		var dict:IntMap<Array<Float>>;
		if (cff2) {
			if (data.u8(1) != 0 || header < 5) throw invalid("Invalid CFF2 header.");
			final length = data.u16(3);
			dict = dictionary(data.slice(header, length));
			global = index(data, header + length).entries;
		} else {
			if (version != 1) throw invalid("Unsupported CFF version.");
			final names = index(data, header);
			final top = index(data, names.end);
			if (top.entries.length != 1) throw invalid("Expected one CFF font.");
			final strings = index(data, top.end);
			global = index(data, strings.end).entries;
			dict = dictionary(top.entries[0]);
		}
		final variation = cff2 ? dict.get(24) : null;
		regions = variation == null ? [] : readRegions(data, Std.int(variation[0]));
		variationIndices = [];
		final location = dict.get(17);
		if (location == null) throw invalid("Missing CFF charstrings.");
		charStrings = index(data, Std.int(location[0])).entries;
		if (charStrings.length != glyphCount) throw invalid("CFF glyph count does not match maxp.");
		final fdArray = dict.get(1236);
		final fdSelect = dict.get(1237);
		if (!cff2 && fdArray == null && fdSelect == null) {
			local = [subroutines(data, dict)];
			selection = [];
		} else {
			if (fdArray == null) throw invalid("Incomplete CFF font dictionary selection.");
			local = [for (entry in index(data, Std.int(fdArray[0])).entries) subroutines(data, dictionary(entry))];
			selection = [];
			if (fdSelect == null) {
				if (!cff2 || local.length != 1) throw invalid("Missing CFF font dictionary selection.");
				return;
			}
			final offset = Std.int(fdSelect[0]);
			switch data.u8(offset) {
				case 0:
					for (i in 0...glyphCount) selection.push(data.u8(offset + 1 + i));
				case 3, 4:
					final wide = data.u8(offset) == 4;
					if (wide && !cff2) throw invalid("Invalid CFF1 font dictionary format.");
					final count = wide ? data.u32(offset + 1) : data.u16(offset + 1);
					if (count > glyphCount) throw invalid("Too many CFF dictionary ranges.");
					final stride = wide ? 6 : 3;
					for (i in 0...count) {
						final row = offset + (wide ? 5 : 3) + i * stride;
						final first = wide ? data.u32(row) : data.u16(row);
						final end = wide ? data.u32(row + stride) : data.u16(row + stride);
						if (first != selection.length || end < first || end > glyphCount)
							throw invalid("Invalid CFF font dictionary range.");
						final fd = wide ? data.u16(row + 4) : data.u8(row + 2);
						for (_ in first...end) selection.push(fd);
					}
				default: throw invalid("Unsupported CFF font dictionary selection.");
			}
			if (selection.length != glyphCount) throw invalid("Incomplete CFF font dictionary ranges.");
			for (fd in selection) if (fd >= local.length) throw invalid("Invalid CFF font dictionary index.");
		}
	}

	public function outline(id:Int):Array<Array<FontPoint>> {
		final fd = selection.length == 0 ? 0 : selection[id];
		final reader = new CharString(family, global, local[fd], cff2, regions, variationIndices[fd]);
		reader.read(charStrings[id], 0);
		return reader.contours;
	}

	function subroutines(data:FontTable, dict:IntMap<Array<Float>>):Array<FontTable> {
		final field = dict.get(18);
		if (field == null) {
			variationIndices.push(0);
			return [];
		}
		final offset = Std.int(field[1]);
		final priv = dictionary(data.slice(offset, Std.int(field[0])), cff2);
		final variation = cff2 ? priv.get(22) : null;
		variationIndices.push(variation == null ? 0 : Std.int(variation[0]));
		final subrs = priv.get(19);
		return subrs == null ? [] : index(data, offset + Std.int(subrs[0])).entries;
	}

	function index(data:FontTable, start:Int):CffIndex {
		final countSize = cff2 ? 4 : 2;
		final count = cff2 ? data.u32(start) : data.u16(start);
		if (count == 0) return {entries: [], end: start + countSize};
		final size = data.u8(start + countSize);
		if (size < 1 || size > 4) throw invalid("Invalid CFF index offset size.");
		final offsets = start + countSize + 1;
		if (count >= Std.int((data.length - offsets) / size)) throw invalid("Truncated CFF index.");
		final base = offsets + (count + 1) * size - 1;
		final entries = [];
		var last = 1;
		for (i in 0...count + 1) {
			var value = 0;
			for (j in 0...size) {
				if (value > 0x7fffff) throw invalid("CFF index offset is too large.");
				value = value * 256 + data.u8(offsets + i * size + j);
			}
			if ((i == 0 && value != 1) || value < last || value > data.length - base) throw invalid("Invalid CFF index offset.");
			if (i > 0) entries.push(data.slice(base + last, value - last));
			last = value;
		}
		return {entries: entries, end: base + last};
	}

	function dictionary(data:FontTable, privateDict:Bool = false):IntMap<Array<Float>> {
		final dict = new IntMap<Array<Float>>();
		var values:Array<Float> = [];
		var variation = 0;
		var pos = 0;
		while (pos < data.length) {
			final op = data.u8(pos++);
			if (op == 28) {
				values.push(data.i16(pos));
				pos += 2;
			} else if (op == 29) {
				values.push(data.i16(pos) * 65536.0 + data.u16(pos + 2));
				pos += 4;
			} else if (op == 30) {
				// Real-valued dictionary entries (e.g. FontMatrix) do not encode offsets.
				var done = false;
				while (!done) {
					final packed = data.u8(pos++);
					done = (packed >> 4) == 15 || (packed & 15) == 15;
				}
				values.push(0);
			} else if (op >= 32) {
				if (op <= 246) values.push(op - 139);
				else if (op <= 250) values.push((op - 247) * 256 + data.u8(pos++) + 108);
				else if (op <= 254) values.push(-(op - 251) * 256 - data.u8(pos++) - 108);
				else throw invalid("Invalid CFF dictionary operand.");
			} else {
				final key = op == 12 ? 1200 + data.u8(pos++) : op;
				if (privateDict && key == 23) {
					applyBlend(values, regions, variation, family);
					continue;
				}
				if (privateDict && key == 22) {
					if (values.length != 1) throw invalid("Invalid CFF2 variation index.");
					variation = Std.int(values[0]);
				}
				dict.set(key, values);
				values = [];
			}
		}
		return dict;
	}

	function readRegions(data:FontTable, offset:Int):Array<Array<Bool>> {
		final size = data.u16(offset);
		final store = data.slice(offset + 2, size == 65535 ? data.length - offset - 2 : size);
		if (store.u16(0) != 1) throw invalid("Invalid CFF2 variation store format.");
		final list = store.u32(2);
		final axes = store.u16(list);
		final count = store.u16(list + 2);
		if (axes == 0 || count > Std.int((store.length - list - 4) / (axes * 6))) throw invalid("Invalid CFF2 variation regions.");
		final active = [for (region in 0...count) {
			var neutral = true;
			for (axis in 0...axes) {
				final axisRecord = list + 4 + (region * axes + axis) * 6;
				final start = store.i16(axisRecord);
				final peak = store.i16(axisRecord + 2);
				final end = store.i16(axisRecord + 4);
				if (start > peak || peak > end || (start < 0 && end > 0 && peak != 0))
					throw invalid("Invalid CFF2 variation axis range.");
				if (peak != 0) neutral = false;
			}
			neutral;
		}];
		return [for (i in 0...store.u16(6)) {
			final entry = store.u32(8 + i * 4);
			if (store.u16(entry) != 0 || store.u16(entry + 2) != 0) throw invalid("Invalid CFF2 variation data.");
			[for (j in 0...store.u16(entry + 4)) {
				final region = store.u16(entry + 6 + j * 2);
				if (region >= active.length) throw invalid("Invalid CFF2 variation region index.");
				active[region];
			}];
		}];
	}

	@:allow(vision.formats._internal.fonts.otf.CharString)
	static function applyBlend(stack:Array<Float>, regions:Array<Array<Bool>>, index:Int, family:String):Void {
		if (index < 0 || index >= regions.length || stack.length == 0) throw new FontLoadingError(family, "Invalid CFF2 blend.");
		final operand = stack.pop();
		final count = Std.int(operand);
		final active = regions[index];
		if (count <= 0 || count != operand || count > Std.int(stack.length / (1 + active.length)))
			throw new FontLoadingError(family, "Invalid CFF2 blend operand count.");
		final start = stack.length - count * (1 + active.length);
		for (i in 0...count)
			for (j in 0...active.length)
				if (active[j]) stack[start + i] += stack[start + count + i * active.length + j];
		stack.resize(start + count);
	}

	inline function invalid(reason:String):FontLoadingError {
		return new FontLoadingError(family, reason);
	}
}

private class CharString {
	public final contours:Array<Array<FontPoint>> = [];
	final family:String;
	final global:Array<FontTable>;
	final local:Array<FontTable>;
	final cff2:Bool;
	final regions:Array<Array<Bool>>;
	var variation:Int;
	var stack:Array<Float> = [];
	var contour:Array<FontPoint> = null;
	var x = 0.0;
	var y = 0.0;
	var hints = 0;
	var steps = 0;
	var pointCount = 0;
	var ended = false;

	public function new(family:String, global:Array<FontTable>, local:Array<FontTable>, cff2:Bool, regions:Array<Array<Bool>>, variation:Int) {
		this.family = family;
		this.global = global;
		this.local = local;
		this.cff2 = cff2;
		this.regions = regions;
		this.variation = variation;
	}

	public function read(data:FontTable, depth:Int):Void {
		if (depth > 16) throw invalid("CFF subroutine nesting is too deep.");
		var pos = 0;
		while (pos < data.length) {
			if (++steps > 100000) throw invalid("CFF glyph exceeds its instruction budget.");
			final op = data.u8(pos++);
			if (op == 28 || op >= 32) {
				if (stack.length >= (cff2 ? 513 : 48)) throw invalid("CFF operand stack is full.");
				if (op == 28) {
					stack.push(data.i16(pos));
					pos += 2;
				} else if (op <= 246) stack.push(op - 139);
				else if (op <= 250) stack.push((op - 247) * 256 + data.u8(pos++) + 108);
				else if (op <= 254) stack.push(-(op - 251) * 256 - data.u8(pos++) - 108);
				else {
					stack.push(data.i16(pos) + data.u16(pos + 2) / 65536);
					pos += 4;
				}
				continue;
			}
			if (op == 10 || op == 29) {
				final subrs = op == 10 ? local : global;
				final bias = subrs.length < 1240 ? 107 : subrs.length < 33900 ? 1131 : 32768;
				if (stack.length == 0) throw invalid("Missing CFF subroutine operand.");
				final index = Std.int(stack.pop()) + bias;
				if (index < 0 || index >= subrs.length) throw invalid("Invalid CFF subroutine index.");
				read(subrs[index], depth + 1);
				if (ended) return;
				continue;
			}
			if (cff2 && op == 15) {
				if (stack.length != 1) throw invalid("Invalid CFF2 variation index.");
				variation = Std.int(stack.pop());
				if (variation < 0 || variation >= regions.length) throw invalid("Unknown CFF2 variation index.");
				continue;
			}
			if (cff2 && op == 16) {
				CffOutline.applyBlend(stack, regions, variation, family);
				continue;
			}
			final values = stack;
			stack = [];
			final n = values.length;
			switch op {
				case 1, 3, 18, 23: hints += n >> 1;
				case 19, 20:
					hints += n >> 1;
					pos += (hints + 7) >> 3;
					data.slice(pos, 0);
				case 4: require(n, 1); move(0, values[n - 1]);
				case 21: require(n, 2); move(values[n - 2], values[n - 1]);
				case 22: require(n, 1); move(values[n - 1], 0);
				case 5:
					require(n, 2, 2);
					for (i in 0...(n >> 1)) line(values[i * 2], values[i * 2 + 1]);
				case 6, 7:
					var horizontal = op == 6;
					for (value in values) {
						line(horizontal ? value : 0, horizontal ? 0 : value);
						horizontal = !horizontal;
					}
				case 8:
					require(n, 6, 6);
					for (i in 0...Std.int(n / 6)) curveAt(values, i * 6);
				case 24:
					require(n - 2, 6, 6);
					for (i in 0...Std.int((n - 2) / 6)) curveAt(values, i * 6);
					line(values[n - 2], values[n - 1]);
				case 25:
					require(n - 6, 2, 2);
					for (i in 0...((n - 6) >> 1)) line(values[i * 2], values[i * 2 + 1]);
					curveAt(values, n - 6);
				case 26, 27:
					final vertical = op == 26;
					var i = n & 1;
					require(n - i, 4, 4);
					var first = i == 1 ? values[0] : 0;
					while (i < n) {
						if (vertical) curve(first, values[i], values[i + 1], values[i + 2], 0, values[i + 3]);
						else curve(values[i], first, values[i + 1], values[i + 2], values[i + 3], 0);
						first = 0;
						i += 4;
					}
				case 30, 31:
					final extra = n & 1;
					require(n - extra, 4, 4);
					var horizontal = op == 31;
					var i = 0;
					while (i < n - extra) {
						final last = i + 4 == n - extra && extra == 1 ? values[n - 1] : 0;
						if (horizontal) curve(values[i], 0, values[i + 1], values[i + 2], last, values[i + 3]);
						else curve(0, values[i], values[i + 1], values[i + 2], values[i + 3], last);
						horizontal = !horizontal;
						i += 4;
					}
				case 12:
					final command = data.u8(pos++);
					switch command {
						case 34:
							require(n, 7);
							curve(values[0], 0, values[1], values[2], values[3], 0);
							curve(values[4], 0, values[5], -values[2], values[6], 0);
						case 35:
							require(n, 13);
							curveAt(values, 0);
							curveAt(values, 6);
						case 36:
							require(n, 9);
							curve(values[0], values[1], values[2], values[3], values[4], 0);
							curve(values[5], 0, values[6], values[7], values[8], -(values[1] + values[3] + values[7]));
						case 37:
							require(n, 11);
							curveAt(values, 0);
							final dx = values[0] + values[2] + values[4] + values[6] + values[8];
							final dy = values[1] + values[3] + values[5] + values[7] + values[9];
							final horizontal = Math.abs(dx) > Math.abs(dy);
							curve(values[6], values[7], values[8], values[9], horizontal ? values[10] : -dx, horizontal ? -dy : values[10]);
						default: throw invalid('Unsupported CFF escape operator $command.');
					}
				case 11:
					stack = values;
					return;
				case 14:
					ended = true;
					return;
				default: throw invalid('Unsupported CFF operator $op.');
			}
		}
	}

	inline function require(count:Int, minimum:Int, multiple:Int = 1):Void {
		if (count < minimum || count % multiple != 0) throw invalid("Invalid CFF operand count.");
	}

	function move(dx:Float, dy:Float):Void {
		contour = [];
		contours.push(contour);
		line(dx, dy);
	}

	function line(dx:Float, dy:Float):Void {
		x += dx;
		y += dy;
		point(x, y);
	}

	inline function curveAt(values:Array<Float>, i:Int):Void {
		curve(values[i], values[i + 1], values[i + 2], values[i + 3], values[i + 4], values[i + 5]);
	}

	function curve(dx1:Float, dy1:Float, dx2:Float, dy2:Float, dx3:Float, dy3:Float):Void {
		final ax = x + dx1, ay = y + dy1;
		final bx = ax + dx2, by = ay + dy2;
		final cx = bx + dx3, cy = by + dy3;
		final bend = Math.abs(dx1 - dx2) + Math.abs(dy1 - dy2) + Math.abs(dx2 - dx3) + Math.abs(dy2 - dy3);
		final count = Std.int(Math.min(64, Math.max(4, Math.ceil(Math.sqrt(bend)))));
		for (i in 1...count + 1) {
			final t = i / count;
			final u = 1 - t;
			point(u * u * u * x + 3 * u * u * t * ax + 3 * u * t * t * bx + t * t * t * cx,
				u * u * u * y + 3 * u * u * t * ay + 3 * u * t * t * by + t * t * t * cy);
		}
		x = cx;
		y = cy;
	}

	function point(x:Float, y:Float):Void {
		if (contour == null || ++pointCount > 65536) throw invalid("Invalid CFF contour.");
		contour.push({x: x, y: y, onCurve: true});
	}

	inline function invalid(reason:String):FontLoadingError {
		return new FontLoadingError(family, reason);
	}
}
