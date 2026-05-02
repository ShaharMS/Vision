package tests;

import tests.support.Factories;
import tests.support.ImageAssertions;
import utest.Assert;
import vision.Vision;
import vision.algorithms.BilateralFilter;
import vision.algorithms.Gauss;
import vision.algorithms.Sobel;
import vision.ds.Color;
import vision.ds.Image;
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
}
