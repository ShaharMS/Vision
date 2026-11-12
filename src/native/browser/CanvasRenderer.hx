package native.browser;

#if js
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageData;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageStorage;
import native.browser.BrowserPixels;
import native.browser.WebGlRenderer;
import native.browser.WebGlRenderer.WebGlSurface;
import vision.exceptions.VisionException;

/** Draws Vision images in caller order using a dedicated browser canvas. **/
@:noCompletion
class CanvasRenderer {
	public final canvas:CanvasElement;
	public var usesWebGl(get, never):Bool;

	final pixels = new BrowserPixels();
	final attached = new Array<ImageStorage>();
	final gpu:WebGlRenderer;
	final context:CanvasRenderingContext2D;
	final staging:CanvasElement;
	final stagingContext:CanvasRenderingContext2D;
	var imageData:ImageData;
	var disposed = false;

	/** Prefer WebGL 2 where available. Pass false to request Canvas 2D directly. **/
	public function new(canvas:CanvasElement, preferWebGl:Bool = true, preserve:Bool = false) {
		this.canvas = canvas;
		final gl = preferWebGl ? canvas.getContextWebGL2({preserveDrawingBuffer: preserve}) : null;
		if (gl != null) {
			gpu = new WebGlRenderer(gl);
		} else {
			context = canvas.getContext2d();
			if (context == null) throw new VisionException("The canvas has no compatible drawing context", "CanvasRenderer");
			staging = Browser.document.createCanvasElement();
			stagingContext = staging.getContext2d();
		}
	}

	inline function get_usesWebGl():Bool {
		return gpu != null;
	}

	/**
		Associates an image with this renderer's WebGL context so eligible Vision
		operations can keep their results on the device.
		Returns false when the context, image size, or mutable byte access requires CPU storage.
	**/
	public function attach(image:Image):Bool {
		checkOpen();
		if (gpu == null) return false;
		final storage = image.storage();
		if (owns(storage)) return image.isGpuBacked;
		if (storage.surface != null) return false;

		final surface = gpu.createSurface(image.width, image.height);
		if (surface == null) return false;
		if (!surface.isAvailable() || !storage.attach(surface)) {
			surface.dispose();
			return false;
		}
		attached.push(storage);
		surface.onDispose = () -> {
			attached.remove(storage);
		};
		return true;
	}

	/** Materializes the image's pixels and releases this renderer's texture. **/
	public function detach(image:Image):Void {
		final storage = image.storage();
		if (owns(storage)) storage.detach();
	}

	function owns(storage:ImageStorage):Bool {
		return storage.surface is WebGlSurface && (cast storage.surface : WebGlSurface).owner == gpu;
	}

	/** Draw at a position in canvas pixels with source-over alpha blending. **/
	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		drawPixels(image, x, y, false);
	}

	/** Draw as if Vision.invert had been applied, leaving the source image untouched. **/
	public function drawInverted(image:Image, x:Int = 0, y:Int = 0):Void {
		checkOpen();
		if (gpu != null && !image.hasView()) drawPixels(image, x, y, true);
		else draw(Vision.invert(image.clone()), x, y);
	}

	function drawPixels(image:Image, x:Int, y:Int, invert:Bool):Void {
		checkOpen();
		final width = image.width;
		final height = image.height;
		if (width <= 0 || height <= 0 || canvas.width <= 0 || canvas.height <= 0) return;
		final storage = image.storage();
		if (gpu != null && owns(storage) && storage.prepareSurface()) {
			final surface:WebGlSurface = cast storage.surface;
			gpu.presentTexture(surface.texture, width, height, x, y, canvas.width, canvas.height, invert);
			return;
		}
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
	public function clear(color:Color = 0x00000000):Void {
		checkOpen();
		if (gpu != null) {
			gpu.clear(color);
		} else {
			context.clearRect(0, 0, canvas.width, canvas.height);
			if (color.alpha != 0) {
				context.fillStyle = 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha / 255})';
				context.fillRect(0, 0, canvas.width, canvas.height);
			}
		}
	}

	/** Releases the renderer's backing resources. **/
	public function dispose():Void {
		if (disposed) return;
		for (storage in attached.copy()) {
			if (owns(storage)) storage.detach();
		}
		attached.resize(0);
		disposed = true;
		pixels.rgba = null;
		imageData = null;
		if (gpu != null) gpu.dispose();
		else staging.width = staging.height = 0;
	}

	inline function checkOpen():Void {
		if (disposed) throw new VisionException("The canvas renderer has been disposed", "CanvasRenderer");
	}
}
#end
