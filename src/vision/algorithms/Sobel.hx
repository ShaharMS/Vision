package vision.algorithms;

import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

using vision.tools.MathTools;

/**
 * An implementation of both the sobel operator & edge detection algorithms
 * by [Shahar Marcus](https://www.github.com/ShaharMS)
 */
class Sobel {

    public static function convolveWithSobelOperator(image:Image) {


        var edgeColors:Array<Array<Int>> = [];
        var maxGradient = -1;

        for (i in 1...image.width - 1) {
            for (j in 1...image.height - 1) {

                var val00 = ImageTools.grayscalePixel(image.getPixel(i - 1, j - 1)).red;
                var val01 = ImageTools.grayscalePixel(image.getPixel(i - 1, j)).red;
                var val02 = ImageTools.grayscalePixel(image.getPixel(i - 1, j + 1)).red;
                var val10 = ImageTools.grayscalePixel(image.getPixel(i, j - 1)).red;
                var val11 = ImageTools.grayscalePixel(image.getPixel(i, j)).red;
                var val12 = ImageTools.grayscalePixel(image.getPixel(i, j + 1)).red;
                var val20 = ImageTools.grayscalePixel(image.getPixel(i + 1, j - 1)).red;
                var val21 = ImageTools.grayscalePixel(image.getPixel(i + 1, j)).red;
                var val22 = ImageTools.grayscalePixel(image.getPixel(i + 1, j + 1)).red;

                var gx =  ((-3 * val00) + (0 * val01) + (3 * val02)) 
                        + ((-10 * val10) + (0 * val11) + (10 * val12))
                        + ((-3 * val20) + (0 * val21) + (3 * val22));

                var gy =  ((-3 * val00) + (-10 * val01) + (-3 * val02))
                        + ((0 * val10) + (0 * val11) + (0 * val12))
                        + ((3 * val20) + (10 * val21) + (3 * val22));

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
        for (i in 1...image.width - 1) {
            for (j in 1...image.height - 1) {
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
            /**
            What does this algorithm do?
            Basically, it takes 9 pixels chunks each time it performs a calculation, and tries to see how different the
            colors of the pixels from the left are from the right. for example, lets say this is the chunk:

                 0 ,  0 , 112
                 0 , 112, 112
                121, 112, 112
            
            With the naked eye, we can see that the pixels are very different from each other, and therefore, are edges.
            The way the algorithm knows it, is: its multiplying the left side by -1, the middle by 0 and the right by 1.
            Then, it multiplies each edge by 10 and each corner by 3, 
            and then adding them together:

                 0  *-3 +  0  *-10 + 121 *-3 = -363  |
                 0  * 0 + 112 * 0 + 112 * 0 =   0    | + = 1483
                112 * 3 + 112 * 10 + 112 * 3 =  1846 |

            If this value is greater than the threshold, then we declare it an edge. now, were gonna do the same thing
            for all chunks of the image, and from top to bottom too if needed.
        **/
        function name() {
            
        }
}