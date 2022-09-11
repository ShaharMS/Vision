package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.canny.CannyObject;
using vision.algorithms.Canny;


/**
 * An implementation of the canny edge detection algorithm, 
 * by [ShaharMS](https://www.github.com/ShaharMS).
 *
 * The Canny Edge Detection is a multi-stage edge 
 * detection algorithm, utilizing blurring filters 
 * and multi-level thresholding.
 *
 * This class contains function for all 5 stages:
 * 
 * - `grayscale()`
 * - `applyGaussian()`
 * - `applySobelFilters()`
 * - `nonMaxSuppresion()`
 * - `applyHysteresis()`
 */
class Canny {


    public static function grayscale(image:CannyObject):CannyObject {
        return Vision.grayscale(image);
    }

    public static function applyGaussian(image:CannyObject, size:Int, sigma:Float):CannyObject {
        return Vision.gaussianBlur(image, sigma, size);
    }

    public static function applySobelFilters(image:CannyObject):CannyObject {
        var filtered = new Image(image.width, image.height);
        
        final yFilter = [
            [-1, 0, 1],
            [-2, 0, 2],
            [-1, 0, 1]
        ] ,xFilter = [
            [-1, -2, -1],
            [ 0,  0,  0],
            [1, 2, 1]
        ];

        var ghs = 0, gvs = 0;
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                ghs = gvs = 0;
                var neighbors = getNeighbors(3, x, y, image);
                for (i in 0...2) {
                    for (j in 0...2) {
                        ghs += yFilter[i][j] * neighbors[i][j];
                        gvs += xFilter[i][j] * neighbors[i][j];
                    }
                } 
                var w = Std.int(Math.sqrt(ghs*ghs+gvs*gvs));
                var c = new Color(w);
                filtered.setPixel(x, y, c.grayscale());
            }
        }

        return filtered;

    }

    static function getNeighbors(kernalSize:Int, x:Int, y:Int, image:Image):Array<Array<Color>> {
        var neighbors:Array<Array<Color>> = [];
        for (i in 0...kernalSize + 1) neighbors[i] = [];
        var roundedDown = Std.int((kernalSize - 1) / 2);

        for (X in -roundedDown...roundedDown + 1) {
            for (Y in -roundedDown...roundedDown + 1) {
                if (x + X < 0 || x + X >= image.width || y + Y < 0 || y + Y >= image.height) {
                    neighbors[X + roundedDown].push(0);
                    continue;
                }
                neighbors[X + roundedDown].push(image.getPixel(x + X, y + Y));
            }
        }
        return neighbors;
    }
}