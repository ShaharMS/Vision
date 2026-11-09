import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.GL;
import js.lib.Uint8Array;
import vision.Vision;
import vision.backend.browser.CanvasRenderer;
import vision.backend.browser.WebGpuInverter;
import vision.ds.Image;

class BrowserDrawing {
	static function main() {
		try {
			testDrawing(false);
			testDrawing(true);
			WebGpuInverter.create().then(inverter -> {
				if (inverter == null) {
					Browser.document.body.setAttribute("data-webgpu", "unavailable");
					pass();
					return;
				}
				final image = new Image(17, 7, 0x8030A070);
				image.setPixel(16, 6, 0xFF12ABCD);
				final expected = Vision.invert(image.clone());
				inverter.invert(image).then(result -> {
					inverter.dispose();
					if (result.exportToBytes().compare(expected.exportToBytes()) != 0 || image.getPixel(16, 6) != 0xFF12ABCD)
						throw "WebGPU compute did not match CPU inversion";
					Browser.document.body.setAttribute("data-webgpu", "pass");
					pass();
				}).catchError(fail);
			}).catchError(fail);
		} catch (error:Dynamic) {
			fail(error);
		}
	}

	static function pass():Void {
		Browser.document.body.setAttribute("data-result", "pass");
	}

	static function fail(error:Dynamic):Void {
		Browser.document.body.setAttribute("data-result", "fail");
		Browser.document.body.appendChild(Browser.document.createTextNode(Std.string(error)));
	}

	static function testDrawing(webGl:Bool) {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = 3;
		canvas.height = 3;
		Browser.document.body.appendChild(canvas);
		if (!webGl)
			canvas.getContext2d();
		final renderer = new CanvasRenderer(canvas);
		if (renderer.usesWebGl != webGl)
			throw "Unexpected browser drawing backend";

		final background = new Image(3, 3, 0xFFFF0000);
		final sprite = new Image(2, 2);
		sprite.setPixel(0, 0, 0xFF00FF00);
		sprite.setPixel(0, 1, 0x800000FF);
		renderer.draw(background);
		renderer.draw(sprite, 1, 1);
		expectPixel(canvas, webGl, 1, 1, [0, 255, 0, 255]);
		expectPixel(canvas, webGl, 2, 1, [255, 0, 0, 255]);
		expectPixel(canvas, webGl, 1, 2, [127, 0, 128, 255]);

		renderer.clear();
		sprite.setPixel(0, 0, 0xFFFF00FF);
		final bytes = sprite.underlying;
		bytes[bytes.length - 12] = 255;
		bytes[bytes.length - 10] = 255;
		renderer.draw(sprite, 1, 1);
		expectPixel(canvas, webGl, 1, 1, [255, 0, 255, 255]);
		expectPixel(canvas, webGl, 2, 1, [0, 255, 0, 255]);
		expectPixel(canvas, webGl, 0, 0, [0, 0, 0, 0]);
		testInverted(renderer, webGl, sprite);
		renderer.dispose();
	}

	static function testInverted(renderer:CanvasRenderer, webGl:Bool, sprite:Image):Void {
		final original = sprite.getPixel(0, 0);
		final expected = Vision.invert(sprite.clone());
		renderer.clear();
		renderer.drawInverted(sprite);
		for (y in 0...sprite.height) {
			for (x in 0...sprite.width) {
				final color = expected.getPixel(x, y);
				expectPixel(renderer.canvas, webGl, x, y, [color.red, color.green, color.blue, color.alpha]);
			}
		}
		if (sprite.getPixel(0, 0) != original)
			throw "The source changed during drawing";

		sprite.setView({x: 1, y: 0, width: 1, height: 1});
		renderer.clear();
		renderer.drawInverted(sprite);
		expectPixel(renderer.canvas, webGl, 0, 0, [255, 0, 255, 255]);
		expectPixel(renderer.canvas, webGl, 1, 0, [255, 0, 255, 255]);
	}

	static function expectPixel(canvas:CanvasElement, webGl:Bool, x:Int, y:Int, expected:Array<Int>) {
		final pixel = if (webGl) {
			final rgba = new Uint8Array(4);
			canvas.getContextWebGL2().readPixels(x, canvas.height - 1 - y, 1, 1, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
			[for (index in 0...4) rgba[index]];
		} else {
			final rgba = canvas.getContext2d().getImageData(x, y, 1, 1).data;
			[for (index in 0...4) rgba[index]];
		};
		for (index in 0...4) {
			if (Math.abs(pixel[index] - expected[index]) > 1)
				throw 'WebGL=$webGl at ($x, $y) expected $expected, got $pixel';
		}
	}
}
