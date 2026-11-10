package;

import vision.ds.Image;
import vision.ds.Screen;

using vision.Vision;

/** Runs the same drawing loop on a browser page or in a desktop window. **/
class ScreenExample {
	static function main() {
		final screen = new Screen(24, 32, 320, 180);
		final background = new Image(screen.width, screen.height, 0xFF24344D);
		final badge = new Image(48, 48, 0xFF54AB92);
		badge.fillCircle(24, 24, 12, 0xFFFFAA44);
		screen.attach(badge);

		var x = 0;
		screen.start(() -> {
			screen.draw(background);
			screen.draw(badge, x, 66);
			x += 2;
			if (x > screen.width - badge.width) {
				x = 0;
				badge.invert();
			}
		});
	}
}
