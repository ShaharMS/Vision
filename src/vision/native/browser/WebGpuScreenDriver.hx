package vision.native.browser;

#if (js && !nodejs)
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.specifics.ScreenOptions;
import vision.native.ScreenBackend.ScreenDriver;
import vision.exceptions.WebGpuError;

/** Bridges Screen to the WebGPU presentation canvas. **/
@:noCompletion
class WebGpuScreenDriver implements ScreenDriver {
	final screen:WebGpuScreen;
	var frame:Image;
	var frameX = 0;
	var frameY = 0;
	var animationFrame:Null<Int>;

	public function new(x:Int, y:Int, width:Int, height:Int, options:ScreenOptions) {
		screen = new WebGpuScreen(options.webGpu, width, height);
		screen.canvas.style.position = "absolute";
		screen.canvas.hidden = !options.visible;
		setBounds(x, y, width, height);
		clear(Color.BLACK);
	}

	public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		screen.canvas.style.left = x + "px";
		screen.canvas.style.top = y + "px";
		if (screen.canvas.width != width) screen.canvas.width = width;
		if (screen.canvas.height != height) screen.canvas.height = height;
		if (frame != null) screen.draw(frame, frameX, frameY);
	}

	public function clear(color:Color):Void draw(new Image(screen.canvas.width, screen.canvas.height, color), 0, 0);
	public function draw(image:Image, x:Int, y:Int):Void {
		frame = image;
		frameX = x;
		frameY = y;
		screen.draw(image, x, y);
	}
	public function drawInverted(image:Image, x:Int, y:Int):Void draw(image.accelerate().invert().commit(), x, y);
	public function attach(image:Image):Bool return screen.attach(image);
	public function detach(image:Image):Void image.backend().detachWebGpu();
	public function capture():Image throw new WebGpuError("Use readbackWebGpu() on the committed image before exporting.");
	public function processEvents():Bool return true;
	public function hasWindow():Bool return true;
	public function waitForFrame(remaining:()->Float, complete:()->Void):Void {
		function next(_:Float):Void {
			if (remaining() > 0.001) animationFrame = js.Browser.window.requestAnimationFrame(next);
			else {
				animationFrame = null;
				complete();
			}
		}
		animationFrame = js.Browser.window.requestAnimationFrame(next);
	}
	public function dispose():Void {
		if (animationFrame != null) js.Browser.window.cancelAnimationFrame(animationFrame);
		screen.dispose();
		frame = null;
	}
}
#end
