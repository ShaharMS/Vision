package vision.ds;

import haxe.io.BytesData;
import haxe.io.Bytes;

/**
    An abstract over `haxe.io.Bytes`, allows array access, and adds a couple of functions.
**/
@:forward
abstract ByteArray(Bytes) from Bytes to Bytes {

    @:op([]) inline function read(index:Int) {
        return this.get(index);
    }

    @:op([]) inline function write(index:Int, value:Int) {
        return this.set(index, value);
    }

    public inline function setUInt8(pos:Int, v:Int) {
        return this.set(pos, v);
    }

    public inline function getUInt8(pos:Int):Int {
        return this.get(pos);
    }

    public inline function setInt8(pos:Int, v:Int) {
        return this.set(pos, v);
    }

    public inline function getInt8(pos:Int):Int {
        var v = this.get(pos);
        return v * -(v >> 7);
    }


    public inline function setBytes(pos:Int, array:ByteArray) {
        this.blit(pos, array, 0, array.length);
    }

    public inline function getBytes(pos:Int, length:Int):ByteArray {
        var array = new ByteArray(length);
        array.blit(0, this, pos, length);
        return array;
    }

    /**
        Creates a new `ByteArray`. Values are set to 0.
    **/
    public inline function new(length:Int) {
        this = Bytes.alloc(length);
        this.fill(0, length, 0);
    }

    public inline function resize(length:Int) {
        var newBytes = Bytes.alloc(length);
        newBytes.fill(0, newBytes.length, 0);
        newBytes.blit(0, this, 0, this.length);
        this = newBytes;
    }

	public inline function concat(array:ByteArray):ByteArray {
		var newBytes = Bytes.alloc(this.length + array.length);
		newBytes.blit(0, this, 0, this.length);
		newBytes.blit(this.length, array, 0, array.length);
		return newBytes;
	}

    public inline function toArray():Array<Int> {
        return [for (i in 0...this.length) this.get(i)]; // Probably needs a change
    }
}