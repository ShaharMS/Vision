package vision.native.cpu;

import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.native.ImageBackend;
import vision.native.ImageBackend.ImageOperation;
import vision.tools.MathTools;
import vision.native.ImageBackend.ImageSurface;

/** Packed CPU pixels and synchronization state for an optional drawing surface. **/
@:noCompletion
class CpuImage {
	final packed:ByteArray;
	public var length(get, never):Int;
	var exposed:Bool;
	public var surface(default, null):ImageSurface;
	var cpuValid = true;
	var surfaceValid = false;

	public function new(packed:ByteArray, exposed:Bool) {
		this.packed = packed;
		this.exposed = exposed;
	}

	public function exportPixels():ByteArray {
		final pixels = readPixels();
		return pixels.sub(ImageBackend.PIXEL_OFFSET, pixels.length - ImageBackend.PIXEL_OFFSET);
	}

	public function colors():Array<Color> {
		final pixels = readPixels();
		final result:Array<Color> = [];
		var offset = ImageBackend.PIXEL_OFFSET;
		while (offset < pixels.length) {
			result.push(Color.fromRGBA(pixels[offset + 1], pixels[offset + 2], pixels[offset + 3], pixels[offset]));
			offset += 4;
		}
		return result;
	}

	public var width(get, never):Int;
	public var height(get, never):Int;
	public var isGpuBacked(get, never):Bool;

	inline function get_width():Int
		return #if vision_higher_width_cap this.packed.getInt32(0) #else this.packed.getUInt16(0) #end;

	inline function get_height():Int {
		final width = get_width();
		return width == 0 ? 0 : Math.ceil((this.packed.length - ImageBackend.PIXEL_OFFSET) / (width * 4.0));
	}

	inline function get_isGpuBacked():Bool
		return this.surface != null && this.surface.isAvailable();

	public inline function readColor(position:Int):Color {
		position += ImageBackend.PIXEL_OFFSET;
		final pixels = readPixels();
		var value = pixels[position] << 24 | pixels[position + 1] << 16 | pixels[position + 2] << 8 | pixels[position + 3];
		#if (python || php || lua)
		var signedValue:haxe.Int32 = value;
		signedValue = signedValue + 0;
		value = signedValue;
		#end
		return new Color(value);
	}

	public inline function writeColor(position:Int, color:Color):Color {
		position += ImageBackend.PIXEL_OFFSET;
		final pixels = writePixels();
		pixels[position] = color.alpha;
		pixels[position + 1] = color.red;
		pixels[position + 2] = color.green;
		pixels[position + 3] = color.blue;
		return color;
	}

	inline function get_length():Int
		return this.packed.length;

	public function attach(surface:ImageSurface):Bool {
		if (this.exposed || this.surface != null) return false;
		this.surface = surface;
		return true;
	}

	public function detach():Void {
		if (this.surface != null) {
			readPixels();
			this.surface.dispose();
			this.surface = null;
			this.surfaceValid = false;
		}
	}

	public function prepareSurface():Bool {
		final surface = this.surface;
		if (surface == null || !surface.isAvailable()) return false;
		if (!this.surfaceValid) this.surfaceValid = surface.upload(this.packed);
		return this.surfaceValid;
	}

	public function transform(operation:ImageOperation, value:Int):Bool {
		if (prepareSurface() && this.surface.transform(operation, value)) {
			this.cpuValid = false;
			return true;
		}
		return false;
	}

	public function readPixels():ByteArray {
		if (!this.cpuValid) {
			this.surface.download(this.packed);
			this.cpuValid = true;
		}
		return this.packed;
	}

	public function writePixels():ByteArray {
		final pixels = readPixels();
		this.surfaceValid = false;
		return pixels;
	}

	public function bytes():ByteArray {
		detach();
		this.exposed = true;
		return this.packed;
	}

	public function copy():CpuImage {
		final pixels = readPixels();
		final copy = new ByteArray(pixels.length);
		copy.blit(0, pixels, 0, pixels.length);
		return new CpuImage(copy, false);
	}

	public inline function get(index:Int):Int
		return this.packed.get(index);

	public inline function set(index:Int, value:Int):Void
		this.packed.set(index, value);

	public inline function getInt32(index:Int):Int
		return this.packed.getInt32(index);

	public inline function setInt32(index:Int, value:Int):Void
		this.packed.setInt32(index, value);

	public inline function getUInt16(index:Int):Int
		return this.packed.getUInt16(index);

	public inline function setUInt16(index:Int, value:Int):Void
		this.packed.setUInt16(index, value);

	public static function allocate(width:Int, height:Int, color:Color):CpuImage {
		final bytes = new ByteArray(width * height * 4 + ImageBackend.PIXEL_OFFSET);
		#if vision_higher_width_cap
		bytes.setInt32(0, width);
		#else
		bytes.setUInt16(0, width);
		#end
		if (color != 0) {
			var offset = ImageBackend.PIXEL_OFFSET;
			while (offset < bytes.length) {
				bytes[offset] = color.alpha;
				bytes[offset + 1] = color.red;
				bytes[offset + 2] = color.green;
				bytes[offset + 3] = color.blue;
				offset += 4;
			}
		}
		return new CpuImage(bytes, false);
	}

	public static function apply(image:Image, operation:ImageOperation, value:Int):Void {
		image.forEachPixelInView((x, y, pixel) -> {
			final color:Color = switch operation {
				case Invert: Color.fromRGBA(255 - pixel.red, 255 - pixel.green, 255 - pixel.blue);
				case SimpleGrayscale:
					final gray = Std.int((pixel.red + pixel.green + pixel.blue) / 3);
					Color.fromRGBA(gray, gray, gray);
				case Grayscale:
					final gray = Std.int(0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue);
					Color.fromRGBA(gray, gray, gray);
				case BlackAndWhite:
					MathTools.max(pixel.red, pixel.green, pixel.blue) > value ? Color.WHITE : Color.BLACK;
			};
			image.setUnsafePixel(x, y, color);
		});
	}
}
