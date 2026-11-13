package vision.native.vulkan;

#if (cpp && !cppia && vision_vulkan && vision_vulkan_screen)
import cpp.Star;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.ScreenError;
import vision.native.cpu.CpuScreenBackend;
import vision.native.vulkan.VulkanDevice.VulkanBuffer;

/** Presents Vulkan buffers through an SDL window and Vulkan swapchain. **/
@:noCompletion
class VulkanScreenBackend extends CpuScreenBackend {
	var window:Star<VulkanWindow>;

	public function new(x:Int, y:Int, width:Int, height:Int, visible:Bool) {
		super(width, height);
		window = VulkanWindowApi.openWindow(x, y, width, height, visible);
		if (window == null) throw new ScreenError("Could not open a Vulkan presentation surface");
		present();
	}

	override public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		final replacement = resizedFrame(width, height);
		if (!VulkanWindowApi.setBounds(window, x, y, width, height))
			throw new ScreenError("Could not resize the Vulkan swapchain");
		frame = replacement;
		present();
	}

	override public function clear(color:Color):Void {
		frame.accelerate().clear(color).commit(InPlace);
		present();
	}

	override public function draw(image:Image, x:Int, y:Int):Void {
		if (!frame.backend().composite(image.backend(), x, y, false)) super.draw(image, x, y);
		present();
	}

	override public function drawInverted(image:Image, x:Int, y:Int):Void {
		if (image.hasView() || !frame.backend().composite(image.backend(), x, y, true))
			super.drawInverted(image, x, y);
		else present();
	}

	function present():Void {
		if (!VulkanWindowApi.present(window, frame.backend().deviceBuffer()))
			throw new ScreenError("Could not present the Vulkan frame");
	}

	override public function attach(image:Image):Bool return image.backend().deviceBuffer() != null;
	override public function detach(image:Image):Void image.backend().detach();
	override public function processEvents():Bool return window != null && VulkanWindowApi.pollWindow(window);
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
	static function composite(target:Star<VulkanBuffer>, source:Star<VulkanBuffer>, x:Int, y:Int, invert:Bool):Bool;
	static function present(window:Star<VulkanWindow>, frame:Star<VulkanBuffer>):Bool;
}

@:include("VulkanWindow.hpp")
@:native("vision_vulkan::Window")
extern class VulkanWindow {}
#end
