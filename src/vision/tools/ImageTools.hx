package vision.tools;

import vision.helpers.FormatImageLoader;
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
import vision.ds.ImageResizeAlgorithm;
#if js
import js.lib.Promise;
import js.Browser;
import js.html.CanvasElement;

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
	public static function loadFromFile(?image:Image, path:String, ?onComplete:Image->Void) {
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
			  for (o in 0...4) {
          		image.underlying[i + (@:privateAccess Image.OFFSET + 1) + o] = imageData.data[i + o];
        		}
				i += 4;
			}

			if(onComplete != null)
				onComplete(image);
		}
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
	public static function saveToFile(image:Image, pathWithFileName:String, saveFormat:ImageFormat = PNG) {
		#if (!js)
			#if format
			switch saveFormat {
				case PNG: {
					try {
						final out = sys.io.File.write(pathWithFileName);
						var writer = new format.png.Writer(out);
						final data = format.png.Tools.build32ARGB(image.width, image.height, image.underlying.sub(Image.OFFSET, image.underlying.length - Image.OFFSET));
						writer.write(data);
						out.close();
					} catch (e:haxe.Exception) {
						#if !vision_quiet
						throw new ImageSavingFailed(saveFormat, e.message);
						#end
					}
				}
				case BMP: {
					#if !vision_quiet
					throw new Unimplemented('Using `ImageTools.saveToFile` with `BMP` format');
					#end
				}
			}
			#else
				#if !vision_quiet
				throw new LibraryRequired("format", [], "ImageTools.loadFromFile", "function");
				#end
			#end
		#else
			#if format
			switch saveFormat {
				case PNG: {
					try {
						var canvas = image.toJsCanvas();
  						var i = canvas.toDataURL("image/png", 1.0).replace("image/png", "image/octet-stream");
  						var link = Browser.document.createAnchorElement();
  						link.download = new Path(pathWithFileName).file + ".png";
  						link.href = i;
  						link.click();
					} catch (e:haxe.Exception) {
						#if !vision_quiet
						throw new ImageSavingFailed(saveFormat, e.message);
						#end
					}
				}
				case BMP: {
					#if !vision_quiet
					throw new Unimplemented('Using `ImageTools.saveToFile` with `BMP` format');
					#end
				}
			}
			#else
				#if !vision_quiet
				throw new LibraryRequired("format", [], "ImageTools.loadFromFile", "function");
				#end
			#end
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
		final bmp = toBitmapData(image);
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
	public static function toShape(image:Image):flash.display.Shape {
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
	#if js
	public static function fromJsCanvas(canvas:js.html.CanvasElement):Image {
		var image:Image = Image.fromBytes(new ByteArray(Image.OFFSET + (canvas.width + canvas.height) * 4), canvas.width, canvas.height);

		final imageData = canvas.getContext2d().getImageData(0, 0, image.width, image.height);

		{
			var i = 0;
			while (i < imageData.data.length) {
        for (o in 0...4)
				  image.underlying[i + (Image.OFFSET + 1) + o] = imageData.data[i + o];
				i += 4;
			}
		}

		return image;
	}

	public static function toJsCanvas(image:Image):js.html.CanvasElement {
		var c = js.Browser.document.createCanvasElement();

		c.width = image.width;
		c.height = image.height;

		var ctx = c.getContext2d();
		final imageData = ctx.getImageData(0, 0, image.width, image.height);
		var data = imageData.data;
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				var i = (y * image.width + x) * 4;
        for (o in 0...4)
				  data[i + o] = image.underlying[i + (Image.OFFSET + 1) + o];
			}
		}

		ctx.putImageData(imageData, 0, 0);

		return c;
	}

	public static function fromJsImage(image:js.html.ImageElement):Image {
		var canvas = js.Browser.document.createCanvasElement();
		canvas.width = image.width;
		canvas.height = image.height;
		canvas.getContext2d().drawImage(image, 0, 0);
 		return fromJsCanvas(canvas);
	}

	public static function toJsImage(image:Image):js.html.ImageElement {
		var canvas = image.toJsCanvas();
		var htmlImage = js.Browser.document.createImageElement();
		htmlImage.src = canvas.toDataURL();
		return htmlImage;
	}
	#end
	#if (haxeui_core && (haxeui_flixel || haxeui_openfl || haxeui_heaps || haxeui_html5))
	public static function fromHaxeUIImage(image:haxe.ui.components.Image):Image {
		#if haxeui_flixel
			return fromFlxSprite(image.resource);
		#elseif haxeui_openfl
			return fromBitmapData(image.resource);
		#elseif haxeui_heaps
			return fromHeapsPixels(image.resource);
		#else
			return fromJsImage(image.resource);
		#end
	}

	public static function toHaxeUIImage(image:Image):haxe.ui.components.Image {
		var huiImage = new haxe.ui.components.Image();
		huiImage.width = image.width;
		huiImage.height = image.height;
		#if haxeui_flixel
			huiImage.resource = toFlxSprite(image);
		#elseif haxeui_openfl
			huiImage.resource = toBitmapData(image);
		#elseif haxeui_heaps
			huiImage.resource = toHeapsPixels(image);
		#else
			huiImage.resource = toJsImage(image);
		#end
		return huiImage;
	}

	public static function fromHaxeUIImageData(image:haxe.ui.backend.ImageData):Image {
		#if haxeui_flixel
			return fromFlxSprite(image);
		#elseif haxeui_openfl
			return fromBitmapData(image);
		#elseif haxeui_heaps
			return fromHeapsPixels(image);
		#else
			return fromJsImage(image);
		#end
	}

	public static function toHaxeUIImageData(image:Image):haxe.ui.backend.ImageData {
		#if haxeui_flixel
			return toFlxSprite(image);
		#elseif haxeui_openfl
			return fromBitmapData(image);
		#elseif haxeui_heaps
			return toHeapsPixels(image);
		#else
			return toJsImage(image);
		#end
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
