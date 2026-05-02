package vision.algorithms;

import vision.ds.Color;
import vision.ds.HoughLine2D;
import vision.ds.Ray2D;
import vision.ds.Image;
import vision.ds.specifics.HoughLineOptions;

class SimpleHough {

    public static function detectParameterLines(image:Image, ?options:HoughLineOptions):Array<HoughLine2D> {
        return Hough.detectLines(image, options);
    }

    public static function mapParameterLines(image:Image, lines:Array<HoughLine2D>):Image {
        return Hough.mapLines(image, lines);
    }
    
    public static function detectLines(image:Image, threshold:Int):Array<Ray2D> {
        var options = new HoughLineOptions();
        options.voteThreshold = threshold;
        var rays:Array<Ray2D> = [];
        for (line in Hough.detectLines(image, options)) {
            rays.push(line.toRay2D());
        }
        return rays;
    }

    public static function mapLines(image:Image, rays:Array<Ray2D>):Image {
        for (ray in rays) {
            image.drawRay2D(ray, Color.CYAN);
        }

        return image;
    }
}