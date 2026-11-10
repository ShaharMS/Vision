package;

import vision.ds.Image;
import vision.ds.NativeImageRenderer;

/** Moves an image across a standalone Windows window. **/
class NativeImageExample {
	static function main() {
		final window = new NativeImageRenderer(320, 180);
		final badge = new Image(48, 48, 0xFF54AB92);
		badge.fillCircle(24, 24, 12, 0xFFFFAA44);

		var x = 0;
		while (window.poll()) {
			window.clear(0xFF24344D);
			window.draw(badge, x, 66);
			if (!window.present()) break;
			x = (x + 2) % (window.width - badge.width + 1);
			Sys.sleep(1 / 60);
		}
		window.dispose();
	}
}
