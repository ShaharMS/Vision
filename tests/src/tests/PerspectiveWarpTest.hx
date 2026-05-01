package tests;

import utest.Assert;
import vision.algorithms.PerspectiveWarp;
import vision.ds.Point2D;

@:access(vision.algorithms.PerspectiveWarp)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class PerspectiveWarpTest extends utest.Test {

	@:visionTestId("vision.algorithms.PerspectiveWarp.generateMatrix#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_generateMatrix__default() {
		var destinationPoints = [new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(1.0, 0.0), new vision.ds.Point2D(1.0, 1.0), new vision.ds.Point2D(0.0, 1.0)];
		var sourcePoints = [new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(1.0, 0.0), new vision.ds.Point2D(1.0, 1.0), new vision.ds.Point2D(0.0, 1.0)];
		var result = vision.algorithms.PerspectiveWarp.generateMatrix(destinationPoints, sourcePoints);
		Assert.notNull(result);
	}

	@:visionTestId("vision.algorithms.PerspectiveWarp.generateMatrix#duplicates")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_generateMatrix__duplicates() {
		var destinationPoints = [new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(1.0, 0.0), new vision.ds.Point2D(1.0, 1.0), new vision.ds.Point2D(0.0, 1.0)];
		var sourcePoints = [new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(1.0, 0.0), new vision.ds.Point2D(1.0, 1.0), new vision.ds.Point2D(0.0, 1.0)];
		var result = vision.algorithms.PerspectiveWarp.generateMatrix(destinationPoints, sourcePoints);
		Assert.notNull(result);
	}

}
