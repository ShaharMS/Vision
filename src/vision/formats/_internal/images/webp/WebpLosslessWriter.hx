package vision.formats._internal.images.webp;

import haxe.io.Bytes;
import vision.ds.Image;
import vision.formats._internal.images.webp.WebpBits.WebpBitWriter;

/** Writes VP8L literals with canonical prefix codes and constant-channel trees. **/
@:noCompletion
class WebpLosslessWriter {
	public static function write(image:Image):Bytes {
		final source = image.exportToBytes();
		final channels = [2, 1, 3, 0]; // green, red, blue, alpha
		final constants = [for (channel in channels) source.get(channel)];
		for (i in 0...channels.length) {
			var offset = channels[i] + 4;
			while (offset < source.length) {
				if (source.get(offset) != constants[i]) {
					constants[i] = -1;
					break;
				}
				offset += 4;
			}
		}
		final bits = new WebpBitWriter();
		bits.write(0x2f, 8);
		bits.write(image.width - 1, 14);
		bits.write(image.height - 1, 14);
		bits.write(constants[3] == 255 ? 0 : 1, 1);
		bits.write(0, 3);
		bits.write(0, 3); // no transforms, color cache, or entropy image
		for (constant in constants) {
			if (constant >= 0) writeConstant(bits, constant);
			else writeByteTree(bits);
		}
		writeConstant(bits, 0); // no backward references

		var offset = 0;
		while (offset < source.length) {
			for (i in 0...channels.length)
				if (constants[i] < 0) bits.write(reverseByte(source.get(offset + channels[i])), 8);
			offset += 4;
		}
		return bits.finish();
	}

	static function writeConstant(bits:WebpBitWriter, symbol:Int):Void {
		bits.write(1, 1); // simple tree
		bits.write(0, 1); // one symbol
		bits.write(symbol <= 1 ? 0 : 1, 1);
		bits.write(symbol, symbol <= 1 ? 1 : 8);
	}

	static function writeByteTree(bits:WebpBitWriter):Void {
		bits.write(0, 1); // normal tree
		bits.write(8, 4); // twelve code-length entries, ending with symbol 8
		for (_ in 0...11) bits.write(0, 3);
		bits.write(1, 3);
		bits.write(1, 1); // limit the table to 256 literal symbols
		bits.write(3, 3); // an eight-bit length field
		bits.write(254, 8);
		// The single code-length symbol is 8, so the 256 lengths take no additional bits.
	}

	static inline function reverseByte(value:Int):Int {
		value = ((value & 0x55) << 1) | ((value >>> 1) & 0x55);
		value = ((value & 0x33) << 2) | ((value >>> 2) & 0x33);
		return ((value & 15) << 4) | (value >>> 4);
	}
}
