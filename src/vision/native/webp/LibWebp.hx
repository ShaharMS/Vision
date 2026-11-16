package vision.native.webp;

#if (cpp && !cppia && vision_webp)
import haxe.io.BytesData;

@:include("vision/native/webp/codec.h")
@:buildXml('
	<files id="haxe">
		<compilerflag value="-I${haxelib:vision}/src" />
		<compilerflag value="-I${VISION_WEBP_PREFIX}/include" if="VISION_WEBP_PREFIX" />
	</files>
	<target id="haxe">
		<lib name="-L${VISION_WEBP_PREFIX}/lib" if="VISION_WEBP_PREFIX" unless="windows" />
		<lib name="-lwebp" unless="windows" />
		<lib name="${VISION_WEBP_PREFIX}/lib/libwebp.lib" if="windows VISION_WEBP_PREFIX" />
		<lib name="libwebp.lib" if="windows" unless="VISION_WEBP_PREFIX" />
	</target>')
extern class LibWebp {
	@:native("vision_webp_dimensions") static function dimensions(source:BytesData):Int;
	@:native("vision_webp_decode") static function decode(source:BytesData, pixels:BytesData, stride:Int):Bool;
	@:native("vision_webp_encode") static function encode(rgba:BytesData, width:Int, height:Int, quality:Float):BytesData;
}
#end
