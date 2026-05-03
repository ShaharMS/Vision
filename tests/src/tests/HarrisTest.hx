package tests;

import utest.Assert;
import vision.algorithms.Harris;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Matrix2D;
import vision.ds.specifics.HarrisCornerOptions;
import vision.ds.specifics.HarrisResponseOptions;

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

	@:visionTestId("vision.algorithms.Harris.computeResponse#corner-ordering")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_computeResponse__cornerScoresAboveEdgeAndFlatRegions() {
		var response = Harris.computeResponse(createCornerFixture());
		var cornerScore = maxInRegion(response, 5, 5, 7, 7);
		var edgeScore = maxInRegion(response, 5, 9, 7, 11);
		var flatScore = maxInRegion(response, 0, 0, 2, 2);
		Assert.isTrue(cornerScore > 0);
		Assert.isTrue(cornerScore > edgeScore);
		Assert.isTrue(cornerScore > flatScore);
	}

	@:visionTestId("vision.algorithms.Harris.computeResponse#gaussian-window")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_computeResponse__gaussianWindowKeepsCornerOrdering() {
		var options = new HarrisResponseOptions();
		options.blockSize = 3;
		options.apertureSize = 5;
		options.useGaussianWindow = true;
		var response = Harris.computeResponse(createCornerFixture(), options);
		var cornerScore = maxInRegion(response, 5, 5, 7, 7);
		var edgeScore = maxInRegion(response, 5, 9, 7, 11);
		Assert.isTrue(cornerScore > edgeScore);
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

	function createCornerFixture():Image {
		var image = new Image(18, 18, Color.BLACK);
		for (y in 6...15) {
			for (x in 6...12) image.setPixel(x, y, Color.WHITE);
		}
		return image;
	}

	function maxInRegion(matrix:Matrix2D, startX:Int, startY:Int, endX:Int, endY:Int):Float {
		var maximum = matrix.get(startX, startY);
		for (y in startY...endY + 1) {
			for (x in startX...endX + 1) {
				var value = matrix.get(x, y);
				if (value > maximum) maximum = value;
			}
		}
		return maximum;
	}
}