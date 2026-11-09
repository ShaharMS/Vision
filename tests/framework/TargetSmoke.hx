import vision.Vision;
import vision.ds.Image;

class TargetSmoke {
	static function main() {
		final image = new Image(3, 2, 0xFFFF0000);
		image.setPixel(2, 1, 0xFF00FF00);
		final clone = Vision.invert(image.clone());
		final correct = image.width == 3 && clone.height == 2 && clone.getPixel(2, 1) == 0xFFFF00FF;
		#if flash
		final shape:flash.display.Shape = clone;
		flash.Lib.current.addChild(shape);
		final rendered = new flash.display.BitmapData(3, 2, true, 0);
		rendered.draw(shape);
		final success = correct && (rendered.getPixel32(2, 1) : Int) == 0xFFFF00FF;
		final indicator = new flash.display.Shape();
		indicator.graphics.beginFill(success ? 0x00FF00 : 0xFF0000);
		indicator.graphics.drawRect(0, 0, 64, 64);
		flash.Lib.current.addChild(indicator);
		#else
		if (!correct) throw "Image smoke failed";
		Sys.println("Image smoke passed");
		#end
	}
}
