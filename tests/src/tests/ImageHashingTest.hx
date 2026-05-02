package tests;

import tests.support.AlgorithmFixtures;
import tests.support.CollectionAssertions;
import utest.Assert;
import vision.algorithms.ImageHashing;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.ImageHashing)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ImageHashingTest extends utest.Test {
	function uniformGrayImage(size:Int, value:Int):Image {
		return new Image(size, size, Color.fromRGBA(value, value, value, 255));
	}

	@:visionTestId("vision.algorithms.ImageHashing.ahash#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_ahash__default() {
		CollectionAssertions.bytes([255, 50, 50, 50, 255, 50, 50, 50, 255, 50, 50, 50, 255, 50, 50, 50], ImageHashing.ahash(uniformGrayImage(2, 50), 16));
	}

	@:visionTestId("vision.algorithms.ImageHashing.ahash#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_ahash__tiny() {
		CollectionAssertions.bytes([255, 10, 10, 10], ImageHashing.ahash(uniformGrayImage(1, 10), 4));
	}

	@:visionTestId("vision.algorithms.ImageHashing.ahash#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_ahash__checkerboard() {
		var result = ImageHashing.ahash(AlgorithmFixtures.stepEdgeImage(4, 4, 2), 16);
		Assert.equals(16, result.length);
		Assert.isFalse(result.isEmpty());
	}

	@:visionTestId("vision.algorithms.ImageHashing.phash#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_phash__default() {
		CollectionAssertions.bytes([1, 0, 0, 0, 0, 0, 0, 0], ImageHashing.phash(uniformGrayImage(8, 50)));
	}

	@:visionTestId("vision.algorithms.ImageHashing.phash#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_phash__tiny() {
		CollectionAssertions.bytes([1, 0, 0, 0, 0, 0, 0, 0], ImageHashing.phash(uniformGrayImage(1, 50)));
	}

	@:visionTestId("vision.algorithms.ImageHashing.phash#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_phash__checkerboard() {
		var uniform = ImageHashing.phash(uniformGrayImage(8, 50));
		var result = ImageHashing.phash(AlgorithmFixtures.stepEdgeImage(8, 8, 4));
		Assert.isTrue(result.toArray().join(",") != uniform.toArray().join(","));
	}
}
