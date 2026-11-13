package vision.native.browser;

#if (js && !nodejs)
import js.Browser;
import js.Syntax;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.specifics.ScreenOptions;
import vision.native.ScreenBackend.ScreenDriver;

/** Presents a screen on a browser page. **/
@:noCompletion
class BrowserScreenBackend implements ScreenDriver {
	final renderer:CanvasRenderer;
	var animationFrame:Null<Int>;

	public static function isAvailable():Bool {
		return Syntax.code("typeof document !== 'undefined'") && Browser.document.body != null;
	}

	public function new(x:Int, y:Int, width:Int, height:Int, options:ScreenOptions) {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = width;
		canvas.height = height;
		canvas.style.position = "absolute";
		canvas.hidden = !options.visible;
		renderer = new CanvasRenderer(canvas, options.preferGpu, true);
		setBounds(x, y, width, height);
		renderer.clear(Color.BLACK);
		Browser.document.body.appendChild(canvas);
	}

	public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		final canvas = renderer.canvas;
		if (width != canvas.width || height != canvas.height) {
			final contents = capture();
			canvas.width = width;
			canvas.height = height;
			renderer.clear(Color.BLACK);
			renderer.draw(contents);
		}
		canvas.style.left = x + "px";
		canvas.style.top = y + "px";
		canvas.style.width = width + "px";
		canvas.style.height = height + "px";
	}

	public function clear(color:Color):Void renderer.clear(color);
	public function draw(image:Image, x:Int, y:Int):Void renderer.draw(image, x, y);
	public function drawInverted(image:Image, x:Int, y:Int):Void renderer.drawInverted(image, x, y);
	public function attach(image:Image):Bool return renderer.attach(image);
	public function detach(image:Image):Void renderer.detach(image);
	public function processEvents():Bool return true;
	public function hasWindow():Bool return true;

	public function capture():Image {
		if (!renderer.usesWebGl) return Image.fromJsCanvas(renderer.canvas);
		final copy = Browser.document.createCanvasElement();
		copy.width = renderer.canvas.width;
		copy.height = renderer.canvas.height;
		copy.getContext2d().drawImage(renderer.canvas, 0, 0);
		return Image.fromJsCanvas(copy);
	}

	public function waitForFrame(remaining:()->Float, complete:()->Void):Void {
		function nextFrame(_:Float):Void {
			if (remaining() > 0.001) {
				animationFrame = Browser.window.requestAnimationFrame(nextFrame);
			} else {
				animationFrame = null;
				complete();
			}
		}
		animationFrame = Browser.window.requestAnimationFrame(nextFrame);
	}

	public function dispose():Void {
		if (animationFrame != null) Browser.window.cancelAnimationFrame(animationFrame);
		animationFrame = null;
		renderer.dispose();
		renderer.canvas.remove();
	}
}
#end
