package tests;

import tests.support.CollectionAssertions;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.algorithms.KMeans;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.VisionException;

@:access(vision.algorithms.KMeans)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class KMeansTest extends utest.Test {
	function averageInts(values:Array<Int>):Int {
		var sum = 0;
		for (value in values) {
			sum += value;
		}
		return Math.round(sum / values.length);
	}

	function normalizeClusters(clusters:Array<Array<Int>>):Array<Array<Int>> {
		var normalized = [for (cluster in clusters) {
			var copy = cluster.copy();
			copy.sort((lhs, rhs) -> lhs - rhs);
			copy;
		}];
		normalized.sort((lhs, rhs) -> lhs[0] - rhs[0]);
		return normalized;
	}

	@:visionTestId("vision.algorithms.KMeans.generateClustersUsingConvergence#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_generateClustersUsingConvergence__default() {
		var result = KMeans.generateClustersUsingConvergence([1, 2, 10, 11], 2, (lhs, rhs) -> Math.abs(rhs - lhs), averageInts);
		CollectionAssertions.nestedValues([[1, 2], [10, 11]], normalizeClusters(result));
	}

	@:visionTestId("vision.algorithms.KMeans.generateClustersUsingConvergence#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_generateClustersUsingConvergence__duplicates() {
		ExceptionAssertions.throwsType(() -> {
			KMeans.generateClustersUsingConvergence([], 2, (lhs, rhs) -> Math.abs(rhs - lhs), averageInts);
		}, VisionException);
	}

	@:visionTestId("vision.algorithms.KMeans.getImageColorClusters#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getImageColorClusters__default() {
		var image = new Image(2, 2, Color.BLACK);
		image.setPixel(1, 0, Color.WHITE);
		image.setPixel(1, 1, Color.WHITE);
		var result = KMeans.getImageColorClusters(image, 2);
		result.sort((lhs, rhs) -> lhs.centroid.red - rhs.centroid.red);
		Assert.equals(2, result.length);
		Assert.equals(Color.BLACK, result[0].centroid);
		Assert.equals(Color.WHITE, result[1].centroid);
		Assert.equals(1, result[0].items.length);
		Assert.equals(1, result[1].items.length);
	}

	@:visionTestId("vision.algorithms.KMeans.getImageColorClusters#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getImageColorClusters__tiny() {
		var result = KMeans.getImageColorClusters(new Image(1, 1, Color.MAGENTA), 16);
		Assert.equals(1, result.length);
		Assert.equals(Color.MAGENTA, result[0].centroid);
		Assert.equals(1, result[0].items.length);
	}

	@:visionTestId("vision.algorithms.KMeans.getImageColorClusters#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getImageColorClusters__checkerboard() {
		var image = new Image(2, 2, Color.BLACK);
		image.setPixel(0, 0, Color.WHITE);
		image.setPixel(1, 1, Color.WHITE);
		var result = KMeans.getImageColorClusters(image, 1);
		Assert.equals(1, result.length);
		Assert.equals(2, result[0].items.length);
		Assert.isTrue(result[0].centroid.red >= 127 && result[0].centroid.red <= 128);
		Assert.equals(result[0].centroid.red, result[0].centroid.green);
		Assert.equals(result[0].centroid.green, result[0].centroid.blue);
	}

	@:visionTestId("vision.algorithms.KMeans.pickElementsAtRandom#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_pickElementsAtRandom__default() {
		CollectionAssertions.values([7, 7, 7], KMeans.pickElementsAtRandom([7], 3, false));
	}

	@:visionTestId("vision.algorithms.KMeans.pickElementsAtRandom#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_pickElementsAtRandom__duplicates() {
		var result = KMeans.pickElementsAtRandom([1, 1, 2], 3, true);
		result.sort((lhs, rhs) -> lhs - rhs);
		CollectionAssertions.values([1, 2], result);
	}
}
