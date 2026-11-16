package vision.native.windows;

#if (windows && ((cpp && !cppia) || (hl && vision_hashlink_screen)))
	#if hl
	import vision.native.windows.HashLinkWindows;
	import vision.native.windows.HashLinkWindows.HashLinkWindow;
	#else
	import cpp.Native;
	import cpp.Star;
	import vision.native.windows.Win32.WinMessage;
	import vision.native.windows.D3D11Device.D3D11Window;
	import vision.native.windows.Win32.WinMonitorInfo;
	import vision.native.windows.Win32.WinRect;
	import vision.native.windows.Win32.WinWindow;
	#end
import vision.native.DesktopImageStorage;
import vision.native.DesktopScreenBackend;
import vision.native.ScreenBackend.ScreenWindowMode;
import vision.exceptions.ScreenError;

/** Presents Direct3D 11 textures through a Win32 window and DXGI swapchain. **/
@:noCompletion
class WindowsScreenBackend extends DesktopScreenBackend {
	#if hl
	static inline var WINDOW_OPEN = 1;
	static inline var WINDOW_REPAINT = 2;
	#else
	static inline var WINDOW_STYLE = 0x00CF0000;
	static inline var SHOW_WINDOW = 5;
	static inline var KEEP_Z_ORDER = 0x0004;
	static inline var KEEP_FOCUS = 0x0010;
	static inline var REMOVE_MESSAGE = 1;
	static inline var PAINT_MESSAGE = 0x000F;
	var gpuWindow:Star<D3D11Window>;
	#end

	var normalX:Int;
	var normalY:Int;
	var fullscreenWindow = false;
	var window:#if hl HashLinkWindow #else Star<WinWindow> #end;

	public function new(width:Int, height:Int, visible:Bool, x:Int, y:Int) {
		super(width, height);
		normalX = x;
		normalY = y;
		#if hl
		window = HashLinkWindows.open(x, y, width, height, visible);
		#else
		var bounds = WinRect.make();
		bounds.right = width;
		bounds.bottom = height;
		Win32.adjustWindowRect(Native.addressOf(bounds), WINDOW_STYLE, false);
		window = Win32.createWindow(0, "STATIC", "Vision", WINDOW_STYLE, x, y, bounds.right - bounds.left, bounds.bottom - bounds.top, null, null,
			Win32.moduleHandle(null), null);
		if (window != null && visible) Win32.showWindow(window, SHOW_WINDOW);
		#end
		if (window == null) throw new ScreenError("Windows could not open a drawing window");
		#if !hl
		gpuWindow = D3D11Device.openWindow(window, width, height);
		#end
		if (!present()) {
			dispose();
			throw new ScreenError("Could not open a Direct3D 11 swapchain");
		}
	}

	override public function setWindowMode(mode:ScreenWindowMode):Bool {
		if (window == null) return false;
		#if hl
		if (!HashLinkWindows.setWindowMode(window, mode, fullscreenWindow, normalX, normalY, frame.width, frame.height))
			return false;
		#else
		if (Win32.isWindow(window) == 0) return false;
		if (mode == Fullscreen) {
			var info = WinMonitorInfo.make();
			info.cbSize = Native.sizeof(WinMonitorInfo);
			if (Win32.getMonitorInfo(Win32.monitorFromWindow(window, 2), Native.addressOf(info)) == 0) return false;
			Win32.showWindow(window, 9);
			Win32.setWindowLong(window, -16, 0x90000000);
			final bounds = info.rcMonitor;
			if (Win32.setWindowPos(window, null, bounds.left, bounds.top, bounds.right - bounds.left, bounds.bottom - bounds.top, 0x64) == 0)
				return false;
		} else {
			if (fullscreenWindow) {
				Win32.setWindowLong(window, -16, WINDOW_STYLE | 0x10000000);
				var bounds = WinRect.make();
				bounds.right = frame.width;
				bounds.bottom = frame.height;
				if (Win32.adjustWindowRect(Native.addressOf(bounds), WINDOW_STYLE, false) == 0
					|| Win32.setWindowPos(window, null, normalX, normalY, bounds.right - bounds.left, bounds.bottom - bounds.top, 0x24) == 0)
					return false;
			}
			Win32.showWindow(window, mode == Maximize ? 3 : mode == Minimize ? 6 : 9);
		}
		#end
		fullscreenWindow = mode == Fullscreen;
		if (mode != Minimize) present();
		return true;
	}

	override public function processEvents():Bool {
		if (window == null) return false;
		#if hl
		final state = HashLinkWindows.poll(window);
		if ((state & WINDOW_REPAINT) != 0) present();
		return (state & WINDOW_OPEN) != 0;
		#else
		var message = WinMessage.make();
		while (Win32.peekMessage(Native.addressOf(message), null, 0, 0, REMOVE_MESSAGE) != 0) {
			Win32.translateMessage(Native.addressOf(message));
			Win32.dispatchMessage(Native.addressOf(message));
			if (message.hwnd == window && message.message == PAINT_MESSAGE) present();
		}
		return Win32.isWindow(window) != 0;
		#end
	}

	override public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		final replacement = resizedFrame(width, height);
		#if hl
		final moved = HashLinkWindows.setBounds(window, x, y, width, height);
		#else
		var bounds = WinRect.make();
		bounds.right = width;
		bounds.bottom = height;
		final moved = Win32.adjustWindowRect(Native.addressOf(bounds), WINDOW_STYLE, false) != 0
			&& Win32.setWindowPos(window, null, x, y, bounds.right - bounds.left, bounds.bottom - bounds.top, KEEP_Z_ORDER | KEEP_FOCUS) != 0;
		#end
		if (!moved) throw new ScreenError("Windows could not change the screen bounds");
		normalX = x;
		normalY = y;
		#if !hl
		if ((width != frame.width || height != frame.height) && !D3D11Device.resizeWindow(gpuWindow, width, height))
			throw new ScreenError("Could not resize the Direct3D 11 swapchain");
		#end
		frame = replacement;
		present();
	}


	override public function hasWindow():Bool return window != null;

	override public function present():Bool {
		if (window == null) return false;
		#if hl
		return HashLinkWindows.present(window, DesktopImageStorage.pixels(frame));
		#else
		return Win32.isWindow(window) != 0 && D3D11Device.present(gpuWindow, DesktopImageStorage.pixels(frame));
		#end
	}

	override public function dispose():Void {
		#if !hl
		if (gpuWindow != null) D3D11Device.closeWindow(gpuWindow);
		gpuWindow = null;
		#end
		if (window != null) {
			#if hl
			HashLinkWindows.close(window);
			#else
			if (Win32.isWindow(window) != 0) Win32.destroyWindow(window);
			#end
		}
		window = null;
		super.dispose();
	}
}
#end
