package tests;

import TestResult;
import TestStatus;

import vision.Vision;
import vision.algorithms.ImageHashing;
import vision.ds.ByteArray;
import vision.ds.kmeans.ColorCluster;
import haxe.io.Bytes;
import haxe.crypto.Sha256;
import vision.exceptions.Unimplemented;
import vision.ds.specifics.SimilarityScoringMechanism;
import vision.algorithms.KMeans;
import vision.ds.specifics.ColorChannel;
import vision.ds.TransformationMatrix2D;
import vision.ds.specifics.TransformationMatrixOrigination;
import vision.ds.Point3D;
import vision.ds.specifics.ImageExpansionMode;
import vision.algorithms.PerspectiveWarp;
import vision.ds.specifics.PointTransformationPair;
import vision.algorithms.BilinearInterpolation;
import vision.ds.Matrix2D;
import vision.ds.Int16Point2D;
import haxe.ds.Vector;
import vision.ds.specifics.WhiteNoiseRange;
import vision.algorithms.Laplace;
import vision.ds.specifics.ColorImportanceOrder;
import vision.algorithms.BilateralFilter;
import vision.algorithms.RobertsCross;
import vision.ds.IntPoint2D;
import haxe.extern.EitherType;
import vision.algorithms.Radix;
import haxe.ds.ArraySort;
import vision.ds.Histogram;
import vision.ds.specifics.AlgorithmSettings;
import vision.algorithms.Perwitt;
import vision.algorithms.Sobel;
import vision.ds.Kernel2D;
import vision.ds.canny.CannyObject;
import vision.algorithms.SimpleLineDetector;
import vision.ds.gaussian.GaussianKernelSize;
import vision.ds.Ray2D;
import vision.algorithms.Gauss;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools;
import vision.tools.MathTools.*;

@:access(vision.Vision)
class VisionTests {
    public static function vision_Vision__whiteNoise__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var percentage = 0.0;
			var whiteNoiseRange:WhiteNoiseRange = null;
			
            result = vision.Vision.whiteNoise(image, percentage, whiteNoiseRange);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.whiteNoise",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__vignette__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			var intensity = 0.0;
			var ratioDependent = false;
			var color:Color = null;
			
            result = vision.Vision.vignette(image, strength, intensity, ratioDependent, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.vignette",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__tint__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var withColor:Color = null;
			var percentage = 0.0;
			
            result = vision.Vision.tint(image, withColor, percentage);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.tint",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__sobelEdgeDiffOperator__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			
            result = vision.Vision.sobelEdgeDiffOperator(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.sobelEdgeDiffOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__sobelEdgeDetection__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0.0;
			
            result = vision.Vision.sobelEdgeDetection(image, threshold);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.sobelEdgeDetection",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__smooth__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			var affectAlpha = false;
			var kernelRadius = 0;
			var circularKernel = false;
			var iterations = 0;
			
            result = vision.Vision.smooth(image, strength, affectAlpha, kernelRadius, circularKernel, iterations);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.smooth",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__simpleImageSimilarity__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var compared = new vision.ds.Image(100, 100);
			var scoringMechanism:SimilarityScoringMechanism = null;
			
            result = vision.Vision.simpleImageSimilarity(image, compared, scoringMechanism);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.simpleImageSimilarity",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__sharpen__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			
            result = vision.Vision.sharpen(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.sharpen",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__sepia__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			
            result = vision.Vision.sepia(image, strength);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.sepia",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__saltAndPepperNoise__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var percentage = 0.0;
			
            result = vision.Vision.saltAndPepperNoise(image, percentage);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.saltAndPepperNoise",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__robertEdgeDiffOperator__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			
            result = vision.Vision.robertEdgeDiffOperator(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.robertEdgeDiffOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__replaceColorRanges__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var ranges:Array<{rangeStart:Color, rangeEnd:Color, replacement:Color}> = null;
			
            result = vision.Vision.replaceColorRanges(image, ranges);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.replaceColorRanges",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__projectiveTransform__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var matrix:TransformationMatrix2D = null;
			var expansionMode:ImageExpansionMode = null;
			
            result = vision.Vision.projectiveTransform(image, matrix, expansionMode);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.projectiveTransform",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__posterize__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var bitsPerChannel = 0;
			var affectAlpha = false;
			
            result = vision.Vision.posterize(image, bitsPerChannel, affectAlpha);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.posterize",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__pixelate__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var averagePixels = false;
			var pixelSize = 0;
			var affectAlpha = false;
			
            result = vision.Vision.pixelate(image, averagePixels, pixelSize, affectAlpha);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.pixelate",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__pincushionDistortion__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			
            result = vision.Vision.pincushionDistortion(image, strength);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.pincushionDistortion",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__perwittEdgeDiffOperator__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			
            result = vision.Vision.perwittEdgeDiffOperator(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.perwittEdgeDiffOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__perwittEdgeDetection__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0.0;
			
            result = vision.Vision.perwittEdgeDetection(image, threshold);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.perwittEdgeDetection",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__normalize__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var rangeStart:Color = null;
			var rangeEnd:Color = null;
			
            result = vision.Vision.normalize(image, rangeStart, rangeEnd);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.normalize",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__nearestNeighborBlur__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var iterations = 0;
			
            result = vision.Vision.nearestNeighborBlur(image, iterations);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.nearestNeighborBlur",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__mustacheDistortion__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var amplitude = 0.0;
			
            result = vision.Vision.mustacheDistortion(image, amplitude);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.mustacheDistortion",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__medianBlur__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var kernelSize = 0;
			
            result = vision.Vision.medianBlur(image, kernelSize);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.medianBlur",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__limitColorRanges__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var rangeStart:Color = null;
			var rangeEnd:Color = null;
			
            result = vision.Vision.limitColorRanges(image, rangeStart, rangeEnd);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.limitColorRanges",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__laplacianOfGaussianEdgeDetection__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0;
			var filterPositive = false;
			var sigma = 0.0;
			var kernelSize:GaussianKernelSize = null;
			
            result = vision.Vision.laplacianOfGaussianEdgeDetection(image, threshold, filterPositive, sigma, kernelSize);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.laplacianOfGaussianEdgeDetection",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__laplacianEdgeDiffOperator__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var filterPositive = false;
			
            result = vision.Vision.laplacianEdgeDiffOperator(image, filterPositive);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.laplacianEdgeDiffOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__kmeansPosterize__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var maxColorCount = 0;
			
            result = vision.Vision.kmeansPosterize(image, maxColorCount);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.kmeansPosterize",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__invert__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			
            result = vision.Vision.invert(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.invert",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__grayscale__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var simpleGrayscale = false;
			
            result = vision.Vision.grayscale(image, simpleGrayscale);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.grayscale",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__gaussianBlur__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var sigma = 0.0;
			var kernelSize:GaussianKernelSize = null;
			var fast = false;
			
            result = vision.Vision.gaussianBlur(image, sigma, kernelSize, fast);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.gaussianBlur",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__fisheyeDistortion__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			
            result = vision.Vision.fisheyeDistortion(image, strength);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.fisheyeDistortion",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__filterForColorChannel__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var channel:ColorChannel = null;
			
            result = vision.Vision.filterForColorChannel(image, channel);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.filterForColorChannel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__erode__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var erosionRadius = 0;
			var colorImportanceOrder:ColorImportanceOrder = null;
			var circularKernel = false;
			
            result = vision.Vision.erode(image, erosionRadius, colorImportanceOrder, circularKernel);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.erode",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__dropOutNoise__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var percentage = 0.0;
			var threshold = 0;
			
            result = vision.Vision.dropOutNoise(image, percentage, threshold);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.dropOutNoise",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__dilate__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var dilationRadius = 0;
			var colorImportanceOrder:ColorImportanceOrder = null;
			var circularKernel = false;
			
            result = vision.Vision.dilate(image, dilationRadius, colorImportanceOrder, circularKernel);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.dilate",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__deepfry__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var iterations = 0;
			
            result = vision.Vision.deepfry(image, iterations);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.deepfry",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__convolve__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var kernel:EitherType<Kernel2D, Array<Array<Float>>> = null;
			
            result = vision.Vision.convolve(image, kernel);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.convolve",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__convolutionRidgeDetection__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var normalizationRangeStart:Color = null;
			var normalizationRangeEnd:Color = null;
			var refine = false;
			
            result = vision.Vision.convolutionRidgeDetection(image, normalizationRangeStart, normalizationRangeEnd, refine);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.convolutionRidgeDetection",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__contrast__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			
            result = vision.Vision.contrast(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.contrast",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__combine__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var with = new vision.ds.Image(100, 100);
			var percentage = 0.0;
			
            result = vision.Vision.combine(image, with, percentage);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.combine",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__cannyEdgeDetection__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var sigma = 0.0;
			var kernelSize:GaussianKernelSize = null;
			var lowThreshold = 0.0;
			var highThreshold = 0.0;
			
            result = vision.Vision.cannyEdgeDetection(image, sigma, kernelSize, lowThreshold, highThreshold);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.cannyEdgeDetection",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__blackAndWhite__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0;
			
            result = vision.Vision.blackAndWhite(image, threshold);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.blackAndWhite",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__bilateralDenoise__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var gaussianSigma = 0.0;
			var intensitySigma = 0.0;
			
            result = vision.Vision.bilateralDenoise(image, gaussianSigma, intensitySigma);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.bilateralDenoise",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__barrelDistortion__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			
            result = vision.Vision.barrelDistortion(image, strength);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.barrelDistortion",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_Vision__affineTransform__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var matrix:TransformationMatrix2D = null;
			var expansionMode:ImageExpansionMode = null;
			var originPoint = new vision.ds.Point2D(0, 0);
			var originMode:TransformationMatrixOrigination = null;
			
            result = vision.Vision.affineTransform(image, matrix, expansionMode, originPoint, originMode);
        } catch (e) {
            
        }

        return {
            testName: "vision.Vision.affineTransform",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_Vision__whiteNoise__ShouldWork, 
		vision_Vision__vignette__ShouldWork, 
		vision_Vision__tint__ShouldWork, 
		vision_Vision__sobelEdgeDiffOperator__ShouldWork, 
		vision_Vision__sobelEdgeDetection__ShouldWork, 
		vision_Vision__smooth__ShouldWork, 
		vision_Vision__simpleImageSimilarity__ShouldWork, 
		vision_Vision__sharpen__ShouldWork, 
		vision_Vision__sepia__ShouldWork, 
		vision_Vision__saltAndPepperNoise__ShouldWork, 
		vision_Vision__robertEdgeDiffOperator__ShouldWork, 
		vision_Vision__replaceColorRanges__ShouldWork, 
		vision_Vision__projectiveTransform__ShouldWork, 
		vision_Vision__posterize__ShouldWork, 
		vision_Vision__pixelate__ShouldWork, 
		vision_Vision__pincushionDistortion__ShouldWork, 
		vision_Vision__perwittEdgeDiffOperator__ShouldWork, 
		vision_Vision__perwittEdgeDetection__ShouldWork, 
		vision_Vision__normalize__ShouldWork, 
		vision_Vision__nearestNeighborBlur__ShouldWork, 
		vision_Vision__mustacheDistortion__ShouldWork, 
		vision_Vision__medianBlur__ShouldWork, 
		vision_Vision__limitColorRanges__ShouldWork, 
		vision_Vision__laplacianOfGaussianEdgeDetection__ShouldWork, 
		vision_Vision__laplacianEdgeDiffOperator__ShouldWork, 
		vision_Vision__kmeansPosterize__ShouldWork, 
		vision_Vision__invert__ShouldWork, 
		vision_Vision__grayscale__ShouldWork, 
		vision_Vision__gaussianBlur__ShouldWork, 
		vision_Vision__fisheyeDistortion__ShouldWork, 
		vision_Vision__filterForColorChannel__ShouldWork, 
		vision_Vision__erode__ShouldWork, 
		vision_Vision__dropOutNoise__ShouldWork, 
		vision_Vision__dilate__ShouldWork, 
		vision_Vision__deepfry__ShouldWork, 
		vision_Vision__convolve__ShouldWork, 
		vision_Vision__convolutionRidgeDetection__ShouldWork, 
		vision_Vision__contrast__ShouldWork, 
		vision_Vision__combine__ShouldWork, 
		vision_Vision__cannyEdgeDetection__ShouldWork, 
		vision_Vision__blackAndWhite__ShouldWork, 
		vision_Vision__bilateralDenoise__ShouldWork, 
		vision_Vision__barrelDistortion__ShouldWork, 
		vision_Vision__affineTransform__ShouldWork];
}