package vision.backend.browser;

#if js
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageData;
import vision.Vision;
import vision.ds.Image;
import vision.exceptions.VisionException;

/** Draws Vision images in caller order using a dedicated browser canvas. **/
class CanvasRenderer {
	public final canvas:CanvasElement;
	public var usesWebGl(get, never):Bool;

	final pixels = new BrowserPixels();
	final gpu:WebGlDraw;
	final context:CanvasRenderingContext2D;
	final staging:CanvasElement;
	final stagingContext:CanvasRenderingContext2D;
	var imageData:ImageData;
	var disposed = false;

	/** Prefer WebGL 2 where available. Pass false to request Canvas 2D directly. **/
	public function new(canvas:CanvasElement, preferWebGl:Bool = true) {
		this.canvas = canvas;
		final gl = preferWebGl ? canvas.getContextWebGL2() : null;
		if (gl != null) {
			gpu = new WebGlDraw(gl);
		} else {
			context = canvas.getContext2d();
			if (context == null)
				throw new VisionException("The canvas has no compatible drawing context", "CanvasRenderer");
			staging = Browser.document.createCanvasElement();
			stagingContext = staging.getContext2d();
		}
	}

	inline function get_usesWebGl():Bool {
		return gpu != null;
	}

	/** Draw at a position in canvas pixels with source-over alpha blending. **/
	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		drawPixels(image, x, y, false);
	}

	/** Draw as if Vision.invert had been applied, leaving the source image untouched. **/
	public function drawInverted(image:Image, x:Int = 0, y:Int = 0):Void {
		checkOpen();
		if (gpu != null && !image.hasView())
			drawPixels(image, x, y, true);
		else
			draw(Vision.invert(image.clone()), x, y);
	}

	function drawPixels(image:Image, x:Int, y:Int, invert:Bool):Void {
		checkOpen();
		final width = image.width;
		final height = image.height;
		if (width <= 0 || height <= 0 || canvas.width <= 0 || canvas.height <= 0)
			return;
		final changed = pixels.update(image, width, height);
		if (gpu != null) {
			gpu.draw(pixels.rgba, width, height, changed, x, y, canvas.width, canvas.height, invert);
			return;
		}
		if (imageData == null || imageData.width != width || imageData.height != height) {
			staging.width = width;
			staging.height = height;
			imageData = stagingContext.createImageData(width, height);
		}
		if (changed) {
			imageData.data.set(pixels.rgba);
			stagingContext.putImageData(imageData, 0, 0);
		}
		context.drawImage(staging, x, y);
	}

	/** Clears the canvas to transparent before drawing the next frame. **/
	public function clear():Void {
		checkOpen();
		if (gpu != null)
			gpu.clear();
		else
			context.clearRect(0, 0, canvas.width, canvas.height);
	}

	/** Releases the renderer's backing resources. **/
	public function dispose():Void {
		if (disposed)
			return;
		disposed = true;
		pixels.rgba = null;
		imageData = null;
		if (gpu != null)
			gpu.dispose();
		else
			staging.width = staging.height = 0;
	}

	inline function checkOpen():Void {
		if (disposed)
			throw new VisionException("The canvas renderer has been disposed", "CanvasRenderer");
	}
}
#end
