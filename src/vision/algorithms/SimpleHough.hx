package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Ray2D;
import vision.ds.specifics.HoughLineOptions;

class SimpleHough {

    public static function detectParameterLines(image:Image, ?options:HoughLineOptions):Array<Ray2D> {
        return Hough.detectLines(image, options);
    }

    public static function mapParameterLines(image:Image, lines:Array<Ray2D>):Image {
        for (line in lines) {
            var clipped = line.toLine2D(image.width, image.height);
            if (clipped != null) image.drawLine2D(clipped, Color.CYAN);
        }
        return image;
    }
    
    public static function detectLines(image:Image, threshold:Int):Array<Ray2D> {
        var options = new HoughLineOptions();
        options.voteThreshold = threshold;
        return Hough.detectLines(image, options);
    }

    public static function mapLines(image:Image, rays:Array<Ray2D>):Image {
        for (ray in rays) {
            image.drawRay2D(ray, Color.CYAN);
        }

        return image;
    }
}
