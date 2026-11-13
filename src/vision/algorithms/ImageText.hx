package vision.algorithms;

import vision.ds.Image;
import vision.ds.specifics.TextOptions;
import vision.exceptions.TextDrawingError;
#if js
import vision.native.browser.BrowserText;
#end

@:noCompletion
class ImageText {
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

}
