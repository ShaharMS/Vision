package tests;

import tests.support.ApproxAssertions;
import tests.support.ImageAssertions;
import tests.support.ManualFixtures;
import tests.support.ResamplerAssertions;
import vision.algorithms.KernelResampler;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.KernelResampler)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class KernelResamplerTest extends utest.Test {
	@:visionTestId("vision.algorithms.KernelResampler.resize#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_resize__default() {
		var result = KernelResampler.resize(ManualFixtures.interpolationImage(), 1, 1, 1, (_) -> 1.0);
		ImageAssertions.hasDimensions(result, 1, 1);
		ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(63, 63, 63, 255));
	}

	@:visionTestId("vision.algorithms.KernelResampler.resize#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_resize__tiny() {
		var expected = Color.fromRGBA(12, 34, 56, 255);
		var result = KernelResampler.resize(new Image(1, 1, expected), 1, 1, 1, (_) -> 1.0);
		ResamplerAssertions.uniformColor(result, expected);
	}

	@:visionTestId("vision.algorithms.KernelResampler.resize#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_resize__checkerboard() {
		var result = KernelResampler.resize(ManualFixtures.tinyCheckerboardImage(), 1, 1, 1, (_) -> 1.0);
		ImageAssertions.hasDimensions(result, 1, 1);
		ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(127, 127, 127, 255));
	}

	@:visionTestId("vision.algorithms.KernelResampler.cubicKernel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cubicKernel__default() {
		ApproxAssertions.equalsFloat(1, KernelResampler.cubicKernel(0, 0, 0.5));
		ApproxAssertions.equalsFloat(0, KernelResampler.cubicKernel(2, 0, 0.5));
		ApproxAssertions.equalsFloat(KernelResampler.cubicKernel(0.5, 1 / 3, 1 / 3), KernelResampler.cubicKernel(-0.5, 1 / 3, 1 / 3));
	}
}
