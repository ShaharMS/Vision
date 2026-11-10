package vision.formats.__internal;

#if (vision_native && (cpp || hl))
	#if hl
	typedef NativeWindow = hl.Abstract<"vision_window">;
	typedef NativeBytes = hl.Bytes;
	#else
	typedef NativeWindow = Dynamic;
	typedef NativeBytes = haxe.io.BytesData;
	#end

	@:noCompletion
	#if hl
	@:hlNative("vision_native")
	#end
class NativeImageIO {
	#if hl
	public static function open(x:Int, y:Int, width:Int, height:Int, visible:Bool, preferGpu:Bool):NativeWindow
		return null;

	public static function close(window:NativeWindow):Void {}

	public static function poll(window:NativeWindow):Bool
		return false;

	public static function gpu(window:NativeWindow):Bool
		return false;

	public static function clear(window:NativeWindow, color:Int):Void {}

	public static function draw(window:NativeWindow, bytes:NativeBytes, length:Int, offset:Int, width:Int, height:Int, x:Int, y:Int):Bool
		return false;

	public static function present(window:NativeWindow):Bool
		return false;

	public static function transform(bytes:NativeBytes, length:Int, offset:Int, operation:Int, value:Int):Bool
		return false;
	#else
	public static final open:(Int, Int, Int, Int, Bool, Bool) -> NativeWindow = cpp.Lib.load("vision_native", "open", -1);
	public static final close:NativeWindow->Void = cpp.Lib.load("vision_native", "close", 1);
	public static final poll:NativeWindow->Bool = cpp.Lib.load("vision_native", "poll", 1);
	public static final gpu:NativeWindow->Bool = cpp.Lib.load("vision_native", "gpu", 1);
	public static final clear:(NativeWindow, Int) -> Void = cpp.Lib.load("vision_native", "clear", 2);
	public static final draw:(NativeWindow, NativeBytes, Int, Int, Int, Int, Int, Int) -> Bool = cpp.Lib.load("vision_native", "draw", -1);
	public static final present:NativeWindow->Bool = cpp.Lib.load("vision_native", "present", 1);
	public static final transform:(NativeBytes, Int, Int, Int, Int) -> Bool = cpp.Lib.load("vision_native", "transform", 5);
	#end
}
#end
