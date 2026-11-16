package vision.native.browser;

#if js
import js.html.CanvasElement;
import js.html.webgl.WebGL2RenderingContext;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;
import vision.native.ImageBackend;
import vision.native.browser.CanvasRenderer.CanvasScreenRenderer;

/** Composites source pixels and attached image textures into a WebGL canvas. **/
@:noCompletion
class WebGLScreen implements CanvasScreenRenderer {
	final canvas:CanvasElement;
	final gpu:WebGlRenderer;
	final pixels = new BrowserPixels();
	final attached = new Array<ImageBackend>();

	public function new(canvas:CanvasElement, gl:WebGL2RenderingContext) {
		this.canvas = canvas;
		gpu = new WebGlRenderer(gl);
	}

	/**
		Associates an image with this renderer's WebGL context so eligible Vision
		operations can keep their results on the device.
		Returns false when the context, image size, or mutable byte access requires CPU storage.
	**/
	public function attach(image:Image):Bool {
		final storage = image.backend();
		if (owns(storage)) return image.isGpuBacked;
		if (storage.deviceStorage != null) return false;

		final surface = gpu.createImageStorage(image.width, image.height);
		if (surface == null) return false;
		if (!surface.isAvailable() || !storage.bindDeviceStorage(surface)) {
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
		final storage = image.backend();
		if (owns(storage)) storage.releaseDeviceStorage();
	}

	function owns(storage:ImageBackend):Bool {
		return storage.deviceStorage is WebGLImageBackend && (cast storage.deviceStorage : WebGLImageBackend).owner == gpu;
	}

	/** Draw at a position in canvas pixels with source-over alpha blending. **/
	public function draw(image:Image, x:Int, y:Int):Void {
		drawPixels(image, x, y, false);
	}

	/** Draw as if Vision.invert had been applied, leaving the source image untouched. **/
	public function drawInverted(image:Image, x:Int, y:Int):Void {
		if (!image.hasView()) drawPixels(image, x, y, true);
		else draw(Vision.invert(image.clone()), x, y);
	}

	function drawPixels(image:Image, x:Int, y:Int, invert:Bool):Void {
		final width = image.width;
		final height = image.height;
		if (width <= 0 || height <= 0 || canvas.width <= 0 || canvas.height <= 0) return;
		final storage = image.backend();
		if (owns(storage) && storage.prepareDeviceStorage()) {
			final surface:WebGLImageBackend = cast storage.deviceStorage;
			gpu.presentTexture(surface.texture, width, height, x, y, canvas.width, canvas.height, invert);
			return;
		}
		final changed = pixels.update(image, width, height);
		gpu.draw(pixels.rgba, width, height, changed, x, y, canvas.width, canvas.height, invert);
	}

	public function clear(color:Color):Void gpu.clear(color);

	public function dispose():Void {
		for (storage in attached.copy()) {
			if (owns(storage)) storage.releaseDeviceStorage();
		}
		attached.resize(0);
		pixels.rgba = null;
		gpu.dispose();
	}
}
#end
