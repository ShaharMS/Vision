package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.canny.CannyObject;
using vision.algorithms.Canny;
using vision.tools.MathTools;


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
            [-3, 0, 3],
            [-10, 0, 10],
            [-3, 0, 3]
        ], xFilter = [
            [-3, -10, -3],
            [ 0,  0,  0],
            [3, 10, 3]
        ];

        var ghs = 0, gvs = 0;
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                ghs = gvs = 0;
                var neighbors = getNeighbors(3, x, y, image);
                for (i in 0...2) {
                    for (j in 0...2) {
                        ghs += yFilter[i][j] * neighbors[i][j].to24Bit();
                        gvs += xFilter[i][j] * neighbors[i][j].to24Bit();
                    }
                } 
                var w = Std.int(Math.sqrt(ghs*ghs+gvs*gvs));
                var c = new Color(w);
                filtered.setPixel(x, y, c.grayscale());
            }
        }

        return filtered;

    }

    public static function nonMaxSuppression(image:CannyObject):CannyObject {
        var filtered = new Image(image.width, image.height);

        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var n = getNeighbors(3, x, y, image);
                if (n[1][1] > n[0][1] && n[1][1] > n[2][1])
                    filtered[x][y] = n[1][1];
                else
                    filtered[x][y] = 0;

                if (n[1][1] > n[0][2] && n[1][1] > n[2][0])
                    filtered[x][y] = n[1][1];
                else
                    filtered[x][y] = 0;

                if (n[1][1] > n[1][0] && n[1][1] > n[1][2])
                    filtered[x][y] = n[1][1];
                else
                    filtered[x][y] = 0;

                if (n[1][1] > n[0][0] && n[1][1] > n[2][2])
                    filtered[x][y] = n[1][1];
                else
                    filtered[x][y] = 0;
            }
        }

        return filtered;
    }

    public static function applyHysteresis(image:CannyObject, ht:Float, lt:Float):CannyObject {
        var copy = image.clone();
        final isStrong = (edge:Color) -> edge.redFloat > ht;
        final isCandidate = (edge:Color) -> edge.redFloat <= ht && edge.redFloat >= lt;
        final isWeak = (edge:Color) -> edge.redFloat < lt;
        function traverseEdge(x, y) {
            if (x == 0 || y == 0 || x == image.width - 1 || y == image.height - 1) return;
            if (isStrong(copy[x][y])) {
                var neighbors = getNeighbors(3, x, y, copy);
                for (i in 0...2) {
                    for (j in 0...2) {
                        if (isCandidate(neighbors[i][j])) {
                           copy[x - 1 + i][y - 1 + j] = 0xFFFFFF;
                           traverseEdge(x - 1 + i, y - 1 + j);
                        }
                    }
                }     
            }
                
        }

        for (x in 0...image.width) {
            for (y in 0...image.height) {
                traverseEdge(x, y);                  
            }
        }
        //second iteration
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                if (!isStrong(copy[x][y])) copy[x][y] = 0;                 
            }
        }

        return copy;
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