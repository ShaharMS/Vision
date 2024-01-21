package;

class Main {

    public static function main() {
        var start:Float, end:Float;
        trace("----------Launching Tests----------\n");
        start = haxe.Timer.stamp();
        tests.Test_vision_Vision_laplacianEdgeDiffOperator.main();
		tests.Test_vision_Vision_warp.main();
		tests.Test_vision_Vision_limitColorRanges.main();
		tests.Test_vision_Vision_bilateralDenoise.main();
		tests.Test_vision_Vision_whiteNoise.main();
		tests.Test_vision_Vision_deepfry.main();
		tests.Test_vision_Vision_simpleLine2DDetection.main();
		tests.Test_vision_Vision_combine.main();
		tests.Test_vision_Vision_perwittEdgeDiffOperator.main();
		tests.Test_vision_Vision_cannyEdgeDetection.main();
		tests.Test_vision_Vision_invert.main();
		tests.Test_vision_Vision_saltAndPepperNoise.main();
		tests.Test_vision_Vision_normalize.main();
		tests.Test_vision_Vision_medianBlur.main();
		tests.Test_vision_Vision_laplacianOfGaussianEdgeDetection.main();
		tests.Test_vision_Vision_convolutionRidgeDetection.main();
		tests.Test_vision_Vision_blackAndWhite.main();
		tests.Test_vision_Vision_erode.main();
		tests.Test_vision_Vision_nearestNeighborBlur.main();
		tests.Test_vision_Vision_applyMatrix.main();
		tests.Test_vision_Vision_gaussianBlur.main();
		tests.Test_vision_Vision_dilate.main();
		tests.Test_vision_Vision_sharpen.main();
		tests.Test_vision_Vision_grayscale.main();
		tests.Test_vision_Vision_convolve.main();
		tests.Test_vision_Vision_robertEdgeDiffOperator.main();
		tests.Test_vision_Vision_replaceColorRanges.main();
		tests.Test_vision_Vision_sobelEdgeDiffOperator.main();
		tests.Test_vision_Vision_sobelEdgeDetection.main();
		tests.Test_vision_Vision_contrast.main();
		tests.Test_vision_Vision_perwittEdgeDetection.main();
		tests.Test_vision_Vision_dropOutNoise.main();
        end = haxe.Timer.stamp();
        trace("-----------------------------------\n");
        trace("32 Tests, " + ((end - start) + "") + "s");
    }
}
