package tests;

import tests.support.CollectionAssertions;
import tests.support.Factories;
import tests.support.ImageAssertions;
import utest.Assert;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageFormat;
import vision.ds.ImageResizeAlgorithm;
import vision.tools.ImageTools;

@:access(vision.tools.ImageTools)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ImageToolsTest extends utest.Test {
	function labeledImage():Image {
		var image = new Image(3, 3, 0x00000000);
		var colors = [
			[0xFF000011, 0xFF000022, 0xFF000033],
			[0xFF000044, 0xFF000055, 0xFF000066],
			[0xFF000077, 0xFF000088, 0xFF000099]
		];
		for (y in 0...3) {
			for (x in 0...3) {
				image.setPixel(x, y, colors[y][x]);
			}
		}
		return image;
	}

	function neighborValues(iterator:Iterator<Color>):Array<Color> {
		return [for (value in iterator) value];
	}

	@:visionTestId("vision.tools.ImageTools.defaultResizeAlgorithm#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_defaultResizeAlgorithm__default() {
		Assert.equals(ImageResizeAlgorithm.BilinearInterpolation, ImageTools.defaultResizeAlgorithm);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromFile#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:Ignored("requires filesystem fixture")
	function ignored_test_loadFromFile__default() {
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.saveToFile#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:Ignored("requires filesystem fixture")
	function ignored_test_saveToFile__default() {
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.loadFromURL#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:Ignored("requires network fixture")
	function ignored_test_loadFromURL__default() {
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.exportToFile#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:Ignored("requires filesystem fixture")
	function ignored_test_exportToFile__default() {
		Assert.pass();
	}

	@:visionTestId("vision.tools.ImageTools.loadFromBytes#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_loadFromBytes__default() {
		var source = labeledImage();
		var result = ImageTools.loadFromBytes(new Image(0, 0), ImageTools.exportToBytes(source, ImageFormat.VISION), ImageFormat.VISION);
		ImageAssertions.hasDimensions(result, 3, 3);
		ImageAssertions.pixelEquals(result, 2, 2, 0xFF000099);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromBytes#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_loadFromBytes__tiny() {
		var source = Factories.checkerboardImage(2, 2, 1);
		var bytes = ImageTools.exportToBytes(source, ImageFormat.PNG);
		var result = ImageTools.loadFromBytes(new Image(0, 0), bytes, ImageFormat.PNG);
		ImageAssertions.hasDimensions(result, 2, 2);
		ImageAssertions.pixelEquals(result, 0, 0, 0xFFFFFFFF);
		ImageAssertions.pixelEquals(result, 1, 0, 0xFF000000);
	}

	@:visionTestId("vision.tools.ImageTools.loadFromBytes#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_loadFromBytes__checkerboard() {
		var source = Factories.checkerboardImage(4, 4, 1);
		var bytes = ImageTools.exportToBytes(source, ImageFormat.BMP);
		var result = ImageTools.loadFromBytes(new Image(0, 0), bytes, ImageFormat.BMP);
		ImageAssertions.hasDimensions(result, 4, 4);
		ImageAssertions.pixelEquals(result, 0, 1, 0xFF000000);
		ImageAssertions.pixelEquals(result, 1, 1, 0xFFFFFFFF);
	}

	@:visionTestId("vision.tools.ImageTools.exportToBytes#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_exportToBytes__default() {
		var image = labeledImage();
		CollectionAssertions.bytes(image.underlying.toArray(), ImageTools.exportToBytes(image, ImageFormat.VISION));
	}

	@:visionTestId("vision.tools.ImageTools.exportToBytes#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_exportToBytes__tiny() {
		var result = ImageTools.exportToBytes(Factories.gradientImage(3, 3), ImageFormat.PNG);
		CollectionAssertions.bytes([137, 80, 78, 71], result.getBytes(0, 4));
	}

	@:visionTestId("vision.tools.ImageTools.exportToBytes#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_exportToBytes__checkerboard() {
		var result = ImageTools.exportToBytes(Factories.checkerboardImage(4, 4, 1), ImageFormat.BMP);
		CollectionAssertions.bytes([66, 77], result.getBytes(0, 2));
	}

	@:visionTestId("vision.tools.ImageTools.addToScreen#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_addToScreen__default() {
		var image = Factories.gradientImage(3, 3);
		var result = ImageTools.addToScreen(image, 1, 1, null);
		Assert.equals(cast image, cast result);
		ImageAssertions.hasDimensions(result, 3, 3);
	}

	@:visionTestId("vision.tools.ImageTools.addToScreen#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_addToScreen__tiny() {
		var image = Factories.checkerboardImage(2, 2, 1);
		var result = ImageTools.addToScreen(image, 2, 3, null);
		Assert.equals(cast image, cast result);
		ImageAssertions.pixelEquals(result, 1, 1, 0xFFFFFFFF);
	}

	@:visionTestId("vision.tools.ImageTools.addToScreen#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_addToScreen__checkerboard() {
		var image = labeledImage();
		var result = ImageTools.addToScreen(image, 0, 0, {xUnits: "px", yUnits: "px", zIndex: "5"});
		Assert.equals(cast image, cast result);
		ImageAssertions.pixelEquals(result, 2, 0, 0xFF000033);
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getNeighborsOfPixel__default() {
		var result = ImageTools.getNeighborsOfPixel(labeledImage(), 1, 1, 3);
		CollectionAssertions.nestedValues([
			[0xFF000044, 0xFF000077, 0xFF000022],
			[0xFF000055, 0xFF000088, 0xFF000033],
			[0xFF000066, 0xFF000099, 0xFF000033]
		], result.to2DArray());
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixel#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getNeighborsOfPixel__tiny() {
		var result = ImageTools.getNeighborsOfPixel(labeledImage(), 0, 0, 3);
		CollectionAssertions.nestedValues([
			[0xFF000011, 0xFF000044, 0xFF000011],
			[0xFF000011, 0xFF000044, 0xFF000022],
			[0xFF000022, 0xFF000055, 0xFF000033]
		], result.to2DArray());
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixel#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getNeighborsOfPixel__checkerboard() {
		var result = ImageTools.getNeighborsOfPixel(Factories.checkerboardImage(4, 4, 1), 1, 1, 3);
		CollectionAssertions.nestedValues([
			[0xFF000000, 0xFFFFFFFF, 0xFF000000],
			[0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF],
			[0xFF000000, 0xFFFFFFFF, 0xFF000000]
		], result.to2DArray());
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixelIter#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getNeighborsOfPixelIter__default() {
		CollectionAssertions.values([
			0xFF000044,
			0xFF000077,
			0xFF000022,
			0xFF000055,
			0xFF000088,
			0xFF000033,
			0xFF000066,
			0xFF000099,
			0xFF000033
		], neighborValues(ImageTools.getNeighborsOfPixelIter(labeledImage(), 1, 1, 3)));
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixelIter#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getNeighborsOfPixelIter__tiny() {
		CollectionAssertions.values([
			0xFF000011,
			0xFF000044,
			0xFF000011,
			0xFF000011,
			0xFF000044,
			0xFF000022,
			0xFF000022,
			0xFF000055,
			0xFF000033
		], neighborValues(ImageTools.getNeighborsOfPixelIter(labeledImage(), 0, 0, 3)));
	}

	@:visionTestId("vision.tools.ImageTools.getNeighborsOfPixelIter#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getNeighborsOfPixelIter__checkerboard() {
		CollectionAssertions.values([
			0xFF000000,
			0xFFFFFFFF,
			0xFF000000,
			0xFFFFFFFF,
			0xFF000000,
			0xFFFFFFFF,
			0xFF000000,
			0xFFFFFFFF,
			0xFF000000
		], neighborValues(ImageTools.getNeighborsOfPixelIter(Factories.checkerboardImage(4, 4, 1), 1, 1, 3)));
	}

	@:visionTestId("vision.tools.ImageTools.grayscalePixel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_grayscalePixel__default() {
		Assert.equals((0x80282828 : Color), ImageTools.grayscalePixel(0x803C2418));
	}
}
