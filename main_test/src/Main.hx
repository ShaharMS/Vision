package;

class Main {

    public static function main() {
        var start:Float, end:Float;
        trace("----------Launching Tests----------\n");
        start = haxe.Timer.stamp();
        tests.Test_vision_Vision_laplacianEdgeDiffOperator.main();
		tests.Test_vision_Vision_filterForColorChannel.main();
		tests.Test_vision_Vision_limitColorRanges.main();
		tests.Test_vision_Vision_bilateralDenoise.main();
		tests.Test_vision_Vision_whiteNoise.main();
		tests.Test_vision_Vision_deepfry.main();
		tests.Test_vision_Vision_vignette.main();
		tests.Test_vision_Vision_simpleLine2DDetection.main();
		tests.Test_vision_Vision_kmeansPosterize.main();
		tests.Test_vision_Vision_combine.main();
		tests.Test_vision_Vision_perwittEdgeDiffOperator.main();
		tests.Test_vision_Vision_simpleImageSimilarity.main();
		tests.Test_vision_Vision_cannyEdgeDetection.main();
		tests.Test_vision_Vision_projectiveTransform.main();
		tests.Test_vision_Vision_posterize.main();
		tests.Test_vision_Vision_invert.main();
		tests.Test_vision_Vision_saltAndPepperNoise.main();
		tests.Test_vision_Vision_normalize.main();
		tests.Test_vision_Vision_smooth.main();
		tests.Test_vision_Vision_medianBlur.main();
		tests.Test_vision_Vision_laplacianOfGaussianEdgeDetection.main();
		tests.Test_vision_Vision_convolutionRidgeDetection.main();
		tests.Test_vision_Vision_blackAndWhite.main();
		tests.Test_vision_Vision_fisheyeDistortion.main();
		tests.Test_vision_Vision_erode.main();
		tests.Test_vision_Vision_nearestNeighborBlur.main();
		tests.Test_vision_Vision_mustacheDistortion.main();
		tests.Test_vision_Vision_tint.main();
		tests.Test_vision_Vision_gaussianBlur.main();
		tests.Test_vision_Vision_pixelate.main();
		tests.Test_vision_Vision_sepia.main();
		tests.Test_vision_Vision_dilate.main();
		tests.Test_vision_Vision_sharpen.main();
		tests.Test_vision_Vision_grayscale.main();
		tests.Test_vision_Vision_convolve.main();
		tests.Test_vision_Vision_robertEdgeDiffOperator.main();
		tests.Test_vision_Vision_replaceColorRanges.main();
		tests.Test_vision_Vision_kmeansGroupImageColors.main();
		tests.Test_vision_Vision_sobelEdgeDiffOperator.main();
		tests.Test_vision_Vision_sobelEdgeDetection.main();
		tests.Test_vision_Vision_pincushionDistortion.main();
		tests.Test_vision_Vision_barrelDistortion.main();
		tests.Test_vision_Vision_contrast.main();
		tests.Test_vision_Vision_perwittEdgeDetection.main();
		tests.Test_vision_Vision_dropOutNoise.main();
		tests.Test_vision_Vision_affineTransform.main();
        end = haxe.Timer.stamp();
        trace("-----------------------------------\n");
        trace("46 Tests, " + ((end - start) + "") + "s");
    }
}
