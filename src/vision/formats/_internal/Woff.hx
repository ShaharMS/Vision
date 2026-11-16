package vision.formats._internal;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.InflateImpl;
import vision.exceptions.FontLoadingError;
import vision.formats._internal.fonts.FontData;
import vision.formats._internal.fonts.FontTable;

/** Reads the font tables in a WOFF 1 container. **/
@:noCompletion
class Woff {
	public static function read(source:FontTable, family:String):FontData {
		final flavor = source.u32(4);
		if (flavor != 0x00010000 && flavor != 0x74727565 && flavor != 0x4f54544f)
			throw new FontLoadingError(family, "Unknown WOFF font flavor.");
		final count = source.u16(12);
		final tables = new Map<String, FontTable>();
		var total = 0;
		for (i in 0...count) {
			final entry = 44 + i * 20;
			final tag = source.tag(entry);
			final stored = source.u32(entry + 8);
			final length = source.u32(entry + 12);
			if (tables.exists(tag) || stored > length || length > 64 * 1024 * 1024 - total)
				throw new FontLoadingError(family, "Invalid WOFF table directory.");
			total += length;
			final block = source.slice(source.u32(entry + 4), stored);
			if (stored == length) {
				tables.set(tag, block);
			} else {
				final data = Bytes.alloc(length);
				final inflate = new InflateImpl(new BytesInput(block.toBytes()));
				if (inflate.readBytes(data, 0, length) != length || inflate.readBytes(Bytes.alloc(1), 0, 1) != 0)
					throw new FontLoadingError(family, "Invalid compressed WOFF table.");
				tables.set(tag, new FontTable(data, 0, length));
			}
		}
		return new FontData(tables, family);
	}
}
