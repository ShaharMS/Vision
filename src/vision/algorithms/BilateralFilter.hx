package vision.algorithms;

import haxe.ds.Vector;
import vision.ds.Color;
import vision.ds.Array2D;
import vision.ds.Image;

class BilateralFilter {

    /**
        Applies bilateral filtering.
        
        @param image The image to work with
        @param distanceSigma The sigma values used to generate the gaussian kernal. the kernal's size is 6`distanceSigma`, since 3`distanceSigma` is the radius
        @param intensitySigma The sigma used to calculate the intensity vector
        @return Image
    **/
    public static function filter(image:Image, distanceSigma:Float, intensitySigma:Float):Image {
        var gaussianKernelMatrix:Array2D<Float>;
        var intensityVector:Vector<Float>;

        // Using 3σ rule for filter radius - basically, a kernal radius larger than 3σ computes unnecessary pixels.
        var kernelSize:Int = cast Math.floor(6 * distanceSigma) + 1;
        if (kernelSize % 2 == 0) kernelSize++;
        gaussianKernelMatrix = Gaussian.createKernalOfSize(kernelSize, distanceSigma);

        /*
            Precalculate the intensity vector for performance reasons.
            Repeated testing shows this method is consistently about 4x faster

            The intensity vector is used to get the intensity needed to calculate the weight of each pixel. We get the wanted intensity by plugging in the difference as the index.
            We know there can only be 442 values since filter measure intensity difference as:

                sqrt((red2 - red1)^2 + (green2 - green1)^2 + (blue2 - blue1)^2)

            If we try to get the maximum out of that equation, we need each channel of `2` to be maxed out (255), and each channel of `1` to be 0:

                sqrt((255 - 0)^2 + (255 - 0)^2 + (255 - 0)^2)

            Solving that equation and rounding upwards gives as 442, and since the difference is always a positive integer, 
            there are exactly 442 possibilities for the `difference` value.
        */
        intensityVector = new Vector(442);
        for (i in 0...intensityVector.length) intensityVector[i] = Math.exp(-((i) / (2 * intensitySigma * intensitySigma)));

        /*
            A *way* faster, but slightly imprecise way to compute intensity difference.
        */
        inline function getIntensityDifferenceForVectorPosition(firstColor:Color, secondColor:Color):Int {
            final redDifference = (secondColor.red) - (firstColor.red);
            final greenDifference = (secondColor.green) - (firstColor.green);
            final blueDifference = (secondColor.blue) - (firstColor.blue);

            return Std.int(Math.sqrt(redDifference * redDifference + greenDifference * greenDifference +
                    blueDifference * blueDifference));
        }

        for (x in 0...image.width) {
            for (y in 0...image.height) {
                var numeratorSumR = 0., numeratorSumG = 0., numeratorSumB = 0., denominatorSum = 0., kernelPositionWeight = 0.;

                // needed to transform the kernalSize into something a for loop can work with
                final halfKernelSize = Math.floor(kernelSize / 2);
                final kernelCenterIntensity = image.getPixel(x, y);

                for (i in x - halfKernelSize...x + halfKernelSize) {
                    for (j in y - halfKernelSize...y + halfKernelSize) {
                        if (i >= 0 && j >= 0 && i < image.width && j < image.height) {

                            // (i, j) may be outside the bounds of the image, so we use getSafePixel()
                            final kernelPositionIntensity = image.getSafePixel(i, j);

                            // calculate weight of current kernel position.
                            kernelPositionWeight = gaussianKernelMatrix.get(x - i + halfKernelSize, y - j + halfKernelSize) * intensityVector[getIntensityDifferenceForVectorPosition(kernelCenterIntensity, kernelPositionIntensity)];

                            // process each color component separately.
                            numeratorSumR += kernelPositionWeight * kernelPositionIntensity.red;
                            numeratorSumG += kernelPositionWeight * kernelPositionIntensity.green;
                            numeratorSumB += kernelPositionWeight * kernelPositionIntensity.blue;
                            denominatorSum += kernelPositionWeight;
                        }
                    }
                }

                // normalization by division and color construction, all inline :p
                image.setPixel(x, y, Color.fromRGBA(((Std.int(numeratorSumR / denominatorSum) & 0xFF)), ((Std.int(numeratorSumG / denominatorSum) & 0xFF)), (Std.int(numeratorSumB / denominatorSum) & 0xFF)));
            }
        }

        //cleanup
        intensitySigma = distanceSigma = kernelSize = 0;
        intensityVector = null;
        gaussianKernelMatrix = null;

        return image;
    }
}