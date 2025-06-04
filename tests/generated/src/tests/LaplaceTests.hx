package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Laplace;
import vision.ds.gaussian.GaussianKernelSize;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

class LaplaceTests {
    public static function vision_algorithms_Laplace__laplacianOfGaussian__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Laplace.laplacianOfGaussian((null : Image), (null : GaussianKernelSize), (null : Float), (null : Float), (null : Bool));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Laplace.laplacianOfGaussian",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Laplace__convolveWithLaplacianOperator__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Laplace.convolveWithLaplacianOperator((null : Image), (null : Bool));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Laplace.convolveWithLaplacianOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_Laplace__laplacianOfGaussian__ShouldWork, 
		vision_algorithms_Laplace__convolveWithLaplacianOperator__ShouldWork];
}