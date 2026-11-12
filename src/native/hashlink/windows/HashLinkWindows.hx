package native.hashlink.windows;

#if (hl && windows && vision_hashlink_screen)
typedef HashLinkWindow = hl.Abstract<"vision_screen_window">;

@:noCompletion
@:hlNative("vision_screen")
extern class HashLinkWindows {
	static function open(x:Int, y:Int, width:Int, height:Int, visible:Bool):HashLinkWindow;
	static function poll(window:HashLinkWindow):Int;
	static function present(window:HashLinkWindow, pixels:hl.Bytes, length:Int, width:Int, height:Int):Bool;
	static function close(window:HashLinkWindow):Void;
}
#end
