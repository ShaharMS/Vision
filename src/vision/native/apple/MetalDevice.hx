package vision.native.apple;

#if (cpp && !cppia && (mac || ios) && vision_metal)
import cpp.Star;
import cpp.UInt8;

@:include("MetalDevice.hpp")
@:native("vision_metal")
extern class MetalDevice {
	static function available():Bool;
	static function adapterName():cpp.ConstCharStar;
	static function hardware():Bool;
	static function readbackCount():Int;
	static function composite(target:Star<MetalBuffer>, source:Star<MetalBuffer>, x:Int, y:Int, invert:Bool):Bool;
	static function release(texture:Star<MetalBuffer>):Void;
	static function upload(width:Int, height:Int, bytes:cpp.RawConstPointer<UInt8>):Star<MetalBuffer>;
	static function download(texture:Star<MetalBuffer>, bytes:cpp.RawPointer<UInt8>):Bool;
	static function filter(texture:Star<MetalBuffer>, width:Int, height:Int, mode:Int, value:Int, stepX:Float, stepY:Float,
		kernelWidth:Int, kernelHeight:Int, x:Int, y:Int, w:Int, h:Int, weights:cpp.RawConstPointer<UInt8>):Star<MetalBuffer>;
}

@:include("MetalDevice.hpp")
@:native("vision_metal::Buffer")
extern class MetalBuffer {}
#end
