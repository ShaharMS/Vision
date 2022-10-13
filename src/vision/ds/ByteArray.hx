package vision.ds;

import haxe.io.BytesData;
import haxe.io.Bytes;

/**
    An abstract over `haxe.io.Bytes`, allows array access.
**/
@:forward
abstract ByteArray(Bytes) from Bytes to Bytes {
    
    @:op([]) inline function read(index:Int) {
        return this.get(index);
    }

    @:op([]) inline function write(index:Int, value:Int) {
        return this.set(index, value);
    }

    /**
        Creates a new `ByteArray`
    **/
    public inline function new(length:Int) {
        this = Bytes.alloc(length);
    }
}