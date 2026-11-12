package vision.formats._internal.images.webp;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import vision.exceptions.ImageLoadingFailed;

/** Reads and writes the little-endian bits used by VP8L. **/
@:noCompletion
class WebpBits {
	final input:Bytes;
	var position:Int;
	final end:Int;
	var buffer = 0;
	var bits = 0;

	public function new(input:Bytes, start:Int, end:Int) {
		this.input = input;
		position = start;
		this.end = end;
	}

	public function read(count:Int):Int {
		while (bits < count) {
			if (position >= end) throw new ImageLoadingFailed(WEBP, "Truncated lossless WebP data.");
			buffer |= input.get(position++) << bits;
			bits += 8;
		}
		final result = buffer & ((1 << count) - 1);
		buffer >>>= count;
		bits -= count;
		return result;
	}
}

@:noCompletion
class WebpBitWriter {
	final output = new BytesOutput();
	var buffer = 0;
	var bits = 0;

	public function new() {}

	public function write(value:Int, count:Int):Void {
		buffer |= value << bits;
		bits += count;
		while (bits >= 8) {
			output.writeByte(buffer & 255);
			buffer >>>= 8;
			bits -= 8;
		}
	}

	public function finish():Bytes {
		if (bits > 0) output.writeByte(buffer);
		return output.getBytes();
	}
}
