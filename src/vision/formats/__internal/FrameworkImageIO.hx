package vision.formats.__internal;

import vision.ds.Image;
import vision.ds.ByteArray;

@:access(vision.ds.Image)
class FrameworkImageIO {
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