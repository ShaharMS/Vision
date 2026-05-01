package tests;

import tests.support.Factories;
import utest.Assert;
import vision.ds.Image;
import vision.formats.to.ToBytes;

@:access(vision.formats.to.ToBytes)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class ToBytesTest extends utest.Test {

	@:visionTestId("vision.formats.to.ToBytes.png#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_png__default() {
		var image = Factories.gradientImage(3, 3);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.png(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.formats.to.ToBytes.png#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_png__tiny() {
		var image = Factories.gradientImage(3, 3);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.png(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.formats.to.ToBytes.png#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_png__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.png(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.formats.to.ToBytes.bmp#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bmp__default() {
		var image = Factories.gradientImage(3, 3);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.bmp(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.formats.to.ToBytes.bmp#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bmp__tiny() {
		var image = Factories.gradientImage(3, 3);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.bmp(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.formats.to.ToBytes.bmp#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bmp__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.bmp(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.formats.to.ToBytes.jpeg#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_jpeg__default() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.jpeg(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.formats.to.ToBytes.jpeg#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_jpeg__tiny() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.jpeg(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.formats.to.ToBytes.jpeg#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_jpeg__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var instance = new vision.formats.to.ToBytes();
		var result = instance.jpeg(image);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

}
