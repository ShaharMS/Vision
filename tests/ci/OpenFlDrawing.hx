import openfl.display.Sprite;
import openfl.events.Event;
import vision.formats.to.OpenFlBitmap;
import vision.ds.Image;

class OpenFlDrawing extends Sprite {
	public function new() {
		super();
		final image = new Image(2, 2, 0xFFFF0000);
		final bitmap = new OpenFlBitmap(image);
		final storage = bitmap.bitmapData;
		addChild(bitmap);
		if (storage.getPixel32(0, 0) != 0xFFFF0000) Sys.exit(1);
		addEventListener(Event.ENTER_FRAME, function(_) {
			image.setPixel(0, 0, 0xFF00FF00);
			bitmap.update(image);
			if (bitmap.bitmapData != storage || storage.getPixel32(0, 0) != 0xFF00FF00) Sys.exit(2);
			bitmap.dispose();
			Sys.println("OpenFL bitmap assertions passed");
			Sys.exit(0);
		});
	}
}
