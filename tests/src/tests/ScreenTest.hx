package tests;

import haxe.Timer;
import tests.support.ImageAssertions;
import tests.support.ExceptionAssertions;
import vision.exceptions.ScreenError;
import utest.Assert;
import utest.Async;
#if vision_browser_tests
import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.GL;
import js.lib.Uint8Array;
import js.lib.Promise;
import js.Syntax;
import vision.Vision;
import vision.native.browser.CanvasRenderer;
import vision.ds.Image;
import vision.ds.Screen;
#else
import vision.ds.Image;
import vision.ds.Screen;
#end

@:visionMaturity("semantic")
@:visionLifecycle("active")
class ScreenTest extends utest.Test {
	@:visionTestId("vision.ds.Screen.setBounds#offscreen")
	function test_setBounds__preservesOffscreenDrawing():Void {
		final screen = new Screen(3, 4, 6, 5, {offscreen: true});
		Assert.isFalse(screen.hasDisplay);
		screen.clear(0xff112233);
		screen.draw(new Image(1, 1, 0xffabcdef), 3, 2);
		screen.x = 8;
		screen.y = 9;
		screen.width = 9;
		screen.height = 7;
		Assert.equals(8, screen.x);
		Assert.equals(9, screen.y);
		Assert.equals(9, screen.width);
		Assert.equals(7, screen.height);
		ExceptionAssertions.throwsType(() -> screen.setBounds(0, 0, 0, 7), ScreenError);
		Assert.equals(8, screen.x);
		Assert.equals(9, screen.width);
		final image = screen.capture();
		Assert.equals(0xffabcdef, image.getPixel(3, 2));
		Assert.equals(0xff112233, image.getPixel(0, 0));
		Assert.equals(0xff000000, image.getPixel(8, 6));
		image.setPixel(3, 2, 0xff000000);
		Assert.equals(0xffabcdef, screen.capture().getPixel(3, 2));
		screen.dispose();
		Assert.equals(false, screen.poll().result);
	}

	@:visionTestId("vision.ds.Screen.poll#offscreen")
	function test_poll__offscreenCompletesOnEveryTarget(async:Async):Void {
		final screen = new Screen(0, 0, 4, 4, {offscreen: true, frameRate: 50});
		screen.poll().then(ready -> {
			Assert.isTrue(ready);
			Assert.equals(0.0, screen.deltaTime);
			screen.poll().then(next -> {
				Assert.isTrue(next);
				Assert.isTrue(screen.deltaTime >= 0.018, "Offscreen polling completed before the frame interval");
				screen.dispose();
				async.done();
			});
		});
	}

	#if vision_browser_tests
	@:visionTestId("vision.ds.Screen.draw#canvas2d")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_draw__canvas2d()
		drawing(false);

	@:visionTestId("vision.ds.Screen.draw#webgl")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_draw__webgl()
		drawing(true);

	@:visionTestId("vision.ds.Screen.onFirstDraw#canvas2d")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_onFirstDraw__canvas2d(async:Async)
		finishAsync(screen(false), async);

	@:visionTestId("vision.ds.Screen.onFirstDraw#webgl")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_onFirstDraw__webgl(async:Async)
		finishAsync(screen(true), async);

	@:visionTestId("vision.ds.Screen.poll#browserFrameWait")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_poll__browserFrameWait(async:Async)
		finishAsync(frameWait(), async);

	function finishAsync(result:Promise<Bool>, async:Async):Void {
		result.then(_ -> async.done(), error -> {
			Assert.fail(Std.string(error));
			async.done();
		});
	}

	@:visionTestId("vision.ds.Screen.draw#canvasRoundTrip")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_draw__canvasRoundTrip():Void {
		final image = new Image(2, 3, 0xFFFF0000);
		image.setPixel(1, 2, 0xFF123456);
		final canvas = image.toJsCanvas();
		final converted = Image.fromJsCanvas(canvas);
		Assert.isFalse(converted.width != image.width
			|| converted.height != image.height
			|| converted.exportToBytes().compare(image.exportToBytes()) != 0,
			"Canvas conversion changed the image");
	}

	function screen(preferGpu:Bool):Promise<Bool> {
		return new Promise((resolve, reject) -> {
			final screen = new Screen(3, 4, 5, 6, {preferGpu: preferGpu});
			final canvas:CanvasElement = cast Browser.document.body.lastElementChild;
			final image = new Image(1, 1);
			var frames = 0;
			var firstDraws = 0;
			Assert.isFalse(canvas.style.left != "3px" || canvas.style.top != "4px" || canvas.width != 5 || canvas.height != 6,
				"Screen did not use the requested geometry");
			final webGl = preferGpu && canvas.getContextWebGL2() != null;
			screen.onFirstDraw = () -> {
				firstDraws++;
				image.setPixel(0, 0, 0xFF123456);
			};
			screen.clear();
			screen.draw(new Image(0, 0));
			Assert.equals(0, firstDraws);
			screen.draw(image, 1, 2);
			Assert.equals(1, firstDraws);
			function nextFrame(_:Float):Void {
				try {
					Assert.isTrue(screen.processEvents());
					frames++;
					if (frames == 1) {
						expectPixel(canvas, webGl, 1, 2, [18, 52, 86, 255]);
						screen.drawInverted(new Image(1, 1, 0xFF0055BB), 3, 4);
						Browser.window.requestAnimationFrame(nextFrame);
						return;
					}
					expectPixel(canvas, webGl, 1, 2, [18, 52, 86, 255]);
					expectPixel(canvas, webGl, 3, 4, [255, 170, 68, 255]);
					Assert.equals(1, firstDraws);
					screen.dispose();
					Assert.isFalse(screen.processEvents(), "Disposed Screen still reports open");
					Assert.isFalse(canvas.parentElement != null, "Disposing Screen left its canvas on the page");
					resolve(true);
				} catch (error:Dynamic) {
					screen.dispose();
					reject(error);
				}
			}
			Browser.window.requestAnimationFrame(nextFrame);
		});
	}

	function frameWait():Promise<Bool> {
		final screen = new Screen(3, 4, 5, 6, {preferGpu: false, frameRate: 20});
		final canvas:CanvasElement = cast Browser.document.body.lastElementChild;
		screen.draw(new Image(1, 1, 0xFF123456), 1, 2);
		expectPixel(canvas, false, 1, 2, [18, 52, 86, 255]);
		return new Promise((resolve, _) -> {
			final first = screen.poll();
			Assert.equals(first, screen.poll());
			first.then(ready -> {
				Assert.isFalse(!ready || screen.deltaTime != 0, "First poll should report zero delta");
				final started = Timer.stamp();
				screen.frameRate = 25;
				screen.poll().then(next -> {
					final elapsed = Timer.stamp() - started;
					Assert.isFalse(!next || screen.deltaTime < 0.038 || Math.abs(screen.deltaTime - elapsed) > 0.010,
						"Frame rate or elapsed seconds did not match the browser clock");
					expectPixel(canvas, false, 1, 2, [18, 52, 86, 255]);
					final pending = screen.poll();
					screen.dispose();
					pending.then(closed -> {
						Assert.isFalse(closed, "Disposed screen reported ready");
						resolve(true);
					});
				});
			});
		});
	}

	@:visionTestId("vision.ds.Screen.setBounds#browser")
	function test_setBounds__preservesBrowserDrawing():Void {
		for (preferGpu in [false, true]) {
			final screen = new Screen(0, 0, 6, 5, {preferGpu: preferGpu});
			final canvas:CanvasElement = cast Browser.document.body.lastElementChild;
			screen.draw(new Image(1, 1, 0xffabcdef), 3, 2);
			screen.setBounds(12, 17, 8, 7);
			Assert.equals("12px", canvas.style.left);
			Assert.equals("17px", canvas.style.top);
			Assert.equals(8, canvas.width);
			Assert.equals(7, canvas.height);
			Assert.equals(0xffabcdef, screen.capture().getPixel(3, 2));
			Assert.equals(0xff000000, screen.capture().getPixel(7, 6));
			screen.dispose();
		}
	}

	@:visionTestId("vision.ds.Screen.attach#preservesDevicePixels")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_attach__preservesDevicePixels():Void {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = 3;
		canvas.height = 2;
		final renderer = new CanvasRenderer(canvas);
		final image = new Image(3, 2, 0x80204060);
		image.setPixel(1, 1, 0xFF01EF50);
		final expected = image.clone();
		Vision.invert(expected);
		Vision.grayscale(expected, true);
		Assert.isFalse(!renderer.attach(image) || !image.isGpuBacked, "The image could not attach to WebGL");

		final gl = canvas.getContextWebGL2();
		final draws:Dynamic = gl.drawArrays;
		var passes = 0;
		Syntax.code("{0}.drawArrays = (mode, first, count) => {1}(mode, first, count)", gl, function(mode:Int, first:Int, count:Int) {
			passes++;
			Syntax.code("{0}.call({1}, {2}, {3}, {4})", draws, gl, mode, first, count);
		});
		Vision.invert(image);
		Vision.grayscale(image, true);
		Assert.equals(2, passes);
		renderer.draw(image);
		final color = expected.getPixel(1, 1);
		expectPixel(canvas, true, 1, 1, [color.red, color.green, color.blue, color.alpha]);
		Assert.isFalse(image.exportToBytes().compare(expected.exportToBytes()) != 0, "WebGL storage did not materialize the same pixels");

		image.setPixel(2, 1, 0xFF103254);
		image.setView({
			x: 2,
			y: 1,
			width: 1,
			height: 1
		});
		Vision.invert(image);
		Assert.isFalse(passes != 3 || image.getPixel(2, 1) != 0xFFEFCDAB || image.getPixel(1, 1) != color, "The CPU view fallback changed the wrong pixels");
		image.removeView();
		Vision.invert(image);
		final alias = image;
		final bytes = alias.underlying;
		Assert.isFalse(image.isGpuBacked || renderer.attach(alias), "Exposing mutable pixels must release the GPU backing");
		bytes[bytes.length - 3] = 0xCD;
		ImageAssertions.pixelEquals(image, 2, 1, 0xFFCD3254);
		final retained = new Image(1, 1, 0xFF102030);
		Assert.isTrue(renderer.attach(retained));
		Vision.invert(retained);
		Vision.blackAndWhite(retained, 239);
		renderer.dispose();
		Assert.isFalse(retained.isGpuBacked || retained.getPixel(0, 0) != 0xFF000000, "Disposing the renderer did not preserve a pending image");
	}

	@:visionTestId("vision.ds.Screen.attach#resizeAndBlur")
	function test_attach__resizeAndBlur():Void {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = canvas.height = 12;
		final renderer = new CanvasRenderer(canvas);
		var image = new Image(5, 4, 0x90416181);
		image.setPixel(2, 1, 0xff5a9020);
		image.setPixel(4, 3, 0x20604021);
		final source = image;
		var cpu = image.clone();
		cpu.resize(11, 7, BilinearInterpolation);
		final expected = Vision.gaussianBlur(cpu);
		Assert.isTrue(renderer.attach(image));
		image.resize(11, 7, BilinearInterpolation);
		Assert.isTrue(image.isGpuBacked);
		final blurred = Vision.gaussianBlur(image);
		Assert.isTrue(blurred.isGpuBacked);
		renderer.draw(blurred);
		renderer.dispose();
		Assert.isFalse(blurred.isGpuBacked);
		Assert.equals(5, source.width);
		for (y in 0...expected.height)
			for (x in 0...expected.width) {
				final a = expected.getPixel(x, y);
				final b = blurred.getPixel(x, y);
				Assert.isTrue(Math.abs(a.red - b.red) <= 1 && Math.abs(a.green - b.green) <= 1
					&& Math.abs(a.blue - b.blue) <= 1 && Math.abs(a.alpha - b.alpha) <= 1);
			}
	}

	function drawing(webGl:Bool) {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = 3;
		canvas.height = 3;
		Browser.document.body.appendChild(canvas);
		if (!webGl) canvas.getContext2d();
		final renderer = new CanvasRenderer(canvas);
		Assert.equals(webGl, renderer.usesWebGl);

		final background = new Image(3, 3, 0xFFFF0000);
		Assert.isFalse(!webGl && renderer.attach(background), "Canvas 2D must leave the image on the CPU");
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
		inverted(renderer, webGl, sprite);
		renderer.dispose();
	}

	function inverted(renderer:CanvasRenderer, webGl:Bool, sprite:Image):Void {
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
		Assert.isFalse(sprite.getPixel(0, 0) != original, "The source changed during drawing");

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

	function expectPixel(canvas:CanvasElement, webGl:Bool, x:Int, y:Int, expected:Array<Int>) {
		final pixel = if (webGl) {
			final rgba = new Uint8Array(4);
			canvas.getContextWebGL2().readPixels(x, canvas.height - 1 - y, 1, 1, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
			[for (index in 0...4) rgba[index]];
		} else {
			final rgba = canvas.getContext2d().getImageData(x, y, 1, 1).data;
			[for (index in 0...4) rgba[index]];
		};
		for (index in 0...4) {
			Assert.floatEquals(expected[index], pixel[index], 1);
		}
	}
	#elseif (windows && (cpp || (hl && vision_hashlink_screen)))
	@:visionTestId("vision.ds.Screen.draw#desktopPixels")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_draw__desktopPixels():Void {
		final screen = new Screen(0, 0, 16, 16, {visible: false});
		screen.clear(0xFF102030);
		screen.draw(new Image(2, 2, 0xFF00CC88), 4, 6);
		Assert.equals(0xFF102030, screen.capture().getPixel(0, 0));
		Assert.equals(0xFF00CC88, screen.capture().getPixel(4, 6));
		Assert.isTrue(screen.hasDisplay);
		screen.setBounds(10, 20, 22, 18);
		Assert.equals(10, screen.x);
		Assert.equals(20, screen.y);
		Assert.equals(22, screen.capture().width);
		Assert.equals(18, screen.capture().height);
		Assert.equals(0xFF00CC88, screen.capture().getPixel(4, 6));
		screen.dispose();
	}

	@:visionTestId("vision.ds.Screen.onFirstDraw#desktop")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_onFirstDraw__desktop() {
		final screen = new Screen(12, 18, 64, 48, {visible: false});
		final image = new Image(9, 7, 0xFF223344);
		Assert.isFalse(screen.x != 12 || screen.y != 18 || screen.width != 64 || screen.height != 48, "Screen geometry changed");
		var firstDraws = 0;
		screen.onFirstDraw = () -> firstDraws++;
		screen.clear();
		screen.draw(new Image(0, 0));
		Assert.equals(0, firstDraws);

		var frames = 0;
		while (frames < 2 && screen.processEvents() && screen.poll().result == true) {
			image.setPixel(1, 1, 0xFF00CC88);
			if (frames == 0) screen.drawInverted(image, 4, 6);
			else screen.draw(image, 4, 6);
			frames++;
		}
		screen.dispose();
		Assert.isFalse(frames != 2 || firstDraws != 1 || screen.poll().result == true, "Screen lifecycle did not match the caller's loop");
	}

	@:visionTestId("vision.ds.Screen.poll#desktopFrameWait")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_poll__desktopFrameWait():Void {
		final screen = new Screen(12, 18, 64, 48, {visible: false, frameRate: 20});
		screen.draw(new Image(8, 8, 0xFF102030));
		Assert.isTrue(screen.poll().result == true);
		Assert.equals(0.0, screen.deltaTime);
		final started = Timer.stamp();
		Sys.sleep(0.020);
		Assert.isTrue(screen.poll().result == true);
		final elapsed = Timer.stamp() - started;
		Assert.isFalse(screen.deltaTime < 0.045
			|| Math.abs(screen.deltaTime - elapsed) > 0.015, "Frame rate or elapsed seconds did not match the frame clock");
		screen.dispose();
		Assert.isFalse(screen.poll().result == true || screen.processEvents(), "Disposed screen reported ready");
	}
	#end
}
