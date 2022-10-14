package vision.tools;

import vision.ds.ImageFormat;
import format.swf.Data.LineStyle;
import format.png.Tools;
import vision.ds.Array2D;
import vision.exceptions.Unimplemented;
import vision.ds.ImageResizeAlgorithm;
#if js
import js.lib.Promise;
import js.Browser;
#end
import haxe.ds.Vector;
import vision.ds.Matrix;
import vision.ds.IntPoint2D;
import vision.ds.Color;
import vision.ds.Image;

using StringTools;

/**
	A class used to provide extra utilities to the `Image` class.

	Those properties are not included because they are not needed for the basic functionality of that object.

	to use those utilities, use this class at the top of you file:

		using vision.tools.ImageTools;
**/
class ImageTools {
	/**
	 * The default algorithm to use when resizing an image by "brute force" (setting its `width`/`height` when `vision_allow_resize` is defined)
	 */
	public static var defaultResizeAlgorithm:ImageResizeAlgorithm = BilinearInterpolation;

	/**
		Gets an image from a file. 

		the given path can be an absolute path or a relative path. a URL is valid too.  

		**Note: On `sys` targets, this function requires the `format` library, and only supports PNG.**

		To install:  
		  
		`haxelib install format`

		@param image optional, if you don't want to create a new image instance (usage: `image.loadFromFile("path/to/image.png")`)
		@param path the path to the image file. on js, it can only be a relative path/a URL

		@returns the image object.
		@throws LibraryRequired Thrown when used on `sys` targets without installing & including `format`
		@throws ByteBlittingFailed Thrown when a loaded image's pixel data is corrupted, but the image type is identified (png, jpg...)
		@throws LoadingFailed Thrown when trying to load a corrupted file with a known filetype.
	**/
	public static function loadFromFile(?image:Image, path:String, onComplete:Image->Void) {
		#if sys
			#if format
			if (path.contains("://") && path.split(".").pop().toUpperCase() == "PNG") {
				var httpRequest = new sys.Http(path);
				httpRequest.onBytes = (data) -> {
					try {
						var reader = new format.png.Reader(new haxe.io.BytesInput(data));
						var data = reader.read();
						var header = format.png.Tools.getHeader(data);
						var bytes = format.png.Tools.extract32(data);
						format.png.Tools.reverseBytes(bytes);
						image = new Image(header.width, header.height);
						try {
							image.underlying.blit(4, bytes, 0, bytes.length - 1);
						} catch (e) #if !vision_quiet throw "Byte Blitting Failed: " + e.message; #end
					} catch (e:haxe.Exception) {
						#if vision_quiet
						onComplete(new Image(100, 100));
						#else
						throw "PNG Loading Failed: " + e.message;
						#end
					}

					onComplete(image);
				}
				httpRequest.onError = msg -> {
					trace(msg);
				}
				httpRequest.request();
			} else if (path.split(".").pop().toUpperCase() == "PNG") {
				try {
					var handle = sys.io.File.getBytes(path);
					var reader = new format.png.Reader(new haxe.io.BytesInput(sys.io.File.getBytes(path)));
					var data = reader.read();
					var header = format.png.Tools.getHeader(data);
					var bytes = format.png.Tools.extract32(data);
					format.png.Tools.reverseBytes(bytes);
					var image = new Image(header.width, header.height);

					// copy the ARG bytes from the PNG to the image, without overwriting the first 4 bytes
					image.underlying.blit(4, bytes, 0, bytes.length);

					onComplete(image);
				} catch (e:haxe.Exception) {
					#if vision_quiet
					onComplete(new Image(100, 100));
					#else
					throw "PNG Loading Failed: " + e.message;
					#end
				}
			} else #if !vision_quiet throw new Unimplemented(path.split(".").pop().toUpperCase() + " Decoding"); #end
			#else
				#if !vision_quiet
				throw new LibraryRequired("format", "ImageTools.loadFromFile", "function");
				#end
			#end
		#else
		var imgElement = js.Browser.document.createImageElement();
		imgElement.src = path;
		imgElement.crossOrigin = "Anonymous";
		imgElement.onload = () -> {
			var canvas = js.Browser.document.createCanvasElement();

			canvas.width = imgElement.width;
			canvas.height = imgElement.height;

			canvas.getContext2d().drawImage(imgElement, 0, 0);

			if (image == null) image = new Image(imgElement.width, imgElement.height);

			var imageData = canvas.getContext2d().getImageData(0, 0, image.width, image.height);

			var i = 0;
			while (i < imageData.data.length) {
				image.underlying[i + (@:privateAccess Image.OFFSET + 1) + 0] = imageData.data[i + 0];
				image.underlying[i + (@:privateAccess Image.OFFSET + 1) + 1] = imageData.data[i + 1];
				image.underlying[i + (@:privateAccess Image.OFFSET + 1) + 2] = imageData.data[i + 2];
				image.underlying[i + (@:privateAccess Image.OFFSET + 1) + 3] = imageData.data[i + 3];
				i += 4;
			}

			onComplete(image);
		}
		#end
	}

	public static function saveToFile(image:Image, pathWithFileName:String, saveFormat:ImageFormat = PNG) {
		#if sys
			#if format
			switch saveFormat {
				case PNG: {
					try {
						var out = sys.io.File.write(pathWithFileName);
						var writer = new format.png.Writer(out);
						var data = format.png.Tools.build32ARGB(image.width, image.height, image.underlying.sub(4, image.underlying.length - 4));
						writer.write(data);
						out.close();
					} catch (e:haxe.Exception) {
						#if !vision_quiet
						throw "PNG Saving Failed: " + e.message;
						#end
					}
				}
			}
			#else
				#if !vision_quiet
				throw new LibraryRequired("format", "ImageTools.loadFromFile", "function");
				#end
			#end
		#else
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
		#if sys
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
				data[i] = image.underlying[i + (@:privateAccess Image.OFFSET + 1)];
				data[i + 1] = image.underlying[i + (@:privateAccess Image.OFFSET + 1) + 1];
				data[i + 2] = image.underlying[i + (@:privateAccess Image.OFFSET + 1) + 2];
				data[i + 3] = 255;
			}
		}

		ctx.putImageData(imageData, 0, 0);

		c.style.position = "absolute";
		c.style.top = (y + units.yUnits) != null ? y + units.yUnits : y + "px";
		c.style.left = (x + units.xUnits) != null ? x + units.xUnits : x + "px";

		js.Browser.document.body.appendChild(c);
		#end
		return image;
	}

	public static inline function getNeighborsOfPixel(image:Image, x:Int, y:Int, kernalSize:Int):Array2D<Color> {
		var neighbors = new Array2D(kernalSize, kernalSize);
		var i = 0;
		for (neighbor in getNeighborsOfPixelIter(image, x, y, kernalSize)) {
			neighbors.inner[i++] = neighbor;
		}
		return neighbors;
	}

	public static extern inline function getNeighborsOfPixelIter(image:Image, x:Int, y:Int, kernalSize:Int):Iterator<Color> {
		return new NeighborsIterator(image, x, y, kernalSize);
	}

	public static inline function grayscalePixel(pixel:Color):Color {
		var gray = #if vision_better_grayscale Std.int(0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue) #else Std.int((pixel.red
			+ pixel.green + pixel.blue) / 3) #end;
		return Color.fromRGBA(gray, gray, gray, pixel.alpha);
	}

	#if flixel
	public static function fromFlxSprite(sprite:flixel.FlxSprite):Image {
		var image = new Image(Std.int(sprite.width), Std.int(sprite.height));
		if (sprite.pixels == null) {
			lime.utils.Log.warn("ImageTools.fromFlxSprite() - The given sprite's bitmapData is null. An empty image is returned. Is the given FlxSprite not added?");
			return image;
		}
		for (x in 0...Std.int(sprite.width)) {
			for (y in 0...Std.int(sprite.height)) {
				image.setPixel(x, y, sprite.pixels.getPixel(x, y));
			}
		}
		return image;
	}

	public static function toFlxSprite(image:Image):flixel.FlxSprite {
		var sprite = new flixel.FlxSprite(0, 0);
		sprite.makeGraphic(image.width, image.height, 0x00ffffff);
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				sprite.pixels.setPixel(x, y, image.getPixel(x, y));
			}
		}
		return sprite;
	}
	#end

	#if (openfl || flash)
	public static function fromBitmapData(bitmapData:flash.display.BitmapData):Image {
		var image = new Image(bitmapData.width, bitmapData.height);
		for (x in 0...bitmapData.width) {
			for (y in 0...bitmapData.height) {
				image.setPixel(x, y, bitmapData.getPixel32(x, y));
			}
		}
		return image;
	}

	public static function toBitmapData(image:Image):flash.display.BitmapData {
		var bitmapData = new flash.display.BitmapData(image.width, image.height, true, 0x00000000);
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				bitmapData.setPixel32(x, y, image.getPixel(x, y));
			}
		}
		return bitmapData;
	}

	public static function fromSprite(sprite:flash.display.Sprite):Image {
		var bmp = new flash.display.BitmapData(Std.int(sprite.width), Std.int(sprite.height));
		bmp.draw(sprite);
		return fromBitmapData(bmp);
	}

	public static function toSprite(image:Image):flash.display.Sprite {
		var bmp = toBitmapData(image);
		var s = new flash.display.Sprite();
		s.addChild(new flash.display.Bitmap(bmp));
		return s;
	}

	public static function fromShape(shape:flash.display.Shape):Image {
		var bmp = new flash.display.BitmapData(Std.int(shape.width), Std.int(shape.height));
		bmp.draw(shape);
		return fromBitmapData(bmp);
	}
	#end

	#if openfl
	public static function toShape(image:Image):openfl.display.Shape {
		var s:openfl.display.Shape = cast toSprite(image);
		var sh = new openfl.display.Shape();
		sh.graphics.drawGraphicsData(s.graphics.readGraphicsData());
		return sh;
	}
	#end

	#if lime
	public static function fromLimeImage(limeImage:lime.graphics.Image):Image {
		var image = new Image(limeImage.width, limeImage.height);
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				image.setPixel(x, y, limeImage.getPixel(x, y));
			}
		}
		return image;
	}

	public static function toLimeImage(image:Image):lime.graphics.Image {
		var limeImage = new lime.graphics.Image(image.width, image.height);
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				limeImage.setPixel(x, y, image.getPixel(x, y));
			}
		}
		return limeImage;
	}
	#end

	#if kha
	public static function fromKhaImage(khaImage:kha.Image):Image {
		var image = new Image(khaImage.width, khaImage.height);
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				image.setPixel(x, y, khaImage.at(x, y));
			}
		}
		return image;
	}
	#end

	#if heaps
	public static function fromHeapsPixels(pixels:hxd.Pixels):Image {
		var image = new Image(pixels.width, pixels.height);
		switch pixels.format {
			case ARGB:
			default:
				#if !vision_quiet
				throw "pixels format must be in ARGB format, currently: " + pixels.format;
				#else
				return image;
				#end
		}
		for (x in 0...pixels.width) {
			for (y in 0...pixels.height) {
				image.setPixel(x, y, pixels.getPixel(x, y));
			}
		}
		return image;
	}

	public static function toHeapsPixels(image:Image):hxd.Pixels {
		var pixels = hxd.Pixels.alloc(image.width, image.height, ARGB);
		for (x in 0...image.width) {
			for (y in 0...pixels.height) {
				pixels.setPixel(x, y, image.getPixel(x, y));
			}
		}
		return pixels;
	}
	#end
}

private class NeighborsIterator {
	var roundedDown:Int;
	var image:Image;
	var x:Int;
	var y:Int;
	var X:Int;
	var Y:Int;

	public inline function new(image:Image, x:Int, y:Int, kernalSize:Int) {
		this.image = image;
		this.roundedDown = (kernalSize - 1) >> 1;
		this.x = x;
		this.y = y;
		X = -roundedDown;
		Y = -roundedDown;
	}

	public inline function next():Color {
		var p = image.getSafePixel(x + X, y + Y);
		Y += 1;
		if (Y > roundedDown) {
			Y = -roundedDown;
			X += 1;
		}
		return p;
	}

	public inline function hasNext():Bool {
		return X <= roundedDown && Y <= roundedDown;
	}
}
