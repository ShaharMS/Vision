package vision.ds;

#if (vision_native && (cpp || hl))
import vision.formats.__internal.NativeImageIO;
#end

@:noCompletion
abstract ImageStorage(ImageData) {
	public static inline final FIELD_BYTES = #if vision_higher_width_cap 4 #else 2 #end;
	public static inline final PIXEL_OFFSET = FIELD_BYTES * 5 + 1;

	public var length(get, never):Int;
	public var surface(get, never):ImageSurface;

	public inline function new(bytes:ByteArray, exposed:Bool = false) {
		this = new ImageData(bytes, exposed);
	}

	public static inline function allocate(width:Int, height:Int):ImageStorage {
		final bytes = new ByteArray(width * height * 4 + PIXEL_OFFSET);
		#if vision_higher_width_cap
		bytes.setInt32(0, width);
		#else
		bytes.setUInt16(0, width);
		#end
		return new ImageStorage(bytes);
	}

	inline function get_length():Int
		return this.packed.length;

	inline function get_surface():ImageSurface
		return this.surface;

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

	public function transform(operation:ImageOperation):Bool {
		if (prepareSurface() && this.surface.transform(operation)) {
			this.cpuValid = false;
			return true;
		}
		#if (vision_native && (cpp || hl))
		final pixels = writePixels();
		return NativeImageIO.transform(pixels.getData(), pixels.length, PIXEL_OFFSET, operation);
		#else
		return false;
		#end
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

	public function copy():ImageStorage {
		final pixels = readPixels();
		final copy = new ByteArray(pixels.length);
		copy.blit(0, pixels, 0, pixels.length);
		return new ImageStorage(copy);
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

	@:arrayAccess inline function read(index:Int):Int {
		return readPixels()[index];
	}

	@:arrayAccess inline function write(index:Int, value:Int):Void {
		final pixels = writePixels();
		pixels[index] = value;
	}
}

private class ImageData {
	public final packed:ByteArray;
	public var exposed:Bool;
	public var surface:ImageSurface;
	public var cpuValid = true;
	public var surfaceValid = false;

	public function new(packed:ByteArray, exposed:Bool) {
		this.packed = packed;
		this.exposed = exposed;
	}
}

@:noCompletion
interface ImageSurface {
	function isAvailable():Bool;
	function upload(packed:ByteArray):Bool;
	function download(packed:ByteArray):Void;
	function transform(operation:ImageOperation):Bool;
	function dispose():Void;
}

@:noCompletion
enum abstract ImageOperation(Int) to Int {
	var Invert = 1;
	var SimpleGrayscale = 2;
}
