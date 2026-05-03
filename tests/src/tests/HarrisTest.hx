package tests;

import utest.Assert;
import vision.algorithms.Harris;
import vision.Vision;
import vision.ds.Color;
import vision.ds.HarrisCorner2D;
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

	@:visionTestId("vision.Vision.harrisCornerResponse#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_harrisCornerResponse__default() {
		var response = Vision.harrisCornerResponse(new Image(3, 2, Color.BLACK));
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

	@:visionTestId("vision.Vision.harrisCorners#square-corners")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_harrisCorners__squareReturnsFourCorners() {
		var options = new HarrisCornerOptions();
		options.relativeThreshold = 0.15;
		options.minimumDistance = 4;
		options.maxCorners = 4;
		options.borderMargin = 2;
		var corners = Vision.harrisCorners(createCornerFixture(), options);
		Assert.equals(4, corners.length);
		assertSortedByStrength(corners);
		assertContainsCornerNear(corners, 6, 6, 2.0);
		assertContainsCornerNear(corners, 11, 6, 2.0);
		assertContainsCornerNear(corners, 6, 14, 2.0);
		assertContainsCornerNear(corners, 11, 14, 2.0);
	}

	@:visionTestId("vision.algorithms.Harris.detectCorners#square-corners")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectCorners__squareReturnsFourCorners() {
		var options = new HarrisCornerOptions();
		options.relativeThreshold = 0.15;
		options.minimumDistance = 4;
		options.maxCorners = 4;
		options.borderMargin = 2;
		var corners = Harris.detectCorners(createCornerFixture(), options);
		Assert.equals(4, corners.length);
		assertSortedByStrength(corners);
		assertContainsCornerNear(corners, 6, 6, 2.0);
		assertContainsCornerNear(corners, 11, 6, 2.0);
		assertContainsCornerNear(corners, 6, 14, 2.0);
		assertContainsCornerNear(corners, 11, 14, 2.0);
	}

	@:visionTestId("vision.algorithms.Harris.detectCornersFromResponse#minimum-distance")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_detectCornersFromResponse__minimumDistanceKeepsStrongestPeak() {
		var response = createResponseFixture(12, 12, [
			{x: 3, y: 3, value: 12.0},
			{x: 5, y: 3, value: 10.0},
			{x: 8, y: 8, value: 8.0}
		]);
		var options = new HarrisCornerOptions();
		options.relativeThreshold = 0;
		options.minimumDistance = 3;
		var corners = Harris.detectCornersFromResponse(response, options);
		Assert.equals(2, corners.length);
		assertCorner(corners[0], 3, 3, 12.0);
		assertCorner(corners[1], 8, 8, 8.0);
	}

	@:visionTestId("vision.algorithms.Harris.detectCornersFromResponse#max-corners")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_detectCornersFromResponse__maxCornersKeepsStrongestResponses() {
		var response = createResponseFixture(12, 12, [
			{x: 7, y: 2, value: 12.0},
			{x: 2, y: 7, value: 10.0},
			{x: 2, y: 2, value: 9.0}
		]);
		var options = new HarrisCornerOptions();
		options.relativeThreshold = 0;
		options.maxCorners = 2;
		var corners = Harris.detectCornersFromResponse(response, options);
		Assert.equals(2, corners.length);
		assertCorner(corners[0], 7, 2, 12.0);
		assertCorner(corners[1], 2, 7, 10.0);
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

	function createResponseFixture(width:Int, height:Int, peaks:Array<{x:Int, y:Int, value:Float}>):Matrix2D {
		var response = Harris.createResponseMap(width, height);
		for (peak in peaks) response.set(peak.x, peak.y, peak.value);
		return response;
	}

	function assertCorner(corner:HarrisCorner2D, expectedX:Int, expectedY:Int, expectedScore:Float):Void {
		Assert.equals(expectedX, Std.int(corner.point.x));
		Assert.equals(expectedY, Std.int(corner.point.y));
		Assert.equals(expectedScore, corner.score);
	}

	function assertContainsCornerNear(corners:Array<HarrisCorner2D>, expectedX:Int, expectedY:Int, maximumDistance:Float):Void {
		for (corner in corners) {
			var deltaX = corner.point.x - expectedX;
			var deltaY = corner.point.y - expectedY;
			if (Math.sqrt(deltaX * deltaX + deltaY * deltaY) <= maximumDistance) return;
		}
		Assert.fail('Expected a detected corner near ($expectedX, $expectedY).');
	}

	function assertSortedByStrength(corners:Array<HarrisCorner2D>):Void {
		for (index in 1...corners.length) {
			var previous = corners[index - 1];
			var current = corners[index];
			if (previous.score > current.score) continue;
			if (previous.score == current.score && isCoordinateOrdered(previous, current)) continue;
			Assert.fail('Expected corners to be ordered deterministically by score then coordinates.');
		}
	}

	function isCoordinateOrdered(left:HarrisCorner2D, right:HarrisCorner2D):Bool {
		if (left.point.y < right.point.y) return true;
		if (left.point.y > right.point.y) return false;
		return left.point.x <= right.point.x;
	}
}