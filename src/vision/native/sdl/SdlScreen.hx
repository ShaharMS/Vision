package vision.native.sdl;

#if (cpp && !cppia && VISION_SDL_PREFIX)
import cpp.ConstCharStar;
import cpp.RawPointer;
import cpp.RawConstPointer;
import cpp.Star;
import cpp.UInt8;

@:include("vision/native/sdl/screen.h")
@:buildXml('
	<files id="haxe">
		<compilerflag value="-I${haxelib:vision}/src" />
		<compilerflag value="-I${VISION_SDL_PREFIX}/include" if="VISION_SDL_PREFIX" />
		<compilerflag value="-DVISION_SCREEN_TESTS" if="vision_screen_tests" />
	</files>
	<target id="haxe">
		<lib name="-L${VISION_SDL_PREFIX}/lib" if="VISION_SDL_PREFIX" />
		<lib name="-lSDL2" />
	</target>')
extern class SdlScreen {
	@:native("vision_sdl_open") static function open(x:Int, y:Int, width:Int, height:Int, visible:Bool, preferGpu:Bool):Star<SdlWindow>;
	@:native("vision_sdl_close") static function close(window:Star<SdlWindow>):Void;
	@:native("vision_sdl_poll") static function poll(window:Star<SdlWindow>):Int;
	@:native("vision_sdl_bounds") static function setBounds(window:Star<SdlWindow>, x:Int, y:Int, width:Int, height:Int):Bool;
	@:native("vision_sdl_clear") static function clear(window:Star<SdlWindow>, color:UInt):Bool;
	@:native("vision_sdl_draw")
	static function draw(window:Star<SdlWindow>, argb:RawConstPointer<UInt8>, width:Int, height:Int, x:Int, y:Int):Bool;
	@:native("vision_sdl_present") static function present(window:Star<SdlWindow>):Bool;
	@:native("vision_sdl_capture") static function capture(window:Star<SdlWindow>, argb:RawPointer<UInt8>):Bool;
	@:native("SDL_GetError") static function error():ConstCharStar;
	#if vision_screen_tests
	@:native("SDL_GetCurrentVideoDriver") static function videoDriver():ConstCharStar;
	@:native("vision_sdl_window_id") static function id(window:Star<SdlWindow>):UInt;
	@:native("vision_sdl_window_exists") static function exists(id:UInt):Bool;
	@:native("vision_sdl_matches_size") static function matchesSize(window:Star<SdlWindow>, width:Int, height:Int):Bool;
	@:native("vision_sdl_is_shown") static function isShown(window:Star<SdlWindow>):Bool;
	@:native("vision_sdl_renderer_name") static function rendererName(window:Star<SdlWindow>):ConstCharStar;
	@:native("vision_sdl_accelerated") static function accelerated(window:Star<SdlWindow>):Bool;
	@:native("vision_sdl_pixel") static function pixel(window:Star<SdlWindow>, x:Int, y:Int):UInt;
	@:native("vision_sdl_request_close") static function requestClose(window:Star<SdlWindow>):Bool;
	#end
}

@:include("vision/native/sdl/screen.h")
@:native("VisionSdlWindow")
extern class SdlWindow {}
#end
