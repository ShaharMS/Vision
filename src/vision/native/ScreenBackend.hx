package vision.native;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.specifics.ScreenOptions;
import vision.exceptions.ScreenError;
import vision.native.cpu.CpuScreenBackend;
#if (js && !nodejs)
import vision.native.browser.BrowserScreenBackend;
#elseif (windows && (cpp || (hl && vision_hashlink_screen)))
import vision.native.windows.WindowsScreenBackend;
#end

/** Selects and delegates to the screen implementation available on this target. **/
@:forward(setBounds, clear, draw, drawInverted, capture, attach, detach, processEvents, waitForFrame, dispose, hasWindow)
abstract ScreenBackend(ScreenDriver) {
	public function new(x:Int, y:Int, width:Int, height:Int, options:ScreenOptions) {
		if (options.offscreen) {
			this = new CpuScreenBackend(width, height);
			return;
		}
		#if (js && !nodejs)
		if (BrowserScreenBackend.isAvailable()) {
			if (options.webGpu != null) {
				this = new vision.native.browser.WebGpuScreenDriver(x, y, width, height, options);
				return;
			}
			this = new BrowserScreenBackend(x, y, width, height, options);
			return;
		}
		#elseif (cpp && !cppia && (mac || ios) && vision_metal)
		if (options.preferGpu) {
			this = new vision.native.apple.MetalScreenBackend(x, y, width, height, options.visible);
			return;
		}
		#elseif (cpp && !cppia && vision_vulkan && vision_vulkan_screen)
		if (options.preferGpu) {
			this = new vision.native.vulkan.VulkanScreenBackend(x, y, width, height, options.visible);
			return;
		}
		#elseif (windows && (cpp || (hl && vision_hashlink_screen)))
		this = new WindowsScreenBackend(width, height, options.visible, x, y, options.preferGpu);
		return;
		#end
		this = new CpuScreenBackend(width, height);
	}
	/** Validates the drawable size before a backend allocates its frame. **/
	public static function validateSize(width:Int, height:Int):Void {
		if (width <= 0 || height <= 0 || width * 1.0 * height * 4 > 0x7fffffff - vision.ds.accelerate.PixelStorage.PIXEL_OFFSET
			#if !vision_higher_width_cap || width > 0xffff #end)
			throw new ScreenError("Invalid screen dimensions");
	}

}

/** Operations shared by windowed and in-memory screen implementations. **/
@:noCompletion
interface ScreenDriver {
	function setBounds(x:Int, y:Int, width:Int, height:Int):Void;
	function clear(color:Color):Void;
	function draw(image:Image, x:Int, y:Int):Void;
	function drawInverted(image:Image, x:Int, y:Int):Void;
	function capture():Image;
	function attach(image:Image):Bool;
	function detach(image:Image):Void;
	function processEvents():Bool;
	function waitForFrame(remaining:()->Float, complete:()->Void):Void;
	function dispose():Void;
	function hasWindow():Bool;
}
