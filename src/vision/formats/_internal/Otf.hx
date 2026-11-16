package vision.formats._internal;

import vision.formats._internal.fonts.FontData;
import vision.formats._internal.fonts.FontTable;
import vision.formats._internal.fonts.Sfnt;

/** Reads a CFF-flavored OpenType font. TrueType-flavored files use Ttf. **/
@:noCompletion
class Otf {
	public static function read(source:FontTable, family:String):FontData {
		return new FontData(Sfnt.read(source, family), family);
	}
}
