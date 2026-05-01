package tests;

import tests.support.Factories;
import utest.Assert;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Kernel2D;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.TransformationMatrix2D;

@:access(vision.Vision)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class VisionTest extends utest.Test {

	@:visionTestId("vision.Vision.combine#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_combine__default() {
		var image = Factories.gradientImage(3, 3);
		var with = Factories.gradientImage(3, 3);
		var percentage = 1.0;
		var result = vision.Vision.combine(image, with, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.combine#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_combine__tiny() {
		var image = Factories.gradientImage(3, 3);
		var with = Factories.gradientImage(3, 3);
		var percentage = 1.0;
		var result = vision.Vision.combine(image, with, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.combine#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_combine__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var with = Factories.checkerboardImage(8, 8, 2);
		var percentage = 1.0;
		var result = vision.Vision.combine(image, with, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.tint#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_tint__default() {
		var image = Factories.gradientImage(3, 3);
		var withColor = (0xFF336699 : vision.ds.Color);
		var percentage = 1.0;
		var result = vision.Vision.tint(image, withColor, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.tint#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_tint__tiny() {
		var image = Factories.gradientImage(3, 3);
		var withColor = (0xFF336699 : vision.ds.Color);
		var percentage = 1.0;
		var result = vision.Vision.tint(image, withColor, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.tint#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_tint__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var withColor = (0xFF336699 : vision.ds.Color);
		var percentage = 1.0;
		var result = vision.Vision.tint(image, withColor, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.grayscale#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_grayscale__default() {
		var image = Factories.gradientImage(3, 3);
		var simpleGrayscale = false;
		var result = vision.Vision.grayscale(image, simpleGrayscale);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.grayscale#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_grayscale__tiny() {
		var image = Factories.gradientImage(3, 3);
		var simpleGrayscale = false;
		var result = vision.Vision.grayscale(image, simpleGrayscale);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.grayscale#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_grayscale__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var simpleGrayscale = false;
		var result = vision.Vision.grayscale(image, simpleGrayscale);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.invert#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_invert__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.invert(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.invert#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_invert__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.invert(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.invert#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_invert__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.Vision.invert(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sepia#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sepia__default() {
		var image = Factories.gradientImage(3, 3);
		var strength = 1.0;
		var result = vision.Vision.sepia(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sepia#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sepia__tiny() {
		var image = Factories.gradientImage(3, 3);
		var strength = 1.0;
		var result = vision.Vision.sepia(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sepia#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sepia__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var strength = 1.0;
		var result = vision.Vision.sepia(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.blackAndWhite#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_blackAndWhite__default() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1;
		var result = vision.Vision.blackAndWhite(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.blackAndWhite#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_blackAndWhite__tiny() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1;
		var result = vision.Vision.blackAndWhite(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.blackAndWhite#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_blackAndWhite__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var threshold = 1;
		var result = vision.Vision.blackAndWhite(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.contrast#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_contrast__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.contrast(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.contrast#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_contrast__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.contrast(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.contrast#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_contrast__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.Vision.contrast(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.smooth#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_smooth__default() {
		var image = Factories.gradientImage(3, 3);
		var strength = 1.0;
		var affectAlpha = true;
		var kernelRadius = 3;
		var circularKernel = false;
		var iterations = 1;
		var result = vision.Vision.smooth(image, strength, affectAlpha, kernelRadius, circularKernel, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.smooth#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_smooth__tiny() {
		var image = Factories.gradientImage(3, 3);
		var strength = 1.0;
		var affectAlpha = true;
		var kernelRadius = 3;
		var circularKernel = false;
		var iterations = 1;
		var result = vision.Vision.smooth(image, strength, affectAlpha, kernelRadius, circularKernel, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.smooth#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_smooth__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var strength = 1.0;
		var affectAlpha = true;
		var kernelRadius = 3;
		var circularKernel = false;
		var iterations = 1;
		var result = vision.Vision.smooth(image, strength, affectAlpha, kernelRadius, circularKernel, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.pixelate#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_pixelate__default() {
		var image = Factories.gradientImage(3, 3);
		var averagePixels = false;
		var pixelSize = 3;
		var affectAlpha = true;
		var result = vision.Vision.pixelate(image, averagePixels, pixelSize, affectAlpha);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.pixelate#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_pixelate__tiny() {
		var image = Factories.gradientImage(3, 3);
		var averagePixels = false;
		var pixelSize = 3;
		var affectAlpha = true;
		var result = vision.Vision.pixelate(image, averagePixels, pixelSize, affectAlpha);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.pixelate#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_pixelate__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var averagePixels = false;
		var pixelSize = 3;
		var affectAlpha = true;
		var result = vision.Vision.pixelate(image, averagePixels, pixelSize, affectAlpha);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.posterize#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_posterize__default() {
		var image = Factories.gradientImage(3, 3);
		var bitsPerChannel = 1;
		var affectAlpha = true;
		var result = vision.Vision.posterize(image, bitsPerChannel, affectAlpha);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.posterize#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_posterize__tiny() {
		var image = Factories.gradientImage(3, 3);
		var bitsPerChannel = 1;
		var affectAlpha = true;
		var result = vision.Vision.posterize(image, bitsPerChannel, affectAlpha);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.posterize#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_posterize__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var bitsPerChannel = 1;
		var affectAlpha = true;
		var result = vision.Vision.posterize(image, bitsPerChannel, affectAlpha);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sharpen#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sharpen__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.sharpen(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sharpen#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sharpen__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.sharpen(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sharpen#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sharpen__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.Vision.sharpen(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.deepfry#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_deepfry__default() {
		var image = Factories.gradientImage(3, 3);
		var iterations = 1;
		var result = vision.Vision.deepfry(image, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.deepfry#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_deepfry__tiny() {
		var image = Factories.gradientImage(3, 3);
		var iterations = 1;
		var result = vision.Vision.deepfry(image, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.deepfry#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_deepfry__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var iterations = 1;
		var result = vision.Vision.deepfry(image, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.vignette#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_vignette__default() {
		var image = Factories.gradientImage(3, 3);
		var strength = null;
		var intensity = null;
		var ratioDependent = false;
		var color = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.vignette(image, strength, intensity, ratioDependent, color);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.vignette#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_vignette__tiny() {
		var image = Factories.gradientImage(3, 3);
		var strength = null;
		var intensity = null;
		var ratioDependent = false;
		var color = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.vignette(image, strength, intensity, ratioDependent, color);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.vignette#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_vignette__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var strength = null;
		var intensity = null;
		var ratioDependent = false;
		var color = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.vignette(image, strength, intensity, ratioDependent, color);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.fisheyeDistortion#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fisheyeDistortion__default() {
		var image = Factories.gradientImage(3, 3);
		var strength = null;
		var result = vision.Vision.fisheyeDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.fisheyeDistortion#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fisheyeDistortion__tiny() {
		var image = Factories.gradientImage(3, 3);
		var strength = null;
		var result = vision.Vision.fisheyeDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.fisheyeDistortion#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fisheyeDistortion__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var strength = null;
		var result = vision.Vision.fisheyeDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.barrelDistortion#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_barrelDistortion__default() {
		var image = Factories.gradientImage(3, 3);
		var strength = null;
		var result = vision.Vision.barrelDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.barrelDistortion#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_barrelDistortion__tiny() {
		var image = Factories.gradientImage(3, 3);
		var strength = null;
		var result = vision.Vision.barrelDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.barrelDistortion#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_barrelDistortion__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var strength = null;
		var result = vision.Vision.barrelDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.pincushionDistortion#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_pincushionDistortion__default() {
		var image = Factories.gradientImage(3, 3);
		var strength = null;
		var result = vision.Vision.pincushionDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.pincushionDistortion#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_pincushionDistortion__tiny() {
		var image = Factories.gradientImage(3, 3);
		var strength = null;
		var result = vision.Vision.pincushionDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.pincushionDistortion#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_pincushionDistortion__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var strength = null;
		var result = vision.Vision.pincushionDistortion(image, strength);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.mustacheDistortion#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_mustacheDistortion__default() {
		var image = Factories.gradientImage(3, 3);
		var amplitude = 1.0;
		var result = vision.Vision.mustacheDistortion(image, amplitude);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.mustacheDistortion#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_mustacheDistortion__tiny() {
		var image = Factories.gradientImage(3, 3);
		var amplitude = 1.0;
		var result = vision.Vision.mustacheDistortion(image, amplitude);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.mustacheDistortion#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_mustacheDistortion__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var amplitude = 1.0;
		var result = vision.Vision.mustacheDistortion(image, amplitude);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.dilate#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_dilate__default() {
		var image = Factories.gradientImage(3, 3);
		var dilationRadius = 3;
		var colorImportanceOrder = null;
		var circularKernel = false;
		var result = vision.Vision.dilate(image, dilationRadius, colorImportanceOrder, circularKernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.dilate#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_dilate__tiny() {
		var image = Factories.gradientImage(3, 3);
		var dilationRadius = 3;
		var colorImportanceOrder = null;
		var circularKernel = false;
		var result = vision.Vision.dilate(image, dilationRadius, colorImportanceOrder, circularKernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.dilate#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_dilate__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var dilationRadius = 3;
		var colorImportanceOrder = null;
		var circularKernel = false;
		var result = vision.Vision.dilate(image, dilationRadius, colorImportanceOrder, circularKernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.erode#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_erode__default() {
		var image = Factories.gradientImage(3, 3);
		var erosionRadius = 3;
		var colorImportanceOrder = null;
		var circularKernel = false;
		var result = vision.Vision.erode(image, erosionRadius, colorImportanceOrder, circularKernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.erode#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_erode__tiny() {
		var image = Factories.gradientImage(3, 3);
		var erosionRadius = 3;
		var colorImportanceOrder = null;
		var circularKernel = false;
		var result = vision.Vision.erode(image, erosionRadius, colorImportanceOrder, circularKernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.erode#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_erode__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var erosionRadius = 3;
		var colorImportanceOrder = null;
		var circularKernel = false;
		var result = vision.Vision.erode(image, erosionRadius, colorImportanceOrder, circularKernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.saltAndPepperNoise#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_saltAndPepperNoise__default() {
		var image = Factories.gradientImage(3, 3);
		var percentage = 1.0;
		var result = vision.Vision.saltAndPepperNoise(image, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.saltAndPepperNoise#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_saltAndPepperNoise__tiny() {
		var image = Factories.gradientImage(3, 3);
		var percentage = 1.0;
		var result = vision.Vision.saltAndPepperNoise(image, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.saltAndPepperNoise#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_saltAndPepperNoise__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var percentage = 1.0;
		var result = vision.Vision.saltAndPepperNoise(image, percentage);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.dropOutNoise#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_dropOutNoise__default() {
		var image = Factories.gradientImage(3, 3);
		var percentage = 1.0;
		var threshold = 1;
		var result = vision.Vision.dropOutNoise(image, percentage, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.dropOutNoise#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_dropOutNoise__tiny() {
		var image = Factories.gradientImage(3, 3);
		var percentage = 1.0;
		var threshold = 1;
		var result = vision.Vision.dropOutNoise(image, percentage, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.dropOutNoise#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_dropOutNoise__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var percentage = 1.0;
		var threshold = 1;
		var result = vision.Vision.dropOutNoise(image, percentage, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.whiteNoise#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_whiteNoise__default() {
		var image = Factories.gradientImage(3, 3);
		var percentage = 1.0;
		var whiteNoiseRange = null;
		var result = vision.Vision.whiteNoise(image, percentage, whiteNoiseRange);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.whiteNoise#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_whiteNoise__tiny() {
		var image = Factories.gradientImage(3, 3);
		var percentage = 1.0;
		var whiteNoiseRange = null;
		var result = vision.Vision.whiteNoise(image, percentage, whiteNoiseRange);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.whiteNoise#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_whiteNoise__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var percentage = 1.0;
		var whiteNoiseRange = null;
		var result = vision.Vision.whiteNoise(image, percentage, whiteNoiseRange);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.normalize#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_normalize__default() {
		var image = Factories.gradientImage(3, 3);
		var rangeStart = (0xFF336699 : vision.ds.Color);
		var rangeEnd = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.normalize(image, rangeStart, rangeEnd);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.normalize#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_normalize__tiny() {
		var image = Factories.gradientImage(3, 3);
		var rangeStart = (0xFF336699 : vision.ds.Color);
		var rangeEnd = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.normalize(image, rangeStart, rangeEnd);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.normalize#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_normalize__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var rangeStart = (0xFF336699 : vision.ds.Color);
		var rangeEnd = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.normalize(image, rangeStart, rangeEnd);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.limitColorRanges#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_limitColorRanges__default() {
		var image = Factories.gradientImage(3, 3);
		var rangeStart = (0xFF336699 : vision.ds.Color);
		var rangeEnd = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.limitColorRanges(image, rangeStart, rangeEnd);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.limitColorRanges#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_limitColorRanges__tiny() {
		var image = Factories.gradientImage(3, 3);
		var rangeStart = (0xFF336699 : vision.ds.Color);
		var rangeEnd = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.limitColorRanges(image, rangeStart, rangeEnd);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.limitColorRanges#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_limitColorRanges__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var rangeStart = (0xFF336699 : vision.ds.Color);
		var rangeEnd = (0xFF336699 : vision.ds.Color);
		var result = vision.Vision.limitColorRanges(image, rangeStart, rangeEnd);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.replaceColorRanges#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_replaceColorRanges__default() {
		var image = Factories.gradientImage(3, 3);
		var ranges = [{rangeStart: (0xFF000000 : vision.ds.Color), rangeEnd: (0xFFFFFFFF : vision.ds.Color), replacement: (0xFF336699 : vision.ds.Color)}];
		var result = vision.Vision.replaceColorRanges(image, ranges);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.replaceColorRanges#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_replaceColorRanges__tiny() {
		var image = Factories.gradientImage(3, 3);
		var ranges = [{rangeStart: (0xFF000000 : vision.ds.Color), rangeEnd: (0xFFFFFFFF : vision.ds.Color), replacement: (0xFF336699 : vision.ds.Color)}];
		var result = vision.Vision.replaceColorRanges(image, ranges);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.replaceColorRanges#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_replaceColorRanges__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var ranges = [{rangeStart: (0xFF000000 : vision.ds.Color), rangeEnd: (0xFFFFFFFF : vision.ds.Color), replacement: (0xFF336699 : vision.ds.Color)}];
		var result = vision.Vision.replaceColorRanges(image, ranges);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.filterForColorChannel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filterForColorChannel__default() {
		var image = Factories.gradientImage(3, 3);
		var channel = vision.ds.specifics.ColorChannel.RED;
		var result = vision.Vision.filterForColorChannel(image, channel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.filterForColorChannel#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filterForColorChannel__tiny() {
		var image = Factories.gradientImage(3, 3);
		var channel = vision.ds.specifics.ColorChannel.RED;
		var result = vision.Vision.filterForColorChannel(image, channel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.filterForColorChannel#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filterForColorChannel__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var channel = vision.ds.specifics.ColorChannel.RED;
		var result = vision.Vision.filterForColorChannel(image, channel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.convolve#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolve__default() {
		var image = Factories.gradientImage(3, 3);
		var kernel = null;
		var result = vision.Vision.convolve(image, kernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.convolve#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolve__tiny() {
		var image = Factories.gradientImage(3, 3);
		var kernel = null;
		var result = vision.Vision.convolve(image, kernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.convolve#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolve__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var kernel = null;
		var result = vision.Vision.convolve(image, kernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.affineTransform#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_affineTransform__default() {
		var image = Factories.gradientImage(3, 3);
		var matrix = vision.ds.Matrix2D.IDENTITY();
		var expansionMode = vision.ds.specifics.ImageExpansionMode.RESIZE;
		var originPoint = new vision.ds.Point2D(1.0, 1.0);
		var originMode = null;
		var result = vision.Vision.affineTransform(image, matrix, expansionMode, originPoint, originMode);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.affineTransform#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_affineTransform__tiny() {
		var image = Factories.gradientImage(3, 3);
		var matrix = vision.ds.Matrix2D.IDENTITY();
		var expansionMode = vision.ds.specifics.ImageExpansionMode.RESIZE;
		var originPoint = new vision.ds.Point2D(1.0, 1.0);
		var originMode = null;
		var result = vision.Vision.affineTransform(image, matrix, expansionMode, originPoint, originMode);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.affineTransform#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_affineTransform__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var matrix = vision.ds.Matrix2D.IDENTITY();
		var expansionMode = vision.ds.specifics.ImageExpansionMode.RESIZE;
		var originPoint = new vision.ds.Point2D(1.0, 1.0);
		var originMode = null;
		var result = vision.Vision.affineTransform(image, matrix, expansionMode, originPoint, originMode);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.projectiveTransform#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_projectiveTransform__default() {
		var image = Factories.gradientImage(3, 3);
		var matrix = vision.ds.Matrix2D.IDENTITY();
		var expansionMode = vision.ds.specifics.ImageExpansionMode.RESIZE;
		var result = vision.Vision.projectiveTransform(image, matrix, expansionMode);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.projectiveTransform#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_projectiveTransform__tiny() {
		var image = Factories.gradientImage(3, 3);
		var matrix = vision.ds.Matrix2D.IDENTITY();
		var expansionMode = vision.ds.specifics.ImageExpansionMode.RESIZE;
		var result = vision.Vision.projectiveTransform(image, matrix, expansionMode);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.projectiveTransform#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_projectiveTransform__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var matrix = vision.ds.Matrix2D.IDENTITY();
		var expansionMode = vision.ds.specifics.ImageExpansionMode.RESIZE;
		var result = vision.Vision.projectiveTransform(image, matrix, expansionMode);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.nearestNeighborBlur#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_nearestNeighborBlur__default() {
		var image = Factories.gradientImage(3, 3);
		var iterations = 1;
		var result = vision.Vision.nearestNeighborBlur(image, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.nearestNeighborBlur#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_nearestNeighborBlur__tiny() {
		var image = Factories.gradientImage(3, 3);
		var iterations = 1;
		var result = vision.Vision.nearestNeighborBlur(image, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.nearestNeighborBlur#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_nearestNeighborBlur__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var iterations = 1;
		var result = vision.Vision.nearestNeighborBlur(image, iterations);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.gaussianBlur#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_gaussianBlur__default() {
		var image = Factories.gradientImage(3, 3);
		var sigma = null;
		var kernelSize = null;
		var fast = null;
		var result = vision.Vision.gaussianBlur(image, sigma, kernelSize, fast);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.gaussianBlur#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_gaussianBlur__tiny() {
		var image = Factories.gradientImage(3, 3);
		var sigma = null;
		var kernelSize = null;
		var fast = null;
		var result = vision.Vision.gaussianBlur(image, sigma, kernelSize, fast);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.gaussianBlur#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_gaussianBlur__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var sigma = null;
		var kernelSize = null;
		var fast = null;
		var result = vision.Vision.gaussianBlur(image, sigma, kernelSize, fast);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.medianBlur#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_medianBlur__default() {
		var image = Factories.gradientImage(3, 3);
		var kernelSize = 3;
		var result = vision.Vision.medianBlur(image, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.medianBlur#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_medianBlur__tiny() {
		var image = Factories.gradientImage(3, 3);
		var kernelSize = 3;
		var result = vision.Vision.medianBlur(image, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.medianBlur#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_medianBlur__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var kernelSize = 3;
		var result = vision.Vision.medianBlur(image, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.simpleLine2DDetection#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_simpleLine2DDetection__default() {
		var image = Factories.gradientImage(3, 3);
		var accuracy = 1.0;
		var minLineLength = 1.0;
		var speedToAccuracyRatio = null;
		var result = vision.Vision.simpleLine2DDetection(image, accuracy, minLineLength, speedToAccuracyRatio);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.Vision.simpleLine2DDetection#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_simpleLine2DDetection__tiny() {
		var image = Factories.gradientImage(3, 3);
		var accuracy = 1.0;
		var minLineLength = 1.0;
		var speedToAccuracyRatio = null;
		var result = vision.Vision.simpleLine2DDetection(image, accuracy, minLineLength, speedToAccuracyRatio);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.Vision.simpleLine2DDetection#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_simpleLine2DDetection__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var accuracy = 1.0;
		var minLineLength = 1.0;
		var speedToAccuracyRatio = null;
		var result = vision.Vision.simpleLine2DDetection(image, accuracy, minLineLength, speedToAccuracyRatio);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.Vision.sobelEdgeDiffOperator#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sobelEdgeDiffOperator__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.sobelEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sobelEdgeDiffOperator#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sobelEdgeDiffOperator__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.sobelEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sobelEdgeDiffOperator#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sobelEdgeDiffOperator__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.Vision.sobelEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.perwittEdgeDiffOperator#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_perwittEdgeDiffOperator__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.perwittEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.perwittEdgeDiffOperator#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_perwittEdgeDiffOperator__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.perwittEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.perwittEdgeDiffOperator#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_perwittEdgeDiffOperator__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.Vision.perwittEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.robertEdgeDiffOperator#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_robertEdgeDiffOperator__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.robertEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.robertEdgeDiffOperator#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_robertEdgeDiffOperator__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.Vision.robertEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.robertEdgeDiffOperator#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_robertEdgeDiffOperator__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.Vision.robertEdgeDiffOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.laplacianEdgeDiffOperator#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianEdgeDiffOperator__default() {
		var image = Factories.gradientImage(3, 3);
		var filterPositive = false;
		var result = vision.Vision.laplacianEdgeDiffOperator(image, filterPositive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.laplacianEdgeDiffOperator#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianEdgeDiffOperator__tiny() {
		var image = Factories.gradientImage(3, 3);
		var filterPositive = false;
		var result = vision.Vision.laplacianEdgeDiffOperator(image, filterPositive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.laplacianEdgeDiffOperator#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianEdgeDiffOperator__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var filterPositive = false;
		var result = vision.Vision.laplacianEdgeDiffOperator(image, filterPositive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.cannyEdgeDetection#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_cannyEdgeDetection__default() {
		var image = Factories.gradientImage(3, 3);
		var sigma = 1.0;
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var lowThreshold = 1.0;
		var highThreshold = 1.0;
		var result = vision.Vision.cannyEdgeDetection(image, sigma, kernelSize, lowThreshold, highThreshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.cannyEdgeDetection#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_cannyEdgeDetection__tiny() {
		var image = Factories.gradientImage(3, 3);
		var sigma = 1.0;
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var lowThreshold = 1.0;
		var highThreshold = 1.0;
		var result = vision.Vision.cannyEdgeDetection(image, sigma, kernelSize, lowThreshold, highThreshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.cannyEdgeDetection#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_cannyEdgeDetection__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var sigma = 1.0;
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var lowThreshold = 1.0;
		var highThreshold = 1.0;
		var result = vision.Vision.cannyEdgeDetection(image, sigma, kernelSize, lowThreshold, highThreshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sobelEdgeDetection#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sobelEdgeDetection__default() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1.0;
		var result = vision.Vision.sobelEdgeDetection(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sobelEdgeDetection#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sobelEdgeDetection__tiny() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1.0;
		var result = vision.Vision.sobelEdgeDetection(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.sobelEdgeDetection#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_sobelEdgeDetection__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var threshold = 1.0;
		var result = vision.Vision.sobelEdgeDetection(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.perwittEdgeDetection#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_perwittEdgeDetection__default() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1.0;
		var result = vision.Vision.perwittEdgeDetection(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.perwittEdgeDetection#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_perwittEdgeDetection__tiny() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1.0;
		var result = vision.Vision.perwittEdgeDetection(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.perwittEdgeDetection#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_perwittEdgeDetection__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var threshold = 1.0;
		var result = vision.Vision.perwittEdgeDetection(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.laplacianOfGaussianEdgeDetection#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussianEdgeDetection__default() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1;
		var filterPositive = false;
		var sigma = 1.0;
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var result = vision.Vision.laplacianOfGaussianEdgeDetection(image, threshold, filterPositive, sigma, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.laplacianOfGaussianEdgeDetection#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussianEdgeDetection__tiny() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1;
		var filterPositive = false;
		var sigma = 1.0;
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var result = vision.Vision.laplacianOfGaussianEdgeDetection(image, threshold, filterPositive, sigma, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.laplacianOfGaussianEdgeDetection#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussianEdgeDetection__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var threshold = 1;
		var filterPositive = false;
		var sigma = 1.0;
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var result = vision.Vision.laplacianOfGaussianEdgeDetection(image, threshold, filterPositive, sigma, kernelSize);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.convolutionRidgeDetection#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolutionRidgeDetection__default() {
		var image = Factories.gradientImage(3, 3);
		var normalizationRangeStart = (0xFF336699 : vision.ds.Color);
		var normalizationRangeEnd = (0xFF336699 : vision.ds.Color);
		var refine = false;
		var result = vision.Vision.convolutionRidgeDetection(image, normalizationRangeStart, normalizationRangeEnd, refine);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.convolutionRidgeDetection#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolutionRidgeDetection__tiny() {
		var image = Factories.gradientImage(3, 3);
		var normalizationRangeStart = (0xFF336699 : vision.ds.Color);
		var normalizationRangeEnd = (0xFF336699 : vision.ds.Color);
		var refine = false;
		var result = vision.Vision.convolutionRidgeDetection(image, normalizationRangeStart, normalizationRangeEnd, refine);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.convolutionRidgeDetection#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolutionRidgeDetection__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var normalizationRangeStart = (0xFF336699 : vision.ds.Color);
		var normalizationRangeEnd = (0xFF336699 : vision.ds.Color);
		var refine = false;
		var result = vision.Vision.convolutionRidgeDetection(image, normalizationRangeStart, normalizationRangeEnd, refine);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.bilateralDenoise#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bilateralDenoise__default() {
		var image = Factories.gradientImage(3, 3);
		var gaussianSigma = 1.0;
		var intensitySigma = 1.0;
		var result = vision.Vision.bilateralDenoise(image, gaussianSigma, intensitySigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.bilateralDenoise#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bilateralDenoise__tiny() {
		var image = Factories.gradientImage(3, 3);
		var gaussianSigma = 1.0;
		var intensitySigma = 1.0;
		var result = vision.Vision.bilateralDenoise(image, gaussianSigma, intensitySigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.bilateralDenoise#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bilateralDenoise__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var gaussianSigma = 1.0;
		var intensitySigma = 1.0;
		var result = vision.Vision.bilateralDenoise(image, gaussianSigma, intensitySigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.simpleImageSimilarity#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_simpleImageSimilarity__default() {
		var image = Factories.gradientImage(3, 3);
		var compared = Factories.gradientImage(3, 3);
		var scoringMechanism = null;
		var result = vision.Vision.simpleImageSimilarity(image, compared, scoringMechanism);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.Vision.simpleImageSimilarity#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_simpleImageSimilarity__tiny() {
		var image = Factories.gradientImage(3, 3);
		var compared = Factories.gradientImage(3, 3);
		var scoringMechanism = null;
		var result = vision.Vision.simpleImageSimilarity(image, compared, scoringMechanism);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.Vision.simpleImageSimilarity#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_simpleImageSimilarity__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var compared = Factories.checkerboardImage(8, 8, 2);
		var scoringMechanism = null;
		var result = vision.Vision.simpleImageSimilarity(image, compared, scoringMechanism);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.Vision.kmeansPosterize#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_kmeansPosterize__default() {
		var image = Factories.gradientImage(3, 3);
		var maxColorCount = 1;
		var result = vision.Vision.kmeansPosterize(image, maxColorCount);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.kmeansPosterize#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_kmeansPosterize__tiny() {
		var image = Factories.gradientImage(3, 3);
		var maxColorCount = 1;
		var result = vision.Vision.kmeansPosterize(image, maxColorCount);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.kmeansPosterize#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_kmeansPosterize__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var maxColorCount = 1;
		var result = vision.Vision.kmeansPosterize(image, maxColorCount);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.Vision.kmeansGroupImageColors#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_kmeansGroupImageColors__default() {
		var image = Factories.gradientImage(3, 3);
		var groupCount = 1;
		var considerTransparency = false;
		var result = vision.Vision.kmeansGroupImageColors(image, groupCount, considerTransparency);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.Vision.kmeansGroupImageColors#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_kmeansGroupImageColors__tiny() {
		var image = Factories.gradientImage(3, 3);
		var groupCount = 1;
		var considerTransparency = false;
		var result = vision.Vision.kmeansGroupImageColors(image, groupCount, considerTransparency);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.Vision.kmeansGroupImageColors#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_kmeansGroupImageColors__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var groupCount = 1;
		var considerTransparency = false;
		var result = vision.Vision.kmeansGroupImageColors(image, groupCount, considerTransparency);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

}
