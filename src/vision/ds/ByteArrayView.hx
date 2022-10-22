package vision.ds;

class __ByteArrayView {
    
    public var parentArray:ByteArray;

    public var pos:Int;
    public var len:Int;

    public function new(array:ByteArray, from:Int, length:Int) {
        pos = from;
        len = length;
    }

    public function get(pos:Int):Int {
        return parentArray.get(pos + this.pos);
    }

    public function set(pos:Int, value:Int) {
        return parentArray.set(pos + this.pos, value);
    }
}

@:access(vision.ds.ByteArrayView.__ByteArrayView)
abstract ByteArrayView(__ByteArrayView) {
    
    public function new(byteArray:ByteArray, from:Int, length:Int) {
        this.pos = from;
        this.len = length;
    }

    @:op([]) inline function read(index:Int) {
        return this.get(index);
    }

    @:op([]) inline function write(index:Int, value:Int) {
        return this.set(index, value);
    }    
}