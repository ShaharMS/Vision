package vision.native.windows;

#if (windows && cpp && !cppia)
import cpp.Star;
import cpp.UInt8;

@:include("D3D11Device.hpp")
@:native("vision_d3d11")
extern class D3D11Device {
	static function available():Bool;
	static function synchronize():Bool;
	static function readbackCount():Int;
	static function openWindow(window:Star<vision.native.windows.Win32.WinWindow>, width:Int, height:Int):Star<D3D11Window>;
	static function closeWindow(window:Star<D3D11Window>):Void;
	static function present(window:Star<D3D11Window>, frame:Star<D3D11Texture>):Bool;
	static function draw(target:Star<D3D11Texture>, source:Star<D3D11Texture>, x:Int, y:Int, invert:Bool):Bool;
	static function release(texture:Star<D3D11Texture>):Void;
	static function upload(width:Int, height:Int, bytes:cpp.RawConstPointer<UInt8>):Star<D3D11Texture>;
	static function download(texture:Star<D3D11Texture>, bytes:cpp.RawPointer<UInt8>):Bool;
	static function filter(texture:Star<D3D11Texture>, width:Int, height:Int, mode:Int, value:Int, stepX:Float, stepY:Float,
		kernelWidth:Int, kernelHeight:Int, x:Int, y:Int, w:Int, h:Int, weights:cpp.RawConstPointer<UInt8>):Star<D3D11Texture>;
}

@:include("D3D11Device.hpp")
@:native("vision_d3d11::Texture")
extern class D3D11Texture {}
@:include("D3D11Device.hpp")
@:native("vision_d3d11::WindowTarget")
extern class D3D11Window {}
#end
