package vision.backend;

#if (cpp && windows)
import cpp.Native;
import cpp.NativeArray;
import cpp.Star;
import vision.backend.Win32.WinBitmapHeader;
import vision.backend.Win32.WinBitmapInfo;
import vision.backend.Win32.WinMessage;
import vision.backend.Win32.WinRect;
import vision.backend.Win32.WinWindow;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.PixelFormat;
import vision.exceptions.VisionException;

/** Desktop drawing through Windows system externs. **/
@:noCompletion
class WindowsRenderer {
	static inline var WINDOW_STYLE = 0x00CA0000;
	static inline var SHOW_WINDOW = 5;
	static inline var REMOVE_MESSAGE = 1;
	static inline var PAINT_MESSAGE = 0x000F;
	static inline var COPY_SOURCE = 0x00CC0020;

	final frame:Image;
	var window:Star<WinWindow>;

	public function new(width:Int, height:Int, visible:Bool, x:Int, y:Int) {
		frame = new Image(width, height, Color.BLACK);
		var bounds = WinRect.make();
		bounds.right = width;
		bounds.bottom = height;
		Win32.adjustWindowRect(Native.addressOf(bounds), WINDOW_STYLE, false);
		window = Win32.createWindow(0, "STATIC", "Vision", WINDOW_STYLE, x, y, bounds.right - bounds.left, bounds.bottom - bounds.top, null, null,
			Win32.moduleHandle(null), null);
		if (window == null) throw new VisionException("Windows could not open a drawing window", "Screen");
		if (visible) Win32.showWindow(window, SHOW_WINDOW);
	}

	public function poll():Bool {
		var message = WinMessage.make();
		while (Win32.peekMessage(Native.addressOf(message), null, 0, 0, REMOVE_MESSAGE) != 0) {
			Win32.translateMessage(Native.addressOf(message));
			Win32.dispatchMessage(Native.addressOf(message));
			if (message.hwnd == window && message.message == PAINT_MESSAGE) present();
		}
		return window != null && Win32.isWindow(window) != 0;
	}

	public function clear(color:Color):Void {
		frame.fillRect(0, 0, frame.width, frame.height, color | 0xFF000000);
	}

	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		final left = Std.int(Math.max(0, -x));
		final top = Std.int(Math.max(0, -y));
		final right = Std.int(Math.min(image.width, frame.width - x));
		final bottom = Std.int(Math.min(image.height, frame.height - y));
		for (row in top...bottom) {
			for (column in left...right)
				frame.paintPixel(x + column, y + row, image.getPixel(column, row));
		}
	}

	public function present():Bool {
		if (window == null || Win32.isWindow(window) == 0) return false;
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
	}

	public function dispose():Void {
		if (window != null && Win32.isWindow(window) != 0) Win32.destroyWindow(window);
		window = null;
	}
}
#end
