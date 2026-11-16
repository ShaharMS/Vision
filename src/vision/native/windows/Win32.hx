package vision.native.windows;

#if (cpp && windows)
import cpp.ConstCharStar;
import cpp.Star;

@:include("windows.h")
@:buildXml('<target id="haxe"><lib name="user32.lib" /></target>')
extern class Win32 {
	@:native("CreateWindowExA")
	static function createWindow(exStyle:Int, className:ConstCharStar, title:ConstCharStar, style:Int, x:Int, y:Int, width:Int, height:Int,
		parent:Star<WinWindow>, menu:Star<WinMenu>, instance:Star<WinInstance>, data:Star<cpp.Void>):Star<WinWindow>;

	@:native("GetModuleHandleA")
	static function moduleHandle(name:ConstCharStar):Star<WinInstance>;

	@:native("AdjustWindowRect")
	static function adjustWindowRect(bounds:Star<WinRect>, style:Int, hasMenu:Bool):Int;

	@:native("SetWindowPos")
	static function setWindowPos(window:Star<WinWindow>, insertAfter:Star<WinWindow>, x:Int, y:Int, width:Int, height:Int, flags:Int):Int;

	@:native("ShowWindow")
	static function showWindow(window:Star<WinWindow>, command:Int):Int;

	@:native("SetWindowLongW")
	static function setWindowLong(window:Star<WinWindow>, index:Int, value:Int):Int;

	@:native("MonitorFromWindow")
	static function monitorFromWindow(window:Star<WinWindow>, flags:Int):Star<WinMonitor>;

	@:native("GetMonitorInfoW")
	static function getMonitorInfo(monitor:Star<WinMonitor>, info:Star<WinMonitorInfo>):Int;

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
@:native("HMONITOR__")
extern class WinMonitor {}

@:include("windows.h")
@:native("MONITORINFO")
@:structAccess
extern class WinMonitorInfo {
	@:native("MONITORINFO") static function make():WinMonitorInfo;
	var cbSize:Int;
	var rcMonitor:WinRect;
}

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

#end
