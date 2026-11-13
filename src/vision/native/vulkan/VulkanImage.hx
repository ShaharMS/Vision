package vision.native.vulkan;

#if (cpp && !cppia && vision_vulkan)
import cpp.NativeArray;
import cpp.Star;
import cpp.vm.Gc;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.accelerate.ImageCommand;
import vision.ds.accelerate.ImageCommitMode;
import vision.ds.accelerate.PixelStorage;
import vision.exceptions.VisionError;
import vision.native.cpu.CpuImage;
import vision.native.vulkan.VulkanDevice.VulkanBuffer;

/** Vulkan image storage with a lazy storage buffer and a synchronized ARGB cache. **/
@:build(vision.native.vulkan.VulkanBuild.configure())
class VulkanImage extends CpuImage {
	var buffer:Star<VulkanBuffer>;
	var cpuValid = true;
	var exposed:Bool;

	public function new(bytes:ByteArray, exposed:Bool = false) {
		super(bytes, exposed);
		this.exposed = exposed;
		Gc.setFinalizer(this, cpp.Callable.fromStaticFunction(finalize));
	}

	static function finalize(image:VulkanImage):Void {
		image.releaseBuffer();
	}

	public static function allocate(width:Int, height:Int, color:Color = 0):VulkanImage {
		return new VulkanImage(CpuImage.allocate(width, height, color).writePixels());
	}

	override function get_isGpuBacked():Bool return buffer != null;

	/** Uploads the packed pixels once, unless the image exposes writable bytes. **/
	public function deviceBuffer():Star<VulkanBuffer> {
		if (buffer == null && !exposed && width > 0 && height > 0) {
			final pixels = super.readPixels();
			buffer = VulkanDevice.upload(width, height, NativeArray.address(pixels.getData(), PixelStorage.PIXEL_OFFSET).constRaw);
		}
		return buffer;
	}

	#if vision_vulkan_screen
	/** Composites an image into this buffer without materializing packed pixels. **/
	public function composite(source:VulkanImage, x:Int, y:Int, invert:Bool):Bool {
		final destination = deviceBuffer();
		final input = source.deviceBuffer();
		if (destination == null || input == null ||
			!vision.native.vulkan.VulkanScreenBackend.VulkanWindowApi.composite(destination, input, x, y, invert)) return false;
		cpuValid = false;
		return true;
	}
	#end

	public function detach():Void {
		readPixels();
		releaseBuffer();
	}

	function releaseBuffer():Void {
		if (buffer != null) VulkanDevice.release(buffer);
		buffer = null;
	}

	override public function readPixels():ByteArray {
		final bytes = super.readPixels();
		if (!cpuValid) {
			if (!VulkanDevice.download(buffer, NativeArray.address(bytes.getData(), PixelStorage.PIXEL_OFFSET).raw))
				throw new VisionError("Could not read the Vulkan buffer.", "Vulkan");
			cpuValid = true;
		}
		return bytes;
	}

	override public function writePixels():ByteArray {
		final bytes = readPixels();
		releaseBuffer();
		return bytes;
	}

	override public function bytes():ByteArray {
		detach();
		exposed = true;
		return super.bytes();
	}

	override public function copy():VulkanImage {
		final bytes = super.readPixels();
		final result = new ByteArray(bytes.length);
		result.blit(0, bytes, 0, bytes.length);
		final copy = new VulkanImage(result);
		if (buffer != null) {
			copy.buffer = pass(buffer, width, height, 1, 0, 1, 1);
			copy.cpuValid = cpuValid;
			if (copy.buffer == null && !cpuValid) {
				result.blit(0, readPixels(), 0, bytes.length);
				copy.cpuValid = true;
			}
		}
		return copy;
	}

	public function executeBatch(commands:Array<ImageCommand>, mode:ImageCommitMode):Null<Image> {
		final image:Image = cast this;
		if (commands.length == 0 || image.hasView() || exposed) return null;
		var w = width;
		var h = height;
		for (command in commands) switch command {
			case Resize(nw, nh, algorithm) if (nw > 0 && nh > 0 && nw <= 16384 && nh <= 16384
				&& (algorithm == BilinearInterpolation || algorithm == NearestNeighbor)):
				w = nw;
				h = nh;
			case Convolve(kernel) if (kernel.width * kernel.height <= 81):
			case ConvolveAxis(weights, _) if (weights.length <= 81):
			case Clear(_), Transform(_, _):
			case FillRectangle(bounds, _) if (bounds.x >= 0 && bounds.y >= 0 && bounds.width >= 0 && bounds.height >= 0
				&& bounds.width <= w - bounds.x && bounds.height <= h - bounds.y):
			default: return null;
		}
		if (mode == InPlace && (w != width || h != height)) return null;
		final source = deviceBuffer();
		if (source == null) return null;
		var current = source;
		w = width;
		h = height;
		for (command in commands) {
			var next:Star<VulkanBuffer> = null;
			switch command {
				case Resize(nw, nh, algorithm):
					final bilinear = algorithm == BilinearInterpolation;
					final result = pass(current, nw, nh, bilinear ? 0 : 1, 0,
						w / nw - (bilinear ? 1 / nw : 0), h / nh - (bilinear ? 1 / nh : 0));
					w = nw;
					h = nh;
					next = result;
				case Convolve(kernel):
					next = pass(current, w, h, 2, 0, 0, 0, kernel.width, kernel.height, kernel.underlying.inner);
				case ConvolveAxis(weights, vertical):
					next = pass(current, w, h, 3, 0, 0, 0, vertical ? 1 : weights.length, vertical ? weights.length : 1, weights);
				case Transform(operation, value):
					final shader = switch operation {
						case Invert: 4;
						case SimpleGrayscale: 5;
						case BlackAndWhite: 6;
						case Grayscale: 8;
					};
					next = pass(current, w, h, shader, value, 0, 0);
				case Clear(color):
					next = pass(current, w, h, 7, packedColor(color), 0, 0, 0, 0, null, 0, 0, w, h);
				case FillRectangle(bounds, color):
					next = pass(current, w, h, 7, packedColor(color), 0, 0, 0, 0, null, bounds.x, bounds.y, bounds.width, bounds.height);
				default:
			};
			if (current != source) VulkanDevice.release(current);
			if (next == null) return null;
			current = next;
		}
		final result = mode == InPlace ? this : allocate(w, h);
		result.releaseBuffer();
		result.buffer = current;
		result.cpuValid = false;
		return cast result;
	}

	static inline function packedColor(color:Color):Int {
		return color.alpha | (color.red << 8) | (color.green << 16) | (color.blue << 24);
	}

	static inline function pass(input:Star<VulkanBuffer>, width:Int, height:Int, mode:Int, value:Int, stepX:Float, stepY:Float,
			kernelWidth:Int = 0, kernelHeight:Int = 0, ?weights:Array<Float>, x:Int = 0, y:Int = 0, w:Int = 0, h:Int = 0):Star<VulkanBuffer> {
		if (weights == null)
			return VulkanDevice.filter(input, width, height, mode, value, stepX, stepY, kernelWidth, kernelHeight, x, y, w, h, null);
		final bytes = new ByteArray(weights.length * 8);
		for (i in 0...weights.length) bytes.setDouble(i * 8, weights[i]);
		return VulkanDevice.filter(input, width, height, mode, value, stepX, stepY, kernelWidth, kernelHeight, x, y, w, h,
			NativeArray.address(bytes.getData(), 0).constRaw);
	}
}
#end
