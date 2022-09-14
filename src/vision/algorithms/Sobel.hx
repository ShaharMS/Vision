package vision.algorithms;

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
        var edge = new Image(image.width, image.height);

        for (x in 1...image.width - 2) {
            for (y in 1...image.height - 2) {
                var pixel_x = (sobelX[0][0] * image.getPixel(x-1,y-1)) + (sobelX[0][1] * image.getPixel(x,y-1)) + (sobelX[0][2] * image.getPixel(x+1,y-1)) +
                        (sobelX[1][0] * image.getPixel(x-1,y))   + (sobelX[1][1] * image.getPixel(x,y))   + (sobelX[1][2] * image.getPixel(x+1,y)) +
                        (sobelX[2][0] * image.getPixel(x-1,y+1)) + (sobelX[2][1] * image.getPixel(x,y+1)) + (sobelX[2][2] * image.getPixel(x+1,y+1));
          
                var pixel_y = (sobelY[0][0] * image.getPixel(x-1,y-1)) + (sobelY[0][1] * image.getPixel(x,y-1)) + (sobelY[0][2] * image.getPixel(x+1,y-1)) +
                        (sobelY[1][0] * image.getPixel(x-1,y))   + (sobelY[1][1] * image.getPixel(x,y))   + (sobelY[1][2] * image.getPixel(x+1,y)) +
                        (sobelY[2][0] * image.getPixel(x-1,y+1)) + (sobelY[2][1] * image.getPixel(x,y+1)) + (sobelY[2][2] * image.getPixel(x+1,y+1));
          
                final val = Math.sqrt((pixel_x * pixel_x) + (pixel_y * pixel_y)).ceil();
              edge[x][y] = ImageTools.grayscalePixel(val);
    
            }
        }

        return edge;
    }    
}