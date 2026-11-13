package;

#if (windows && cpp && !cppia)
import haxe.Timer;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Kernels;
import vision.ds.Screen;
import vision.native.windows.D3D11Device;

/** Verifies and times a Windows texture batch and can run it in a live Screen. **/
class WindowsD3D11Benchmark {
	static function main():Void {
		if (!D3D11Device.available()) throw "D3D11 hardware initialization failed";
		final demo = Sys.args().indexOf("--demo") >= 0;
		final screen = new Screen(140, 110, 800, 480, {visible: demo});
		final image = new Image(320, 192, 0xff182f48);
		final kernel = Kernels.gaussian(5, 1.1);

		// The exposed byte buffer keeps these reference operations on the CPU.
		final reference = image.clone();
		function cpu(x:Int):Image {
			var result = reference.clone();
			result.underlying;
			result.fillRect(x, 68, 65, 55, 0xff4de1c5);
			result.fillRect(250 - x, 43, 48, 45, 0xfff2a553);
			result.resize(800, 480, BilinearInterpolation);
			result.underlying;
			return Vision.convolve(result, kernel);
		}

		function gpu(x:Int):Image {
			return image.accelerate()
				.fillRect({x: x, y: 68, width: 65, height: 55}, 0xff4de1c5)
				.fillRect({x: 250 - x, y: 43, width: 48, height: 45}, 0xfff2a553)
				.resize(800, 480, BilinearInterpolation)
				.convolve(kernel)
				.commit();
		}

		if (!screen.attach(image)) throw "D3D11 Screen attachment failed";
		final expected = cpu(80).exportToBytes();
		final reads = D3D11Device.readbackCount();
		final actual = gpu(80);
		if (!actual.isGpuBacked) throw "The batch fell back to CPU pixels";
		screen.draw(actual);
		final capture = screen.capture();
		if (!capture.isGpuBacked) throw "Screen capture fell back to CPU pixels";
		if (D3D11Device.readbackCount() != reads) throw "Screen drawing read back pixels";
		final displayed = capture.exportToBytes();
		final bytes = actual.exportToBytes();
		if (D3D11Device.readbackCount() != reads + 2) throw "Expected one readback per export, got " + (D3D11Device.readbackCount() - reads);
		var maxDifference = 0;
		for (i in 0...expected.length) {
			maxDifference = Std.int(Math.max(maxDifference, Math.abs(expected[i] - bytes[i])));
			if (displayed[i] != bytes[i]) throw 'Screen pixels differ at byte $i';
		}
		if (maxDifference > 1) throw 'CPU/GPU channel difference $maxDifference';

		if (demo) {
			final started = Timer.stamp();
			while (screen.processEvents()) {
				final x = Std.int(20 + (Math.sin((Timer.stamp() - started) * 2) + 1) * 105);
				screen.draw(gpu(x));
				Sys.sleep(0.008);
			}
		} else {
			function measure(run:Int->Image, present:Bool, readback:Bool):Float {
				final times = [];
				for (i in 0...11) {
					if (!D3D11Device.synchronize()) throw "D3D11 synchronization failed";
					final start = Timer.stamp();
					final frame = run(40 + i * 10);
					if (present) screen.draw(frame);
					if (readback) frame.exportToBytes();
					if (!D3D11Device.synchronize()) throw "D3D11 synchronization failed";
					if (i > 0) times.push((Timer.stamp() - start) * 1000);
				}
				times.sort((a, b) -> a < b ? -1 : a > b ? 1 : 0);
				return (times[4] + times[5]) / 2;
			}
			Sys.println(haxe.Json.stringify({
				cpuProcess: measure(cpu, false, false),
				gpuProcess: measure(gpu, false, false),
				gpuPresent: measure(gpu, true, false),
				gpuReadback: measure(gpu, false, true),
				maxChannelDifference: maxDifference
			}));
		}
		screen.dispose();
	}
}
#end
