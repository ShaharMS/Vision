package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** A bounded open bitstream unit from the AV1 low-overhead stream. **/
typedef Av1Obu = {
	final type:Int;
	final temporalId:Int;
	final spatialId:Int;
	final offset:Int;
	final length:Int;
}

/** Reads byte-aligned AV1 OBU headers and payload ranges. **/
@:noCompletion
class Av1ObuReader {
	final bytes:Bytes;
	var position:Int;
	final end:Int;

	public function new(bytes:Bytes, offset:Int, length:Int) {
		if (offset < 0 || length < 0 || offset > bytes.length - length)
			throw new Av1BitstreamError("Invalid OBU byte range.");
		this.bytes = bytes;
		position = offset;
		end = offset + length;
	}

	/** Returns the next unit and advances past its payload. **/
	public function next():Null<Av1Obu> {
		if (position == end) return null;
		final header = byte();
		if ((header & 0x83) != 2) throw new Av1BitstreamError("Invalid low-overhead OBU header.");
		var temporalId = 0;
		var spatialId = 0;
		if ((header & 4) != 0) {
			final extension = byte();
			if ((extension & 7) != 0) throw new Av1BitstreamError("Invalid OBU extension.");
			temporalId = extension >>> 5;
			spatialId = (extension >>> 3) & 3;
		}
		final size = length();
		if (size > end - position) throw new Av1BitstreamError("Truncated OBU payload.");
		final result:Av1Obu = {
			type: (header >>> 3) & 15, temporalId: temporalId, spatialId: spatialId, offset: position, length: size
		};
		position += size;
		return result;
	}

	function length():Int {
		var result = 0;
		for (i in 0...8) {
			final part = byte();
			final data = part & 127;
			if ((i == 4 && data > 7) || (i > 4 && data != 0))
				throw new Av1BitstreamError("OBU size exceeds the supported byte range.");
			if (i <= 4) result |= data << (i * 7);
			if ((part & 128) == 0) return result;
		}
		throw new Av1BitstreamError("Unterminated OBU size.");
	}

	inline function byte():Int {
		if (position >= end) throw new Av1BitstreamError("Truncated OBU header.");
		return bytes.get(position++);
	}
}
