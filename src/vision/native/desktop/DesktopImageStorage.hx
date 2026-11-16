package vision.native.desktop;

#if ((cpp && !cppia && (windows || mac || vision_vulkan)) || (hl && windows && vision_hashlink_screen))
#if cpp
import cpp.NativeArray;
import cpp.Star;
import cpp.vm.Gc;
#end
using Lambda;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.accelerate.ImageCommand;
import vision.ds.accelerate.ImageCommitMode;
import vision.exceptions.VisionError;
import vision.native.ImageBackend;
import vision.native.ImageBackend.DeviceImageStorage;
import vision.native.ImageBackend.ImageOperation;
#if hl
import vision.native.windows.HashLinkWindows as Device;
import vision.native.windows.HashLinkWindows.HashLinkTexture as Resource;
#elseif windows
import vision.native.windows.D3D11Device as Device;
import vision.native.windows.D3D11Device.D3D11Texture as Resource;
#elseif mac
import vision.native.apple.MetalDevice as Device;
import vision.native.apple.MetalDevice.MetalBuffer as Resource;
#else
import vision.native.linux.VulkanDevice as Device;
import vision.native.linux.VulkanDevice.VulkanBuffer as Resource;
#end

private typedef DesktopResource = #if hl Resource #else Star<Resource> #end;

/** Keeps ARGB pixels on the desktop GPU until CPU pixel access requires a download. **/
#if hl
#elseif windows
@:build(vision.native.windows.D3D11Build.configure())
#elseif mac
@:build(vision.native.apple.MetalBuild.configure())
#else
@:build(vision.native.linux.VulkanBuild.configure())
#end
@:noCompletion
class DesktopImageStorage implements DeviceImageStorage {
	final width:Int;
	final height:Int;
	var resource:DesktopResource;

	function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;
		#if cpp
		Gc.setFinalizer(this, cpp.Callable.fromStaticFunction(finalize));
		#end
	}

	static function finalize(storage:DesktopImageStorage):Void storage.dispose();

	public static function prepare(image:Image):DesktopImageStorage {
		if (image.width == 0 || image.height == 0 || !Device.available()) return null;
		final backend = image.backend();
		if (backend.deviceStorage == null && !backend.bindDeviceStorage(new DesktopImageStorage(image.width, image.height))) return null;
		return backend.prepareDeviceStorage() ? cast backend.deviceStorage : null;
	}

	public static function pixels(image:Image):DesktopResource {
		final storage = prepare(image);
		return storage == null ? null : storage.resource;
	}

	public static function composite(target:Image, source:Image, x:Int, y:Int, invert:Bool):Bool {
		final input = pixels(source);
		final output = pixels(target);
		if (input == null || output == null || input == output) return false;
		final ok = #if windows Device.draw(output, input, x, y, invert) #else Device.composite(output, input, x, y, invert) #end;
		if (ok) target.backend().markDeviceWritten();
		return ok;
	}

	public function isAvailable():Bool return Device.available();

	public function upload(packed:ByteArray):Bool {
		final next = #if hl
			Device.upload(width, height, packed.getData(), ImageBackend.PIXEL_OFFSET);
		#else
			Device.upload(width, height, NativeArray.address(packed.getData(), ImageBackend.PIXEL_OFFSET).constRaw);
		#end
		if (next == null) return false;
		replace(next);
		return true;
	}

	public function download(packed:ByteArray):Void {
		final ok = #if hl
			Device.download(resource, packed.getData(), ImageBackend.PIXEL_OFFSET);
		#else
			Device.download(resource, NativeArray.address(packed.getData(), ImageBackend.PIXEL_OFFSET).raw);
		#end
		if (!ok)
			throw new VisionError("Could not download GPU image pixels.", "Image");
	}

	public function dispose():Void replace(null);

	function replace(next:DesktopResource):Void {
		if (resource != null) Device.release(resource);
		resource = next;
	}

	public function transform(operation:ImageOperation, value:Int):Bool {
		final next = pass(resource, width, height, transformMode(operation), value);
		if (next == null) return false;
		replace(next);
		return true;
	}

	public static function execute(source:Image, commands:Array<ImageCommand>, mode:ImageCommitMode):Image {
		if (source.hasView() || commands.length == 0) return null;
		var width = source.width;
		var height = source.height;
		for (command in commands) switch command {
			case Resize(w, h, algorithm) if (w > 0 && h > 0 && w <= 16384 && h <= 16384
				&& w * 1.0 * h * 4 <= 0x7fffffff - ImageBackend.PIXEL_OFFSET
				&& (algorithm == BilinearInterpolation || algorithm == NearestNeighbor)):
				width = w;
				height = h;
			case Clear(_), Transform(_, _):
			case FillRectangle(bounds, _) if (bounds.x >= 0 && bounds.y >= 0 && bounds.width >= 0 && bounds.height >= 0
				&& bounds.width <= width - bounds.x && bounds.height <= height - bounds.y):
			case Convolve(kernel) if (kernel.width > 0 && kernel.height > 0 && kernel.width % 2 == 1 && kernel.height % 2 == 1
				&& kernel.width * 1.0 * kernel.height <= 81 && kernel.underlying.length == kernel.width * kernel.height
				&& !kernel.underlying.inner.exists(weight -> !Math.isFinite(weight))):
			case ConvolveAxis(weights, _) if (weights.length <= 81):
			default: return null;
		}
		if (mode == InPlace && (width != source.width || height != source.height)) return null;

		final storage = prepare(source);
		if (storage == null) return null;
		final original = storage.resource;
		var current = original;
		width = source.width;
		height = source.height;
		for (command in commands) {
			final next:DesktopResource = switch command {
				case Resize(w, h, algorithm):
					final bilinear = algorithm == BilinearInterpolation;
					final output = pass(current, w, h, bilinear ? 0 : 1, 0,
						(width - (bilinear ? 1 : 0)) / w, (height - (bilinear ? 1 : 0)) / h);
					width = w;
					height = h;
					output;
				case Convolve(kernel):
					pass(current, width, height, 2, 0, 0, 0, kernel.width, kernel.height, kernel.underlying.inner);
				case ConvolveAxis(weights, vertical):
					pass(current, width, height, 2, 0, 0, 0, vertical ? 1 : weights.length, vertical ? weights.length : 1, weights);
				case Transform(operation, value):
					pass(current, width, height, transformMode(operation), value);
				case Clear(color):
					pass(current, width, height, 7, packedColor(color), 0, 0, 0, 0, null, 0, 0, width, height);
				case FillRectangle(bounds, color):
					pass(current, width, height, 7, packedColor(color), 0, 0, 0, 0, null, bounds.x, bounds.y, bounds.width, bounds.height);
				default: null;
			};
			if (current != original) Device.release(current);
			if (next == null) return null;
			current = next;
		}
		#if windows
		if (!Device.synchronize()) {
			Device.release(current);
			return null;
		}
		#end
		final result = mode == InPlace ? source : new Image(width, height);
		final output = mode == InPlace ? storage : new DesktopImageStorage(width, height);
		if (mode == NewImage) result.backend().bindDeviceStorage(output);
		output.replace(current);
		result.backend().markDeviceWritten();
		return result;
	}

	static function transformMode(operation:ImageOperation):Int return switch operation {
		case Invert: 4;
		case SimpleGrayscale: 5;
		case BlackAndWhite: 6;
		case Grayscale: 8;
	};

	static inline function packedColor(color:Color):Int {
		#if windows
		return color;
		#else
		return color.alpha | (color.red << 8) | (color.green << 16) | (color.blue << 24);
		#end
	}

	static inline function pass(input:DesktopResource, width:Int, height:Int, mode:Int, value:Int, stepX:Float = 0, stepY:Float = 0,
			kernelWidth:Int = 0, kernelHeight:Int = 0, ?weights:Array<Float>, x:Int = 0, y:Int = 0, w:Int = 0, h:Int = 0):DesktopResource {
		if (weights == null)
			return Device.filter(input, width, height, mode, value, stepX, stepY, kernelWidth, kernelHeight, x, y, w, h, null);
		final bytes = new ByteArray(weights.length * 8);
		for (i in 0...weights.length) bytes.setDouble(i * 8, weights[i]);
		return Device.filter(input, width, height, mode, value, stepX, stepY, kernelWidth, kernelHeight, x, y, w, h,
			#if hl bytes.getData() #else NativeArray.address(bytes.getData(), 0).constRaw #end);
	}
}
#end
