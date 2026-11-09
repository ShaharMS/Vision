import js.Browser;
import vision.Vision;
import vision.ds.CanvasRenderer;
import vision.ds.WebGpuInverter;
import vision.ds.Image;

class BrowserInversionBenchmark {
	static function main() {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = canvas.height = 1024;
		final renderer = new CanvasRenderer(canvas);
		final gl = canvas.getContextWebGL2();
		if (!renderer.usesWebGl) throw "WebGL unavailable";
		final info = gl.getExtension("WEBGL_debug_renderer_info");
		final source = new Image(1024, 1024, 0x80305593);
		source.setPixel(40, 54, 0xFFABCDEF);
		final cached = Vision.invert(source.clone());
		final gpu = () -> renderer.drawInverted(source);
		final cpu = () -> renderer.draw(Vision.invert(source.clone()));
		final cpuCached = () -> renderer.draw(cached);
		function measure(draw:Void->Void, frames:Int) {
			gl.finish();
			final start = Browser.window.performance.now();
			for (_ in 0...frames) draw();
			gl.finish();
			return (Browser.window.performance.now() - start) / frames;
		}
		final coldGpu = measure(gpu, 1);
		final coldCpu = measure(cpu, 1);
		measure(gpu, 10);
		measure(cpu, 10);
		final samples = [for (trial in 0...5) {
			gpu: measure(gpu, 30),
			cpu: measure(cpu, 30),
			cpuCached: measure(cpuCached, 30)
		}];
		final results:Dynamic = {
			renderer: info == null ? null : gl.getParameter(info.UNMASKED_RENDERER_WEBGL),
			coldGpu: coldGpu, coldCpu: coldCpu, warmMilliseconds: samples,
			glError: gl.getError()
		};
		renderer.dispose();

		final start = Browser.window.performance.now();
		WebGpuInverter.create().then(inverter -> {
			if (inverter == null) {
				complete(results, "unavailable");
				return;
			}
			results.webGpuSetupMs = Browser.window.performance.now() - start;
			final computeTimes = [];
			function sample(remaining:Int):js.lib.Promise<Bool> {
				if (remaining == 0)
					return js.lib.Promise.resolve(true);
				final started = Browser.window.performance.now();
				return inverter.invert(source).then(result -> {
					computeTimes.push(Browser.window.performance.now() - started);
					if (result.getPixel(40, 54) != cached.getPixel(40, 54))
						throw "WebGPU benchmark output mismatch";
					return sample(remaining - 1);
				});
			}
			final cpuStarted = Browser.window.performance.now();
			for (_ in 0...10) {
				if (Vision.invert(source.clone()).getPixel(40, 54) != cached.getPixel(40, 54))
					throw "CPU benchmark output mismatch";
			}
			results.cpuToCpuMs = (Browser.window.performance.now() - cpuStarted) / 10;
			sample(11).then(_ -> {
				inverter.dispose();
				results.webGpuFirstCpuToCpuMs = computeTimes.shift();
				results.webGpuWarmCpuToCpuMs = computeTimes;
				complete(results, "pass");
			}).catchError(error -> {
				inverter.dispose();
				failed(error);
			});
		}).catchError(failed);
	}

	static function complete(results:Dynamic, webgpu:String):Void {
		Browser.document.body.setAttribute("data-result", "pass");
		Browser.document.body.setAttribute("data-webgpu", webgpu);
		Browser.document.body.innerText = haxe.Json.stringify(results);
	}

	static function failed(error:Dynamic):Void {
		Browser.document.body.setAttribute("data-result", "fail");
		Browser.document.body.innerText = Std.string(error);
	}
}
