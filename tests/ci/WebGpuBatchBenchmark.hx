package;

#if (js && !nodejs)
import js.Browser;
import js.lib.Promise;
import vision.ds.Image;
import vision.ds.Color;
import vision.ds.Kernels;
import vision.native.browser.WebGpuBatchDevice;

/** Checks WebGPU output and measures complete batches including one readback. **/
class WebGpuBatchBenchmark {
	static function main():Void {
		final clock = Browser.window.performance;
		final setup = clock.now();
		WebGpuBatchDevice.create().then(device -> {
			if (device == null) throw "WebGPU adapter or pipeline unavailable";
			final setupMs = clock.now() - setup;
			final source = new Image(640, 480);
			for (y in 0...source.height)
				for (x in 0...source.width)
					source.setPixel(x, y, Color.fromRGBA((x * 17 + y * 5) & 255, (x * 3 + y * 19) & 255, (x * 7 + y * 11) & 255, (x + y) & 255));
			final kernel = Kernels.gaussian(5, 1);
			function batch() {
				return source.accelerate().resize(480, 360, BilinearInterpolation)
					.convolve(kernel).fillRect({x: 20, y: 30, width: 60, height: 70}, Color.CYAN);
			}
			final cpuTimes = [];
			var reference = batch().commit().exportToBytes();
			for (_ in 0...7) {
				final start = clock.now();
				reference = batch().commit().exportToBytes();
				cpuTimes.push(clock.now() - start);
			}
			final gpuTimes = [];
			var maxDifference = 0;
			function measure(i:Int):Promise<Bool> {
				if (i == 8) return Promise.resolve(true);
				final start = clock.now();
				return batch().commitWebGpu(device).then(result -> {
					final bytes = result.exportToBytes();
					if (i > 0) gpuTimes.push(clock.now() - start);
					if (bytes.length != reference.length) throw "Incorrect output dimensions";
					for (j in 0...bytes.length)
						maxDifference = Std.int(Math.max(maxDifference, Math.abs(bytes[j] - reference[j])));
					if (maxDifference > 1) throw 'Channel difference $maxDifference';
					return measure(i + 1);
				});
			}
			return measure(0).then(_ -> {
				device.dispose();
				cpuTimes.sort(compare);
				gpuTimes.sort(compare);
				Browser.document.body.innerText = haxe.Json.stringify({
					setupMs: setupMs, cpuMedianMs: cpuTimes[3], webGpuMedianMs: gpuTimes[3],
					maxChannelDifference: maxDifference
				});
				return true;
			});
		}).catchError(error -> {
			Browser.document.body.innerText = "FAIL: " + Std.string(error);
			return false;
		});
	}

	static function compare(a:Float, b:Float):Int return a < b ? -1 : (a > b ? 1 : 0);
}
#end
