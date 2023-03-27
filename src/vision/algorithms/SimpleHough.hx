package vision.algorithms;

import vision.ds.Color;
import vision.ds.Ray2D;
import vision.ds.Image;

class SimpleHough {
    
    public static function detectLines(image:Image, threshold:Int):Array<Ray2D> {
        
        var accumulator:Map<String, Null<Int>> = [];
        var rays:Array<Ray2D> = [];

        image.forEachPixel((x, y, color) -> {
            if (color.red == 255) {
                for (deg in 0...179) {
                    var ray = new Ray2D({x: x, y: y}, null, deg);
                    var rayAsString = '${Std.int(ray.xIntercept)}|$deg';
                    if (accumulator[rayAsString] == null) accumulator[rayAsString] = 1
                    else accumulator[rayAsString]++;
                }
            }
        });

        for (key => value in accumulator) { 
            if (value >= threshold) {
                var x = Std.parseFloat(key.split(",")[0]);
                var y = 0;
                var deg = Std.parseInt(key.split("|")[1]);
                rays.push(new Ray2D({x: x, y: y}, null, deg));
            }
        }

        return rays;
    }

    public static function mapLines(image:Image, rays:Array<Ray2D>) {
        for (ray in rays) {
            image.drawRay2D(ray, Color.CYAN);
        }

        return image;
    }
}