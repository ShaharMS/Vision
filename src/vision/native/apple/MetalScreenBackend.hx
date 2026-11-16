package vision.native.apple;

#if (cpp && !cppia && mac)
import cpp.Star;
import vision.exceptions.ScreenError;
import vision.native.desktop.DesktopImageStorage;
import vision.native.desktop.DesktopScreenBackend;
import vision.native.ScreenBackend.ScreenWindowMode;
import vision.native.apple.MetalDevice.MetalBuffer;

/** Presents Metal buffers through an AppKit window and CAMetalLayer. **/
@:noCompletion
class MetalScreenBackend extends DesktopScreenBackend {
	var window:Star<MetalWindow>;

	public function new(x:Int, y:Int, width:Int, height:Int, visible:Bool) {
		super(width, height);
		window = MetalWindowApi.openWindow(x, y, width, height, visible);
		if (window == null) throw new ScreenError("Could not open a Metal presentation surface");
		try presentFrame() catch (error:Dynamic) {
			dispose();
			throw error;
		}
	}

	override public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		final replacement = resizedFrame(width, height);
		MetalWindowApi.setBounds(window, x, y, width, height);
		frame = replacement;
		presentFrame();
	}

	override public function present():Bool return MetalWindowApi.present(window, DesktopImageStorage.pixels(frame));

	override public function setWindowMode(mode:ScreenWindowMode):Bool return MetalWindowApi.setWindowMode(window, mode);
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
	static function setWindowMode(window:Star<MetalWindow>, mode:Int):Bool;
	static function requestClose(window:Star<MetalWindow>):Void;
	static function present(window:Star<MetalWindow>, frame:Star<MetalBuffer>):Bool;
}

@:include("MetalWindow.hpp")
@:native("vision_metal::Window")
extern class MetalWindow {}
#end
