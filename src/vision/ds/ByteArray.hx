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
        Creates a new `ByteArray`. Values are set to 0.
    **/
    public inline function new(length:Int) {
        this = Bytes.alloc(length);
        this.fill(0);
    }

    public inline function resize(length:Int) {
        var newBytes = Bytes.alloc(length);
        newBytes.fill(0);
        newBytes.blit(0, this, 0, this.length);
        this = newBytes;
    }
        
    }
}