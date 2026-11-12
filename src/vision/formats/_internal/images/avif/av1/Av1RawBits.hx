package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** Reads bounded, uncompressed AV1 syntax. **/
@:noCompletion
class Av1RawBits {
	final bytes:Bytes;
	final end:Int;
	var position:Int;
	var bit:Int = 7;

	public function new(bytes:Bytes, offset:Int, length:Int) {
		if (offset < 0 || length < 0 || offset > bytes.length - length)
			throw new Av1BitstreamError("Invalid AV1 raw bit range.");
		this.bytes = bytes;
		position = offset;
		end = offset + length;
	}

	public inline function flag():Bool return read(1) != 0;

	/** Reads a two's complement fixed-width field. **/
	public function signed(count:Int):Int {
		final value = read(count);
		final sign = 1 << (count - 1);
		return (value ^ sign) - sign;
	}

	/** Reads a non-symmetric integer in the range from zero to limit minus one. **/
	public function nonSymmetric(limit:Int):Int {
		if (limit == 1) return 0;
		var width = 0;
		while ((1 << width) <= limit) width++;
		final shortCodes = (1 << width) - limit;
		final value = read(width - 1);
		return value < shortCodes ? value : (value << 1) - shortCodes + read(1);
	}

	/** Consumes zero padding and returns the next byte offset. **/
	public function align():Int {
		while (bit != 7) if (flag()) throw new Av1BitstreamError("Invalid AV1 byte alignment.");
		return position;
	}

	public function read(count:Int):Int {
		var value = 0;
		for (_ in 0...count) {
			if (position == end) throw new Av1BitstreamError("Truncated AV1 raw syntax.");
			value = (value << 1) | ((bytes.get(position) >>> bit) & 1);
			if (bit == 0) {
				position++;
				bit = 7;
			} else bit--;
		}
		return value;
	}

	public function skipUvlc():Void {
		var zeroes = 0;
		while (!flag()) {
			if (zeroes < 32) zeroes++;
		}
		if (zeroes < 32) read(zeroes);
	}

	public function readTrailingBits():Void {
		if (!flag()) throw new Av1BitstreamError("Missing AV1 sequence header trailing bit.");
		while (position < end) {
			if (flag()) throw new Av1BitstreamError("Nonzero AV1 sequence header padding.");
		}
	}
}
