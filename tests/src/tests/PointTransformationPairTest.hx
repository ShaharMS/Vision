package tests;

import utest.Assert;
import vision.ds.Point2D;
import vision.ds.specifics.PointTransformationPair;

@:access(vision.ds.specifics.PointTransformationPair)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class PointTransformationPairTest extends utest.Test {
	function createPair():PointTransformationPair {
		return new PointTransformationPair(new Point2D(1, 2), new Point2D(3, 4));
	}

	@:visionTestId("vision.ds.specifics.PointTransformationPair.from#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_from__default() {
		var result = createPair().from;
		Assert.equals(1, result.x);
		Assert.equals(2, result.y);
	}

	@:visionTestId("vision.ds.specifics.PointTransformationPair.to#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_to__default() {
		var result = createPair().to;
		Assert.equals(3, result.x);
		Assert.equals(4, result.y);
	}
}
