package tests;

import utest.Assert;
import vision.ds.Point2D;
import vision.ds.specifics.PointTransformationPair;

@:access(vision.ds.specifics.PointTransformationPair)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class PointTransformationPairTest extends utest.Test {

	@:visionTestId("vision.ds.specifics.PointTransformationPair.from#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_from__default() {
		var ctor_from = new vision.ds.Point2D(1.0, 1.0);
		var ctor_to = new vision.ds.Point2D(1.0, 1.0);
		var instance = new vision.ds.specifics.PointTransformationPair(ctor_from, ctor_to);
		var result = instance.from;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.specifics.PointTransformationPair.to#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_to__default() {
		var ctor_from = new vision.ds.Point2D(1.0, 1.0);
		var ctor_to = new vision.ds.Point2D(1.0, 1.0);
		var instance = new vision.ds.specifics.PointTransformationPair(ctor_from, ctor_to);
		var result = instance.to;
		Assert.notNull(result);
	}

}
