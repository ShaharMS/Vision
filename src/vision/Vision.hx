package vision;

import vision.algorithms.SimpleLineDetector;
import vision.ds.gaussian.GaussianKernalSize;
import vision.ds.hough.HoughSpace;
import vision.ds.Ray2D;
import vision.algorithms.Gaussian;
import vision.algorithms.Hough;
import vision.ds.Point2D;
import vision.ds.LineSegment2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools;

using vision.tools.MathTools;

/**
    The class where all image manipulation functions are stored.
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
                var gray = Std.int((pixel.red + pixel.green + pixel.blue) / 3);
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
        function getContrasted(color:Color):Color {
            var red = color.red > 127 ? 255 : 0;
            var green = color.green > 127 ? 255 : 0;
            var blue = color.blue > 127 ? 255 : 0;
            return Color.fromRGBA(red, green, blue);
        }
        
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var pixel = image.getPixel(x, y);
                var contrasted = getContrasted(pixel);
                image.setPixel(x, y, contrasted);
            }
        }

        return image;
    }

    /**
        Uses the hough transform to detect lines inside an image.  

        NOTICE - unlike the `houghLines` function in OpenCV, this function returns line **segments**, and not line equations.
        
        ANOTHER NOTICE - this function doesn't require pre-processing of the image. just throw your image on it and 
        it will do the rest. (ie. it doesn't need to be edge detected/grayscaled)
    
        @param image The image to be processed.H
        @param threshold The threshold for detecting lines. This exists because we need to detect edges before applying the transformation, and this threshold will be used as the argument for the Perwitt edge detector.
        @param maxRayCount The maximum number of rays to be detected. Unless you have a very large image, or a good reason, this should remain unset.
    **/
    public static function houghRay2DDetection(image:Image, threshold:Int = 100, ?maxRayCount:Null<Int> = null):Array<Ray2D> {
        
        var edges = sobelEdgeDetection(image.clone(), threshold); //TODO: #3 switch to canny edge detection
        var houghSpace = Hough.toHoughSpaceWithRays(edges, threshold, maxRayCount);

        return houghSpace.rays;
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
        var blurredImage = image.clone();
        var imageClone = image.clone();
        for (i in 0...iterations) {
            for (x in 1...blurredImage.width - 1) {
                for (y in 1...blurredImage.height - 1) {
                    var neighbors = [
                        imageClone.getPixel(x - 1, y - 1), 
                        imageClone.getPixel(x, y - 1), 
                        imageClone.getPixel(x + 1, y - 1),
                        imageClone.getPixel(x - 1, y), 
                        imageClone.getPixel(x, y),
                        imageClone.getPixel(x + 1, y),
                        imageClone.getPixel(x - 1, y + 1), 
                        imageClone.getPixel(x, y + 1), 
                        imageClone.getPixel(x + 1, y + 1)
                    ];
                    var averageRed = (
                        neighbors[0].red + neighbors[1].red + neighbors[2].red +
                        neighbors[3].red + neighbors[4].red + neighbors[5].red +
                        neighbors[6].red + neighbors[7].red + neighbors[8].red
                    ) / 9;
                    var averageGreen = (
                        neighbors[0].green + neighbors[1].green + neighbors[2].green +
                        neighbors[3].green + neighbors[4].green + neighbors[5].green +
                        neighbors[6].green + neighbors[7].green + neighbors[8].green
                    ) / 9;
                    var averageBlue = (
                        neighbors[0].blue + neighbors[1].blue + neighbors[2].blue +
                        neighbors[3].blue + neighbors[4].blue + neighbors[5].blue +
                        neighbors[6].blue + neighbors[7].blue + neighbors[8].blue
                    ) / 9;
                    blurredImage.setPixel(x, y, Color.fromRGBA(Std.int(averageRed), Std.int(averageGreen), Std.int(averageBlue)));
                }
            }
            imageClone = blurredImage.clone();
        }

        return blurredImage;
    }

    /**
        Uses the gaussian blur algorithm to blur an image.

        This algorithm works by creating a 5x5 (thats the default size) matrix, and then applying
        the gaussiann distribution function to that matrix.

        That matrix will go over each pixel and decide it's color based on the values of 
        the pixels covered by the 5x5 matrix, and the [gaussian distribution function](https://en.wikipedia.org/wiki/Gaussian_function).

        You can modify the values of the matrix by passing a float to the `sigma` parameter.
        The higher the value of `sigma`, the more value will be given to the center pixel's color, and the less value will be given to the surrounding pixels.

        example of how sigma values effect distribution:
        \
        \
        \
        ![gaussian disdribution at different sigma values](https://i.stack.imgur.com/B33AE.png)
    **/
    public static function gaussianBlur(image:Image, ?sigma:Float = 1, ?kernalSize:GaussianKernalSize = GaussianKernalSize.X5):Image {
        var kernal = Gaussian.createKernalOfSize(kernalSize, sigma);
        var blurredImage = image.clone();
        function getNeighbors(x:Int, y:Int):Array<Array<Color>> {
            var neighbors:Array<Array<Color>> = [];
            for (i in 0...kernalSize + 1) neighbors[i] = [];
            var roundedDown = Std.int((kernalSize - 1) / 2);

            for (X in -roundedDown...roundedDown + 1) {
                for (Y in -roundedDown...roundedDown + 1) {
                    if (x + X < 0 || x + X >= image.width || y + Y < 0 || y + Y >= image.height) {
                        neighbors[X + roundedDown].push(null);
                        continue;
                    }
                    neighbors[X + roundedDown].push(image.getPixel(x + X, y + Y));
                }
            }
            return neighbors;
        }
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var neighbors = getNeighbors(x, y);
                var newColor = Color.fromRGBA(0, 0, 0);
                for (X in 0...kernalSize) {
                    for (Y in 0...kernalSize) {
                        if (neighbors[X][Y] == null) {
                            continue;
                        }
                        var red = neighbors[X][Y].red * kernal[X][Y];
                        var green = neighbors[X][Y].green * kernal[X][Y];
                        var blue = neighbors[X][Y].blue * kernal[X][Y];
                        newColor.red += Std.int(red);
                        newColor.green += Std.int(green);
                        newColor.blue += Std.int(blue);
                    }
                }
                blurredImage.setPixel(x, y, newColor);
            }
        }
        return blurredImage;
    }

    /**
        Uses Canny's edge multi stage edge detection algorithm to detect edges in an image,
        while reducing noise.

        This algorithm works by first applying a gaussian blur to the image, and then
        applying more filters to differentiate between strong edges, weak edges and non-edges.

        @param image The image to be edge detected.
        @param sigma The sigma value to be used in the gaussian blur.
        @param threshold The threshold value to be used in the hysteresis thresholding.
        @param lowThreshold The low threshold value to be used in the hysteresis thresholding.
        @param highThreshold The high threshold value to be used in the hysteresis thresholding.

        @return The edge detected image.

    **/
    public static function cannyEdgeDetection(image:Image, sigma:Float = 1, threshold:Float = 0.5, lowThreshold:Float = 0.4, highThreshold:Float = 0.6):Image {
        var blurred = gaussianBlur(image, sigma);
        var grayed = grayscale(blurred);
        var edges = new Image(blurred.width, blurred.height, 0x00000000);

        function getNeighbors(x:Int, y:Int) {
            var neighbors = [[], [], []];
            for (X in -1...2) {
                for (Y in -1...2) {
                    if (x + X < 0 || x + X >= grayed.width || y + Y < 0 || y + Y >= grayed.height) {
                        continue;
                    }
                    neighbors[X + 1][Y + 1] = grayed.getPixel(x + X, y + Y);
                }
            }
            return neighbors;
        }

        for (x in 1...blurred.width - 1) {
            for (y in 1...blurred.height - 1) {
                var neighbors = getNeighbors(x, y);
                var gradient = (
                    neighbors[0][0].redFloat * -1 + neighbors[0][2].redFloat * 1 +
                    neighbors[1][0].redFloat * -2 + neighbors[1][2].redFloat * 2 +
                    neighbors[2][0].redFloat * -1 + neighbors[2][2].redFloat * 1
                ) / 9;
                if (gradient > threshold) {
                    edges.setPixel(x, y, Color.fromRGBAFloat(gradient, gradient, gradient));
                } 
                var gradient = (
                    neighbors[0][0].redFloat * -1 + neighbors[0][1].redFloat * -2 + neighbors[0][2].redFloat * -1 +
                    neighbors[2][0].redFloat * 1 + neighbors[2][1].redFloat * 2 + neighbors[2][2].redFloat * 1
                ) / 9;
                if (gradient > threshold) {
                    edges.setPixel(x, y, Color.fromRGBAFloat(gradient, gradient, gradient));
                }
            }
        }

        return edges;
    }

    /**
        Uses a simple, partially recursive algorithm to detect line segments in an image.

        those lines can be curved/partially incomplete, but they will be detected as lines.

        @param image The image to be line detected.
        @param minLineLength The minimum length of a line segment to be detected.

        @return The line detected image.
    **/
    public static function simpleLineSegment2DDetection(image:Image, minLineGap:Int = 2, minLineLength:Float = 10):Array<LineSegment2D> {
        var lines:Array<LineSegment2D> = [];
        var edgeDetected = blackAndWhite(image.clone(), 1);

        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var line = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineGap, minLineLength);
                if (line != null) {
                    lines.push(line);
                }
            }
        }
        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var line = SimpleLineDetector.findLineFromPoint(edgeDetected, {x: x, y: y}, minLineGap, minLineLength, true);
                if (line != null) {
                    lines.push(line);
                }
            }
        }

        var actualLines:Array<LineSegment2D> = [];
        for (l in lines) {
            var coverage = SimpleLineDetector.lineCoveragePercentage(edgeDetected, l);
            if (coverage > 90) actualLines.push(l);
        }
        return actualLines;
    }
}