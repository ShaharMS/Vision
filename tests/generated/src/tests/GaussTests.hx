package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Gauss;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Array2D;
import vision.exceptions.InvalidGaussianKernelSize;

@:access(vision.algorithms.Gauss)
class GaussTests {
    public static function vision_algorithms_Gauss__create1x1Kernel_Float_ArrayArrayFloat__ShouldWork():TestResult {
        try {
            var sigma = 0.0;
			
            var result = vision.algorithms.Gauss.create1x1Kernel(sigma);

            return {
                testName: "vision.algorithms.Gauss.create1x1Kernel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.create1x1Kernel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Gauss__create3x3Kernel_Float_ArrayArrayFloat__ShouldWork():TestResult {
        try {
            var sigma = 0.0;
			
            var result = vision.algorithms.Gauss.create3x3Kernel(sigma);

            return {
                testName: "vision.algorithms.Gauss.create3x3Kernel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.create3x3Kernel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Gauss__create5x5Kernel_Float_ArrayArrayFloat__ShouldWork():TestResult {
        try {
            var sigma = 0.0;
			
            var result = vision.algorithms.Gauss.create5x5Kernel(sigma);

            return {
                testName: "vision.algorithms.Gauss.create5x5Kernel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.create5x5Kernel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Gauss__create7x7Kernel_Float_ArrayArrayFloat__ShouldWork():TestResult {
        try {
            var sigma = 0.0;
			
            var result = vision.algorithms.Gauss.create7x7Kernel(sigma);

            return {
                testName: "vision.algorithms.Gauss.create7x7Kernel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.create7x7Kernel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Gauss__create9x9Kernel_Float_ArrayArrayFloat__ShouldWork():TestResult {
        try {
            var sigma = 0.0;
			
            var result = vision.algorithms.Gauss.create9x9Kernel(sigma);

            return {
                testName: "vision.algorithms.Gauss.create9x9Kernel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.create9x9Kernel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Gauss__createKernelOfSize_Int_Int_Array2DFloat__ShouldWork():TestResult {
        try {
            var size = 0;
			var sigma = 0;
			
            var result = vision.algorithms.Gauss.createKernelOfSize(size, sigma);

            return {
                testName: "vision.algorithms.Gauss.createKernelOfSize",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.createKernelOfSize",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Gauss__create2DKernelOfSize_Int_Float_Array2DFloat__ShouldWork():TestResult {
        try {
            var size = 0;
			var sigma = 0.0;
			
            var result = vision.algorithms.Gauss.create2DKernelOfSize(size, sigma);

            return {
                testName: "vision.algorithms.Gauss.create2DKernelOfSize",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.create2DKernelOfSize",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Gauss__create1DKernelOfSize_Int_Float_ArrayFloat__ShouldWork():TestResult {
        try {
            var size = 0;
			var sigma = 0.0;
			
            var result = vision.algorithms.Gauss.create1DKernelOfSize(size, sigma);

            return {
                testName: "vision.algorithms.Gauss.create1DKernelOfSize",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.create1DKernelOfSize",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Gauss__fastBlur_Image_Int_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var size = 0;
			var sigma = 0.0;
			
            var result = vision.algorithms.Gauss.fastBlur(image, size, sigma);

            return {
                testName: "vision.algorithms.Gauss.fastBlur",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Gauss.fastBlur",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}