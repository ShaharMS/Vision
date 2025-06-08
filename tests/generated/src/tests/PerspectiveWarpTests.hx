package tests;

import TestResult;
import TestStatus;

import vision.algorithms.PerspectiveWarp;
import vision.ds.Matrix2D;
import vision.ds.Point2D;

@:access(vision.algorithms.PerspectiveWarp)
class PerspectiveWarpTests {
    public static function vision_algorithms_PerspectiveWarp__generateMatrix_ArrayPoint2D_ArrayPoint2D_Matrix2D__ShouldWork():TestResult {
        var result = null;
        try {
            var destinationPoints = [];
			var sourcePoints = [];
			
            result = vision.algorithms.PerspectiveWarp.generateMatrix(destinationPoints, sourcePoints);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.PerspectiveWarp.generateMatrix",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}