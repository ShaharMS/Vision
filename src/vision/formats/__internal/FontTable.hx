package vision.formats.__internal;

import haxe.io.Bytes;
import vision.exceptions.FontLoadingError;

@:noCompletion
class FontTable {
	final bytes:Bytes;
	final start:Int;
	public final length:Int;

	public function new(bytes:Bytes, start:Int, length:Int) {
		this.bytes = bytes;
		this.start = start;
		this.length = length;
	}

	public function slice(offset:Int, size:Int):FontTable {
		check(offset, size);
		return new FontTable(bytes, start + offset, size);
	}

	public function toBytes():Bytes {
		return bytes.sub(start, length);
	}

	public function tag(offset:Int):String {
		check(offset, 4);
		return bytes.getString(start + offset, 4);
	}

	public function u8(offset:Int):Int {
		check(offset, 1);
		return bytes.get(start + offset);
	}

	public inline function i8(offset:Int):Int {
		final value = u8(offset);
		return value < 128 ? value : value - 256;
	}

	public inline function u16(offset:Int):Int {
		return (u8(offset) << 8) | u8(offset + 1);
	}

	public inline function i16(offset:Int):Int {
		final value = u16(offset);
		return value < 32768 ? value : value - 65536;
	}

	public function u32(offset:Int):Int {
		final high = u16(offset);
		if (high >= 32768) throw new FontLoadingError("Font", "Unsupported unsigned font value.");
		return (high << 16) | u16(offset + 2);
	}

	inline function check(offset:Int, size:Int):Void {
		if (offset < 0 || size < 0 || offset > length - size) throw new FontLoadingError("Font", "Truncated font table.");
	}
}
