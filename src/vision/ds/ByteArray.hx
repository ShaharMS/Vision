package vision.ds;

import haxe.io.BytesData;
import haxe.io.Bytes;

/**
    An abstract over `haxe.io.Bytes`, allows array access, and adds a couple of functions.
**/
@:forward
abstract ByteArray(Bytes) from Bytes to Bytes {

    /**
        Reads a byte at the specified index 
    **/
    @:op([]) inline function read(index:Int) {
        return this.get(index);
    }

    /**
        Writes a byte at the specified index
    **/
    @:op([]) inline function write(index:Int, value:Int) {
        return this.set(index, value);
    }

    /**
        Writes an unsigned, 8-bit integer at the specified index
    **/
    public inline function setUInt8(pos:Int, v:Int) {
        return this.set(pos, v);
    }

    /**
        Reads an unsigned, 8-bit integer at the specified index
    **/
    public inline function getUInt8(pos:Int):Int {
        return this.get(pos);
    }

    /**
        Writes a signed, 8-bit integer at the specified index
    **/
    public inline function setInt8(pos:Int, v:Int) {
        return this.set(pos, v);
    }

    /**
        Reads a signed, 8-bit integer at the specified index
    **/
    public inline function getInt8(pos:Int):Int {
        var v = this.get(pos);
        return v * -(v >> 7);
    }

    /**
        Writes an array of bytes at the specified index
    **/
    public inline function setBytes(pos:Int, array:ByteArray) {
        this.blit(pos, array, 0, array.length);
    }

    /**
        Reads an array of bytes at the specified index
    **/
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

    /**
        Resizes the array
        
        @param length the new length
    **/
    public inline function resize(length:Int) {
        var newBytes = Bytes.alloc(length);
        newBytes.fill(0, newBytes.length, 0);
        newBytes.blit(0, this, 0, this.length);
        this = newBytes;
    }

	/**
	    Concatenates a byte array to this one. **Pay Attention** - 
        this differs from `Array.concat` in that it does not create a new array, but modifies this one.
	    
        @param array the array to concatenate.
	    @return this modified `ByteArray`.
	**/
	public inline function concat(array:ByteArray):ByteArray {
		var newBytes = Bytes.alloc(this.length + array.length);
		newBytes.blit(0, this, 0, this.length);
		newBytes.blit(this.length, array, 0, array.length);
		return newBytes;
	}

    /**
        Turns this `ByteArray` into an array of ints, from -255 to 255
    **/
    public inline function toArray():Array<Int> {
        return [for (i in 0...this.length) this.get(i)]; // Probably needs a change
    }
}