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
    public static function vision_Vision__combine_Image_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var with = new vision.ds.Image(100, 100);
			var percentage = 0.0;
			
            var result = vision.Vision.combine(image, with, percentage);

            return {
                testName: "vision.Vision.combine",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.combine",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__tint_Image_Color_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var withColor:Color = null;
			var percentage = 0.0;
			
            var result = vision.Vision.tint(image, withColor, percentage);

            return {
                testName: "vision.Vision.tint",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.tint",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__grayscale_Image_Bool_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var simpleGrayscale = false;
			
            var result = vision.Vision.grayscale(image, simpleGrayscale);

            return {
                testName: "vision.Vision.grayscale",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.grayscale",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__invert_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.Vision.invert(image);

            return {
                testName: "vision.Vision.invert",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.invert",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__sepia_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			
            var result = vision.Vision.sepia(image, strength);

            return {
                testName: "vision.Vision.sepia",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.sepia",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__blackAndWhite_Image_Int_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0;
			
            var result = vision.Vision.blackAndWhite(image, threshold);

            return {
                testName: "vision.Vision.blackAndWhite",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.blackAndWhite",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__contrast_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.Vision.contrast(image);

            return {
                testName: "vision.Vision.contrast",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.contrast",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__smooth_Image_Float_Bool_Int_Bool_Int_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			var affectAlpha = false;
			var kernelRadius = 0;
			var circularKernel = false;
			var iterations = 0;
			
            var result = vision.Vision.smooth(image, strength, affectAlpha, kernelRadius, circularKernel, iterations);

            return {
                testName: "vision.Vision.smooth",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.smooth",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__pixelate_Image_Bool_Int_Bool_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var averagePixels = false;
			var pixelSize = 0;
			var affectAlpha = false;
			
            var result = vision.Vision.pixelate(image, averagePixels, pixelSize, affectAlpha);

            return {
                testName: "vision.Vision.pixelate",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.pixelate",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__posterize_Image_Int_Bool_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var bitsPerChannel = 0;
			var affectAlpha = false;
			
            var result = vision.Vision.posterize(image, bitsPerChannel, affectAlpha);

            return {
                testName: "vision.Vision.posterize",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.posterize",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__sharpen_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.Vision.sharpen(image);

            return {
                testName: "vision.Vision.sharpen",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.sharpen",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__deepfry_Image_Int_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var iterations = 0;
			
            var result = vision.Vision.deepfry(image, iterations);

            return {
                testName: "vision.Vision.deepfry",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.deepfry",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__vignette_Image_Float_Float_Bool_Color_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			var intensity = 0.0;
			var ratioDependent = false;
			var color:Color = null;
			
            var result = vision.Vision.vignette(image, strength, intensity, ratioDependent, color);

            return {
                testName: "vision.Vision.vignette",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.vignette",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__fisheyeDistortion_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			
            var result = vision.Vision.fisheyeDistortion(image, strength);

            return {
                testName: "vision.Vision.fisheyeDistortion",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.fisheyeDistortion",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__barrelDistortion_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			
            var result = vision.Vision.barrelDistortion(image, strength);

            return {
                testName: "vision.Vision.barrelDistortion",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.barrelDistortion",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__pincushionDistortion_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var strength = 0.0;
			
            var result = vision.Vision.pincushionDistortion(image, strength);

            return {
                testName: "vision.Vision.pincushionDistortion",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.pincushionDistortion",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__mustacheDistortion_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var amplitude = 0.0;
			
            var result = vision.Vision.mustacheDistortion(image, amplitude);

            return {
                testName: "vision.Vision.mustacheDistortion",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.mustacheDistortion",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__dilate_Image_Int_ColorImportanceOrder_Bool_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var dilationRadius = 0;
			var colorImportanceOrder:ColorImportanceOrder = null;
			var circularKernel = false;
			
            var result = vision.Vision.dilate(image, dilationRadius, colorImportanceOrder, circularKernel);

            return {
                testName: "vision.Vision.dilate",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.dilate",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__erode_Image_Int_ColorImportanceOrder_Bool_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var erosionRadius = 0;
			var colorImportanceOrder:ColorImportanceOrder = null;
			var circularKernel = false;
			
            var result = vision.Vision.erode(image, erosionRadius, colorImportanceOrder, circularKernel);

            return {
                testName: "vision.Vision.erode",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.erode",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__saltAndPepperNoise_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var percentage = 0.0;
			
            var result = vision.Vision.saltAndPepperNoise(image, percentage);

            return {
                testName: "vision.Vision.saltAndPepperNoise",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.saltAndPepperNoise",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__dropOutNoise_Image_Float_Int_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var percentage = 0.0;
			var threshold = 0;
			
            var result = vision.Vision.dropOutNoise(image, percentage, threshold);

            return {
                testName: "vision.Vision.dropOutNoise",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.dropOutNoise",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__whiteNoise_Image_Float_WhiteNoiseRange_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var percentage = 0.0;
			var whiteNoiseRange:WhiteNoiseRange = null;
			
            var result = vision.Vision.whiteNoise(image, percentage, whiteNoiseRange);

            return {
                testName: "vision.Vision.whiteNoise",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.whiteNoise",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__normalize_Image_Color_Color_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var rangeStart:Color = null;
			var rangeEnd:Color = null;
			
            var result = vision.Vision.normalize(image, rangeStart, rangeEnd);

            return {
                testName: "vision.Vision.normalize",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.normalize",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__limitColorRanges_Image_Color_Color_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var rangeStart:Color = null;
			var rangeEnd:Color = null;
			
            var result = vision.Vision.limitColorRanges(image, rangeStart, rangeEnd);

            return {
                testName: "vision.Vision.limitColorRanges",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.limitColorRanges",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__replaceColorRanges_Image_ArrayrangeStartColorrangeEndColorreplacementColor_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var ranges = [];
			
            var result = vision.Vision.replaceColorRanges(image, ranges);

            return {
                testName: "vision.Vision.replaceColorRanges",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.replaceColorRanges",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__filterForColorChannel_Image_ColorChannel_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var channel:ColorChannel = null;
			
            var result = vision.Vision.filterForColorChannel(image, channel);

            return {
                testName: "vision.Vision.filterForColorChannel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.filterForColorChannel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__convolve_Image_EitherTypeKernel2DArrayArrayFloat_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var kernel:EitherType<Kernel2D, Array<Array<Float>>> = null;
			
            var result = vision.Vision.convolve(image, kernel);

            return {
                testName: "vision.Vision.convolve",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.convolve",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__affineTransform_Image_TransformationMatrix2D_ImageExpansionMode_Point2D_TransformationMatrixOrigination_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var matrix:TransformationMatrix2D = null;
			var expansionMode:ImageExpansionMode = null;
			var originPoint = new vision.ds.Point2D(0, 0);
			var originMode:TransformationMatrixOrigination = null;
			
            var result = vision.Vision.affineTransform(image, matrix, expansionMode, originPoint, originMode);

            return {
                testName: "vision.Vision.affineTransform",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.affineTransform",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__projectiveTransform_Image_TransformationMatrix2D_ImageExpansionMode_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var matrix:TransformationMatrix2D = null;
			var expansionMode:ImageExpansionMode = null;
			
            var result = vision.Vision.projectiveTransform(image, matrix, expansionMode);

            return {
                testName: "vision.Vision.projectiveTransform",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.projectiveTransform",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__nearestNeighborBlur_Image_Int_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var iterations = 0;
			
            var result = vision.Vision.nearestNeighborBlur(image, iterations);

            return {
                testName: "vision.Vision.nearestNeighborBlur",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.nearestNeighborBlur",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__gaussianBlur_Image_Float_GaussianKernelSize_Bool_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var sigma = 0.0;
			var kernelSize:GaussianKernelSize = null;
			var fast = false;
			
            var result = vision.Vision.gaussianBlur(image, sigma, kernelSize, fast);

            return {
                testName: "vision.Vision.gaussianBlur",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.gaussianBlur",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__medianBlur_Image_Int_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var kernelSize = 0;
			
            var result = vision.Vision.medianBlur(image, kernelSize);

            return {
                testName: "vision.Vision.medianBlur",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.medianBlur",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__simpleLine2DDetection_Image_Float_Float_AlgorithmSettings_ArrayLine2D__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var accuracy = 0.0;
			var minLineLength = 0.0;
			var speedToAccuracyRatio:AlgorithmSettings = null;
			
            var result = vision.Vision.simpleLine2DDetection(image, accuracy, minLineLength, speedToAccuracyRatio);

            return {
                testName: "vision.Vision.simpleLine2DDetection",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.simpleLine2DDetection",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__sobelEdgeDiffOperator_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.Vision.sobelEdgeDiffOperator(image);

            return {
                testName: "vision.Vision.sobelEdgeDiffOperator",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.sobelEdgeDiffOperator",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__perwittEdgeDiffOperator_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.Vision.perwittEdgeDiffOperator(image);

            return {
                testName: "vision.Vision.perwittEdgeDiffOperator",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.perwittEdgeDiffOperator",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__robertEdgeDiffOperator_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.Vision.robertEdgeDiffOperator(image);

            return {
                testName: "vision.Vision.robertEdgeDiffOperator",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.robertEdgeDiffOperator",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__laplacianEdgeDiffOperator_Image_Bool_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var filterPositive = false;
			
            var result = vision.Vision.laplacianEdgeDiffOperator(image, filterPositive);

            return {
                testName: "vision.Vision.laplacianEdgeDiffOperator",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.laplacianEdgeDiffOperator",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__cannyEdgeDetection_Image_Float_GaussianKernelSize_Float_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var sigma = 0.0;
			var kernelSize:GaussianKernelSize = null;
			var lowThreshold = 0.0;
			var highThreshold = 0.0;
			
            var result = vision.Vision.cannyEdgeDetection(image, sigma, kernelSize, lowThreshold, highThreshold);

            return {
                testName: "vision.Vision.cannyEdgeDetection",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.cannyEdgeDetection",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__sobelEdgeDetection_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0.0;
			
            var result = vision.Vision.sobelEdgeDetection(image, threshold);

            return {
                testName: "vision.Vision.sobelEdgeDetection",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.sobelEdgeDetection",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__perwittEdgeDetection_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0.0;
			
            var result = vision.Vision.perwittEdgeDetection(image, threshold);

            return {
                testName: "vision.Vision.perwittEdgeDetection",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.perwittEdgeDetection",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__laplacianOfGaussianEdgeDetection_Image_Int_Bool_Float_GaussianKernelSize_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0;
			var filterPositive = false;
			var sigma = 0.0;
			var kernelSize:GaussianKernelSize = null;
			
            var result = vision.Vision.laplacianOfGaussianEdgeDetection(image, threshold, filterPositive, sigma, kernelSize);

            return {
                testName: "vision.Vision.laplacianOfGaussianEdgeDetection",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.laplacianOfGaussianEdgeDetection",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__convolutionRidgeDetection_Image_Color_Color_Bool_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var normalizationRangeStart:Color = null;
			var normalizationRangeEnd:Color = null;
			var refine = false;
			
            var result = vision.Vision.convolutionRidgeDetection(image, normalizationRangeStart, normalizationRangeEnd, refine);

            return {
                testName: "vision.Vision.convolutionRidgeDetection",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.convolutionRidgeDetection",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__bilateralDenoise_Image_Float_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var gaussianSigma = 0.0;
			var intensitySigma = 0.0;
			
            var result = vision.Vision.bilateralDenoise(image, gaussianSigma, intensitySigma);

            return {
                testName: "vision.Vision.bilateralDenoise",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.bilateralDenoise",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__simpleImageSimilarity_Image_Image_SimilarityScoringMechanism_Float__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var compared = new vision.ds.Image(100, 100);
			var scoringMechanism:SimilarityScoringMechanism = null;
			
            var result = vision.Vision.simpleImageSimilarity(image, compared, scoringMechanism);

            return {
                testName: "vision.Vision.simpleImageSimilarity",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.simpleImageSimilarity",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__kmeansPosterize_Image_Int_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var maxColorCount = 0;
			
            var result = vision.Vision.kmeansPosterize(image, maxColorCount);

            return {
                testName: "vision.Vision.kmeansPosterize",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.kmeansPosterize",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_Vision__kmeansGroupImageColors_Image_Int_Bool_ArrayColorCluster__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var groupCount = 0;
			var considerTransparency = false;
			
            var result = vision.Vision.kmeansGroupImageColors(image, groupCount, considerTransparency);

            return {
                testName: "vision.Vision.kmeansGroupImageColors",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.Vision.kmeansGroupImageColors",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}