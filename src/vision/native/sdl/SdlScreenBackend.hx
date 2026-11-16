package vision.native.sdl;

#if (cpp && !cppia && vision_sdl_screen)
import cpp.NativeArray;
import cpp.Star;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.PixelFormat;
import vision.exceptions.ScreenError;
import vision.native.cpu.CpuScreenBackend;
import vision.native.sdl.SdlScreen.SdlWindow;

/** Presents the portable compositing buffer in an SDL desktop window. **/
@:noCompletion
class SdlScreenBackend extends CpuScreenBackend {
	var window:Star<SdlWindow>;

	public function new(x:Int, y:Int, width:Int, height:Int, visible:Bool) {
		super(width, height);
		window = SdlScreen.open(x, y, width, height, visible);
		if (window == null) throw new ScreenError("SDL could not open a window: " + SdlScreen.error().toString());
		if (!present()) {
			final error = SdlScreen.error().toString();
			dispose();
			throw new ScreenError("SDL could not present the initial frame: " + error);
		}
	}

	override public function processEvents():Bool {
		final state = SdlScreen.poll(window);
		if (state == 2) requirePresentation();
		return state != 0;
	}

	override public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		final replacement = resizedFrame(width, height);
		SdlScreen.setBounds(window, x, y, width, height);
		frame = replacement;
		requirePresentation();
	}

	override public function clear(color:Color):Void {
		super.clear(color);
		requirePresentation();
	}

	override public function draw(image:Image, x:Int, y:Int):Void {
		super.draw(image, x, y);
		requirePresentation();
	}

	override public function hasWindow():Bool return window != null;

	function present():Bool {
		final pixels = frame.exportToBytes(PixelFormat.RGBA);
		return SdlScreen.present(window, NativeArray.address(pixels.getData(), 0).raw, frame.width, frame.height);
	}

	function requirePresentation():Void {
		if (!present()) throw new ScreenError("SDL could not present the frame: " + SdlScreen.error().toString());
	}

	override public function dispose():Void {
		if (window != null) {
			SdlScreen.close(window);
			window = null;
		}
		super.dispose();
	}
}
#end
