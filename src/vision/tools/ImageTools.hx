package vision.tools;

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
		the supplied path can be an absolute path or a relative path.

		**Note: On `sys` targets, this function requires the `format` library.**

		To install:\
		\
		`haxelib install format`

		@param image optional, used for chaining purposes. (eg. `image.fromFile("path/to/image.png")`)
		@param path the path to the image file. on js, it can only be a relative path.

		@returns the image object.
	**/
	public static function loadFromFile(?image:Image, path:String, onComplete:Image->Void) {
		#if sys
		if (path.split(".").pop() == "png") {
			try {
				var handle = sys.io.File.getBytes(path);
				var reader = new format.png.Reader(new haxe.io.BytesInput(sys.io.File.getBytes(path)));
				var data = reader.read();
				var header = format.png.Tools.getHeader(data);
				var bytes = format.png.Tools.extract32(data);
				format.png.Tools.reverseBytes(bytes);
				var image = new Image(header.width, header.height);
				
				onComplete(image);
			} catch (e:haxe.Exception) {
				#if vision_quiet
				onComplete(new Image(100, 100));
				#else
				throw "Png Loading Failed.";
				#end
			}
		}
		#if vision_quiet
		#else
		throw new Unimplemented(path.split(".").pop().toUpperCase() + "Decoding");
		#end
		#else
		var imgElement = js.Browser.document.createImageElement();
		imgElement.src = path;
		imgElement.crossOrigin = "Anonymus";
		imgElement.onload = () -> {
			var canvas = js.Browser.document.createCanvasElement();
			canvas.width = imgElement.width;
			canvas.height = imgElement.height;
			canvas.getContext2d().drawImage(imgElement, 0, 0);
			trace(imgElement.width, imgElement.height, imgElement.naturalWidth, imgElement.naturalHeight);
			if (image == null)
				image = new Image(imgElement.width, imgElement.height);
			var imageData = canvas.getContext2d().getImageData(0, 0, image.width, image.height);
			var i = 0;
			while (i < imageData.data.length) {
				var r = imageData.data[i + 0];
				var g = imageData.data[i + 1];
				var b = imageData.data[i + 2];
				var a = imageData.data[i + 3];

				var x = Math.floor((i / 4) % imageData.width);
				var y = Math.floor((i / 4) / imageData.width);
				image.setPixel(x, y, Color.fromRGBA(r, g, b, a));
				i += 4;
			}
			onComplete(image);
		}
		#end
	}

	/**
		Saves an image to the file system. On JS, the saved image should be immidiatelly downloaded
		without a file dialog. On sys, the file should be saved

		**Note: On `sys` targets, this function requires the `format` library.**

		To install:\
		\
		`haxelib install format`

		@param image optional, used for chaining purposes. (eg. `image.fromFile("path/to/image.png")`)
		@param path the path to the image file. on js, it can only be a relative path.

		@returns the image object.
	**/
	public static function encode(image:Image, format:String) {
		
	}

	/**
		Adds an `Image` to the screen.

		**Currently, this function only works on the web**, and
		it uses an absoultly positioned canvas element.

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
				data[i] = image.getPixel(x, y).red;
				data[i + 1] = image.getPixel(x, y).green;
				data[i + 2] = image.getPixel(x, y).blue;
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

	public static function getNeighborsOfPixel(image:Image, x:Int, y:Int, radius:Int):Array<Array<Color>> {
		var neighbors:Array<Array<Color>> = [];
		for (i in 0...radius + 1)
			neighbors[i] = [];
		var roundedDown = Std.int((radius - 1) / 2);

		for (X in -roundedDown...roundedDown + 1) {
			for (Y in -roundedDown...roundedDown + 1) {
				neighbors[X + roundedDown].push(image.getSafePixel(x + X, y + Y));
			}
		}
		return neighbors;
	}

	public static function grayscalePixel(pixel:Color):Color {
		var gray = #if vision_better_grayscale Std.int(0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue) #else Std.int((pixel.red
			+ pixel.green + pixel.blue) / 3) #end;
		return Color.fromRGBA(gray, gray, gray, pixel.alpha);
	}

	#if flixel
	public static function fromFlxSprite(sprite:flixel.FlxSprite):Image {
		var image = new Image(Std.int(sprite.width), Std.int(sprite.height));
		if (sprite.pixels == null) {
			lime.utils.Log.warn("ImageTools.fromFlxSprite() - The supplied sprite's bitmapData is null. An empty image is returned");
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
				throw "pixels format must be RGBA, currently: " + pixels.format;
		}
		for (x in 0...pixels.width) {
			for (y in 0...pixels.height) {
				image.setPixel(x, y, pixels.getPixel(x, y));
			}
		}
		return image;
	}
	public static function toHeapsPixels(image:Image):hxd.Pixels {
		var pixels = hxd.Pixels.alloc(image.width,image.height,ARGB);
		for (x in 0...image.width) {
			for (y in 0...pixels.height) {
				pixels.setPixel(x,y,image.getPixel(x,y));
			}
		}
		return pixels;
	}
	#end
}
