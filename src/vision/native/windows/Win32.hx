package vision.native.windows;

#if (cpp && windows)
import cpp.ConstCharStar;
import cpp.RawConstPointer;
import cpp.Star;
import cpp.UInt8;

@:include("windows.h")
@:buildXml('<target id="haxe"><lib name="user32.lib" /><lib name="gdi32.lib" /></target>')
extern class Win32 {
	@:native("CreateWindowExA")
	static function createWindow(exStyle:Int, className:ConstCharStar, title:ConstCharStar, style:Int, x:Int, y:Int, width:Int, height:Int,
		parent:Star<WinWindow>, menu:Star<WinMenu>, instance:Star<WinInstance>, data:Star<cpp.Void>):Star<WinWindow>;

	@:native("GetModuleHandleA")
	static function moduleHandle(name:ConstCharStar):Star<WinInstance>;

	@:native("AdjustWindowRect")
	static function adjustWindowRect(bounds:Star<WinRect>, style:Int, hasMenu:Bool):Int;

	@:native("ShowWindow")
	static function showWindow(window:Star<WinWindow>, command:Int):Int;

	@:native("DestroyWindow")
	static function destroyWindow(window:Star<WinWindow>):Int;

	@:native("IsWindow")
	static function isWindow(window:Star<WinWindow>):Int;

	@:native("PeekMessageA")
	static function peekMessage(message:Star<WinMessage>, window:Star<WinWindow>, minimum:Int, maximum:Int, remove:Int):Int;

	@:native("TranslateMessage")
	static function translateMessage(message:Star<WinMessage>):Int;

	@:native("DispatchMessageA")
	static function dispatchMessage(message:Star<WinMessage>):cpp.Int64;

	@:native("GetDC")
	static function getDC(window:Star<WinWindow>):Star<WinDC>;

	@:native("ReleaseDC")
	static function releaseDC(window:Star<WinWindow>, dc:Star<WinDC>):Int;

	@:native("StretchDIBits")
	static function stretchBits(dc:Star<WinDC>, x:Int, y:Int, width:Int, height:Int, sourceX:Int, sourceY:Int, sourceWidth:Int, sourceHeight:Int,
		data:RawConstPointer<UInt8>, info:Star<WinBitmapInfo>, usage:Int, operation:Int):Int;
}

@:include("windows.h")
@:native("HWND__")
extern class WinWindow {}

@:include("windows.h")
@:native("HMENU__")
extern class WinMenu {}

@:include("windows.h")
@:native("HINSTANCE__")
extern class WinInstance {}

@:include("windows.h")
@:native("HDC__")
extern class WinDC {}

@:include("windows.h")
@:native("RECT")
@:structAccess
extern class WinRect {
	@:native("RECT") static function make():WinRect;
	var left:Int;
	var top:Int;
	var right:Int;
	var bottom:Int;
}

@:include("windows.h")
@:native("MSG")
@:structAccess
extern class WinMessage {
	@:native("MSG") static function make():WinMessage;
	var hwnd:Star<WinWindow>;
	var message:Int;
}

@:include("windows.h")
@:native("BITMAPINFOHEADER")
@:structAccess
extern class WinBitmapHeader {
	var biSize:Int;
	var biWidth:Int;
	var biHeight:Int;
	var biPlanes:Int;
	var biBitCount:Int;
	var biCompression:Int;
}

@:include("windows.h")
@:native("BITMAPINFO")
@:structAccess
extern class WinBitmapInfo {
	@:native("BITMAPINFO") static function make():WinBitmapInfo;
	var bmiHeader:WinBitmapHeader;
}
#end
