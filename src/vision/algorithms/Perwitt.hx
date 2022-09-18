package vision.algorithms;

import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

using vision.tools.MathTools;

/**
 * An implementation of both the perwitt operator & edge detection algorithms
 * by [Shahar Marcus](https://www.github.com/ShaharMS)
 */
class Perwitt {

    public static function convolveWithPerwittOperator(image:Image) {

        var x = image.width;
        var y = image.height;

        var  maxGval = 0;
        var edgeColors:Array<Array<Int>> = [];
        var  maxGradient = -1;

        for (i in 1...x - 1) {
            for (j in 1...y - 1) {

                var val00 = ImageTools.grayscalePixel(image.getPixel(i - 1, j - 1)).red;
                var val01 = ImageTools.grayscalePixel(image.getPixel(i - 1, j)).red;
                var val02 = ImageTools.grayscalePixel(image.getPixel(i - 1, j + 1)).red;
                var val10 = ImageTools.grayscalePixel(image.getPixel(i, j - 1)).red;
                var val11 = ImageTools.grayscalePixel(image.getPixel(i, j)).red;
                var val12 = ImageTools.grayscalePixel(image.getPixel(i, j + 1)).red;
                var val20 = ImageTools.grayscalePixel(image.getPixel(i + 1, j - 1)).red;
                var val21 = ImageTools.grayscalePixel(image.getPixel(i + 1, j)).red;
                var val22 = ImageTools.grayscalePixel(image.getPixel(i + 1, j + 1)).red;

                var gx =  ((-1 * val00) + (0 * val01) + (1 * val02)) 
                        + ((-2 * val10) + (0 * val11) + (2 * val12))
                        + ((-1 * val20) + (0 * val21) + (1 * val22));

                var gy =  ((-1 * val00) + (-2 * val01) + (-1 * val02))
                        + ((0 * val10) + (0 * val11) + (0 * val12))
                        + ((1 * val20) + (2 * val21) + (1 * val22));

                var gval = Math.sqrt((gx * gx) + (gy * gy));
                var g = Std.int(gval);

                if(maxGradient < g) {
                    maxGradient = g;
                }

                if (edgeColors[i] == null) edgeColors[i] = [];
                edgeColors[i][j] = g;
            }
        }

        var scale = 255.0 / maxGradient;

        var edgeImage = new Image(image.width, image.height);
        for (i in 1...x - 1) {
            for (j in 1...y - 1) {
                var edgeColor = edgeColors[i][j];
                edgeColor = Std.int(edgeColor * scale);
                edgeColor = 0xff000000 | (edgeColor << 16) | (edgeColor << 8) | edgeColor;

                edgeImage.setPixel(i, j, edgeColor);
            }
        }

        return edgeImage;
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