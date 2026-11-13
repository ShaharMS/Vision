package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import vision.exceptions.HevcBitstreamError;

/** An HEVC NAL header and its raw byte sequence payload. **/
typedef HevcNal = {
	final type:Int;
	final layerId:Int;
	final temporalId:Int;
	final rbsp:Bytes;
	final escaped:Bytes;
}

/** Reads length-prefixed HEVC NAL units as stored in a HEIF image item. **/
@:noCompletion
class HevcNalReader {
	final bytes:Bytes;
	final lengthSize:Int;
	var position:Int;
	final end:Int;

	/**
		@param bytes The bytes containing the image item
		@param offset Start of the item
		@param length Length of the item in bytes
		@param lengthSize Width of the NAL length field from the HEVC configuration record
	**/
	public function new(bytes:Bytes, offset:Int, length:Int, lengthSize:Int) {
		if (offset < 0 || length < 0 || offset > bytes.length - length || (lengthSize != 1 && lengthSize != 2 && lengthSize != 4))
			throw new HevcBitstreamError("Invalid NAL item range or length field.");
		this.bytes = bytes;
		this.lengthSize = lengthSize;
		position = offset;
		end = offset + length;
	}

	/** Reads one NAL unit and removes its emulation-prevention bytes. **/
	public function next():Null<HevcNal> {
		if (position == end) return null;
		if (lengthSize > end - position) throw new HevcBitstreamError("Truncated NAL length field.");
		var length = 0.0;
		for (_ in 0...lengthSize) length = length * 256 + bytes.get(position++);
		if (length < 2 || length > end - position) throw new HevcBitstreamError("Truncated or invalid NAL unit.");
		final limit = position + Std.int(length);
		final first = bytes.get(position++);
		final second = bytes.get(position++);
		final temporal = second & 7;
		if ((first & 128) != 0 || temporal == 0) throw new HevcBitstreamError("Invalid NAL header.");

		final payload = new BytesBuffer();
		final start = position;
		var zeroes = 0;
		while (position < limit) {
			final value = bytes.get(position++);
			if (zeroes == 2 && value <= 3) {
				if (value != 3 || position == limit || bytes.get(position) > 3)
					throw new HevcBitstreamError("Invalid NAL emulation-prevention sequence.");
				zeroes = 0;
				continue;
			}
			payload.addByte(value);
			zeroes = value == 0 ? zeroes + 1 : 0;
		}
		return {
			type: (first >>> 1) & 63,
			layerId: ((first & 1) << 5) | (second >>> 3),
			temporalId: temporal - 1,
			rbsp: payload.getBytes(),
			escaped: bytes.sub(start, limit - start)
		};
	}
}
