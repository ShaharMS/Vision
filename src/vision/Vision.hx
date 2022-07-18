package vision;

import vision.ds.Point2D;
import vision.ds.LineSegment2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.MathUtils;

using vision.MathUtils;

/**
    The class where all image manipulation functions are stored.
**/
class Vision {
    
    /**
        Grayscales an image.

        @param image The image to be grayscaled.

        @return The grayscaled image.
    **/
    public static function grayscale(image:Image):Image {
        for (i in 0...image.width) {
            for (j in 0...image.height) {
                var pixel = image.getPixel(i, j);
                var gray = Std.int((pixel.red + pixel.green + pixel.blue) / 3);
                image.setPixel(i, j, Color.fromRGB(gray, gray, gray));
            }
        }
        return image;
    }
    
    /**
        Inverts an image.

        @param image The image to be inverted.

        @return The inverted image.
    **/
    public static function invert(image:Image) {
        for (i in 0...image.width) {
            for (j in 0...image.height) {
                var pixel = image.getPixel(i, j);
                image.setPixel(i, j, Color.fromRGB(255 - pixel.red, 255 - pixel.green, 255 - pixel.blue));
            }
        }
        return image;
    }
    
    /**
        Converts an image to COMPLETE black and white.

        @param image The image to be converted.
        @param threshold The threshold for converting to black and white: 
        `threshold` is the maximum average of the three color components.
        that will still be considered black. `threshold` is a value between 0 and 255.
        The higher the value, the more "sensitive" the conversion. The default value is 128.

        @return The converted image.
    **/
    public static function blackAndWhite(image:Image, threshold:Int = 64):Image {
        for (i in 0...image.width) {
            for (j in 0...image.height) {
                var pixel = image.getPixel(i, j);
                var average = (pixel.red + pixel.green + pixel.blue) / 3;
                if (average > threshold) {
                    image.setPixel(i, j, 0xFFFFFFFF);
                } else {
                    image.setPixel(i, j, Color.fromInt(0));
                }
            }
        }
        return image;
    }

}