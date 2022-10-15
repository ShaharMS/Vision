package vision.ds;

import haxe.io.BytesData;
import haxe.io.Bytes;

/**
    An abstract over `haxe.io.Bytes`, allows array access.
**/
@:forward(length)
abstract ByteArray(BytesData) from BytesData to BytesData {
    @:op([]) inline function read(index:Int) {
        return this[index];
    }

    @:op([]) inline function write(index:Int, value:Int) {
        return this[index] = value;
    }

    /**
        Creates a new `ByteArray`
    **/
    public inline function new(length:Int) {
        this = Bytes.alloc(length).getData();
    }

    public inline function getInt32(index:Int):Int {
        return read(index) | read(index + 1) << 8 | read(index + 2) << 12 | read(index + 3) << 24;
    }

	public inline function setInt32(index:Int, value:Int) {
        write(index, value & 0xFF);
        write(index + 1, (value >> 8) & 0xFF);
        write(index + 2, (value >> 16) & 0xFF);
        write(index + 3, (value >> 24) & 0xFF);
	}
}