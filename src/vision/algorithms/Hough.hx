package vision.algorithms;

import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;

/**
 * Represents a single RGB pixel of an image.
 */
 class Pixel {
    public function new (r:Int, g:Int, b:Int) {
        this.r = r;
        this.g = g;
        this.b = b;
    }
    var r:Int;
    var g:Int;
    var b:Int;
    public function getR() {
        return r;
    }

    public function getG() {
        return g;
    }

    public function getB() {
        return b;
    }
    public function toString() {
        return "(" + getR() + " " + getG() + " " + getB() + ")";
    }
}

/**
 * Represents a straight line in described in Hough coordinates.
 *
 * The line is described by 2 parameters:
 *  - Its distance from (0, 0) point `r`.
 *  - The angle θ between the X axis and the line connecting (0, 0) with the closest point of the line.
 * ```
 *                       /
 *  +-------------------/--------------->
 *  |.. θ  /           /                  X
 *  |  .. /           /
 *  |    ..          /
 *  |      ..       / the line
 *  |     r  ..    /
 *  |          .. /
 *  |            /
 *  |           /
 *  |          /
 *  | Y       /
 *  V
 * ```
 */
class Line {
    public function new(r, theta) {
        this.r = r;
        this.theta = theta;
    }
	var r:Int;
	var theta:Float;
    public function toString(){
        return "r = " + getR() + ", θ = " + getTheta();
    }

    public function getR() {
        return r;
    }

    public function getTheta() {
        return theta;
    }
}

class HoughLineDetector {

    function new() {}

    /**
     * [Description]
     * @param thetaSteps how many θ values to check?
     * @param houghThreshold how many points does a line need to be acknowledged?
     * @param image the image used as input
     * @param binarizationThreshold binarization threshold, needs to be between 0 and 255
     * @return Image
     */
    public static function detect(thetaSteps:Int, houghThreshold:Int, image:Image, binarizationThreshold:Int):Image {

        var detector = new HoughLineDetector();
        return detector.detectLines(thetaSteps, houghThreshold, image, binarizationThreshold);
    }

    /**
     * Perform the detection. Produce a new image with detected lines overlay.
     */
    private function detectLines(thetaSteps:Int,houghThreshold:Int, image:Image, binarizationThreshold:Int):Image {
        var imgArray:Array<Array<Pixel>> = bufferedImageToPixelArray(image);
        var width = image.width;
        var height = image.height;
        var binarized:Array<Array<Bool>> = binarize(imgArray, width, height, binarizationThreshold);
        var houghArray:Array<Array<Int>> = makeHoughArray(binarized, width, height, thetaSteps);
        var lines:Array<Line> = pickLines(houghArray, width, height, thetaSteps, houghThreshold);
        return drawLines(image, width, height, lines);
    }

    /**
     * Given a [[BufferedImage]] convert it to 2D array of [[Pixel]]s.
     */
    private static function bufferedImageToPixelArray(image:Image):Array<Array<Pixel>> {
        var width = image.width;
        var height = image.height;
        var result:Array<Array<Pixel>> = [for (i in 0...height) []]; //new Pixel[height][width] 

        for (row in 0...height) {
            for (col in 0...width) {
                var rgb = image.getPixel(col, row);
                result[row][col] = new Pixel(rgb.red, rgb.green, rgb.blue);
            }
        }
        
        return result;
    }

    /**
     * Given an array of [[Pixel]]s, convert it to an array of booleans of the same size.
     *
     * Given pixel is converted fo `true` if it's color is darker than given threshold value.
     */
    private function binarize(arr:Array<Array<Pixel>>, width:Int, height:Int, threshold:Int):Array<Array<Bool>> {
        var result:Array<Array<Bool>> = [for (i in 0...height) []];//new boolean[height][width]
        final numChannels = 3;
        for(y in 0...height) {
            for(x in 0...width) {
                var p = arr[y][x];
                result[y][x] = (p.getR() + p.getG() + p.getB()) < threshold * numChannels;
            }
        }
        return result;
    }

    /**
     * Given a binarized image, convert it to hough coordinates.
     *
     * @return Array of integers indexed by (r, θ). Each integer represents number
     *         of points on the line described by the (r, θ) pair.
     */
    private function makeHoughArray(binarized:Array<Array<Bool>>, width:Int, height:Int, thetaSteps:Int):Array<Array<Int>> {
        var rSteps:Int = Math.floor(Math.max(width, height) * Math.sqrt(2));
        var thetaStep = Math.PI * 2 / thetaSteps;
        var result:Array<Array<Int>> = [for (i in 0...rSteps) []];//new int[rSteps][thetaSteps]
        for(theta in 0...thetaSteps) {
            for(r in 0...rSteps) {
                result[r][theta] = 0;
            }
        }
        for(y in 0...height) {
            for(x in 0...width) {
                if(binarized[y][x]) {
                    insertPoint(thetaSteps, rSteps, thetaStep, result, x, y);
                }
            }
        }
        return result;
    }

    /**
     * Given an array representing lines in hough space, pick lines that are "good enough":
     * - They must be above the given threshold.
     *
     */
    private function pickLines(houghArray:Array<Array<Int>>, width:Int, height:Int, thetaSteps:Int, houghThreshold:Int):Array<Line> {
        var rSteps:Int = Math.floor(Math.max(width, height) * Math.sqrt(2));
        var thetaStep = Math.PI * 2 / thetaSteps;

        var result:Array<Line> = [];

        for(theta in 0...thetaSteps) {
            for(r in 0...rSteps) {
                var elem = houghArray[r][theta];
                var isBiggerThanNeighbors =
                        (r == 0 || theta == 0 || elem >= houghArray[r - 1][theta - 1]) &&
                                (r == rSteps - 1 || theta == 0 || elem >= houghArray[r + 1][theta - 1]) &&
                                (r == 0 || theta == thetaSteps - 1 || elem >= houghArray[r - 1][theta + 1]) &&
                                (r == rSteps - 1 || theta == thetaSteps - 1 || elem >= houghArray[r + 1][theta + 1]);
                if(elem > houghThreshold &&
                        isBiggerThanNeighbors) {
                    trace(houghArray[r][theta] + " ");
                    result.push(new Line(r, theta * thetaStep));
                }
            }
        }
        return result;
    }

    /**
     * Given a point in the image space, increment the matching lines in the hough space.
     */
    private function insertPoint(thetaSteps:Int, rSteps:Int, thetaStep:Float, result:Array<Array<Int>>, x:Int, y:Int) {
        for (ts in 0...thetaSteps) {
            var theta = ts * thetaStep;
            var r = Math.floor(x * Math.cos(theta) + y * Math.sin(theta));
            if (r >= 0 && r < rSteps) {
                result[r][ts]++;
            }
        }
    }

    /**
     * Given an image, draw the detected lines on it.
     */
    private function drawLines(image:Image, width:Int, height:Int, lines:Array<Line>):Image {
        for(line in lines) {
            drawLine(width, height, image, line);
        }
        return image;
    }

    /**
     * Given a 2d graphics, draw the given line on it.
     */
    private function drawLine(width:Int, height:Int, image:Image, line:Line) {
        var x0 = line.getR() / Math.cos(line.getTheta());
        var x1 = x0 - Math.tan(line.getTheta()) * height;
        var y0 = line.getR() / Math.cos(Math.PI / 2 - line.getTheta());
        var y1 = y0 - 1/Math.tan(line.getTheta()) * width;

        var drawNothing =
                ((x0 < 0 && x1 < 0)
                        || (y0 < 0 && y1 < 0)
                        || (x0 >= width && x1 >= width)
                        || (y0 >= height && y1 >= height));

        if ((y1 > y0) == (x1 > x0)) {
            var tmp = x0;
            x0 = x1;
            x1 = tmp;
        }

        if (x0 < 0) x0 = 0;
        if (x0 >= width) x0 = width;
        if (x1 < 0) x1 = 0;
        if (x1 >= width) x1 = width;
        if (y0 < 0) y0 = 0;
        if (y0 >= height) y0 = height;
        if (y1 < 0) y1 = 0;
        if (y1 >= height) y1 = height;
        trace("Drawing Line: " + new Line2D(new vision.ds.Point2D(x0, y0), new vision.ds.Point2D(x1, y1)).toString());
        if(!drawNothing) image.drawLine(cast x0, cast y0, cast x1, cast y1, Color.CYAN);
    }
}