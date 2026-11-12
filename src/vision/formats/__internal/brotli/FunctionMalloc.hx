package vision.formats.__internal.brotli;
import haxe.ds.Vector;

import vision.formats.__internal.brotli.DefaultFunctions;
import haxe.Constraints.Constructible;

/**
 * ...
 * @author
 */

class FunctionMalloc
{
	public static function mallocUInt(a):Vector<UInt> {
		var arr:Vector<UInt> = new Vector<UInt>(a);
		for (i in 0...a)
		arr[i] = 0;
		return arr;
	}
	public static function mallocInt(a):Vector<Int> {
		var arr:Vector<Int> = new Vector<Int>(a);
		for (i in 0...a)
		arr[i] = 0;
		return arr;
	}
	public static function mallocFloat(a):Vector<Float> {
		var arr:Vector<Float> = new Vector<Float>(a);
		for (i in 0...a)
		arr[i] = 0;
		return arr;
	}
	public static function mallocBool(a):Vector<Bool> {
		var arr:Vector<Bool> = new Vector<Bool>(a);
		for (i in 0...a)
		arr[i] = false;
		return arr;
	}
	@:generic public static function malloc<T:Constructible<Void->Void>>(t:Class<T>, a):Vector<T> {
		var arr:Vector<T> = new Vector<T>(a);
		for (i in 0...a)
		arr[i] = new T();
		return arr;
	}
	@:generic public static function mallocArray<T:Constructible<Void->Void>>(t:Class<T>, a):Array<T> {
		var arr:Array<T> = new Array<T>();
		for (i in 0...a)
		arr[i] = new T();
		return arr;
	}
	@:generic public static function malloc2<T:Constructible<Int->Int->Void>>(t:Class<T>, a):Vector<T> {
		var arr:Vector<T> = new Vector<T>(a);
		for (i in 0...a)
		arr[i] = new T(0,0);
		return arr;
	}
	@:generic public static function malloc2_<T:Constructible<Int->Float->Void>>(t:Class<T>, a):Vector<T> {
		var arr:Vector<T> = new Vector<T>(a);
		for (i in 0...a)
		arr[i] = new T(0,0);
		return arr;
	}
	public function new()
	{

	}

}
