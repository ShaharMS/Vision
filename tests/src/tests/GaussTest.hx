package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ApproxAssertions;
import tests.support.CollectionAssertions;
import tests.support.ExceptionAssertions;
import tests.support.ManualFixtures;
import tests.support.ResamplerAssertions;
import utest.Assert;
import vision.algorithms.Gauss;
import vision.ds.Array2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.InvalidGaussianKernelSize;

@:access(vision.algorithms.Gauss)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class GaussTest extends utest.Test {
	function sumNested(kernel:Array<Array<Float>>):Float {
		var sum = 0.0;
		for (column in kernel) {
			for (value in column) {
				sum += value;
			}
		}
		return sum;
	}

	function sumArray2D(kernel:Array2D<Float>):Float {
		var sum = 0.0;
		for (value in kernel.inner) {
			sum += value;
		}
		return sum;
	}

	@:visionTestId("vision.algorithms.Gauss.create1x1Kernel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create1x1Kernel__default() {
		CollectionAssertions.nestedValues([[1.0]], Gauss.create1x1Kernel(1.0));
	}

	@:visionTestId("vision.algorithms.Gauss.create3x3Kernel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create3x3Kernel__default() {
		var result = Gauss.create3x3Kernel(1.0);
		ApproxAssertions.equalsFloat(1, sumNested(result), 0.0001);
		Assert.isTrue(result[1][1] > result[0][0]);
		ApproxAssertions.equalsFloat(result[0][1], result[2][1], 0.0001);
	}

	@:visionTestId("vision.algorithms.Gauss.create5x5Kernel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create5x5Kernel__default() {
		var result = Gauss.create5x5Kernel(1.0);
		ApproxAssertions.equalsFloat(1, sumNested(result), 0.0001);
		Assert.isTrue(result[2][2] > result[0][0]);
		ApproxAssertions.equalsFloat(result[1][2], result[3][2], 0.0001);
	}

	@:visionTestId("vision.algorithms.Gauss.create7x7Kernel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create7x7Kernel__default() {
		var result = Gauss.create7x7Kernel(1.0);
		ApproxAssertions.equalsFloat(1, sumNested(result), 0.0001);
		ApproxAssertions.equalsFloat(result[2][3], result[4][3], 0.0001);
	}

	@:visionTestId("vision.algorithms.Gauss.create9x9Kernel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create9x9Kernel__default() {
		var result = Gauss.create9x9Kernel(1.0);
		ApproxAssertions.equalsFloat(1, sumNested(result), 0.0001);
		ApproxAssertions.equalsFloat(result[3][4], result[5][4], 0.0001);
	}

	@:visionTestId("vision.algorithms.Gauss.createKernelOfSize#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_createKernelOfSize__default() {
		var result = Gauss.createKernelOfSize(5, 1);
		Assert.equals(5, result.width);
		Assert.equals(5, result.height);
		ApproxAssertions.equalsFloat(1, sumArray2D(result), 0.0001);
	}

	@:visionTestId("vision.algorithms.Gauss.create2DKernelOfSize#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create2DKernelOfSize__default() {
		var result = Gauss.create2DKernelOfSize(5, 1.0);
		Assert.equals(5, result.width);
		Assert.equals(5, result.height);
		ApproxAssertions.equalsFloat(1, sumArray2D(result), 0.0001);
		Assert.isTrue(result.get(2, 2) > result.get(0, 0));
	}

	@:visionTestId("vision.algorithms.Gauss.create2DKernelOfSize#invalidSize")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create2DKernelOfSize__invalidSize() {
		ExceptionAssertions.throwsType(() -> {
			Gauss.create2DKernelOfSize(4, 1.0);
		}, InvalidGaussianKernelSize);
	}

	@:visionTestId("vision.algorithms.Gauss.create1DKernelOfSize#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create1DKernelOfSize__default() {
		var result = Gauss.create1DKernelOfSize(5, 1.0);
		ApproxAssertions.equalsFloat(1, result[0] + result[1] + result[2] + result[3] + result[4], 0.0001);
		ApproxAssertions.equalsFloat(result[0], result[4], 0.0001);
		Assert.isTrue(result[2] > result[1]);
	}

	@:visionTestId("vision.algorithms.Gauss.fastBlur#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fastBlur__default() {
		var result = Gauss.fastBlur(AlgorithmFixtures.centerPixelImage(3), 3, 1.0);
		Assert.isTrue(result.getPixel(1, 1).red < 255);
		Assert.isTrue(result.getPixel(1, 1).red > result.getPixel(0, 1).red);
		Assert.isTrue(result.getPixel(0, 1).red > 0);
	}

	@:visionTestId("vision.algorithms.Gauss.fastBlur#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fastBlur__tiny() {
		var expected = Color.fromRGBA(12, 34, 56, 255);
		var result = Gauss.fastBlur(new Image(1, 1, expected), 3, 1.0);
		ResamplerAssertions.uniformColor(result, expected);
	}

	@:visionTestId("vision.algorithms.Gauss.fastBlur#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fastBlur__checkerboard() {
		var result = Gauss.fastBlur(ManualFixtures.tinyCheckerboardImage(), 3, 1.0);
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}
}
