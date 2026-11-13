package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.exceptions.HevcBitstreamError;
/** Bounded reader for raw HEVC RBSP syntax. **/
@:noCompletion
class HevcRawBits {
	final bytes:Bytes;
	var byte = 0;
	var shift = 7;

	public function new(bytes:Bytes) this.bytes = bytes;

	public function read(count:Int):Int {
		var value = 0;
		for (_ in 0...count) {
			if (byte == bytes.length) throw new HevcBitstreamError("Truncated HEVC header.");
			value = (value << 1) | ((bytes.get(byte) >>> shift) & 1);
			if (shift == 0) {
				byte++;
				shift = 7;
			} else shift--;
		}
		return value;
	}

	public inline function flag():Bool return read(1) != 0;

	public function ue(maximum:Int):Int {
		var zeroes = 0;
		while (!flag()) {
			if (++zeroes > 30) throw new HevcBitstreamError("Invalid HEVC header value.");
		}
		final value = (1 << zeroes) - 1 + read(zeroes);
		if (value > maximum) throw new HevcBitstreamError("Invalid HEVC header value.");
		return value;
	}

	public function se(magnitude:Int):Int {
		final code = ue(magnitude * 2);
		return (code & 1) != 0 ? (code + 1) >> 1 : -(code >> 1);
	}

	public function align():Int {
		if (!flag()) throw new HevcBitstreamError("Missing HEVC header alignment bit.");
		while (shift != 7) if (flag()) throw new HevcBitstreamError("Invalid HEVC header padding.");
		return byte;
	}
}
