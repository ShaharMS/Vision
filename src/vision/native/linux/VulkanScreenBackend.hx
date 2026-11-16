package vision.native.linux;

#if (cpp && !cppia && vision_vulkan)
import cpp.Star;
import vision.exceptions.ScreenError;
import vision.native.DesktopImageStorage;
import vision.native.DesktopScreenBackend;
import vision.native.ScreenBackend.ScreenWindowMode;
import vision.native.linux.VulkanDevice.VulkanBuffer;

/** Presents Vulkan buffers through Wayland or X11. Wayland compositors place top-level windows. **/
@:noCompletion
class VulkanScreenBackend extends DesktopScreenBackend {
	var window:Star<VulkanWindow>;

	public function new(x:Int, y:Int, width:Int, height:Int, visible:Bool) {
		super(width, height);
		window = VulkanWindowApi.openWindow(x, y, width, height, visible);
		if (window == null) throw new ScreenError("Could not open a Vulkan presentation surface");
		try presentFrame() catch (error:Dynamic) {
			dispose();
			throw error;
		}
	}

	override public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		final replacement = resizedFrame(width, height);
		if (!VulkanWindowApi.setBounds(window, x, y, width, height))
			throw new ScreenError("Could not resize the Vulkan swapchain");
		frame = replacement;
		presentFrame();
	}

	override public function present():Bool return VulkanWindowApi.present(window, DesktopImageStorage.pixels(frame));

	override public function setWindowMode(mode:ScreenWindowMode):Bool {
		return VulkanWindowApi.setWindowMode(window, mode) && (mode == Minimize || present());
	}
	override public function processEvents():Bool {
		if (window == null || !VulkanWindowApi.pollWindow(window)) return false;
		if (VulkanWindowApi.needsRepaint(window)) presentFrame();
		return true;
	}
	override public function hasWindow():Bool return window != null;

	override public function dispose():Void {
		if (window != null) VulkanWindowApi.closeWindow(window);
		window = null;
		super.dispose();
	}
}

@:include("VulkanWindow.hpp")
@:native("vision_vulkan")
extern class VulkanWindowApi {
	static function openWindow(x:Int, y:Int, width:Int, height:Int, visible:Bool):Star<VulkanWindow>;
	static function closeWindow(window:Star<VulkanWindow>):Void;
	static function setBounds(window:Star<VulkanWindow>, x:Int, y:Int, width:Int, height:Int):Bool;
	static function pollWindow(window:Star<VulkanWindow>):Bool;
	static function needsRepaint(window:Star<VulkanWindow>):Bool;
	static function windowSystem(window:Star<VulkanWindow>):cpp.ConstCharStar;
	static function swapchainSizeMatches(window:Star<VulkanWindow>, width:Int, height:Int):Bool;
	static function setWindowMode(window:Star<VulkanWindow>, mode:Int):Bool;
	static function requestClose(window:Star<VulkanWindow>):Void;
	static function present(window:Star<VulkanWindow>, frame:Star<VulkanBuffer>):Bool;
}

@:include("VulkanWindow.hpp")
@:native("vision_vulkan::Window")
extern class VulkanWindow {}
#end
