package vision.native.browser;

#if js
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageData;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.CanvasRenderingError;
import vision.native.browser.CanvasRenderer.CanvasScreenRenderer;

/** Composites CPU image pixels through Canvas 2D. **/
@:noCompletion
class Canvas2DScreen implements CanvasScreenRenderer {
	final canvas:CanvasElement;
	final context:CanvasRenderingContext2D;
	final staging:CanvasElement;
	final stagingContext:CanvasRenderingContext2D;
	final pixels = new BrowserPixels();
	var imageData:ImageData;

	public function new(canvas:CanvasElement) {
		this.canvas = canvas;
		context = canvas.getContext2d();
		if (context == null) throw new CanvasRenderingError("The canvas has no compatible drawing context");
		staging = Browser.document.createCanvasElement();
		stagingContext = staging.getContext2d();
	}

	public function draw(image:Image, x:Int, y:Int):Void {
		final width = image.width;
		final height = image.height;
		if (width <= 0 || height <= 0 || canvas.width <= 0 || canvas.height <= 0) return;
		if (imageData == null || imageData.width != width || imageData.height != height) {
			staging.width = width;
			staging.height = height;
			imageData = stagingContext.createImageData(width, height);
		}
		if (pixels.update(image, width, height)) {
			imageData.data.set(pixels.rgba);
			stagingContext.putImageData(imageData, 0, 0);
		}
		context.drawImage(staging, x, y);
	}

	public function drawInverted(image:Image, x:Int, y:Int):Void draw(Vision.invert(image.clone()), x, y);
	public function attach(image:Image):Bool return false;
	public function detach(image:Image):Void {}

	public function clear(color:Color):Void {
		context.clearRect(0, 0, canvas.width, canvas.height);
		if (color.alpha != 0) {
			context.fillStyle = 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha / 255})';
			context.fillRect(0, 0, canvas.width, canvas.height);
		}
	}

	public function dispose():Void {
		pixels.rgba = null;
		imageData = null;
		staging.width = staging.height = 0;
	}
}
#end
