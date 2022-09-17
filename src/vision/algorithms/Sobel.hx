package vision.algorithms;

import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

using vision.tools.MathTools;

/**
 * An implementation of both the sobel operator & edge detection algorithm
 * by [Shahar Marcus](https://www.github.com/ShaharMS)
 */
class Sobel {
    
    public static final sobelX = [
        [-1,0,1],
        [-2,0,2],
        [-1,0,1]
    ];

    public static final sobelY = [
        [-1,-2,-1],
        [0,0,0],
        [1,2,1]
    ];

    public static function convolveWithSobelOperator(image:Image) {
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

        var ghs = 0., gvs = 0.;
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