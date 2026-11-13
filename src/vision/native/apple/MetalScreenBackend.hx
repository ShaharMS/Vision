package vision.native.apple;

#if (cpp && !cppia && mac && vision_metal)
import cpp.Star;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.ScreenError;
import vision.native.cpu.CpuScreenBackend;
import vision.native.apple.MetalDevice.MetalBuffer;

/** Presents Metal buffers through an AppKit window and CAMetalLayer. **/
@:noCompletion
class MetalScreenBackend extends CpuScreenBackend {
	var window:Star<MetalWindow>;

	public function new(x:Int, y:Int, width:Int, height:Int, visible:Bool) {
		super(width, height);
		window = MetalWindowApi.openWindow(x, y, width, height, visible);
		if (window == null) throw new ScreenError("Could not open a Metal presentation surface");
		present();
	}

	override public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		final replacement = resizedFrame(width, height);
		MetalWindowApi.setBounds(window, x, y, width, height);
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
		if (!MetalWindowApi.present(window, frame.backend().deviceBuffer()))
			throw new ScreenError("Could not present the Metal frame");
	}

	override public function attach(image:Image):Bool return image.backend().deviceBuffer() != null;
	override public function detach(image:Image):Void image.backend().detach();
	override public function processEvents():Bool return window != null && MetalWindowApi.pollWindow(window);
	override public function hasWindow():Bool return window != null;

	override public function dispose():Void {
		if (window != null) MetalWindowApi.closeWindow(window);
		window = null;
		super.dispose();
	}
}

@:include("MetalWindow.hpp")
@:native("vision_metal")
extern class MetalWindowApi {
	static function openWindow(x:Int, y:Int, width:Int, height:Int, visible:Bool):Star<MetalWindow>;
	static function closeWindow(window:Star<MetalWindow>):Void;
	static function setBounds(window:Star<MetalWindow>, x:Int, y:Int, width:Int, height:Int):Void;
	static function pollWindow(window:Star<MetalWindow>):Bool;
	static function present(window:Star<MetalWindow>, frame:Star<MetalBuffer>):Bool;
}

@:include("MetalWindow.hpp")
@:native("vision_metal::Window")
extern class MetalWindow {}
#end
