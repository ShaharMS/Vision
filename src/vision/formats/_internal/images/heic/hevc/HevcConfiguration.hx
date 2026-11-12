package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcNalReader.HevcNal;

/** Decoder initialization data carried by a HEIF hvcC property. **/
@:noCompletion
class HevcConfiguration {
	public final lengthSize:Int;
	public final units:Array<HevcNal>;

	/** Reads a decoder configuration record without its enclosing box header. **/
	public function new(bytes:Bytes) {
		if (bytes.length < 23 || bytes.get(0) != 1)
			throw new HevcBitstreamError("Invalid HEVC decoder configuration record.");
		lengthSize = (bytes.get(21) & 3) + 1;
		if (lengthSize == 3) throw new HevcBitstreamError("Invalid HEVC NAL length size.");
		units = [];
		var position = 23;
		for (_ in 0...bytes.get(22)) {
			if (bytes.length - position < 3)
				throw new HevcBitstreamError("Truncated HEVC configuration array.");
			final header = bytes.get(position++);
			if ((header & 64) != 0) throw new HevcBitstreamError("Invalid HEVC configuration array header.");
			final count = (bytes.get(position) << 8) | bytes.get(position + 1);
			position += 2;
			for (_ in 0...count) {
				if (bytes.length - position < 2)
					throw new HevcBitstreamError("Truncated HEVC configuration unit length.");
				final size = (bytes.get(position) << 8) | bytes.get(position + 1);
				if (size > bytes.length - position - 2)
					throw new HevcBitstreamError("Truncated HEVC configuration unit.");
				final unit = new HevcNalReader(bytes, position, size + 2, 2).next();
				if (unit.type != (header & 63))
					throw new HevcBitstreamError("HEVC configuration array and unit types differ.");
				units.push(unit);
				position += size + 2;
			}
		}
		if (position != bytes.length) throw new HevcBitstreamError("Unexpected bytes after HEVC configuration arrays.");
	}
}
