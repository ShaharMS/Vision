package vision.native;

import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.specifics.TextOptions;
import vision.algorithms.TextDrawing;
import vision.exceptions.TextDrawingError;
import vision.native.cpu.CpuImage;
#if js
import vision.native.browser.BrowserText;
#end

/** Storage and platform operations used by Image. **/
@:forward(length, surface, width, height, isGpuBacked, attach, detach, prepareSurface, transform, readPixels, writePixels, bytes,
	readColor, writeColor, exportPixels, colors, get, set, getInt32, setInt32, getUInt16, setUInt16)
abstract ImageBackend(CpuImage) {
	public static inline final FIELD_BYTES = #if vision_higher_width_cap 4 #else 2 #end;
	public static inline final PIXEL_OFFSET = FIELD_BYTES * 5 + 1;

	public inline function new(bytes:ByteArray, exposed:Bool = false) {
		this = new CpuImage(bytes, exposed);
	}

	public static inline function allocate(width:Int, height:Int, color:Color = 0):ImageBackend
		return cast CpuImage.allocate(width, height, color);

	public static function fromColors(rows:Array<Array<Color>>):ImageBackend {
		final width = rows.length == 0 ? 0 : rows[0].length;
		final backend = allocate(width, rows.length);
		var offset = 0;
		for (row in rows)
			for (color in row) {
				backend.writeColor(offset, color);
				offset += 4;
			}
		return backend;
	}

	public static function fromPixels(bytes:ByteArray, width:Int, ?height:Int):ImageBackend {
		final rows = height == null ? (width == 0 ? 0 : Math.ceil(bytes.length / (4.0 * width))) : height;
		final backend = allocate(width, rows);
		backend.writePixels().blit(PIXEL_OFFSET, bytes, 0, bytes.length);
		return backend;
	}

	public static function apply(image:Image, operation:ImageOperation, value:Int = 0):Void {
		final backend = image.backend();
		if (operation == ImageOperation.Grayscale || image.hasView() || !backend.transform(operation, value))
			CpuImage.apply(image, operation, value);
	}

	public static function drawText(image:Image, x:Int, y:Int, text:String, options:TextOptions):Void {
		TextDrawing.validateOptions(options);
		if (options.font != null) {
			TextDrawing.draw(image, x, y, text, options.font, options);
			return;
		}
		#if js
		if (js.Syntax.code("typeof document !== 'undefined'")) {
			BrowserText.draw(image, x, y, text, options);
			return;
		}
		#end
		throw new TextDrawingError("Provide a Font in TextOptions.font for portable text drawing.");
	}

	#if js
	public static function loadTextFont(family:String, bytes:haxe.io.Bytes, weight:Int, italic:Bool, ?features:String):js.lib.Promise<String> {
		return BrowserText.loadFont(family, bytes, weight, italic, features);
	}
	#end

	public inline function copy():ImageBackend return cast this.copy();

	@:arrayAccess inline function read(index:Int):Int {
		return this.readPixels()[index];
	}

	@:arrayAccess inline function write(index:Int, value:Int):Void {
		final pixels = this.writePixels();
		pixels[index] = value;
	}
}

@:noCompletion
interface ImageSurface {
	function isAvailable():Bool;
	function upload(packed:ByteArray):Bool;
	function download(packed:ByteArray):Void;
	function transform(operation:ImageOperation, value:Int):Bool;
	function dispose():Void;
}

@:noCompletion
enum abstract ImageOperation(Int) to Int {
	var Invert = 1;
	var SimpleGrayscale = 2;
	var BlackAndWhite = 3;
	var Grayscale = 4;
}
