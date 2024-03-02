package vision.ds;

import vision.tools.MathTools;
import haxe.Serializer;
import haxe.io.BytesData;
import haxe.io.Bytes;

/**
    An abstract over `haxe.io.Bytes`, allows array access, and adds a bunch of utility functions.
**/
@:forward
abstract ByteArray(Bytes) from Bytes to Bytes {

    /**
        Generates a byte array of length 4, containing `value`.  
        The value is stored in little-endian format.
        @param value The given integer
        @return The resulting `ByteArray`
    **/
    overload extern inline public static function from(value:Int):ByteArray {
        var bytes = new ByteArray(4);
        bytes.setInt32(0, value);
        return bytes;
    }

    /**
        Generates a byte array of length 8, containing `value`.
        The value is stored in little-endian format.
        @param value The given float
        @return The resulting `ByteArray`
    **/
    overload extern inline public static function from(value:Float):ByteArray {
        var bytes = new ByteArray(8);
        bytes.setDouble(0, value);
        return bytes;
    }

    /**
        If `value` is `true`, generates a byte array of length 1, containing 1.  
        If `value` is `false`, generates a byte array of length 1, containing 0.
    **/
    overload extern inline public static function from(value:Bool):ByteArray {
        return value ? new ByteArray(1, 1) : new ByteArray(1, 0);   
    }

    /**
        Encodes the given string into a byte array. `UTF-8` encoding is used by default.
        If you want to use another type of encoding, provide the second parameter.
        @param value The given string
        @return The resulting `ByteArray`
    **/
    overload extern inline public static function from(value:String, ?encoding:haxe.io.Encoding):ByteArray {
        return Bytes.ofString(value);
    }

    /**
        Uses `haxe.io.Serializer` to stringify the given value, then encodes it into a byte array
        using `UTF-8` encoding.
        @param value The given object
        @return The resulting `ByteArray`
    **/
    overload extern inline public static function from(value:Dynamic):ByteArray {
        return Bytes.ofString(Serializer.run(value));
    }

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
        Writes an unsigned, 32-bit integer at the specified index
    **/
    public inline function setUInt32(pos:Int, value:UInt) {
        return this.setInt32(pos, value);
    }

    public inline function getUInt32(pos:Int):UInt {
        return this.getInt32(pos);
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
        Creates a new `ByteArray`. Values are set to `fillWith`, which defaults to `0`.
    **/
    public inline function new(length:Int, fillWith:Int = 0) {
        this = Bytes.alloc(length);
        this.fill(0, length, fillWith);
    }

    /**
        Resizes the array
        
        @param length the new length
    **/
    public inline function resize(length:Int) {
        var newBytes = Bytes.alloc(length);
        newBytes.blit(0, this, 0, MathTools.min(newBytes.length, this.length));
        this = newBytes;
    }

	/**
	    Concatenates a byte array to this one. **Pay Attention** - 
	    
        @param array the array to concatenate.
	    @return a new `ByteArray`.
	**/
	public inline function concat(array:ByteArray):ByteArray {
		var newBytes = Bytes.alloc(this.length + array.length);
		newBytes.blit(0, this, 0, this.length);
		newBytes.blit(this.length, array, 0, array.length);
		return newBytes;
	}

    /**
        Checks if this `ByteArray` is empty, i.e. all bytes are 0.

        @return true if empty, false otherwise
    **/
    public function isEmpty():Bool {
        for (i in 0...this.length) {
            if (this.get(i) != 0) return false;
        }
        return true;
    } 

    /**
        Turns this `ByteArray` into an array of ints, from -255 to 255
    **/
    public inline function toArray():Array<Int> {
        return [for (i in 0...this.length) this.get(i)]; // Probably needs a change
    }
}