package vision.tools;

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
        - `grayscalePixel()`
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
    
    /**
        Gets an image from a file.
        the supplied path can be an absolute path or a relative path.

        Note: this function requires the `format` library.
        
        @param image optional, used for chaining purposes. (eg. `image.fromFile("path/to/image.png")`)
        @param path the path to the image file. on js, it can only be a relative path.

        @returns the image object.
    **/
    public static function loadFromFile(?image:Image, path:String):Image {
        #if sys
        if (path.split(".")[-1] == "png") {
            //var bytes = sys.io.File.getBytes(path);
            //var pngData = new format.png.Data();
            //var brgaBytes = format.png.Tools.extract32(new format.png.Reader(new haxe.io.BytesInput(pngBytes)));
            //format.png.Tools.reverseBytes(brgaBytes);
        }
        
        #else
        var imgElement = js.Browser.document.createImageElement();
        imgElement.src = path;
        var canvas = js.Browser.document.createCanvasElement();
        canvas.getContext2d().drawImage(imgElement, 0, 0);

        if (image == null) {
            image = new Image(imgElement.width, imgElement.height);
        }
        var imageData = canvas.getContext2d().getImageData(0, 0, image.width, image.height);
		var data = imageData.data;
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				var i = (y * image.width + x) * 4;
                var color = Color.fromRGB(data[i], data[i + 1], data[i + 2], data[i + 3]);
				image.setPixel(x, y, color);
			}
		}
		canvas.getContext2d().putImageData(imageData, 0, 0);
        return image;
        #end
        return null;
    }
}