import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.GL;
import js.lib.Uint8Array;
import js.lib.Promise;
import js.Syntax;
import vision.Vision;
import vision.formats.__internal.CanvasRenderer;
import vision.ds.WebGpuInverter;
import vision.ds.Image;
import vision.ds.Screen;

class BrowserDrawing {
	static function main() {
		try {
			testDrawing(false);
			testDrawing(true);
			testAttachedImage();
			testExistingCanvasApi();
			testScreen(false).then(_ -> testScreen(true)).then(_ -> WebGpuInverter.create()).then(inverter -> {
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
					if (result.exportToBytes().compare(expected.exportToBytes()) != 0
						|| image.getPixel(16, 6) != 0xFF12ABCD) throw "WebGPU compute did not match CPU inversion";
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

	static function testExistingCanvasApi():Void {
		final image = new Image(2, 3, 0xFFFF0000);
		image.setPixel(1, 2, 0xFF123456);
		final canvas = image.toJsCanvas();
		final converted = Image.fromJsCanvas(canvas);
		if (converted.width != image.width
			|| converted.height != image.height
			|| converted.exportToBytes().compare(image.exportToBytes()) != 0) throw "Canvas conversion changed the image";
	}

	static function testScreen(preferGpu:Bool):Promise<Bool> {
		return new Promise((resolve, reject) -> {
			final screen = new Screen(3, 4, 5, 6, {preferGpu: preferGpu});
			final canvas:CanvasElement = cast Browser.document.body.lastElementChild;
			final image = new Image(1, 1, 0xFF123456);
			var frames = 0;
			if (canvas.style.left != "3px" || canvas.style.top != "4px" || canvas.width != 5 || canvas.height != 6)
				throw "Screen did not use the requested geometry";
			final webGl = preferGpu && canvas.getContextWebGL2() != null;
			screen.draw(image, 1, 2);
			screen.start(() -> {
				try {
					frames++;
					if (frames == 1) {
						expectPixel(canvas, webGl, 1, 2, [18, 52, 86, 255]);
						screen.draw(new Image(1, 1, 0xFFFFAA44), 3, 4);
						return;
					}
					expectPixel(canvas, webGl, 1, 2, [18, 52, 86, 255]);
					expectPixel(canvas, webGl, 3, 4, [255, 170, 68, 255]);
					screen.stop();
					screen.dispose();
					if (canvas.parentElement != null) throw "Disposing Screen left its canvas on the page";
					resolve(true);
				} catch (error:Dynamic) {
					screen.dispose();
					reject(error);
				}
			});
		});
	}

	static function testAttachedImage():Void {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = 3;
		canvas.height = 2;
		final renderer = new CanvasRenderer(canvas);
		final image = new Image(3, 2, 0x80204060);
		image.setPixel(1, 1, 0xFF01EF50);
		final expected = image.clone();
		Vision.invert(expected);
		Vision.grayscale(expected, true);
		if (!renderer.attach(image) || !image.isGpuBacked) throw "The image could not attach to WebGL";

		final gl = canvas.getContextWebGL2();
		final draws:Dynamic = gl.drawArrays;
		var passes = 0;
		Syntax.code("{0}.drawArrays = (mode, first, count) => {1}(mode, first, count)", gl, function(mode:Int, first:Int, count:Int) {
			passes++;
			Syntax.code("{0}.call({1}, {2}, {3}, {4})", draws, gl, mode, first, count);
		});
		Vision.invert(image);
		Vision.grayscale(image, true);
		if (passes != 2) throw "The ordinary Vision calls did not submit both WebGL operations";
		renderer.draw(image);
		final color = expected.getPixel(1, 1);
		expectPixel(canvas, true, 1, 1, [color.red, color.green, color.blue, color.alpha]);
		if (image.exportToBytes().compare(expected.exportToBytes()) != 0) throw "WebGL storage did not materialize the same pixels";

		image.setPixel(2, 1, 0xFF103254);
		image.setView({
			x: 2,
			y: 1,
			width: 1,
			height: 1
		});
		Vision.invert(image);
		if (passes != 3 || image.getPixel(2, 1) != 0xFFEFCDAB || image.getPixel(1, 1) != color) throw "The CPU view fallback changed the wrong pixels";
		image.removeView();
		Vision.invert(image);
		final alias = image;
		final bytes = alias.underlying;
		if (image.isGpuBacked || renderer.attach(alias)) throw "Exposing mutable pixels must release the GPU backing";
		bytes[bytes.length - 3] = 0xCD;
		if (image.getPixel(2, 1) != 0xFFCD3254) throw "An existing byte alias did not update the image";
		final retained = new Image(1, 1, 0xFF102030);
		if (!renderer.attach(retained)) throw "The renderer could not attach another image";
		Vision.invert(retained);
		Vision.blackAndWhite(retained, 239);
		renderer.dispose();
		if (retained.isGpuBacked || retained.getPixel(0, 0) != 0xFF000000) throw "Disposing the renderer did not preserve a pending image";
	}

	static function testDrawing(webGl:Bool) {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = 3;
		canvas.height = 3;
		Browser.document.body.appendChild(canvas);
		if (!webGl) canvas.getContext2d();
		final renderer = new CanvasRenderer(canvas);
		if (renderer.usesWebGl != webGl) throw "Unexpected browser drawing backend";

		final background = new Image(3, 3, 0xFFFF0000);
		if (!webGl && renderer.attach(background)) throw "Canvas 2D must leave the image on the CPU";
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
		if (sprite.getPixel(0, 0) != original) throw "The source changed during drawing";

		sprite.setView({
			x: 1,
			y: 0,
			width: 1,
			height: 1
		});
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
			if (Math.abs(pixel[index] - expected[index]) > 1) throw 'WebGL=$webGl at ($x, $y) expected $expected, got $pixel';
		}
	}
}
