package vision.native.windows;

#if (windows && cpp && !cppia)
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
import vision.native.windows.D3D11Device.D3D11Texture;

/** Windows image storage with a lazy D3D11 texture and a synchronized ARGB cache. **/
@:build(vision.native.windows.D3D11Build.configure())
class D3D11Image extends CpuImage {
	var texture:Star<D3D11Texture>;
	var cpuValid = true;
	var exposed:Bool;

	public function new(bytes:ByteArray, exposed:Bool = false) {
		super(bytes, exposed);
		this.exposed = exposed;
		Gc.setFinalizer(this, cpp.Callable.fromStaticFunction(finalize));
	}

	static function finalize(image:D3D11Image):Void {
		image.releaseTexture();
	}

	public static function allocate(width:Int, height:Int, color:Color = 0):D3D11Image {
		return new D3D11Image(CpuImage.allocate(width, height, color).writePixels());
	}

	override function get_isGpuBacked():Bool return texture != null;

	/** Uploads the packed pixels once, unless the image exposes writable bytes. **/
	public function deviceTexture():Star<D3D11Texture> {
		if (texture == null && !exposed && width > 0 && height > 0) {
			final pixels = super.readPixels();
			texture = D3D11Device.upload(width, height, NativeArray.address(pixels.getData(), PixelStorage.PIXEL_OFFSET).constRaw);
		}
		return texture;
	}

	public function drawDevice(source:D3D11Image, x:Int, y:Int, invert:Bool):Bool {
		final destination = deviceTexture();
		final input = source.deviceTexture();
		if (!D3D11Device.draw(destination, input, x, y, invert)) return false;
		cpuValid = false;
		return true;
	}

	public function detach():Void {
		readPixels();
		releaseTexture();
	}

	function releaseTexture():Void {
		if (texture != null) D3D11Device.release(texture);
		texture = null;
	}

	override public function readPixels():ByteArray {
		final bytes = super.readPixels();
		if (!cpuValid) {
			if (!D3D11Device.download(texture, NativeArray.address(bytes.getData(), PixelStorage.PIXEL_OFFSET).raw))
				throw new VisionError("Could not read the D3D11 texture.", "D3D11");
			cpuValid = true;
		}
		return bytes;
	}

	override public function writePixels():ByteArray {
		final bytes = readPixels();
		releaseTexture();
		return bytes;
	}

	override public function bytes():ByteArray {
		detach();
		exposed = true;
		return super.bytes();
	}

	override public function copy():D3D11Image {
		final bytes = super.readPixels();
		final result = new ByteArray(bytes.length);
		result.blit(0, bytes, 0, bytes.length);
		final copy = new D3D11Image(result);
		if (texture != null) {
			copy.texture = pass(texture, width, height, 1, 0, 1, 1);
			copy.cpuValid = cpuValid;
			if (copy.texture == null && !cpuValid) {
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
		final source = deviceTexture();
		if (source == null) return null;
		var current = source;
		w = width;
		h = height;
		for (command in commands) {
			var next:Star<D3D11Texture> = null;
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
					next = pass(current, w, h, 7, color, 0, 0, 0, 0, null, 0, 0, w, h);
				case FillRectangle(bounds, color):
					next = pass(current, w, h, 7, color, 0, 0, 0, 0, null, bounds.x, bounds.y, bounds.width, bounds.height);
				default:
			};
			if (current != source) D3D11Device.release(current);
			if (next == null) return null;
			current = next;
		}
		final result = mode == InPlace ? this : allocate(w, h);
		result.releaseTexture();
		result.texture = current;
		result.cpuValid = false;
		return cast result;
	}

	static inline function pass(input:Star<D3D11Texture>, width:Int, height:Int, mode:Int, value:Int, stepX:Float, stepY:Float,
			kernelWidth:Int = 0, kernelHeight:Int = 0, ?weights:Array<Float>, x:Int = 0, y:Int = 0, w:Int = 0, h:Int = 0):Star<D3D11Texture> {
		if (weights == null)
			return D3D11Device.filter(input, width, height, mode, value, stepX, stepY, kernelWidth, kernelHeight, x, y, w, h, null);
		final bytes = new ByteArray(weights.length * 8);
		for (i in 0...weights.length) bytes.setDouble(i * 8, weights[i]);
		return D3D11Device.filter(input, width, height, mode, value, stepX, stepY, kernelWidth, kernelHeight, x, y, w, h,
			NativeArray.address(bytes.getData(), 0).constRaw);
	}
}
#end
