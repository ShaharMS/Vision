import vision.ds.Image;
import vision.ds.Screen;

class ScreenDrawingTest {
	static function main() {
		final screen = new Screen(12, 18, 64, 48, {visible: false});
		final image = new Image(9, 7, 0xFF223344);
		if (screen.x != 12 || screen.y != 18 || screen.width != 64 || screen.height != 48) throw "Screen geometry changed";
		screen.draw(image, 2, 3);
		var frames = 0;
		screen.start(() -> {
			screen.clear(0xFF203040);
			image.setPixel(1, 1, 0xFF00CC88);
			screen.draw(image, 4, 6);
			if (++frames == 2) screen.stop();
		});
		screen.dispose();
		if (frames != 2) throw "Screen loop ended before stop";
		Sys.println("Screen opened, drew two frames, and stopped");
	}
}
