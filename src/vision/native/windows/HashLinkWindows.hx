package vision.native.windows;

#if (hl && windows && vision_hashlink_screen)
typedef HashLinkTexture = hl.Abstract<"vision_d3d11_image">;
typedef HashLinkWindow = hl.Abstract<"vision_screen_window">;

@:noCompletion
@:hlNative("vision_screen")
extern class HashLinkWindows {
	static function open(x:Int, y:Int, width:Int, height:Int, visible:Bool):HashLinkWindow;
	static function setBounds(window:HashLinkWindow, x:Int, y:Int, width:Int, height:Int):Bool;
	static function setWindowMode(window:HashLinkWindow, mode:Int, wasFullscreen:Bool, x:Int, y:Int, width:Int, height:Int):Bool;
	static function poll(window:HashLinkWindow):Int;
	static function present(window:HashLinkWindow, texture:HashLinkTexture):Bool;
	static function available():Bool;
	static function synchronize():Bool;
	static function readbackCount():Int;
	static function release(texture:HashLinkTexture):Void;
	static function upload(width:Int, height:Int, bytes:hl.Bytes, offset:Int):HashLinkTexture;
	static function download(texture:HashLinkTexture, bytes:hl.Bytes, offset:Int):Bool;
	static function draw(target:HashLinkTexture, source:HashLinkTexture, x:Int, y:Int, invert:Bool):Bool;
	static function filter(texture:HashLinkTexture, width:Int, height:Int, mode:Int, value:Int, stepX:Float, stepY:Float,
		kernelWidth:Int, kernelHeight:Int, x:Int, y:Int, w:Int, h:Int, weights:hl.Bytes):HashLinkTexture;
	static function close(window:HashLinkWindow):Void;
}
#end
