package vision.formats._internal.fonts;

import vision.exceptions.FontLoadingError;

/** Reads the table directory shared by TrueType and OpenType font files. **/
@:noCompletion
class Sfnt {
	public static function read(source:FontTable, family:String):Map<String, FontTable> {
		final count = source.u16(4);
		final tables = new Map<String, FontTable>();
		var total = 0;
		for (i in 0...count) {
			final entry = 12 + i * 16;
			final tag = source.tag(entry);
			final length = source.u32(entry + 12);
			if (tables.exists(tag) || length > 64 * 1024 * 1024 - total)
				throw new FontLoadingError(family, "Invalid font table directory.");
			total += length;
			tables.set(tag, source.slice(source.u32(entry + 8), length));
		}
		return tables;
	}
}
