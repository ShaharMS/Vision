package tests;

import js.lib.Promise;
import utest.Assert;
import utest.Async;
import vision.Vision;
import vision.ds.Image;
import vision.native.browser.WebGpuInverter;
import tests.support.ImageAssertions;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class WebGpuInverterTest extends utest.Test {
	@:visionTestId("vision.native.browser.WebGpuInverter.invert#matchesCpu")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:timeout(5000)
	function test_invert__matchesCpu(async:Async):Void {
		WebGpuInverter.create().then(inverter -> {
			if (inverter == null) {
				js.Browser.document.body.setAttribute("data-webgpu", "unavailable");
				Assert.pass("WebGPU unavailable");
				return Promise.resolve(true);
			}

			final image = new Image(17, 7, 0x8030A070);
			image.setPixel(16, 6, 0xFF12ABCD);
			final expected = Vision.invert(image.clone());
			return inverter.invert(image).then(result -> {
				inverter.dispose();
				Assert.equals(0, result.exportToBytes().compare(expected.exportToBytes()));
				ImageAssertions.pixelEquals(image, 16, 6, 0xFF12ABCD);
				js.Browser.document.body.setAttribute("data-webgpu", "pass");
				return true;
			});
		}).then(_ -> async.done(), error -> {
			Assert.fail(Std.string(error));
			async.done();
		});
	}
}
