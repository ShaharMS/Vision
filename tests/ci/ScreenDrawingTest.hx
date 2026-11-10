import vision.ds.Image;
import vision.ds.Screen;

class ScreenDrawingTest {
	static function main() {
		final screen = new Screen(12, 18, 64, 48, {visible: false});
		final image = new Image(9, 7, 0xFF223344);
		if (screen.x != 12 || screen.y != 18 || screen.width != 64 || screen.height != 48) throw "Screen geometry changed";
		var firstDraws = 0;
		screen.onFirstDraw = () -> firstDraws++;
		screen.clear();
		screen.draw(new Image(0, 0));
		if (firstDraws != 0) throw "First draw hook ran before an image was drawn";

		var frames = 0;
		while (frames < 2 && screen.poll()) {
			screen.clear(0xFF203040);
			image.setPixel(1, 1, 0xFF00CC88);
			if (frames == 0) screen.drawInverted(image, 4, 6);
			else screen.draw(image, 4, 6);
			frames++;
		}
		screen.dispose();
		if (frames != 2 || firstDraws != 1 || screen.poll()) throw "Screen lifecycle did not match the caller's loop";
		Sys.println("Screen drew two caller-driven frames and fired the first draw hook once");
	}
}
