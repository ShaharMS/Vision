package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Laplace;
import vision.ds.gaussian.GaussianKernelSize;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

@:access(vision.algorithms.Laplace)
class LaplaceTests {
    public static function vision_algorithms_Laplace__convolveWithLaplacianOperator_Image_Bool_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var positive = false;
			
            result = vision.algorithms.Laplace.convolveWithLaplacianOperator(image, positive);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Laplace.convolveWithLaplacianOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Laplace__laplacianOfGaussian_Image_GaussianKernelSize_Float_Float_Bool_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var kernelSize:GaussianKernelSize = null;
			var sigma = 0.0;
			var threshold = 0.0;
			var positive = false;
			
            result = vision.algorithms.Laplace.laplacianOfGaussian(image, kernelSize, sigma, threshold, positive);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Laplace.laplacianOfGaussian",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}