package vision.native.apple;

#if (cpp && !cppia && (mac || ios) && vision_metal)
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
import vision.native.apple.MetalDevice.MetalBuffer;

/** Metal image storage with a lazy storage buffer and a synchronized ARGB cache. **/
@:build(vision.native.apple.MetalBuild.configure())
class MetalImage extends CpuImage {
	var buffer:Star<MetalBuffer>;
	var cpuValid = true;
	var exposed:Bool;

	public function new(bytes:ByteArray, exposed:Bool = false) {
		super(bytes, exposed);
		this.exposed = exposed;
		Gc.setFinalizer(this, cpp.Callable.fromStaticFunction(finalize));
	}

	static function finalize(image:MetalImage):Void {
		image.releaseBuffer();
	}

	public static function allocate(width:Int, height:Int, color:Color = 0):MetalImage {
		return new MetalImage(CpuImage.allocate(width, height, color).writePixels());
	}

	override function get_isGpuBacked():Bool return buffer != null;

	/** Uploads the packed pixels once, unless the image exposes writable bytes. **/
	public function deviceBuffer():Star<MetalBuffer> {
		if (buffer == null && !exposed && width > 0 && height > 0) {
			final pixels = super.readPixels();
			buffer = MetalDevice.upload(width, height, NativeArray.address(pixels.getData(), PixelStorage.PIXEL_OFFSET).constRaw);
		}
		return buffer;
	}

	/** Composites into this image on the Metal device. **/
	public function composite(source:MetalImage, x:Int, y:Int, invert:Bool):Bool {
		if (!MetalDevice.composite(deviceBuffer(), source.deviceBuffer(), x, y, invert)) return false;
		cpuValid = false;
		return true;
	}

	public function detach():Void {
		readPixels();
		releaseBuffer();
	}

	function releaseBuffer():Void {
		if (buffer != null) MetalDevice.release(buffer);
		buffer = null;
	}

	override public function readPixels():ByteArray {
		final bytes = super.readPixels();
		if (!cpuValid) {
			if (!MetalDevice.download(buffer, NativeArray.address(bytes.getData(), PixelStorage.PIXEL_OFFSET).raw))
				throw new VisionError("Could not read the Metal buffer.", "Metal");
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

	override public function copy():MetalImage {
		final bytes = super.readPixels();
		final result = new ByteArray(bytes.length);
		result.blit(0, bytes, 0, bytes.length);
		final copy = new MetalImage(result);
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
			var next:Star<MetalBuffer> = null;
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
			if (current != source) MetalDevice.release(current);
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

	static inline function pass(input:Star<MetalBuffer>, width:Int, height:Int, mode:Int, value:Int, stepX:Float, stepY:Float,
			kernelWidth:Int = 0, kernelHeight:Int = 0, ?weights:Array<Float>, x:Int = 0, y:Int = 0, w:Int = 0, h:Int = 0):Star<MetalBuffer> {
		if (weights == null)
			return MetalDevice.filter(input, width, height, mode, value, stepX, stepY, kernelWidth, kernelHeight, x, y, w, h, null);
		final bytes = new ByteArray(weights.length * 8);
		for (i in 0...weights.length) bytes.setDouble(i * 8, weights[i]);
		return MetalDevice.filter(input, width, height, mode, value, stepX, stepY, kernelWidth, kernelHeight, x, y, w, h,
			NativeArray.address(bytes.getData(), 0).constRaw);
	}
}
#end
