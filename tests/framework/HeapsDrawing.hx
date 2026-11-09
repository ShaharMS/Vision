import hxd.App;
import vision.backend.framework.HeapsBitmap;
import vision.ds.Image;

class HeapsDrawing extends App {
	override function init() {
		final image = new Image(2, 2, 0xFFFF0000);
		final bitmap = new HeapsBitmap(image, s2d);
		final texture = bitmap.tile.getTexture();
		check(texture.capturePixels().getPixel(0, 0) == 0xFFFF0000, "initial texture");
		image.setPixel(0, 0, 0xFF00FF00);
		bitmap.update(image);
		check(bitmap.tile.getTexture() == texture, "texture reuse");
		check(texture.capturePixels().getPixel(0, 0) == 0xFF00FF00, "updated texture");
		bitmap.dispose();
		Sys.println("Heaps texture assertions passed");
		Sys.exit(0);
	}

	static function check(condition:Bool, name:String) {
		if (!condition) {
			Sys.stderr().writeString('Failed: $name\n');
			Sys.exit(1);
		}
	}

	static function main() new HeapsDrawing();
}
