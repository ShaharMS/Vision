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

    /**
        Creates a new `ByteArray`
    **/
    public inline function new(length:Int) {
        this = Bytes.alloc(length);
    }
}