package tests;

import tests.support.ExceptionAssertions;
import vision.exceptions.InvalidGaussianKernelSize;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class InvalidGaussianKernelSizeTest extends utest.Test {
	@:visionTestId("vision.exceptions.InvalidGaussianKernelSize.new#negative")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__negativeReason() {
		ExceptionAssertions.expectMessage(
			() -> throw new InvalidGaussianKernelSize(-2),
			InvalidGaussianKernelSize,
			"Invalid Gaussian Kernel Size: Creating a gaussian kernel of size -2 is not allowed. Is the kernel size a negative value?"
		);
	}

	@:visionTestId("vision.exceptions.InvalidGaussianKernelSize.new#even")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__evenReason() {
		ExceptionAssertions.expectMessage(
			() -> throw new InvalidGaussianKernelSize(4),
			InvalidGaussianKernelSize,
			"Invalid Gaussian Kernel Size: Creating a gaussian kernel of size 4 is not allowed. Is the kernel size even?"
		);
	}

	@:visionTestId("vision.exceptions.InvalidGaussianKernelSize.new#zero")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__zeroReason() {
		ExceptionAssertions.expectMessage(
			() -> throw new InvalidGaussianKernelSize(0),
			InvalidGaussianKernelSize,
			"Invalid Gaussian Kernel Size: Creating a gaussian kernel of size 0 is not allowed. Is the kernel size 0?"
		);
	}
}