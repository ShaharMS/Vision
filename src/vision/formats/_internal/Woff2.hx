package vision.formats._internal;

import vision.formats._internal.fonts.FontData;
import vision.formats._internal.fonts.FontTable;
import vision.formats._internal.fonts.woff2.Woff2Decoder;

/** Reads the font tables in a WOFF 2 container. **/
@:noCompletion
class Woff2 {
	public static function read(source:FontTable, family:String):FontData {
		return new FontData(Woff2Decoder.read(source), family);
	}
}
