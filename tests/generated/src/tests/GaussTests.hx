package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Gauss;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Array2D;
import vision.exceptions.InvalidGaussianKernelSize;

class GaussTests {
    public static function vision_algorithms_Gauss__fastBlur__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Gauss.fastBlur((null : Image), (null : Int), (null : Float));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Gauss.fastBlur",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Gauss__createKernelOfSize__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Gauss.createKernelOfSize((null : Int), (null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Gauss.createKernelOfSize",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_Gauss__fastBlur__ShouldWork, 
		vision_algorithms_Gauss__createKernelOfSize__ShouldWork];
}