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

	// WOFF2 version of the fixture, with transformed glyf, loca, and hmtx.
	static final woff2 =
		"d09GMgABAAAAAACUAAcAAAAAATwAAABTAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATYCJAQGQwgFCwYACh49ACwbzQD4H4lx" +
		"LMqSenNKPH3d3t5+LPBIY2iSwODECrL8B4aEDTggDrxRBubpBOCARQhJ3aD1g/sSrHZ3gwUGQXECBpC+70PqZQEQFRzGhTGC" +
		"+1ctAw==";

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

	@:visionTestId("vision.ds.TextFont.fromBytes#woff2")
	function test_fromBytes__readsTransformedWoff2() {
		final original = new Image(40, 40);
		final compressed = new Image(40, 40);
		original.drawText(0, 0, "A", {font: TextFont.fromBytes(Base64.decode(fixture)), size: 40});
		compressed.drawText(0, 0, "A", {font: TextFont.fromBytes(Base64.decode(woff2)), size: 40});
		Assert.equals(0, original.exportToBytes().compare(compressed.exportToBytes()));
	}

	@:visionTestId("vision.ds.TextFont.fromBytes#truncatedWoff2")
	function test_fromBytes__rejectsTruncatedWoff2() {
		final data = Base64.decode(woff2);
		// Keep the container length consistent so decoding reaches the damaged Brotli stream.
		final truncated = data.sub(0, data.length - 8);
		truncated.set(11, truncated.length);
		truncated.set(23, truncated.get(23) - 8);
		ExceptionAssertions.throwsType(() -> TextFont.fromBytes(truncated), FontLoadingError);
	}

	@:visionTestId("vision.ds.TextFont.fromBytes#invalidFont")
	function test_fromBytes__rejectsTruncatedFont() {
		ExceptionAssertions.throwsType(() -> TextFont.fromBytes(Bytes.ofString("font")), FontLoadingError);
	}
}
