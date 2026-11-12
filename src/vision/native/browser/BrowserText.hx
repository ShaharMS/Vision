package vision.native.browser;

#if js
import haxe.io.Bytes;
import js.Browser;
import js.Syntax;
import js.html.CanvasRenderingContext2D;
import js.html.FontFace;
import js.lib.Promise;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.specifics.TextOptions;
import vision.exceptions.VisionException;

private typedef TextBounds = {
	final actualBoundingBoxLeft:Float;
	final actualBoundingBoxRight:Float;
	final actualBoundingBoxAscent:Float;
	final actualBoundingBoxDescent:Float;
}

@:noCompletion
class BrowserText {
	public static function loadFont(family:String, bytes:Bytes, weight:Int, italic:Bool, ?features:String):Promise<String> {
		requireDocument();
		final font = new FontFace(family, bytes.getData(), {
			weight: Std.string(weight),
			style: italic ? "italic" : "normal",
			featureSettings: features == null ? "normal" : features
		});
		return font.load().then(loaded -> {
			Browser.document.fonts.add(loaded);
			return family;
		});
	}

	public static function draw(image:Image, x:Int, y:Int, text:String, options:TextOptions):Void {
		requireDocument();
		final canvas = Browser.document.createCanvasElement();
		final context = canvas.getContext2d();
		if (context == null) throw new VisionException("Canvas 2D is unavailable.", "Text Drawing Error");
		final lines = ~/\r\n?|\n/g.split(text);
		final lineHeight = options.lineHeight == 0 ? options.size * 1.25 : options.lineHeight;
		configure(context, options);
		for (i in 0...lines.length) {
			final line = lines[i];
			if (line.length == 0) continue;
			final lineY = y + i * lineHeight;
			final bounds:TextBounds = cast context.measureText(line);
			final left = Math.floor(Math.max(0, x - bounds.actualBoundingBoxLeft - 1));
			final top = Math.floor(Math.max(0, lineY - bounds.actualBoundingBoxAscent - 1));
			final right = Math.ceil(Math.min(image.width, x + bounds.actualBoundingBoxRight + 1));
			final bottom = Math.ceil(Math.min(image.height, lineY + bounds.actualBoundingBoxDescent + 1));
			if (right <= left || bottom <= top) continue;
			canvas.width = right - left;
			canvas.height = bottom - top;
			configure(context, options);
			context.fillText(line, x - left, lineY - top);
			final pixels = context.getImageData(0, 0, canvas.width, canvas.height).data;
			var offset = 0;
			for (py in top...bottom)
				for (px in left...right) {
					final alpha = pixels[offset + 3] / 255;
					if (alpha > 0) {
						final background = image.getUnsafePixel(px, py);
						final remainder = background.alphaFloat * (1 - alpha);
						final opacity = alpha + remainder;
						image.setPixel(px, py, Color.fromRGBA(
							Math.round((pixels[offset] * alpha + background.red * remainder) / opacity),
							Math.round((pixels[offset + 1] * alpha + background.green * remainder) / opacity),
							Math.round((pixels[offset + 2] * alpha + background.blue * remainder) / opacity),
							Math.round(opacity * 255)));
					}
					offset += 4;
				}
		}
	}

	static function configure(context:CanvasRenderingContext2D, options:TextOptions):Void {
		final style = options.italic ? "italic" : "normal";
		context.font = '$style ${options.weight} ${options.size}px ${options.fontFamily}';
		context.textBaseline = "top";
		context.textAlign = options.rightToLeft ? "right" : "left";
		final direction = options.rightToLeft ? "rtl" : "ltr";
		Syntax.code("{0}.direction = {1}", context, direction);
		context.fillStyle = 'rgb(${options.color.red},${options.color.green},${options.color.blue})';
		context.globalAlpha = options.color.alphaFloat;
	}

	static function requireDocument():Void {
		if (Syntax.code("typeof document === 'undefined'"))
			throw new VisionException("Text drawing requires a browser document.", "Text Drawing Error");
	}
}
#end
