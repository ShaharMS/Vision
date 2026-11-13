package vision.formats._internal.fonts;

@:noCompletion
class OpenTypeLookups {
	public final table:FontTable;
	final list:Int;
	final features = new Map<String, Array<Int>>();
	final glyphClasses:Null<FontTable>;

	public function new(table:FontTable, gdef:Null<FontTable>, scriptTag:String) {
		this.table = table;
		final classOffset = gdef == null ? 0 : gdef.u16(4);
		glyphClasses = classOffset == 0 ? null : gdef.slice(classOffset, gdef.length - classOffset);
		final scripts = table.u16(4);
		final featureList = table.u16(6);
		list = table.u16(8);
		var script = 0;
		for (i in 0...table.u16(scripts)) {
			final record = scripts + 2 + i * 6;
			final tag = table.tag(record);
			if (tag == scriptTag || (tag == "DFLT" && script == 0)) script = scripts + table.u16(record + 4);
		}
		if (script == 0 || table.u16(script) == 0) return;
		final language = script + table.u16(script);
		final required = table.u16(language + 2);
		final indices = [for (i in 0...table.u16(language + 4)) table.u16(language + 6 + i * 2)];
		if (required != 0xffff) indices.push(required);
		for (index in indices) {
			if (index >= table.u16(featureList)) continue;
			final record = featureList + 2 + index * 6;
			final tag = table.tag(record);
			final feature = featureList + table.u16(record + 4);
			var lookups = features.get(tag);
			if (lookups == null) features.set(tag, lookups = []);
			for (i in 0...table.u16(feature + 2)) {
				final id = table.u16(feature + 4 + i * 2);
				if (id < table.u16(list) && !lookups.contains(id)) lookups.push(id);
			}
			lookups.sort((a, b) -> a - b);
		}
	}

	public function feature(tag:String):Array<Int> {
		final found = features.get(tag);
		return found == null ? [] : found;
	}

	public function lookup(id:Int):Int return id >= table.u16(list) ? 0 : list + table.u16(list + 2 + id * 2);

	public function glyphClass(glyph:Int):Int {
		return glyphClasses == null ? 0 : readClass(glyphClasses, 0, glyph);
	}

	public function classAt(offset:Int, glyph:Int):Int return readClass(table, offset, glyph);

	static function readClass(data:FontTable, offset:Int, glyph:Int):Int {
		if (glyph < 0) return 0;
		switch data.u16(offset) {
			case 1:
				final index = glyph - data.u16(offset + 2);
				if (index >= 0 && index < data.u16(offset + 4)) return data.u16(offset + 6 + index * 2);
			case 2:
				for (i in 0...data.u16(offset + 2)) {
					final row = offset + 4 + i * 6;
					if (glyph < data.u16(row)) break;
					if (glyph <= data.u16(row + 2)) return data.u16(row + 4);
				}
			default:
		}
		return 0;
	}

	public function ignored(glyph:Int, flags:Int):Bool {
		final category = glyphClass(glyph);
		return glyph == -1 || (category >= 1 && category <= 3 && (flags & (1 << category)) != 0);
	}

	public function coverage(offset:Int, glyph:Int):Int {
		switch table.u16(offset) {
			case 1:
				var lo = 0;
				var hi = table.u16(offset + 2);
				while (lo < hi) {
					final mid = (lo + hi) >> 1;
					final value = table.u16(offset + 4 + mid * 2);
					if (value == glyph) return mid;
					if (value < glyph) lo = mid + 1;
					else hi = mid;
				}
			case 2:
				var lo = 0;
				var hi = table.u16(offset + 2);
				while (lo < hi) {
					final mid = (lo + hi) >> 1;
					final row = offset + 4 + mid * 6;
					final first = table.u16(row);
					if (glyph < first) hi = mid;
					else if (glyph > table.u16(row + 2)) lo = mid + 1;
					else return table.u16(row + 4) + glyph - first;
				}
			default:
		}
		return -1;
	}

	/** Matches the coverage arrays of a format 3 chained context subtable. **/
	public function context(sub:Int, glyphs:Array<Int>, index:Int, flags:Int, next:(Int, Int, Int)->Int):Null<{inputs:Array<Int>, records:Int}> {
		var offset = sub + 2;
		var position = index;
		final backtrack = table.u16(offset);
		offset += 2;
		for (_ in 0...backtrack) {
			position = next(position, -1, flags);
			if (position < 0 || coverage(sub + table.u16(offset), glyphs[position]) < 0) return null;
			offset += 2;
		}
		final inputCount = table.u16(offset);
		offset += 2;
		position = index;
		final inputs = [];
		for (i in 0...inputCount) {
			if (i != 0) position = next(position, 1, flags);
			if (position < 0 || coverage(sub + table.u16(offset), glyphs[position]) < 0) return null;
			inputs.push(position);
			offset += 2;
		}
		final lookahead = table.u16(offset);
		offset += 2;
		for (_ in 0...lookahead) {
			position = next(position, 1, flags);
			if (position < 0 || coverage(sub + table.u16(offset), glyphs[position]) < 0) return null;
			offset += 2;
		}
		return {inputs: inputs, records: offset};
	}
}
