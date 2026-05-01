package tests;

import tests.support.Factories;
import utest.Assert;
import vision.ds.ByteArray;
import vision.formats.from.FromBytes;

@:access(vision.formats.from.FromBytes)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class FromBytesTest extends utest.Test {

	@:visionTestId("vision.formats.from.FromBytes.png#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_png__default() {
		var bytes = vision.formats.ImageIO.to.bytes.png(Factories.checkerboardImage(2, 2, 1));
		var instance = new vision.formats.from.FromBytes();
		var result = instance.png(bytes);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.formats.from.FromBytes.png#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_png__tiny() {
		var bytes = vision.formats.ImageIO.to.bytes.png(Factories.checkerboardImage(2, 2, 1));
		var instance = new vision.formats.from.FromBytes();
		var result = instance.png(bytes);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.formats.from.FromBytes.png#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_png__checkerboard() {
		var bytes = vision.formats.ImageIO.to.bytes.png(Factories.checkerboardImage(2, 2, 1));
		var instance = new vision.formats.from.FromBytes();
		var result = instance.png(bytes);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.formats.from.FromBytes.bmp#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bmp__default() {
		var bytes = vision.formats.ImageIO.to.bytes.bmp(Factories.checkerboardImage(2, 2, 1));
		var instance = new vision.formats.from.FromBytes();
		var result = instance.bmp(bytes);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.formats.from.FromBytes.bmp#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bmp__tiny() {
		var bytes = vision.formats.ImageIO.to.bytes.bmp(Factories.checkerboardImage(2, 2, 1));
		var instance = new vision.formats.from.FromBytes();
		var result = instance.bmp(bytes);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.formats.from.FromBytes.bmp#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bmp__checkerboard() {
		var bytes = vision.formats.ImageIO.to.bytes.bmp(Factories.checkerboardImage(2, 2, 1));
		var instance = new vision.formats.from.FromBytes();
		var result = instance.bmp(bytes);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.formats.from.FromBytes.jpeg#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_jpeg__default() {
		var bytes = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var instance = new vision.formats.from.FromBytes();
		var threw = false;
		try {
			instance.jpeg(bytes);
		} catch (e:Dynamic) {
			threw = true;
		}
		Assert.isTrue(threw);
	}

	@:visionTestId("vision.formats.from.FromBytes.jpeg#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_jpeg__tiny() {
		var bytes = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var instance = new vision.formats.from.FromBytes();
		var threw = false;
		try {
			instance.jpeg(bytes);
		} catch (e:Dynamic) {
			threw = true;
		}
		Assert.isTrue(threw);
	}

	@:visionTestId("vision.formats.from.FromBytes.jpeg#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_jpeg__checkerboard() {
		var bytes = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var instance = new vision.formats.from.FromBytes();
		var threw = false;
		try {
			instance.jpeg(bytes);
		} catch (e:Dynamic) {
			threw = true;
		}
		Assert.isTrue(threw);
	}

}
