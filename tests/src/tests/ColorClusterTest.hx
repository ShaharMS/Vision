package tests;

import utest.Assert;
import vision.ds.Color;
import vision.ds.kmeans.ColorCluster;

@:access(vision.ds.kmeans.ColorCluster)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class ColorClusterTest extends utest.Test {

	@:visionTestId("vision.ds.kmeans.ColorCluster.centroid#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_centroid__default() {
		var ctor_centroid = (0xFF336699 : vision.ds.Color);
		var ctor_items = [cast 1, cast 2, cast 3];
		var instance = new vision.ds.kmeans.ColorCluster(ctor_centroid, ctor_items);
		var result = instance.centroid;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.kmeans.ColorCluster.items#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_items__default() {
		var ctor_centroid = (0xFF336699 : vision.ds.Color);
		var ctor_items = [cast 1, cast 2, cast 3];
		var instance = new vision.ds.kmeans.ColorCluster(ctor_centroid, ctor_items);
		var result = instance.items;
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

}
