package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.algorithms.Hough;
import vision.ds.Color;
import vision.ds.HoughLine2D;
import vision.ds.Image;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HoughStandardTest extends utest.Test {
	@:visionTestId("vision.algorithms.Hough.createAccumulator#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_createAccumulator__default() {
		var accumulator = Hough.createAccumulator(4, 3);
		Assert.equals(4, accumulator.width);
		Assert.equals(3, accumulator.height);
		Assert.equals(0.0, accumulator.get(0, 0));
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__default() {
		var result = Hough.detectLines(new Image(3, 3, Color.BLACK));
		Assert.equals(0, result.length);
	}

	@:visionTestId("vision.ds.HoughLine2D.toRay2D#horizontal")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toRay2D__horizontalLineDirection() {
		var ray = new HoughLine2D(2, Math.PI / 2).toRay2D();
		var nextPoint = ray.getPointAtX(ray.point.x + 5);

		ApproxAssertions.equalsFloat(2, ray.point.y);
		ApproxAssertions.equalsFloat(2, nextPoint.y);
	}

	@:visionTestId("vision.ds.HoughLine2D.toRay2D#vertical")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toRay2D__verticalLineDirection() {
		var ray = new HoughLine2D(3, 0).toRay2D();
		var nextPoint = ray.getPointAtY(ray.point.y + 5);

		ApproxAssertions.equalsFloat(3, ray.point.x);
		ApproxAssertions.equalsFloat(3, nextPoint.x, 0.001);
	}
}