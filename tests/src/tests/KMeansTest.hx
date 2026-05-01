package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.KMeans;
import vision.ds.Image;

@:access(vision.algorithms.KMeans)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class KMeansTest extends utest.Test {

	@:visionTestId("vision.algorithms.KMeans.generateClustersUsingConvergence#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_generateClustersUsingConvergence__default() {
		var values = [1, 2, 3, 4];
		var clusterAmount = 1;
		var distanceFunction = (arg0, arg1) -> Math.abs((cast arg1 : Float) - (cast arg0 : Float));
		var averageFunction = (arg0) -> arg0[0];
		var result = vision.algorithms.KMeans.generateClustersUsingConvergence(values, clusterAmount, distanceFunction, averageFunction);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.KMeans.generateClustersUsingConvergence#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_generateClustersUsingConvergence__duplicates() {
		var values = [1, 2, 2, 4];
		var clusterAmount = 1;
		var distanceFunction = (arg0, arg1) -> Math.abs((cast arg1 : Float) - (cast arg0 : Float));
		var averageFunction = (arg0) -> arg0[0];
		var result = vision.algorithms.KMeans.generateClustersUsingConvergence(values, clusterAmount, distanceFunction, averageFunction);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.KMeans.getImageColorClusters#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getImageColorClusters__default() {
		var image = Factories.gradientImage(3, 3);
		var clusterAmount = 1;
		var result = vision.algorithms.KMeans.getImageColorClusters(image, clusterAmount);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.KMeans.getImageColorClusters#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getImageColorClusters__tiny() {
		var image = Factories.gradientImage(3, 3);
		var clusterAmount = 1;
		var result = vision.algorithms.KMeans.getImageColorClusters(image, clusterAmount);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.KMeans.getImageColorClusters#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getImageColorClusters__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var clusterAmount = 1;
		var result = vision.algorithms.KMeans.getImageColorClusters(image, clusterAmount);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.KMeans.pickElementsAtRandom#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_pickElementsAtRandom__default() {
		var values = [1, 2, 3, 4];
		var amount = 1;
		var distinct = false;
		var result = vision.algorithms.KMeans.pickElementsAtRandom(values, amount, distinct);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.KMeans.pickElementsAtRandom#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_pickElementsAtRandom__duplicates() {
		var values = [1, 2, 2, 4];
		var amount = 1;
		var distinct = false;
		var result = vision.algorithms.KMeans.pickElementsAtRandom(values, amount, distinct);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

}
