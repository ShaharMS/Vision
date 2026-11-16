package tests;

import tests.support.Factories;
import tests.support.ExceptionAssertions;
import tests.support.ApproxAssertions;
import tests.support.ImageAssertions;
import utest.Assert;
import vision.Vision;
import vision.algorithms.BilateralFilter;
import vision.algorithms.Gauss;
import vision.algorithms.Sobel;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Kernels;
import vision.ds.Matrix2D;
import vision.ds.Transform2D;
import vision.exceptions.MatrixShapeError;
import vision.exceptions.VisionException;
import vision.ds.gaussian.GaussianKernelSize;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class VisionTest extends utest.Test {
@:visionTestId("vision.Vision.combine#weightedMutation")
@:visionMaturity("semantic")
@:visionLifecycle("active")
@:visionRequires("image_fixture")
function test_combine__weightedMutation() {
var base = new Image(1, 1, Color.fromRGBA(20, 40, 60));
var overlay = new Image(1, 1, Color.fromRGBA(220, 140, 100));

var result = Vision.combine(base, overlay, 25);

Assert.isTrue(result == base);
ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(70, 65, 70));
}

@:visionTestId("vision.Vision.gaussianBlur#fastDelegatesToGauss")
@:visionMaturity("semantic")
@:visionLifecycle("active")
@:visionRequires("image_fixture")
function test_gaussianBlur__fastDelegatesToGauss() {
var fixture = Factories.gradientImage(8, 8);
var expected = Gauss.fastBlur(fixture.clone(), GaussianKernelSize.X5, 1);
var actual = Vision.gaussianBlur(fixture.clone(), 1, GaussianKernelSize.X5, true);

ImageAssertions.imagesEqual(expected, actual);
}

@:visionTestId("vision.Vision.bilateralDenoise#delegatesToBilateralFilter")
@:visionMaturity("semantic")
@:visionLifecycle("active")
@:visionRequires("image_fixture")
function test_bilateralDenoise__delegatesToBilateralFilter() {
var fixture = Factories.gradientImage(8, 8);
var expected = BilateralFilter.filter(fixture.clone(), 0.8, 50);
var actual = Vision.bilateralDenoise(fixture.clone(), 0.8, 50);

ImageAssertions.imagesEqual(expected, actual);
}

@:visionTestId("vision.Vision.sobelEdgeDetection#delegatesToSobel")
@:visionMaturity("semantic")
@:visionLifecycle("active")
@:visionRequires("image_fixture")
function test_sobelEdgeDetection__delegatesToSobel() {
var fixture = Factories.whiteLineImage(8, 8);
var expected = Sobel.detectEdges(fixture.clone(), 100);
var actual = Vision.sobelEdgeDetection(fixture.clone(), 100);

ImageAssertions.imagesEqual(expected, actual);
}

@:visionTestId("vision.Vision.simpleImageSimilarity#identityAndSymmetry")
@:visionMaturity("semantic")
@:visionLifecycle("active")
@:visionRequires("image_fixture")
function test_simpleImageSimilarity__identityAndSymmetry() {
var first = Factories.gradientImage(8, 8);
var second = Factories.checkerboardImage(8, 8, 2);

var identical = Vision.simpleImageSimilarity(first, first.clone());
var forward = Vision.simpleImageSimilarity(first, second);
var backward = Vision.simpleImageSimilarity(second, first);

Assert.isTrue(Math.abs(identical - 1) < 0.000001);
Assert.isTrue(Math.abs(forward - backward) < 0.000001);
Assert.isTrue(forward < 1);
}

	@:visionTestId("vision.Vision.convolve#rectangularOrientation")
	function test_convolve__rectangularOrientation() {
		var image = new Image(2, 2, Color.fromRGBA(12, 34, 56, 78));
		image.setPixel(1, 0, Color.fromRGBA(40, 50, 60, 180));
		image.setPixel(0, 1, Color.fromRGBA(100, 110, 120, 200));
		var result = Vision.convolve(image, Matrix2D.fromRows([[0, 0, 2]]));

		ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(80, 100, 120, 78));
		ImageAssertions.pixelEquals(result, 1, 0, Color.fromRGBA(80, 100, 120, 180));
		ImageAssertions.pixelEquals(image, 0, 0, Color.fromRGBA(12, 34, 56, 78));
	}

	@:visionTestId("vision.Vision.convolve#zeroSumAndClipping")
	function test_convolve__zeroSumAndClipping() {
		var image = new Image(3, 3, Color.fromRGBA(20, 50, 120));
		image.setPixel(1, 1, Color.fromRGBA(40, 10, 255));
		var result = Vision.convolve(image, Kernels.laplacianNegative());
		ImageAssertions.pixelEquals(result, 1, 1, Color.fromRGBA(80, 0, 255));
		ExceptionAssertions.throwsType(() -> Vision.convolve(image, Matrix2D.fromRows([[1, 1]])), MatrixShapeError);
	}

	@:visionTestId("vision.Vision.convolve#presets")
	function test_convolve__presets() {
		var image = new Image(2, 2, Color.fromRGBA(19, 73, 201, 47));
		ImageAssertions.imagesEqual(image, Vision.convolve(image));
		ImageAssertions.imagesEqual(image, Vision.convolve(image, Kernels.boxBlur()));
		ImageAssertions.imagesEqual(image, Vision.convolve(image, Kernels.gaussian(5, 1)));
		ImageAssertions.imagesEqual(image, Vision.convolve(image, Kernels.unsharpMasking()));
		var kernel = Kernels.sharpen();
		kernel.set(1, 1, 0);
		Assert.equals(5.0, Kernels.sharpen().get(1, 1));
		ApproxAssertions.equalsFloat(1, Kernels.gaussian(3, 1e-200).get(1, 1));
	}

	@:visionTestId("vision.Vision.affineTransform#requiresAffine")
	function test_affineTransform__requiresAffine() {
		var image = Factories.gradientImage(3, 3);
		var affine = Transform2D.fromRows([2, 0, 0], [0, 2, 0], [0, 0, 2]);
		ImageAssertions.imagesEqual(image, Vision.affineTransform(image, affine));
		var projective = Transform2D.fromRows([1, 0, 0], [0, 1, 0], [0.25, 0, 1]);
		ExceptionAssertions.throwsType(() -> Vision.affineTransform(image, projective), VisionException);
	}

	@:visionTestId("vision.Vision.projectiveTransform#homogeneousScale")
	function test_projectiveTransform__homogeneousScale() {
		var image = Factories.gradientImage(3, 3);
		var map = Transform2D.fromRows([1, 0, 0], [0, 1, 0], [0.25, 0, 1]);
		var scaled = Transform2D.fromMatrix(map.toMatrix().multiplyWithScalar(-2));
		ImageAssertions.imagesEqual(Vision.projectiveTransform(image, map), Vision.projectiveTransform(image, scaled));
		var horizon = Transform2D.fromRows([1, 0, 0], [0, 1, 0], [1, 0, -1]);
		ExceptionAssertions.throwsType(() -> Vision.projectiveTransform(image, horizon), VisionException);
	}
}
