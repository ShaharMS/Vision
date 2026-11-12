package tests;

import haxe.crypto.Base64;
import haxe.io.Bytes;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.TextFont;
import vision.exceptions.FontLoadingError;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class PortableTextTest extends utest.Test {
	// A minimal TrueType fixture with one triangular glyph mapped to A.
	static final fixture =
		"AAEAAAAHAAAAAAAAaGVhZAAAAAAAAAB8AAAANmhoZWEAAAAAAAAAsgAAACRtYXhwAAAAAAAAANYAAAAGaG10eAAAAAAAAADc" +
		"AAAACGxvY2EAAAAAAAAA5AAAAAZnbHlmAAAAAAAAAOoAAAAeY21hcAAAAAAAAAEIAAAALAAAAAAAAAAAAAAAAAAAAAAAAAPo" +
		"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAB" +
		"AAAAAgPoAAAD6AAAAAAAAAAPAAEAZABkA4QDhAACAAABAQEAZAGQAZAAZAMg/OAAAAAAAQADAAEAAAAMAAQAIAAAAAQABAAB" +
		"AAAAQf//AAAAQf///8AAAQAAAAA=";

	static final wrapped =
		"d09GRgABAAAAAAFAAAcAAAAAATQAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAABoZWFkAAAAuAAAABEAAAA2AAAAAGhoZWEAAADM" +
		"AAAAEQAAACQAAAAAbWF4cAAAAOAAAAAGAAAABgAAAABobXR4AAAA6AAAAAgAAAAIAAAAAGxvY2EAAADwAAAABgAAAAYAAAAA" +
		"Z2x5ZgAAAPgAAAAeAAAAHgAAAABjbWFwAAABGAAAACYAAAAsAAAAAHicY2BAB8wvMIQwAAAgWgDsAAAAeJxjYGBgYG5hwAeY" +
		"ABCCAIoAAAAAAQAAAAIAAAPoAAAD6AAAAAAAAAAPAAAAAQBkAGQDhAOEAAIAAAEBAQBkAZABkABkAyD84AAAAHicY2BgYGRg" +
		"BmIGBh4GFgYFIM0ChCC+4///EPL/ATCfAQBNkwZ9AAA=";

	@:visionTestId("vision.ds.Image.drawText#portableOutline")
	function test_drawText__portableOutline() {
		final font = TextFont.fromBytes(Base64.decode(fixture));
		final image = new Image(40, 40);
		image.drawText(0, 0, "A", {font: font, size: 40, color: Color.WHITE});
		Assert.equals(255, image.getPixel(20, 20).alpha);
		Assert.equals(0, image.getPixel(0, 0).alpha);
		Assert.equals(0, image.getPixel(39, 39).alpha);
		Assert.isTrue(image.toArray().filter(pixel -> pixel.alpha > 0).length > 400);
	}

	@:visionTestId("vision.ds.TextFont.fromBytes#woff")
	function test_fromBytes__readsCompressedWoff() {
		final original = new Image(40, 40);
		final compressed = new Image(40, 40);
		original.drawText(0, 0, "A", {font: TextFont.fromBytes(Base64.decode(fixture)), size: 40});
		compressed.drawText(0, 0, "A", {font: TextFont.fromBytes(Base64.decode(wrapped)), size: 40});
		Assert.equals(0, original.exportToBytes().compare(compressed.exportToBytes()));
	}

	@:visionTestId("vision.ds.TextFont.fromBytes#invalidFont")
	function test_fromBytes__rejectsTruncatedFont() {
		ExceptionAssertions.throwsType(() -> TextFont.fromBytes(Bytes.ofString("font")), FontLoadingError);
	}
}
