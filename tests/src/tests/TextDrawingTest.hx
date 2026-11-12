package tests;

#if vision_browser_tests
import utest.Assert;
import vision.ds.Color;
import vision.ds.Image;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class TextDrawingTest extends utest.Test {
	@:visionTestId("vision.ds.Image.drawText#mixedDirection")
	function test_drawText__mixedDirection() {
		final ltr = new Image(240, 54);
		final rtl = new Image(240, 54);
		final text = "abc العربية 123";
		ltr.drawText(10, 4, text, {size: 24, color: Color.WHITE});
		rtl.drawText(230, 4, text, {size: 24, color: Color.WHITE, rightToLeft: true});
		Assert.isTrue(ltr.toArray().filter(color -> color.alpha > 0).length > 100);
		Assert.isTrue(rtl.toArray().filter(color -> color.alpha > 0).length > 100);
		Assert.isFalse(ltr.exportToBytes().compare(rtl.exportToBytes()) == 0);
	}

	@:visionTestId("vision.ds.Image.drawText#clipping")
	function test_drawText__clipping() {
		final image = new Image(48, 50, Color.BLUE);
		final ink = Color.fromRGBA(255, 0, 0, 128);
		image.drawText(-4, -2, "MMMM\nMMMM", {size: 22, color: ink, lineHeight: 24});
		var upper = 0;
		var lower = 0;
		for (y in 0...image.height)
			for (x in 0...image.width) {
				final color = image.getPixel(x, y);
				Assert.equals(255, color.alpha);
				Assert.isTrue(color.red <= 128);
				if (color.red == 0) continue;
				if (y < 22) upper++; else lower++;
			}
		Assert.isTrue(upper > 10);
		Assert.isTrue(lower > 10);
	}
}
#end
