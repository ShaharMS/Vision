import js.Browser;
import vision.Vision;
import vision.backend.browser.CanvasRenderer;
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
		Browser.document.body.innerText = haxe.Json.stringify({
			renderer: info == null ? null : gl.getParameter(info.UNMASKED_RENDERER_WEBGL),
			coldGpu: coldGpu, coldCpu: coldCpu, warmMilliseconds: samples,
			glError: gl.getError()
		});
		renderer.dispose();
	}
}
