package tests;

import tests.support.CollectionAssertions;
import tests.support.ExceptionAssertions;
import vision.algorithms.PerspectiveWarp;
import vision.ds.Point2D;
import vision.exceptions.SingularMatrixError;

@:access(vision.algorithms.PerspectiveWarp)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class PerspectiveWarpTest extends utest.Test {
	function unitSquare():Array<Point2D> {
		return [new Point2D(0, 0), new Point2D(1, 0), new Point2D(1, 1), new Point2D(0, 1)];
	}

	@:visionTestId("vision.algorithms.PerspectiveWarp.generateMatrix#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_generateMatrix__default() {
		var result = PerspectiveWarp.generateMatrix(unitSquare(), unitSquare());
		CollectionAssertions.nestedValues([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], result.underlying.to2DArray());
	}

	@:visionTestId("vision.algorithms.PerspectiveWarp.generateMatrix#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_generateMatrix__duplicates() {
		ExceptionAssertions.throwsType(() -> {
			PerspectiveWarp.generateMatrix([new Point2D(0, 0), new Point2D(1, 0), new Point2D(1, 1), new Point2D(1, 1)], unitSquare());
		}, SingularMatrixError);
	}
}
