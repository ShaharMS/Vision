package vision.tools;

#if sys
import sys.io.File;
#end
import haxe.Http;
import vision.formats.ImageIO;
#if format
import vision.formats.__internal.FormatImageLoader;
#end
import haxe.io.Path;
import haxe.crypto.Base64;
import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.exceptions.ImageLoadingFailed;
import vision.exceptions.ImageSavingFailed;
import vision.exceptions.LibraryRequired;
import vision.ds.ImageFormat;
import vision.ds.Array2D;
import vision.exceptions.Unimplemented;
import vision.exceptions.WebResponseError;
import vision.ds.ImageResizeAlgorithm;
#if js
import js.Browser;
import js.html.CanvasElement;
import vision.formats.__internal.JsImageLoader;
import vision.formats.__internal.JsImageExporter;
#end
import haxe.ds.Vector;
import vision.ds.IntPoint2D;
import vision.ds.Point2D;
import vision.ds.Color;
import vision.ds.Image;

using vision.tools.MathTools;
using StringTools;

/**
	A class used to provide extra utilities to the `Image` class.

	Those properties are not included because they are not needed for the basic functionality of that object.

	to use those utilities, use this class at the top of you file:

		using vision.tools.ImageTools;
**/
@:access(vision.ds.Image)
class ImageTools {
	/**
		The default algorithm to use when resizing an image by "brute force" (setting its `width`/`height` when `vision_allow_resize` is defined)
	**/
	public static var defaultResizeAlgorithm:ImageResizeAlgorithm = BilinearInterpolation;

	/**
		Gets an image from a file. 

		the given path can be an absolute path or a relative path. a URL is valid too.  

		**Note: On Non-`js` targets, this function requires the `format` library, and only supports PNG.**

		To install:  
		  
		`haxelib install format`

		@param image optional, if you don't want to create a new image instance (usage: `image.loadFromFile("path/to/image.png")`)
		@param path the path to the image file. On `js`, it can only be a relative path/a URL

		@returns the image object.
		@throws LibraryRequired Thrown when used on `sys` targets without installing & including `format`
		@throws ImageLoadingFailed Thrown when trying to load a corrupted file.
		@throws WebResponseError Thrown when a file loading attempt from a URL fails.
		@throws Unimplemented Thrown when used with unsupported file types.
	**/
	overload extern public static inline function loadFromFile(?image:Image, path:String, ?onComplete:Image->Void) {
		#if (!js)
			#if format
			var func:ByteArray -> Image;
			if (path.contains("://")) {
				func = switch path.split(".").pop().split("?").shift().toUpperCase() {
					case "PNG": FormatImageLoader.png;
					case "BMP": FormatImageLoader.bmp;
					case var type: {
						#if !vision_quiet
						throw new Unimplemented('Using `ImageTools.loadFromFile` with a file of type `${type}`');
						#end
						FormatImageLoader.png; // vision_quiet gonna vision_quiet i guess lol
					}
				}
				var httpRequest = new sys.Http(path);
				httpRequest.addHeader("User-Agent", "Vision");
				httpRequest.onBytes = (data) -> {
					if(onComplete != null)
						onComplete(func(data));
				}
				httpRequest.onError = msg -> {
					#if !vision_quiet
					throw new WebResponseError(path, msg);
					#end
				}
				httpRequest.request();
			} else {
				final handle = sys.io.File.getBytes(path);
				func = switch path.split(".").pop().split("?").shift().toUpperCase() {
					case "PNG": FormatImageLoader.png;
					case "BMP": FormatImageLoader.bmp;
					case var type: {
						#if !vision_quiet
						throw new Unimplemented('Using `ImageTools.loadFromFile` with a file of type `${type}`');
						#end
						FormatImageLoader.png;
					}
				}

				if(onComplete != null)
					onComplete(func(handle));
			}
			#else
				#if !vision_quiet
				throw new LibraryRequired("format", [], "ImageTools.loadFromFile", "function");
				#end
			#end
		#else
		JsImageLoader.loadAsync(path, image, onComplete);
		#end
	}
	
	/**
	    Saves an image to a path.

		**Note: this function requires the `format` library, and only supports PNG.**

		To install:

		`haxelib install format`


		@param image The image to save
		@param pathWithFileName The path to save to
		@param saveFormat An image format.
		@throws LibraryRequired Thrown when used without installing & including `format`
		@throws ImageSavingFailed Thrown when trying to save a corrupted image.
	**/
	@:deprecated("ImageTools.saveToFile() is deprecated. use ImageTools.exportToFile() instead")
	public static function saveToFile(image:Image, pathWithFileName:String, saveFormat:ImageFormat = PNG) {
		return exportToFile(image, pathWithFileName, saveFormat);
	}

	
	public static function loadFromBytes(?image:Image, bytes:ByteArray, fileFormat:ImageFormat):Image {
		image = image == null ? new Image(0, 0) : image;
		image.copyImageFrom(
			switch fileFormat {
				case VISION: cast bytes;
				case PNG: ImageIO.from.bytes.png(bytes);
				case BMP: ImageIO.from.bytes.bmp(bytes);
				case JPEG: ImageIO.from.bytes.jpeg(bytes);
				default: {
					#if !vision_quiet
					throw new Unimplemented('Using `ImageTools.fromBytes` with a file of type `${fileFormat}`');
					#end
					ImageIO.from.bytes.png(bytes);
				}
			}
		);

		return image;
	}

	overload extern public static inline function loadFromFile(?image:Image, path:String):Image {
		#if js
		return image.copyImageFrom(JsImageLoader.loadFileSync(path));
		#else
		return loadFromBytes(image, File.getBytes(path), Path.extension(path));
		#end
	}

	public static function loadFromURL(?image:Image, url:String):Image {
		#if js
		return image.copyImageFrom(JsImageLoader.loadURLSync(url));
		#else
		var http = new Http(url);
		var requestStatus = 2;
		http.onBytes = (data) -> {
			loadFromBytes(image, data, Path.extension(url));
			requestStatus = 1;
		}
		http.onError = (msg) -> {
			#if !vision_quiet
			throw new WebResponseError(url, msg);
			#end
			requestStatus = 0;
		}
		http.request();
		
		while (requestStatus == 2) {
			#if sys
			Sys.sleep(0.1);
			#end
			// This is a busy loop. Pretty bad, but there isn't really a better way.
		}
		
		if (requestStatus == 0) {
			#if !vision_quiet
			throw new WebResponseError(url, "Failed to load image");
			#end
		}
		
		return image;
		#end
	}

	public static function exportToBytes(?image:Image, format:ImageFormat):ByteArray {
		image = image == null ? new Image(0, 0) : image;
		return switch format {
			case VISION: image.underlying;
			case PNG: ImageIO.to.bytes.png(image);
			case BMP: ImageIO.to.bytes.bmp(image);
			case JPEG: ImageIO.to.bytes.jpeg(image);
			default: {
				#if !vision_quiet
				throw new Unimplemented('Using `ImageTools.toBytes` with a file of type `${format}`');
				#end
				ImageIO.to.bytes.png(image);
			}
		};
	}

	public static function exportToFile(image:Image, pathWithFileName:String, format:ImageFormat = PNG) {
		#if js
		JsImageExporter.saveToFileAsync(image, pathWithFileName, format);
		#else
		File.saveBytes(pathWithFileName, exportToBytes(image, format));
		#end
	}

	/**
		Adds an `Image` to the screen.

		**Currently, this function only works on the web**, and
		it uses an absolutely positioned canvas element.

		#### Notice - JS Only

		if you want to use this function to add an image to a web page,
		and also want to use different units than pixels, you can use the `units` parameter.

			addToScreen(image, 50, 20, {xUnits: "vw", yUnits: "vh", zIndex: 1});

		@param image the image to add.
		@param x the x position of the image.
		@param y the y position of the image.

		@returns the image object.
	**/
	public static function addToScreen(image:Image, x:Int, y:Int, ?units:{?xUnits:String, ?yUnits:String, ?zIndex:String}):Image {
		#if (!js)
		#else
		var c = js.Browser.document.createCanvasElement();

		c.width = image.width;
		c.height = image.height;

		var ctx = c.getContext2d();
		var imageData = ctx.getImageData(0, 0, image.width, image.height);
		var data = imageData.data;

		for (x in 0...image.width) {
			for (y in 0...image.height) {
				var i = (y * image.width + x) * 4;
        for (o in 0...4)
				  data[i + o] = image.underlying[i + (@:privateAccess Image.OFFSET + 1) + o];
			}
		}

		ctx.putImageData(imageData, 0, 0);

		c.style.position = "absolute";
		if (units == null) units = {};

		c.style.top = (y + units.yUnits) != null ? y + units.yUnits : y + "px";
		c.style.left = (x + units.xUnits) != null ? x + units.xUnits : x + "px";
		if (units.zIndex != null) c.style.zIndex = units.zIndex;

		js.Browser.document.body.appendChild(c);
		#end
		return image;
	}

	/**
		Gets an `Array2D` of all neighboring pixels at `x, y`.
		
		The pixels are added to the Array2D from left to right, top to bottom.
		
		@param image The image to get the neighbors in.
		@param x The x position of the pixel.
		@param y The y position of the pixel.
		@param kernelSize the width & height of the kernel.
		@return an `Array2D` of colors
	**/
	public static inline function getNeighborsOfPixel(image:Image, x:Int, y:Int, kernelSize:Int):Array2D<Color> {
		var neighbors = new Array2D(kernelSize, kernelSize);
		var i = 0;
		for (neighbor in getNeighborsOfPixelIter(image, x, y, kernelSize)) {
			neighbors.inner[i++] = neighbor;
		}
		return neighbors;
	}

	/**
		Gets an iterator over all neighboring pixels at `x, y`.

		The pixels are iterated on from left to right, top to bottom.

		@param image The image to get the neighbors in.
		@param x The x position of the pixel.
		@param y The y position of the pixel.
		@param kernelSize the width & height of the kernel.
		@param circular Whether or not the kernel is a circle, or a square. to get more "accurate" neighbors, set this to `true`. `false` by default.
		@return an `Array2D` of colors
	**/
	public static extern inline function getNeighborsOfPixelIter(image:Image, x:Int, y:Int, kernelSize:Int, circular:Bool = false):Iterator<Color> {
		return new NeighborsIterator(image, x, y, kernelSize, circular);
	}

	public static inline function grayscalePixel(pixel:Color):Color {
		final gray = #if vision_better_grayscale Std.int(0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue) #else Std.int((pixel.red
			+ pixel.green + pixel.blue) / 3) #end;
		return Color.fromRGBA(gray, gray, gray, pixel.alpha);
	}
}

private class NeighborsIterator {
	var roundedDown:Int;
	var image:Image;
	var x:Int;
	var y:Int;
	var X:Int;
	var Y:Int;
	var circular:Bool;

	public inline function new(image:Image, x:Int, y:Int, kernelSize:Int, circular:Bool = false) {
		this.image = image;
		this.roundedDown = (kernelSize - 1) >> 1;
		this.x = x;
		this.y = y;
		this.circular = circular;
		X = -roundedDown;
		Y = -roundedDown;
	}

	public inline function next():Color {
		do {
			Y += 1;
			if (Y > roundedDown) {
				Y = -roundedDown;
				X += 1;
			}
		} while (circular && ({x: X, y: Y} : Point2D).distanceBetweenPoints({x: roundedDown, y: roundedDown}) > roundedDown);
		return image.getSafePixel(x + X, y + Y);
	}

	public inline function hasNext():Bool {
		return X <= roundedDown && Y <= roundedDown;
	}
}
