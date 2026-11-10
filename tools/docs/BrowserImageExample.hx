package;

import js.Browser;
import vision.ds.CanvasRenderer;
import vision.ds.Image;

using vision.Vision;

/** Draws a small scene and updates a Vision image when the canvas is clicked. **/
class BrowserImageExample {
	static function main() {
		final canvas = Browser.document.createCanvasElement();
		canvas.width = 240;
		canvas.height = 160;
		Browser.document.body.appendChild(canvas);

		final renderer = new CanvasRenderer(canvas);
		final background = new Image(canvas.width, canvas.height, 0xFF24344D);
		final badge = new Image(80, 80);
		badge.fillRect(0, 0, 80, 80, 0xFFE69B42);
		badge.fillCircle(40, 40, 20, 0xFF315A83);
		renderer.attach(badge);

		function drawFrame():Void {
			renderer.clear();
			renderer.draw(background);
			renderer.draw(badge, 80, 40);
		}

		drawFrame();
		canvas.onclick = _ -> {
			badge.invert();
			drawFrame();
		};
		Browser.window.addEventListener("pagehide", _ -> renderer.dispose());
	}
}
