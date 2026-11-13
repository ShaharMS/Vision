package vision.native.windows;

#if (windows && (cpp || (hl && vision_hashlink_screen)))
	#if hl
	import vision.native.hashlink.windows.HashLinkWindows;
	import vision.native.hashlink.windows.HashLinkWindows.HashLinkWindow;
	#else
	import cpp.Native;
	import cpp.NativeArray;
	import cpp.Star;
	import vision.native.windows.Win32.WinBitmapHeader;
	import vision.native.windows.Win32.WinBitmapInfo;
	import vision.native.windows.Win32.WinMessage;
	import vision.native.windows.Win32.WinRect;
	import vision.native.windows.Win32.WinWindow;
	#end
import vision.ds.Color;
import vision.native.cpu.CpuScreenBackend;
import vision.ds.Image;
import vision.ds.PixelFormat;
import vision.exceptions.ScreenError;

/** Desktop drawing through Windows system externs. **/
@:noCompletion
class WindowsScreenBackend extends CpuScreenBackend {
	#if hl
	static inline var WINDOW_OPEN = 1;
	static inline var WINDOW_REPAINT = 2;
	#else
	static inline var WINDOW_STYLE = 0x00CA0000;
	static inline var SHOW_WINDOW = 5;
	static inline var KEEP_Z_ORDER = 0x0004;
	static inline var KEEP_FOCUS = 0x0010;
	static inline var REMOVE_MESSAGE = 1;
	static inline var PAINT_MESSAGE = 0x000F;
	static inline var COPY_SOURCE = 0x00CC0020;
	#end

	#if (cpp && !cppia && !vision_vulkan)
	var gpuWindow:Star<vision.native.windows.D3D11Device.D3D11Window>;
	final preferGpu:Bool;
	#end

	var window:#if hl HashLinkWindow #else Star<WinWindow> #end;

	public function new(width:Int, height:Int, visible:Bool, x:Int, y:Int, preferGpu:Bool = true) {
		super(width, height);
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
		#if (cpp && !cppia && !vision_vulkan)
		this.preferGpu = preferGpu;
		if (preferGpu) gpuWindow = D3D11Device.openWindow(window, width, height);
		#end
		present();
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
		#if (cpp && !cppia && !vision_vulkan)
		if (gpuWindow != null) D3D11Device.closeWindow(gpuWindow);
		gpuWindow = preferGpu ? D3D11Device.openWindow(window, width, height) : null;
		#end
		frame = replacement;
		present();
	}

	override public function clear(color:Color):Void {
		super.clear(color);
		present();
	}

	override public function draw(image:Image, x:Int, y:Int):Void {
		#if (cpp && !cppia && !vision_vulkan)
		if (gpuWindow != null && frame.backend().drawDevice(image.backend(), x, y, false)) {
			present();
			return;
		}
		#end
		super.draw(image, x, y);
		present();
	}

	#if (cpp && !cppia && !vision_vulkan)
	override public function drawInverted(image:Image, x:Int, y:Int):Void {
		if (gpuWindow != null && !image.hasView() && frame.backend().drawDevice(image.backend(), x, y, true)) {
			present();
			return;
		}
		super.drawInverted(image, x, y);
	}

	override public function attach(image:Image):Bool return gpuWindow != null && image.backend().deviceTexture() != null;
	override public function detach(image:Image):Void image.backend().detach();
	#end

	override public function hasWindow():Bool return window != null;

	public function present():Bool {
		if (window == null) return false;
		#if hl
		final bytes = frame.exportToBytes(PixelFormat.BGRA);
		return HashLinkWindows.present(window, bytes.getData(), bytes.length, frame.width, frame.height);
		#else
		if (Win32.isWindow(window) == 0) return false;
		#if (!cppia && !vision_vulkan)
		if (gpuWindow != null && D3D11Device.present(gpuWindow, frame.backend().deviceTexture())) return true;
		#end
		final dc = Win32.getDC(window);
		if (dc == null) return false;

		var info = WinBitmapInfo.make();
		info.bmiHeader.biSize = Native.sizeof(WinBitmapHeader);
		info.bmiHeader.biWidth = frame.width;
		info.bmiHeader.biHeight = -frame.height;
		info.bmiHeader.biPlanes = 1;
		info.bmiHeader.biBitCount = 32;
		final bytes = frame.exportToBytes(PixelFormat.BGRA);
		final pixels = NativeArray.address(bytes.getData(), 0);
		final rows = Win32.stretchBits(dc, 0, 0, frame.width, frame.height, 0, 0, frame.width, frame.height, pixels.constRaw, Native.addressOf(info), 0,
			COPY_SOURCE);
		Win32.releaseDC(window, dc);
		return rows != 0 && rows != -1;
		#end
	}

	override public function dispose():Void {
		#if (cpp && !cppia && !vision_vulkan)
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
