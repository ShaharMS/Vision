package vision.native.unix;

#if (cpp && !cppia && VISION_SDL_PREFIX)
import cpp.NativeArray;
import cpp.Star;
import haxe.io.Bytes;
import vision.Vision;
import vision.ds.Color;
import vision.native.ScreenBackend.ScreenWindowMode;
import vision.ds.Image;
import vision.exceptions.ScreenError;
import vision.native.ScreenBackend.ScreenDriver;
import vision.native.unix.SdlScreen.SdlWindow;

/** Composites and presents in an SDL render target and reads pixels back on capture. **/
@:noCompletion
class SdlScreenBackend implements ScreenDriver {
	var window:Star<SdlWindow>;
	var width:Int;
	var height:Int;

	public function new(x:Int, y:Int, width:Int, height:Int, visible:Bool, preferGpu:Bool) {
		window = SdlScreen.open(x, y, width, height, visible, preferGpu);
		check(window != null, "open a window and render target");
		this.width = width;
		this.height = height;
		if (!SdlScreen.present(window)) {
			final error = SdlScreen.error().toString();
			dispose();
			throw new ScreenError("SDL could not present the initial frame: " + error);
		}
	}

	public function setWindowMode(mode:ScreenWindowMode):Bool return SdlScreen.setWindowMode(window, mode);

	public function processEvents():Bool {
		final state = SdlScreen.poll(window);
		if (state == 2) present();
		return state != 0;
	}

	public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		check(SdlScreen.setBounds(window, x, y, width, height), "resize the render target");
		this.width = width;
		this.height = height;
		present();
	}

	public function clear(color:Color):Void {
		check(SdlScreen.clear(window, color.toInt()), "clear the frame");
		present();
	}

	public function draw(image:Image, x:Int, y:Int):Void {
		final pixels = image.backend().readPixels().getData();
		check(SdlScreen.draw(window, NativeArray.address(pixels, ImageBackend.PIXEL_OFFSET).constRaw, image.width, image.height, x, y),
			"draw the image");
		present();
	}

	public function drawInverted(image:Image, x:Int, y:Int):Void {
		draw(Vision.invert(image.clone()), x, y);
	}

	public function capture():Image {
		final pixels = Bytes.alloc(width * height * 4);
		check(SdlScreen.capture(window, NativeArray.address(pixels.getData(), 0).raw), "read the frame");
		return Image.loadFromBytes(pixels, width, height);
	}

	public function hasWindow():Bool return window != null;



	inline function present():Void check(SdlScreen.present(window), "present the frame");

	static function check(ok:Bool, operation:String):Void {
		if (!ok) throw new ScreenError("SDL could not " + operation + ": " + SdlScreen.error().toString());
	}

	public function dispose():Void {
		if (window != null) {
			SdlScreen.close(window);
			window = null;
		}
	}
}
#end
