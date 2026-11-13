package vision.native.vulkan;

#if (cpp && !cppia && vision_vulkan)
import cpp.Star;
import cpp.UInt8;

@:include("VulkanDevice.hpp")
@:native("vision_vulkan")
extern class VulkanDevice {
	static function available():Bool;
	static function adapterName():cpp.ConstCharStar;
	static function hardware():Bool;
	static function readbackCount():Int;
	static function release(texture:Star<VulkanBuffer>):Void;
	static function upload(width:Int, height:Int, bytes:cpp.RawConstPointer<UInt8>):Star<VulkanBuffer>;
	static function download(texture:Star<VulkanBuffer>, bytes:cpp.RawPointer<UInt8>):Bool;
	static function filter(texture:Star<VulkanBuffer>, width:Int, height:Int, mode:Int, value:Int, stepX:Float, stepY:Float,
		kernelWidth:Int, kernelHeight:Int, x:Int, y:Int, w:Int, h:Int, weights:cpp.RawConstPointer<UInt8>):Star<VulkanBuffer>;
}

@:include("VulkanDevice.hpp")
@:native("vision_vulkan::Buffer")
extern class VulkanBuffer {}
#end
