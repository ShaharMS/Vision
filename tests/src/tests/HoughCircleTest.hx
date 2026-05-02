package tests;

import utest.Assert;
import vision.algorithms.Hough;
import vision.ds.Circle2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Point2D;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HoughCircleTest extends utest.Test {
	@:visionTestId("vision.ds.Circle2D.copy#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_circle2D_copy__default() {
		var copy = new Circle2D(new Point2D(2, 3), 4, 5).copy();
		Assert.equals(2.0, copy.center.x);
		Assert.equals(3.0, copy.center.y);
		Assert.equals(4.0, copy.radius);
		Assert.equals(5.0, copy.votes);
	}

	@:visionTestId("vision.algorithms.Hough.detectCircles#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectCircles__default() {
		var result = Hough.detectCircles(new Image(3, 3, Color.BLACK));
		Assert.equals(0, result.length);
	}
}