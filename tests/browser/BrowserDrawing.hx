import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.GL;
import js.lib.Uint8Array;
import vision.backend.browser.CanvasRenderer;
import vision.ds.Image;

class BrowserDrawing {
	static function main() {
		try {
			testDrawing(false);
			testDrawing(true);
			Browser.document.body.setAttribute("data-result", "pass");
		} catch (error:Dynamic) {
			Browser.document.body.setAttribute("data-result", "fail");
			Browser.document.body.appendChild(Browser.document.createTextNode(Std.string(error)));
		}
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
		renderer.dispose();
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
