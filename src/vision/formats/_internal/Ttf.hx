package vision.formats._internal;

import vision.exceptions.FontLoadingError;
import vision.formats._internal.fonts.FontData;
import vision.formats._internal.fonts.FontTable;
import vision.formats._internal.fonts.Sfnt;

/** Reads a font stored in a TrueType SFNT container. **/
@:noCompletion
class Ttf {
	public static function read(source:FontTable, family:String):FontData {
		final tables = Sfnt.read(source, family);
		if (!tables.exists("glyf")) throw new FontLoadingError(family, "Missing TrueType glyph outlines.");
		return new FontData(tables, family);
	}
}
