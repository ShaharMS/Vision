package vision.native.browser;

#if (js && !nodejs)
import vision.ds.ByteArray;
import vision.ds.accelerate.PixelStorage;
import vision.exceptions.WebGpuError;
import vision.native.browser.WebGpuBatchDevice.WebGpuPixels;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.accelerate.ImageCommand;
import vision.ds.accelerate.ImageCommitMode;
import vision.ds.accelerate.ImageOperation;
import vision.native.browser.WebGlRenderer.WebGlSurface;
import vision.native.cpu.CpuImage;

/** Browser image storage with a WebGL texture and a synchronized packed pixel cache. **/
class BrowserImage extends CpuImage {
	public var surface(default, null):WebGlSurface;
	var cpuValid = true;
	var surfaceValid = false;
	var exposed:Bool;
	var webGpu:WebGpuBatchDevice;
	var resident:WebGpuPixels;

	public function new(bytes:ByteArray, exposed:Bool = false) {
		super(bytes, exposed);
		this.exposed = exposed;
	}

	public static function allocate(width:Int, height:Int, color:Color = 0):BrowserImage {
		return new BrowserImage(CpuImage.allocate(width, height, color).writePixels());
	}

	override function get_isGpuBacked():Bool return resident != null || (surface != null && surface.isAvailable());

	public function attach(surface:WebGlSurface):Bool {
		if (exposed || webGpu != null || this.surface != null) return false;
		this.surface = surface;
		return true;
	}

	public function detach():Void {
		if (surface == null) return;
		readPixels();
		surface.dispose();
		surface = null;
		surfaceValid = false;
	}

	public function prepareSurface():Bool {
		if (surface == null || !surface.isAvailable()) return false;
		if (!surfaceValid) surfaceValid = surface.upload(super.readPixels());
		return surfaceValid;
	}

	/**
		Submits a supported batch against the attached WebGL context.
		Returns null when the command sequence needs the packed-pixel executor.
	**/
	public function executeBatch(commands:Array<ImageCommand>, mode:ImageCommitMode):Null<Image> {
		final image:Image = cast this;
		if (webGpu != null && commands.length != 0) {
			final result = webGpu.commit(image, commands, mode);
			if (result != null) return result;
		}
		if (commands.length == 0 || image.hasView() || surface == null) return null;
		if (mode == InPlace && commands.length == 1) switch commands[0] {
			case Transform(operation, value) if (operation != Grayscale && transform(operation, value)): return image;
			default:
		}

		var width = image.width;
		var height = image.height;
		for (command in commands) switch command {
			case Resize(w, h, algorithm) if (w > 0 && h > 0 && (algorithm == BilinearInterpolation || algorithm == NearestNeighbor)):
				if (w * 4.0 * h > 0x7fffffff - vision.ds.accelerate.PixelStorage.PIXEL_OFFSET
					#if !vision_higher_width_cap || w > 0xffff #end) return null;
				width = w;
				height = h;
			case Convolve(kernel) if (kernel.width * kernel.height <= 81):
			case ConvolveAxis(weights, _) if (weights.length <= 81):
			case Transform(operation, _) if (operation != Grayscale):
			case FillRectangle(bounds, _) if (bounds.x >= 0 && bounds.y >= 0 && bounds.width >= 0 && bounds.height >= 0
				&& bounds.width <= width - bounds.x && bounds.height <= height - bounds.y):
			default: return null;
		}
		if (mode == InPlace && (width != image.width || height != image.height)) return null;
		if (!prepareSurface()) return null;

		var current = surface;
		for (command in commands) {
			final next = switch command {
				case Resize(w, h, algorithm):
					final bilinear = algorithm == BilinearInterpolation;
					final stepX = current.width / w - (bilinear ? 1 / w : 0);
					final stepY = current.height / h - (bilinear ? 1 / h : 0);
					current.filter(w, h, bilinear ? 0 : 1, stepX, stepY);
				case Convolve(kernel):
					current.filter(current.width, current.height, 2, 0, 0, kernel.width, kernel.height, kernel.underlying.inner);
				case ConvolveAxis(weights, vertical):
					current.filter(current.width, current.height, 3, 0, 0, vertical ? 1 : weights.length, vertical ? weights.length : 1, weights);
				case Transform(operation, value):
					final target = current == surface ? current.filter(current.width, current.height, 1, 1, 1) : current;
					if (target == null || target.transform(operation, value)) target else {
						if (target != current) target.dispose();
						null;
					}
				case FillRectangle(bounds, color):
					final target = current == surface ? current.filter(current.width, current.height, 1, 1, 1) : current;
					if (target == null || target.fillRect(bounds, color)) target else {
						if (target != current) target.dispose();
						null;
					}
				default: null;
			};
			if (current != surface && current != next) current.dispose();
			if (next == null) return null;
			current = next;
		}

		final result = mode == InPlace ? this : allocate(width, height);
		if (result.surface != null) result.surface.dispose();
		result.surface = current;
		result.surfaceValid = true;
		result.cpuValid = false;
		if (current.owner.onImageAttached != null) current.owner.onImageAttached(result, current);
		return cast result;
	}

	public function transform(operation:ImageOperation, value:Int):Bool {
		if (!prepareSurface() || !surface.transform(operation, value)) return false;
		cpuValid = false;
		return true;
	}

	@:allow(vision.native.browser.WebGpuBatchDevice)
	function attachWebGpu(device:WebGpuBatchDevice):Bool {
		if (exposed || surface != null || (webGpu != null && webGpu != device)) return false;
		webGpu = device;
		return true;
	}

	@:allow(vision.native.browser.WebGpuBatchDevice)
	function adoptWebGpu(device:WebGpuBatchDevice, pixels:WebGpuPixels):Void {
		releaseWebGpu();
		webGpu = device;
		resident = pixels;
		cpuValid = false;
	}

	@:allow(vision.native.browser.WebGpuBatchDevice)
	function webGpuPixels(device:WebGpuBatchDevice):Null<WebGpuPixels> return webGpu == device ? resident : null;

	public function readbackWebGpu():js.lib.Promise<Image> {
		final pixels = resident;
		if (pixels == null || cpuValid) return js.lib.Promise.resolve(cast this);
		final packed = super.readPixels();
		return webGpu.download(pixels).then(bytes -> {
			if (resident != pixels) throw new WebGpuError("The image changed during readback.");
			packed.blit(PixelStorage.PIXEL_OFFSET, bytes, 0, bytes.length);
			cpuValid = true;
			return (cast this : Image);
		});
	}

	public function detachWebGpu():Void {
		readPixels();
		releaseWebGpu();
		webGpu = null;
	}

	function releaseWebGpu():Void {
		if (resident != null) resident.buffer.destroy();
		resident = null;
	}

	override public function readPixels():ByteArray {
		final bytes = super.readPixels();
		if (!cpuValid) {
			if (resident != null) throw new WebGpuError("Call readbackWebGpu() before accessing WebGPU pixels on the CPU.");
			surface.download(bytes);
			cpuValid = true;
		}
		return bytes;
	}

	override public function writePixels():ByteArray {
		final bytes = readPixels();
		releaseWebGpu();
		surfaceValid = false;
		return bytes;
	}

	override public function bytes():ByteArray {
		readPixels();
		releaseWebGpu();
		webGpu = null;
		detach();
		exposed = true;
		return super.bytes();
	}

	override public function copy():BrowserImage {
		final pixels = readPixels();
		final result = new ByteArray(pixels.length);
		result.blit(0, pixels, 0, pixels.length);
		return new BrowserImage(result);
	}
}
#end
