package vision.formats._internal.images.webp;

// Adapted from golang.org/x/image/vp8, copyright The Go Authors. See VP8-LICENSE.

import vision.ds.ByteArray;

/** Boolean arithmetic decoder for a bounded VP8 partition. **/
@:noCompletion
class Vp8Partition {
	final bytes:ByteArray;
	final end:Int;
	var position:Int;
	var range = 254;
	var bits = 0;
	var available = 0;

	public function new(bytes:ByteArray, start:Int, end:Int) {
		this.bytes = bytes;
		this.end = end;
		position = start;
	}

	public function readBit(probability:Int):Bool {
		if (available < 8) {
			if (position == end) throw WebpContainer.invalid("Truncated VP8 arithmetic partition.");
			bits |= bytes[position++] << (8 - available);
			available += 8;
		}
		final split = ((range * probability) >> 8) + 1;
		final bit = bits >= (split << 8);
		if (bit) {
			range -= split;
			bits -= split << 8;
		} else {
			range = split - 1;
		}
		while (range < 127) {
			range = (range << 1) | 1;
			bits <<= 1;
			available--;
		}
		return bit;
	}

	public function readUint(probability:Int, count:Int):Int {
		var value = 0;
		for (_ in 0...count) value = (value << 1) | (readBit(probability) ? 1 : 0);
		return value;
	}

	public function readOptionalInt(probability:Int, count:Int):Int {
		if (!readBit(probability)) return 0;
		final value = readUint(probability, count);
		return readBit(probability) ? -value : value;
	}
}
