package tests;

import tests.support.Factories;
import utest.Assert;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.ImageTools;

@:access(vision.tools.ImageTools)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class ImageToolsTest extends utest.Test {

	@:visionTestId("vision.tools.ImageTools.defaultResizeAlgorithm#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_defaultResizeAlgorithm__default() {
		var result = vision.tools.ImageTools.defaultResizeAlgorithm;
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromFile#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:Ignored("requires filesystem fixture")
	function ignored_test_loadFromFile__default() {
		var image = Factories.gradientImage(3, 3);
		var path = "fixture.png";
		var onComplete = null;
		vision.tools.ImageTools.loadFromFile(image, path, onComplete);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.loadFromFile#tiny")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:Ignored("requires filesystem fixture")
	function ignored_test_loadFromFile__tiny() {
		var image = Factories.gradientImage(3, 3);
		var path = "fixture.png";
		var onComplete = null;
		vision.tools.ImageTools.loadFromFile(image, path, onComplete);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.loadFromFile#checkerboard")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:Ignored("requires filesystem fixture")
	function ignored_test_loadFromFile__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var path = "fixture.png";
		var onComplete = null;
		vision.tools.ImageTools.loadFromFile(image, path, onComplete);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.saveToFile#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_saveToFile__default() {
		var image = Factories.gradientImage(3, 3);
		var pathWithFileName = "fixture.png";
		var saveFormat = vision.ds.ImageFormat.PNG;
		vision.tools.ImageTools.saveToFile(image, pathWithFileName, saveFormat);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.saveToFile#tiny")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_saveToFile__tiny() {
		var image = Factories.gradientImage(3, 3);
		var pathWithFileName = "fixture.png";
		var saveFormat = vision.ds.ImageFormat.PNG;
		vision.tools.ImageTools.saveToFile(image, pathWithFileName, saveFormat);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.saveToFile#checkerboard")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_saveToFile__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var pathWithFileName = "fixture.png";
		var saveFormat = vision.ds.ImageFormat.PNG;
		vision.tools.ImageTools.saveToFile(image, pathWithFileName, saveFormat);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.loadFromBytes#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_loadFromBytes__default() {
		var image = Factories.gradientImage(3, 3);
		var bytes = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var fileFormat = vision.ds.ImageFormat.PNG;
		var result = vision.tools.ImageTools.loadFromBytes(image, bytes, fileFormat);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromBytes#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_loadFromBytes__tiny() {
		var image = Factories.gradientImage(3, 3);
		var bytes = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var fileFormat = vision.ds.ImageFormat.PNG;
		var result = vision.tools.ImageTools.loadFromBytes(image, bytes, fileFormat);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromBytes#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_loadFromBytes__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var bytes = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var fileFormat = vision.ds.ImageFormat.PNG;
		var result = vision.tools.ImageTools.loadFromBytes(image, bytes, fileFormat);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromURL#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires network fixture")
	function ignored_test_loadFromURL__default() {
		var image = Factories.gradientImage(3, 3);
		var url = "42";
		var result = vision.tools.ImageTools.loadFromURL(image, url);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromURL#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires network fixture")
	function ignored_test_loadFromURL__tiny() {
		var image = Factories.gradientImage(3, 3);
		var url = "42";
		var result = vision.tools.ImageTools.loadFromURL(image, url);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromURL#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires network fixture")
	function ignored_test_loadFromURL__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var url = "42";
		var result = vision.tools.ImageTools.loadFromURL(image, url);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.exportToBytes#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_exportToBytes__default() {
		var image = Factories.gradientImage(3, 3);
		var format = vision.ds.ImageFormat.PNG;
		var result = vision.tools.ImageTools.exportToBytes(image, format);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.tools.ImageTools.exportToBytes#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_exportToBytes__tiny() {
		var image = Factories.gradientImage(3, 3);
		var format = vision.ds.ImageFormat.PNG;
		var result = vision.tools.ImageTools.exportToBytes(image, format);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.tools.ImageTools.exportToBytes#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_exportToBytes__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var format = vision.ds.ImageFormat.PNG;
		var result = vision.tools.ImageTools.exportToBytes(image, format);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.tools.ImageTools.exportToFile#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_exportToFile__default() {
		var image = Factories.gradientImage(3, 3);
		var pathWithFileName = "fixture.png";
		var format = vision.ds.ImageFormat.PNG;
		vision.tools.ImageTools.exportToFile(image, pathWithFileName, format);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.exportToFile#tiny")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_exportToFile__tiny() {
		var image = Factories.gradientImage(3, 3);
		var pathWithFileName = "fixture.png";
		var format = vision.ds.ImageFormat.PNG;
		vision.tools.ImageTools.exportToFile(image, pathWithFileName, format);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.exportToFile#checkerboard")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	@:Ignored("requires filesystem fixture")
	function ignored_test_exportToFile__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var pathWithFileName = "fixture.png";
		var format = vision.ds.ImageFormat.PNG;
		vision.tools.ImageTools.exportToFile(image, pathWithFileName, format);
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.addToScreen#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_addToScreen__default() {
		var image = Factories.gradientImage(3, 3);
		var x = 1;
		var y = 1;
		var units = null;
		var result = vision.tools.ImageTools.addToScreen(image, x, y, units);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.addToScreen#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_addToScreen__tiny() {
		var image = Factories.gradientImage(3, 3);
		var x = 1;
		var y = 1;
		var units = null;
		var result = vision.tools.ImageTools.addToScreen(image, x, y, units);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.addToScreen#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_addToScreen__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var x = 1;
		var y = 1;
		var units = null;
		var result = vision.tools.ImageTools.addToScreen(image, x, y, units);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getNeighborsOfPixel__default() {
		var image = Factories.gradientImage(3, 3);
		var x = 1;
		var y = 1;
		var kernelSize = 3;
		var result = vision.tools.ImageTools.getNeighborsOfPixel(image, x, y, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixel#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getNeighborsOfPixel__tiny() {
		var image = Factories.gradientImage(3, 3);
		var x = 1;
		var y = 1;
		var kernelSize = 3;
		var result = vision.tools.ImageTools.getNeighborsOfPixel(image, x, y, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixel#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getNeighborsOfPixel__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var x = 1;
		var y = 1;
		var kernelSize = 3;
		var result = vision.tools.ImageTools.getNeighborsOfPixel(image, x, y, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixelIter#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getNeighborsOfPixelIter__default() {
		var image = Factories.gradientImage(3, 3);
		var x = 1;
		var y = 1;
		var kernelSize = 3;
		var circular = false;
		var result = vision.tools.ImageTools.getNeighborsOfPixelIter(image, x, y, kernelSize, circular);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixelIter#tiny")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getNeighborsOfPixelIter__tiny() {
		var image = Factories.gradientImage(3, 3);
		var x = 1;
		var y = 1;
		var kernelSize = 3;
		var circular = false;
		var result = vision.tools.ImageTools.getNeighborsOfPixelIter(image, x, y, kernelSize, circular);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixelIter#checkerboard")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_getNeighborsOfPixelIter__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var x = 1;
		var y = 1;
		var kernelSize = 3;
		var circular = false;
		var result = vision.tools.ImageTools.getNeighborsOfPixelIter(image, x, y, kernelSize, circular);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ImageTools.grayscalePixel#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_grayscalePixel__default() {
		var pixel = (0xFF336699 : vision.ds.Color);
		var result = vision.tools.ImageTools.grayscalePixel(pixel);
		Assert.notNull(result);
	}

}
