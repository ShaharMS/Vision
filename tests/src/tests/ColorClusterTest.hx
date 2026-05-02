package tests;

import tests.support.CollectionAssertions;
import utest.Assert;
import vision.ds.Color;
import vision.ds.kmeans.ColorCluster;

@:access(vision.ds.kmeans.ColorCluster)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ColorClusterTest extends utest.Test {
	function createCluster():ColorCluster {
		return new ColorCluster(Color.fromRGBA(51, 102, 153, 255), [Color.RED, Color.GREEN]);
	}

	@:visionTestId("vision.ds.kmeans.ColorCluster.new#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__default() {
		var result = createCluster();
		Assert.equals(Color.fromRGBA(51, 102, 153, 255), result.centroid);
		CollectionAssertions.values([Color.RED, Color.GREEN], result.items);
	}

	@:visionTestId("vision.ds.kmeans.ColorCluster.centroid#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_centroid__default() {
		Assert.equals(Color.fromRGBA(51, 102, 153, 255), createCluster().centroid);
	}

	@:visionTestId("vision.ds.kmeans.ColorCluster.items#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_items__default() {
		CollectionAssertions.values([Color.RED, Color.GREEN], createCluster().items);
	}
}
