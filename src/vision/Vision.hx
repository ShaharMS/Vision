package vision;

import haxe.extern.EitherType;
import vision.algorithms.Radix;
import haxe.ds.ArraySort;
import vision.ds.Histogram;
import vision.ds.simple.AlgorithmSettings;
import haxe.Timer;
import vision.helpers.VisionThread;
import vision.algorithms.Perwitt;
import vision.algorithms.Sobel;
import vision.ds.Kernal2D;
import vision.ds.canny.CannyObject;
import vision.algorithms.SimpleLineDetector;
import vision.ds.gaussian.GaussianKernalSize;
import vision.ds.hough.HoughSpace;
import vision.ds.Ray2D;
import vision.algorithms.Gaussian;
import vision.algorithms.Hough;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools;

using vision.tools.MathTools;
using vision.tools.ImageTools;
using vision.algorithms.Canny;

/**
    The class where all image manipulation & computer vision functions are stored.

    If you're going to make extensive use of this class, it is recommended to use this as a static extension:

    ```haxe
    using vision.Vision;
    ```
**/
class Vision {
    
    /**
        Grayscales an image.

        @param image The image to be grayscaled.

        @return The grayscaled image.
    **/
    public static function grayscale(image:Image):Image {
        for (i in 0...image.width) {
            for (j in 0...image.height) {
                var pixel = image.getPixel(i, j);
                var gray = #if vision_better_grayscale Std.int(0.2126 * pixel.red + 0.7152 * pixel.green + 0.0722 * pixel.blue) #else Std.int((pixel.red + pixel.green + pixel.blue) / 3) #end;
                image.setPixel(i, j, Color.fromRGBA(gray, gray, gray));
            }
        }
        return image;
    }
    
    /**
        Inverts an image.

        @param image The image to be inverted.

        @return The inverted image.
    **/
    public static function invert(image:Image) {
        for (i in 0...image.width) {
            for (j in 0...image.height) {
                var pixel = image.getPixel(i, j);
                image.setPixel(i, j, Color.fromRGBA(255 - pixel.red, 255 - pixel.green, 255 - pixel.blue));
            }
        }
        return image;
    }
    
    /**
        Converts an image to COMPLETE black and white.

        @param image The image to be converted.
        @param threshold The threshold for converting to black and white: 
        `threshold` is the maximum average of the three color components.
        that will still be considered black. `threshold` is a value between 0 and 255.
        The higher the value, the more "sensitive" the conversion. The default value is 128.

        @return The converted image.
    **/
    public static function blackAndWhite(image:Image, threshold:Int = 64):Image {
        for (i in 0...image.width) {
            for (j in 0...image.height) {
                var pixel = image.getPixel(i, j);
                var average = (pixel.red + pixel.green + pixel.blue) / 3;
                if (average > threshold) {
                    image.setPixel(i, j, 0xFFFFFFFF);
                } else {
                    image.setPixel(i, j, Color.fromInt(0));
                }
            }
        }
        return image;
    }

    /**
        Gets a contrast-enhanced version of an image,
        with more exaggerated colors.

        @param image The image to be contrasted.
    **/
    public static function contrast(image:Image):Image {
        return convolve(image, UnsharpMasking);
    }

    /**
        Returns a sharpened version of the provided image.

        When an image is sharpened. it's color differences are exaggerated. The more times
        the image is sharpened, the more "deepfried" it'll look.

        @param image The image to be contrasted.
        @return The sharpened image. The original copy is not preserved.
    **/
    public static function sharpen(image:Image):Image {
        return convolve(image, Sharpen);
    }

    /**
       Deepfries an image by running to through a sharpening filter `iterations` times.
       
       The higher the value, the more deepfried the image will look.
       @param image The image to be deepfried
       @param iterations The amount of times the image gets sharpened. default is `2`
       @return The deepfried image. the original copy is not preserved.
    **/
    public static function deepfry(image:Image, iterations:Int = 2):Image {
        for (i in 0...iterations) image = sharpen(image);
        return image;
    }

    /**
     * Limits the range of colors on an image, by resizing the range of a given color channel, according to the values
     * of `rangeStart`'s and `rangeEnd`'s color channels.
     * 
     * ### How Does this work?
     * 
     * 1. before calculating anything, you get the min & max values of each color channel from the two given colors.
     * For example, if `rangeStart` is `0xFF05F243` and `rangeEnd` is `0x239A6262`, the min/max values of the `red` channel 
     * will be set to (`0x05`, `0x9A`), the min/max values of the green channel will be set to (`0x62`, `0xF2`)...
     * 2. Loop over the pixels, and calculate the ratios between the the pixel's color channel's and the values (`0x00`, `0xFF`)
     * 3. Now, calculate the step between each color value of the new range, by dividing each channel's (`max` - `min`) by `255`. the
     * default step between each color value is `1` by default (`(0xFF - 0x00) / 0xFF = 1`).
     * 4. Loop over the channels, and multiply their value by the value of the new `step` (for example, 4
     * `newStep = (0x88 - 0x00) / 0xFF = 0.5`, `color.red = color.red * newStep`);
     * 5. enjoy your normalized image :)
     * 
     * 
     * @param image The image to be normalized
     * @param rangeStart The start of the range of channels. By default, this value is `0x00000000`
     * @param rangeEnd The end of the range of channels. By default, this value is `0xFFFFFFFF
     * @return The normalized image. The original copy is not preserved.
     */
    public static function normalize(image:Image, rangeStart:Color, rangeEnd:Color) {
        var max:Color = 0x0, min:Color = 0x0, step:Color = 0x0;
        max.red = cast Math.max(rangeStart.red, rangeEnd.red);
        min.red = cast Math.min(rangeStart.red, rangeEnd.red);
        max.green = cast Math.max(rangeStart.green, rangeEnd.green);
        min.green = cast Math.min(rangeStart.green, rangeEnd.green);
        max.blue = cast Math.max(rangeStart.blue, rangeEnd.blue);
        min.blue = cast Math.min(rangeStart.blue, rangeEnd.blue);
        step.redFloat = (max.red - min.red) / 0xFF;
        step.blueFloat = (max.blue - min.blue) / 0xFF;
        step.greenFloat = (max.green - min.green) / 0xFF;

        image.forEachPixel((x, y, color) -> {
            color.redFloat *= step.redFloat;
            color.blueFloat *= step.blueFloat;
            color.greenFloat *= step.greenFloat;
            image.setPixel(x, y, color);
        });
        return image;
    }

    /**
        manipulates the image's pixel data by passing the pixels' value through a kernal.

        This is useful for many things, such as simple blurring, sharpening, noise maps, and more that comes to mind :).

        There are a couple of preexisting matrices you can use, and also a custom tool to let you create your own kernals from scratch using enums.

        ### How does this work?

        simply put, it takes each pixel, and multiples its surrounding pixels by the values you give the matrix.

        In the following demo, you can see how convolution works for the `Sharpen` matrix:

        ![Sharpen Convolution](https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/2D_Convolution_Animation.gif/220px-2D_Convolution_Animation.gif)

        1. multiply the current pixel's value by the value of the center of the matrix
        1. multiply the current pixel's immediate neighbors (vertical/horizontal) by the matching value on the matrix 
        (the pixel to the right of the current pixel will be multiplied by the value to the right of the center of the matrix)
        1. do the same thing with the other neighbors
        1. enjoy your convolved image :)

        @param image the image to be manipulated
        @param kernal the type/value of the kernal. can be: **`Identity`**, **`BoxBlur`**, **`RidgeDetection`**, **`Sharpen`**, **`UnsharpMasking`**, **`Assemble3x3`**, **`Assemble5x5`**,
        or just a matrix: both `convolve(image, BoxBlur)` and `convolve(image, [[1,1,1],[1,1,1],[1,1,1]])` are valid ways to represent a box blur.
        @return A convolved version of the image. The original image is not preserved
    **/
    public static function convolve(image:Image, kernal:EitherType<Kernal2D, Array<Array<Float>>>):Image {

        var matrix:Array<Array<Float>>;
        if (kernal is Array) {
            matrix = cast kernal;
        } else {
            matrix = switch cast (kernal, Kernal2D) {
                case Identity: [
                    [0, 0, 0],
                    [0, 1, 0],
                    [0, 0, 0],
                ];
                case BoxBlur: [
                    [1, 1, 1],
                    [1, 1, 1],
                    [1, 1, 1],
                ];
                case RidgeDetection: [
                    [-1, -1, -1],
                    [-1, 4, -1],
                    [-1, -1, -1],
                ];
                case RidgeDetectionAggressive: [
                    [-1, -1, -1],
                    [-1, 7, -1],
                    [-1, -1, -1],
                ];
                case Sharpen: [
                    [0, -1, 0],
                    [-1, 5, -1],
                    [0, -1, 0],
                ];
                case UnsharpMasking:[
                    [1, 4, 6, 4, 1],
                    [4, 16,  24 , 16, 4],
                    [6, 24, -476, 24, 6],
                    [4, 16,  24 , 16, 4],
                    [1, 4, 6, 4, 1]
                ];
                case Assemble3x3(corner, edge, center): [
                    [corner, edge, corner],
                    [edge, center, edge],
                    [corner, edge, corner]
                ];
                case Assemble5x5(farCorner, farEdge, edge, midCorner, midEdge, center): [
                    [farCorner, farEdge, edge, farEdge, farCorner],
                    [farEdge, midCorner, midEdge, midCorner, farEdge],
                    [edge, midEdge, center, midEdge, edge],
                    [farEdge, midCorner, midEdge, midCorner, farEdge],
                    [farCorner, farEdge, edge, farEdge, farCorner]
                ];
                case Custom(kernal): kernal;
                case GaussianBlur(size, sigma): Gaussian.createKernalOfSize(size, sigma);
            }
        }

        var convolved = new Image(image.width, image.height);
        var maxLength = -1;
        for (array in matrix) {if (array.length > maxLength) maxLength = array.length;};
        var flatMatrix = matrix.flatten();
        var denominator = 0.;
        for (number in flatMatrix) denominator += number;
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var neighbors:Array<Color> = image.getNeighborsOfPixel(x, y, maxLength).flatten();
                var red = 0., green = 0., blue = 0.;
                for (i in 0...neighbors.length) {
                    red += flatMatrix[i] * neighbors[i].red;
                    blue += flatMatrix[i] * neighbors[i].blue;
                    green += flatMatrix[i] * neighbors[i].green;
                }
                red /= denominator;
                green /= denominator;
                blue /= denominator;
                convolved.setPixel(x, y, Color.fromRGBA(Std.int(red), Std.int(green), Std.int(blue)));

            }
        }
        trace(flatMatrix.length);
        return image = convolved;
    }

    /**
        Detects edges within an image.

        Edges are detected using the Sobel operator, going from left to right and top to bottom.

        To improve angle related errors with the sobel operator, Scharr's optimized version is used.

        There's no need to pre-process the image, just throw it on it and it will do the rest. 
        (ie. it doesn't need to be grayscaled/black and white)

        @param image The image to be processed.
        @param threshold The threshold for detecting edges. The lower the value, 
        the more pixels will be considered edges (check this function's source code for more information).

        @return The image with edges detected. This image is returned as a new, black and white image.
    **/
    public static function sobelEdgeDetection(image:Image, threshold:Float = 100):Image {

        // If you came here for the explanation of the algorithm, Congrats! learning is fun :D
        /*
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

                 0  *-3 +  0  *-10 + 121 *-3 = -363 |
                 0  * 0 + 112 * 0 + 112 * 0 =   0  | + = 1483
                112 * 3 + 112 * 10 + 112 * 3 =  1846 |

            If this value is greater than the threshold, then we declare it an edge. now, were gonna do the same thing
            for all chunks of the image, and from top to bottom too if needed.
        */
        var edges = new Image(image.width, image.height, Color.fromRGBA(0, 0, 0));
        var blacknwhite = grayscale(image.clone());
        for (x in 1...blacknwhite.width - 1) {
            for (y in 1...blacknwhite.height - 1) {
                var neighbors = [
                    blacknwhite.getPixel(x - 1, y - 1), 
                    blacknwhite.getPixel(x, y - 1), 
                    blacknwhite.getPixel(x + 1, y - 1),
                    blacknwhite.getPixel(x - 1, y), 
                    blacknwhite.getPixel(x, y),
                    blacknwhite.getPixel(x + 1, y),
                    blacknwhite.getPixel(x - 1, y + 1), 
                    blacknwhite.getPixel(x, y + 1), 
                    blacknwhite.getPixel(x + 1, y + 1)
                ];
                final sobelCalculationIterationLTR = 
                    neighbors[0].red * -3 + neighbors[3].red * -10 + neighbors[6].red * -3 +
                    neighbors[2].red * 3 + neighbors[5].red * 10 + neighbors[8].red * 3
                ;
                if (Math.abs(sobelCalculationIterationLTR) > threshold) {
                    edges.setPixel(x, y, Color.fromRGBA(255, 255, 255));
                    continue;
                }
                final sobelCalculationIterationTTB = 
                    neighbors[0].red * -3 + neighbors[1].red * -10 + neighbors[2].red * -3 +
                    neighbors[6].red * 3 + neighbors[7].red * 10 + neighbors[8].red * 3
                ;
                if (Math.abs(sobelCalculationIterationTTB) > threshold) {
                    edges.setPixel(x, y, Color.fromRGBA(255, 255, 255));
                    continue;
                }
            }
        }

        var intermediate = edges.clone();

        for (x in 1...intermediate.width - 1) {
            for (y in 1...intermediate.height - 1) {
                if (edges.getPixel(x, y).red == 0) {
                    var candidate = false, X = false, Y = false;
                    if (image.getPixel(x + 1, y).red == 255 && image.getPixel(x - 1, y).red == 255) {
                        candidate = true; X = true;
                    }
                    if (image.getPixel(x, y + 1).red == 255 && image.getPixel(x, y - 1).red == 255) {
                        candidate = true; Y = true;
                    }

                    if (candidate) {
                        intermediate.setPixel(x, y, Color.fromRGBA(255, 255, 255));
                        if (X) {
                            intermediate.setPixel(x + 1, y, Color.fromRGBA(0, 0, 0));
                            intermediate.setPixel(x - 1, y, Color.fromRGBA(0, 0, 0));
                        }
                        if (Y) {
                            intermediate.setPixel(x, y + 1, Color.fromRGBA(0, 0, 0));
                            intermediate.setPixel(x, y - 1, Color.fromRGBA(0, 0, 0));
                        }
                    }
                }
            }
        }

        return intermediate;
    }

    /**
        Detects edges within an image.

        Edges are detected using the Perwitt operator, going from left to right and top to bottom.

        There's no need to pre-process the image, just throw it on it and it will do the rest. 
        (ie. it doesn't need to be grayscaled/black and white)

        @param image The image to be processed.
        @param threshold The threshold for detecting edges. The lower the value, the more pixels will be considered edges (check this function's source code for more information).

        @return The image with edges detected. This image is returned as a new, black and white image.
    **/
    public static function perwittEdgeDetection(image:Image, threshold:Float = 100):Image {

        // If you came here for the explanation of the algorithm, Congrats! learning is fun :D
        /*
            What does this algorithm do?
            Basically, it takes 9 pixels chunks each time it performs a calculation, and tries to see how different the
            colors of the pixels from the left are from the right. for example, lets say this is the chunk:

                 0 ,  0 , 112
                 0 , 112, 112
                121, 112, 112
            
            With the naked eye, we can see that the pixels are very different from each other, and therefore, are edges.
            The way the algorithm knows it, is: its multiplying the left side by -1, the middle by 0 and the right by 1, 
            and then adding them together:

                 0  *-1 +  0  *-1 + 121 *-1 = -121 |
                 0  * 0 + 112 * 0 + 112 * 0 =   0  | + = 215
                112 * 1 + 112 * 1 + 112 * 1 =  336 |

            Now, if this value is greater than the threshold, then we declare it an edge. now, were gonna do the same thing
            for all chunks of the image, and from top to bottom too if needed.
        */
        var edges = new Image(image.width, image.height, Color.fromRGBA(0, 0, 0));
        var blacknwhite = grayscale(image.clone());
        for (x in 1...blacknwhite.width - 1) {
            for (y in 1...blacknwhite.height - 1) {
                var neighbors = [
                    blacknwhite.getPixel(x - 1, y - 1), 
                    blacknwhite.getPixel(x, y - 1), 
                    blacknwhite.getPixel(x + 1, y - 1),
                    blacknwhite.getPixel(x - 1, y), 
                    blacknwhite.getPixel(x, y),
                    blacknwhite.getPixel(x + 1, y),
                    blacknwhite.getPixel(x - 1, y + 1), 
                    blacknwhite.getPixel(x, y + 1), 
                    blacknwhite.getPixel(x + 1, y + 1)
                ];
                final perwittCalculationIterationLTR = 
                    neighbors[0].red * -1 + neighbors[3].red * -1 + neighbors[6].red * -1 +
                    neighbors[2].red * 1 + neighbors[5].red * 1 + neighbors[8].red * 1
                ;
                if (Math.abs(perwittCalculationIterationLTR) > threshold) {
                    edges.setPixel(x, y, Color.fromRGBA(255, 255, 255));
                    continue;
                }
                final perwittCalculationIterationTTB = 
                    neighbors[0].red * -1 + neighbors[1].red * -1 + neighbors[2].red * -1 +
                    neighbors[6].red * 1 + neighbors[7].red * 1 + neighbors[8].red * 1
                ;
                if (Math.abs(perwittCalculationIterationTTB) > threshold) {
                    edges.setPixel(x, y, Color.fromRGBA(255, 255, 255));
                    continue;
                }
            }
        }
        return edges;
    }

    /**
        Uses an iterative, nearest-neighbor style algorithm to blur an image.

        The algorithm is very simple and quite fast, but also very sensitive 
        performance-wise. The maximum value recommended ti use for the 
        `iterations` property is 100.

        @param image The image to be blurred.
        @param iterations The number of times the algorithm will be run. the more iterations, the more blurry the image will be, and the higher the "blur range". for example: a value of 3 will produce a blur range of 3 pixels on each object.

        @return The blurred image.
    **/
    public static function nearestNeighborBlur(image:Image, iterations:Int = 1):Image {
        for (i in 0...iterations) convolve(image, BoxBlur);
        return image;
    }

    /**
        Uses the gaussian blur algorithm to blur an image.

        This algorithm works by creating a 5x5 (thats the default size) matrix, and then applying
        the gaussian distribution function to that matrix.

        That matrix will go over each pixel and decide it's color based on the values of 
        the pixels covered by the 5x5 matrix, and the [gaussian distribution function](https://en.wikipedia.org/wiki/Gaussian_function).

        You can modify the values of the matrix by passing a float to the `sigma` parameter.
        The higher the value of `sigma`, the more value will be given to the center pixel's color, and the less value will be given to the surrounding pixels.

        example of how sigma values effect distribution:
        \
        \
        \
        ![gaussian distribution at different sigma values](https://i.stack.imgur.com/B33AE.png)
    **/
    public static function gaussianBlur(image:Image, ?sigma:Float = 1, ?kernalSize:GaussianKernalSize = GaussianKernalSize.X5):Image {
        return convolve(image, GaussianBlur(kernalSize, sigma));
    }

    /**
     * Applies a median filter to an image to reduce the amount of noise in that image.
     * @param image 
     * @param kernalRadius 
     * @return Image
     */
    public static function medianBlur(image:Image, kernalRadius:Int):Image {
        var medianed = new Image(image.width, image.height);

        image.forEachPixel((x, y, color) -> {
            var neighbors:Array<UInt> = image.getNeighborsOfPixel(x, y, kernalRadius).flatten();
            //Radix.sort(neighbors);
            ArraySort.sort(neighbors, (a, b) -> a - b);
            medianed.setPixel(x, y, neighbors[Std.int(neighbors.length / 2)]);
        });

        return image = medianed;
    }

    /**
        Uses Canny's edge multi stage edge detection algorithm to detect edges in an image,
        while reducing noise.

        This algorithm works by first applying a gaussian blur to the image, and then
        applying more filters to differentiate between strong edges, weak edges and non-edges.

        @param image The image to be edge detected.
        @param sigma The sigma value to be used in the gaussian blur.
        @param initialKernalSize This is used for the second step of the canny edge detection - gaussian blur. unless you want to improve performance, this should remain unchanged.
        @param lowThreshold The low threshold value to be used in the hysteresis thresholding.
        @param highThreshold The high threshold value to be used in the hysteresis thresholding.

        @return The edge detected image.

    **/
    public static function cannyEdgeDetection(image:Image, sigma:Float = 1, initialKernalSize:GaussianKernalSize = X5, lowThreshold:Float = 0.05, highThreshold:Float = 0.2):Image {
        var cannyObject:CannyObject = image.clone();
        return blackAndWhite(cannyObject.grayscale().applyGaussian(initialKernalSize, sigma).applySobelFilters().nonMaxSuppression().applyHysteresis(highThreshold, lowThreshold), 40);
    }

    /**
        Uses a simple, partially recursive algorithm to detect line segments in an image.

        those lines can be partially incomplete, but they will be detected as lines.

        @param image The image to be line detected.
        @param accuracy When a line is detected, the algorithm checks how much of the line actually covers a 
        "line portion" of the image. `accuracy` is set to `50` by default - at least half of the line has to match with the image.
        To optimize for line count, `40` and below is recommended. otherwise, `50` to `60` should be fine.
        @param minLineLength The minimum length of a line segment to be detected.
        @param speedToAccuracyRatio  If the algorithm is too slow/too inaccurate for you, you can change this setting.

        @return The line detected image.
    **/
    public static function simpleLine2DDetection(image:Image, accuracy:Float = 50, minLineLength:Float = 10, ?speedToAccuracyRatio:AlgorithmSettings = Medium_Intermidiate):Array<Line2D> {
        final kernalSize = switch speedToAccuracyRatio {
            case VeryLow_VeryFast: X1;
            case Low_Fast: X3;
            case Medium_Intermidiate: X5;
            case High_Slow: X7;
            case VeryHigh_VerySlow: X9;
        }
        var edgeDetected = cannyEdgeDetection(image, 1, kernalSize, 0.05, 0.16);
        // #if vision_multithread
        // var actualLines:Array<Line2D> = [];
        // var edgeDetectedMirrored = cannyEdgeDetection(image.mirror(), 1, kernalSize, 0.05, 0.16);
        // var lines:Array<Array<Line2D>> = [[], [], [], [], [], [], [], []];
        // var threads:Array<VisionThread> = [];
        // var flag1 = false, flag2 = false, flag3 = false, flag4 = false, flag5 = false, flag6 = false, flag7 = false, flag8 = false;
        // threads.push(VisionThread.create(() -> {image.forEachPixel((x, y, color) -> lines[0].push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength)));flag1 = true;}));
        // threads.push(VisionThread.create(() -> {image.forEachPixel((x, y, color) -> lines[1].push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true)));flag2 = true;}));
        // threads.push(VisionThread.create(() -> {image.forEachPixel((x, y, color) -> lines[2].push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, false, true)));flag3 = true;}));
        // threads.push(VisionThread.create(() -> {image.forEachPixel((x, y, color) -> lines[3].push(SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true, true)));flag4 = true;}));
        // threads.push(VisionThread.create(() -> {image.forEachPixel((x, y, color) -> lines[4].push(SimpleLineDetector.findLineFromPoint(edgeDetectedMirrored, {x: x, y: y}, minLineLength)));flag5 = true;}));
        // threads.push(VisionThread.create(() -> {image.forEachPixel((x, y, color) -> lines[5].push(SimpleLineDetector.findLineFromPoint(edgeDetectedMirrored, {x: x, y: y}, minLineLength, true)));flag6 = true;}));
        // threads.push(VisionThread.create(() -> {image.forEachPixel((x, y, color) -> lines[6].push(SimpleLineDetector.findLineFromPoint(edgeDetectedMirrored, {x: x, y: y}, minLineLength, false, true)));flag7 = true;}));
        // threads.push(VisionThread.create(() -> {image.forEachPixel((x, y, color) -> lines[7].push(SimpleLineDetector.findLineFromPoint(edgeDetectedMirrored, {x: x, y: y}, minLineLength, true, true)));flag8 = true;}));
        // for (i in 0...8) {
        //     threads[i].relaunchEvents = true;
        //     threads[i].onDone = () -> {
        //         for (l in lines[i]) {
        //             if (l == null) continue;
        //             if (i < 4) {
        //                 if (SimpleLineDetector.lineCoveragePercentage(edgeDetected, l) < accuracy) continue;
        //                 actualLines.push(l);
        //             } else {
        //                 if (SimpleLineDetector.lineCoveragePercentage(edgeDetectedMirrored, l) < accuracy) continue;
        //                 actualLines.push(l.mirrorInsideRectangle({x: 0, y: 0, width: image.width, height: image.height}));
        //             }
        //         }
        //     }; 
        // }

        // while (!(flag1 && flag2 && flag3 && flag4 && flag5 && flag6 && flag7 && flag8)) {}
        // #else
        var lines:Array<Line2D> = [];
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var line = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength);
                lines.push(line);
                var line2 = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true);
                lines.push(line2);
                var line3 = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, false, true);
                lines.push(line3);
                var line4 = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true, true);
                lines.push(line4);
            }
        }
        var actualLines:Array<Line2D> = [];
        trace(accuracy);
        for (l in lines) {
            if (l == null) continue;
            if (SimpleLineDetector.lineCoveragePercentage(edgeDetected, l) < accuracy) continue;
            actualLines.push(l);
        }
        //now, get a mirrored version
        var edgeDetected = cannyEdgeDetection(image.mirror(), 1, kernalSize, 0.05, 0.16);
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var line = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength);
                lines.push(line);
                var line2 = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true);
                lines.push(line2);
                var line3 = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, false, true);
                lines.push(line3);
                var line4 = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineLength, true, true);
                lines.push(line4);
            }
        }
        for (l in lines) {
            if (l == null) continue;
            if (SimpleLineDetector.lineCoveragePercentage(edgeDetected, l) < accuracy) continue;
            actualLines.push(l.mirrorInsideRectangle({x: 0, y: 0, width: image.width, height: image.height}));
        }
        // #end
        return actualLines;
    }

    /**
     * Applies the sobel filter to an image.
     * 
     * The image doesn't have to get grayscaled before being passed 
     * to this function.
     * 
     * It is different from the `sobelEdgeDetection` function, since
     * it doesn't try to threshold the resulting image to extract the strong edges,
     * and leaves that information in. example of this filter in action:
     * 
     * |Status|Image|
     * |---|---|
     * |before filtering: |![Pre-Processed](https://i.stack.imgur.com/Bnxa6.jpg)|
     * |after filtering:|![Post-Processed](https://i.stack.imgur.com/o54O0.png)|
     * 
     * @param image The image to be operated on
     * @return A new image, containing the gradients of the edges as whitened pixels.
     */
    public static function sobelEdgeDiffOperator(image:Image) {
        return Sobel.convolveWithSobelOperator(grayscale(image.clone()));   
    }

    /**
     * Applies the perwitt filter to an image.
     * 
     * The image doesnt have to get grayscaled before being passed 
     * to this function.
     * 
     * It is different from the `perwittEdgeDetection` function, since
     * it doesnt try to threshold the resulting image to extract the strong edges,
     * and leaves that information in. example of this filter in action:
     * 
     * |Status|Image|
     * |---|---|
     * |before filtering: |![Pre-Processed](https://i.stack.imgur.com/Bnxa6.jpg)|
     * |after filtering:|![Post-Processed](https://i.stack.imgur.com/o54O0.png)|
     * 
     * @param image The image to be operated on
     * @return A new image, containing the gradients of the edges as whitened pixels.
     */
     public static function perwittEdgeDiffOperator(image:Image) {
        return Perwitt.convolveWithPerwittOperator(grayscale(image.clone()));   
    }
}