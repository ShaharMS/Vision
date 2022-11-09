package vision.ds;

import haxe.ds.Vector;

@:forward
abstract ArrayAccessVector<T>(Vector<T>) from Vector<T> to Vector<T> {
    @:arrayAccess function r(i:Int) {
        return this.get(i);       
    }

    @:arrayAccess function w(i:Int, v:T) {
        return this.set(i, v);       
    }

    public function new(length:Int) {
        this = new Vector(length);
    }

    @:to public function toArray():Array<T> {
        return this.toArray();
    }

    @:from public static function fromArray<A>(arr:Array<A>):ArrayAccessVector<A> {
        return cast Vector.fromArrayCopy(arr);
    }
}