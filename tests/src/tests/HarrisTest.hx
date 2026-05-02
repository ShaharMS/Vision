package tests;

import utest.Assert;
import vision.algorithms.Harris;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.specifics.HarrisCornerOptions;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HarrisTest extends utest.Test {
	@:visionTestId("vision.algorithms.Harris.computeResponse#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_computeResponse__default() {
		var response = Harris.computeResponse(new Image(3, 2, Color.BLACK));
		Assert.equals(3, response.width);
		Assert.equals(2, response.height);
		Assert.equals(0.0, response.get(0, 0));
	}

	@:visionTestId("vision.algorithms.Harris.detectCorners#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectCorners__default() {
		var options = new HarrisCornerOptions();
		options.maxCorners = 4;
		var result = Harris.detectCorners(new Image(3, 3, Color.BLACK), options);
		Assert.equals(0, result.length);
	}
}