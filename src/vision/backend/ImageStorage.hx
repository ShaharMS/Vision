package vision.backend;

import vision.ds.ByteArray;

/** Internal CPU backing for an image, including its packed metadata. **/
@:noCompletion
@:forward(length, blit, sub, get, set, getInt32, setInt32, getUInt16, setUInt16)
abstract ImageStorage(ByteArray) {
	public static inline final FIELD_BYTES = #if vision_higher_width_cap 4 #else 2 #end;
	public static inline final PIXEL_OFFSET = FIELD_BYTES * 5 + 1;

	public inline function new(bytes:ByteArray) {
		this = bytes;
	}

	public static inline function allocate(width:Int, height:Int):ImageStorage {
		final bytes = new ByteArray(width * height * 4 + PIXEL_OFFSET);
		#if vision_higher_width_cap
		bytes.setInt32(0, width);
		#else
		bytes.setUInt16(0, width);
		#end
		return new ImageStorage(bytes);
	}

	public inline function bytes():ByteArray {
		return this;
	}

	@:arrayAccess inline function read(index:Int):Int {
		return this[index];
	}

	@:arrayAccess inline function write(index:Int, value:Int):Void {
		this[index] = value;
	}
}
