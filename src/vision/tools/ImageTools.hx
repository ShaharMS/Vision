package vision.tools;

import flash.display.Bitmap;
import haxe.ui.components.Canvas;
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

	This class contains the following utilities:

	 - getting images from files (**Requires the `format` library**)
	 - extra pixels manipulation functions:
		- `darkenPixel()`
		- `lightenPixel()`
		- `invertPixel()`
		- [x] `grayscalePixel()`
		- `blurPixel()`
		- `blurPixels()`
		- `replaceColor()`
		- `replaceColorsInRange()`

	 - copying utilities:
		- `copyPixelsFromImage()`
		- `copyPixelsFromFile()`
		- `copyPixelsTo()`
		- `copyPixelRectTo()`
**/
class ImageTools {
	public static var defaultResizeAlgorithm:ImageResizeAlgorithm = BilinearInterpolation;

	/**
		Gets an image from a file.
		the supplied path can be an absolute path or a relative path.

		**Note: this function requires the `format` library.**

		To install:\
		\
		`haxelib install format`

		@param image optional, used for chaining purposes. (eg. `image.fromFile("path/to/image.png")`)
		@param path the path to the image file. on js, it can only be a relative path.

		@returns the image object.
	**/
	public static function loadFromFile(?image:Image, path:String, onComplete:Image->Void) {
		#if sys
		if (path.split(".")[-1] == "png") {
			// var bytes = sys.io.File.getBytes(path);
			// var pngData = new format.png.Data();
			// var brgaBytes = format.png.Tools.extract32(new format.png.Reader(new haxe.io.BytesInput(pngBytes)));
			// format.png.Tools.reverseBytes(brgaBytes);
		}
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
				if (x + X < 0 || x + X >= image.width || y + Y < 0 || y + Y >= image.height) {
					// special case: we need to check where exactly is the coord outside of the image
					var gettable:IntPoint2D = new IntPoint2D(0, 0);
					var ox = x + X;
					var oy = y + Y;
					if (ox < 0 && oy < 0)
						gettable.x = gettable.y = 0;
					else if (ox < 0 && oy >= image.height) {
						gettable.x = 0;
						gettable.y = image.height - 1;
					} else if (ox >= image.width && oy < 0) {
						gettable.x = image.width - 1;
						gettable.y = 0;
					} else if (ox >= image.width && oy >= image.height) {
						gettable.x = image.width - 1;
						gettable.y = image.height - 1;
					} else if (ox < 0) {
						gettable.x = 0;
						gettable.y = oy;
					} else if (oy < 0) {
						gettable.x = ox;
						gettable.y = 0;
					} else if (ox >= image.width) {
						gettable.x = image.width - 1;
						gettable.y = oy;
					} else if (oy >= image.height) {
						gettable.x = ox;
						gettable.y = image.height - 1;
					}

					neighbors[X + roundedDown].push(image.getPixel(gettable.x, gettable.y));
					continue;
				}
				neighbors[X + roundedDown].push(image.getPixel(x + X, y + Y));
			}
		}
		return neighbors;
	}

	/**
	 * Takes a 2D array and flattens it to a regular, 1D array.
	 * @param array
	 * @return Array<T>
	 */
	@:generic overload extern inline public static function flatten<T>(array:Array<Array<T>>):Array<T> {
		var flat = [];
		for (item in array)
			flat = flat.concat(item);
		return flat;
	}

	/**
	 * Takes a Matrix and flattens it into a Vector.
	 * @param matrix
	 * @return Vector<T>
	 */
	@:generic overload extern inline public static function flatten<T>(matrix:Matrix<T>):Vector<T> {
		var flat = [];
		for (item in matrix)
			flat = flat.concat(item.toArray());
		return Vector.fromArrayCopy(flat);
	}

	public static function grayscalePixel(pixel:Color):Color {
		var gray = #if vision_better_grayscale Std.int(0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue) #else Std.int((pixel.red
			+ pixel.green + pixel.blue) / 3) #end;
		return Color.fromRGBA(gray, gray, gray, pixel.alpha);
	}

	#if flixel
	public static function fromFlxSprite(sprite:flixel.FlxSprite):Image {
		var image = new Image(sprite.width, sprite.height);
		if (sprite.bitmapData == null) {
			Log.warn("ImageTools.fromFlxSprite() - The supplied sprite's bitmapData is null. An empty image is returned");
			return image;
		}
		for (x in 0...sprite.width) {
			for (y in 0...sprite.height) {
				image.setPixel(x, y, sprite.bitmapData.getPixel(x, y));
			}
		}
		return image;
	}

	public static function toFlxSprite(image:Image):flixel.FlxSprite {
		var sprite = new flixel.FlxSprite(0, 0);
		sprite.makeGraphic(image.width, image.height, 0x00ffffff);
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				sprite.bitmapData.setPixel(x, y, image.getPixel(x, y));
			}
		}
		return sprite;
	}
	#end

	#if (openfl || flash)
	public static function fromBitmapData(bitmapData:flash.display.BitmapData):Image {
		var image = new Image(bitmapData.width, bitmapData.height);
		bitmapData.lock();
		for (x in 0...bitmapData.width) {
			for (y in 0...bitmapData.height) {
				image.setPixel(x, y, bitmapData.getPixel(x, y));
			}
		}
		bitmapData.unlock();
		return image;
	}

	public static function toBitmapData(image:Image):flash.display.BitmapData {
		var bitmapData = new flash.display.BitmapData(image.width, image.height, true, 0x00ffffff);
		bitmapData.lock();
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				bitmapData.setPixel(x, y, image.getPixel(x, y));
			}
		}
		bitmapData.unlock();
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

	public static function toShape(image:Image):flash.display.Shape {
		var s = toSprite(image);
		var sh = new flash.display.Shape();
		#if openfl sh.graphics.drawGraphicsData(s.graphics.readGraphicsData()); #end
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
	public static function fromHeapsBitmapData(bitmap:hxd.BitmapData):Image {
		var image = new Image(bitmap.width, bitmap.height);
		bitmap.lock();
		for (x in 0...bitmap.width) {
			for (y in 0...bitmap.height) {
				image.setPixel(x, y, bitmap.getPixel(x, y));
			}
		}
		bitmap.unlock();
		return image;
	}
	#end
}
