package tests;

import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Font;
import vision.formats._internal.fonts.TextShaper;
import vision.formats._internal.fonts.FontTable;
import vision.formats._internal.fonts.otf.GposKerning;
import vision.exceptions.FontLoadingError;

@:visionMaturity("semantic")
@:visionLifecycle("active")
@:access(vision.ds.Font)
class PortableTextTest extends utest.Test {
	// A minimal TrueType fixture with one triangular glyph mapped to A.
	static final fixture =
		"AAEAAAAHAAAAAAAAaGVhZAAAAAAAAAB8AAAANmhoZWEAAAAAAAAAsgAAACRtYXhwAAAAAAAAANYAAAAGaG10eAAAAAAAAADc" +
		"AAAACGxvY2EAAAAAAAAA5AAAAAZnbHlmAAAAAAAAAOoAAAAeY21hcAAAAAAAAAEIAAAALAAAAAAAAAAAAAAAAAAAAAAAAAPo" +
		"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAB" +
		"AAAAAgPoAAAD6AAAAAAAAAAPAAEAZABkA4QDhAACAAABAQEAZAGQAZAAZAMg/OAAAAAAAQADAAEAAAAMAAQAIAAAAAQABAAB" +
		"AAAAQf//AAAAQf///8AAAQAAAAA=";

	// Synthetic TrueType faces with Arabic cmap entries and optional GSUB.
	static final arabicFont =
		"AAEAAAAIAAAAAAAAaGVhZAAAAAAAAACMAAAANmhoZWEAAAAAAAAAwgAAACRtYXhwAAAAAAAAAOYAAAAGaG10eAAAAAAAAADs" +
		"AAAACGxvY2EAAAAAAAAA9AAAABZnbHlmAAAAAAAAAQoAAAAeY21hcAAAAAAAAAEoAAAAZEdTVUIAAAAAAAABjAAAAMgAAAAA" +
		"AAAAAAAAAAAAAAAAAAAD6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4QAAAAAAAAAAAAAAAAAAAAA" +
		"AAAAAAAAAAAAAAAAAAIAAQAAAAoD6AAAA+gAAAAAAAAADwAPAA8ADwAPAA8ADwAPAA8AAQBkAGQDhAOEAAIAAAEBAQBkAZAB" +
		"kABkAyD84AAAAAABAAMACgAAAAwADAAAAAAAWAAAAAAAAAAGAAAGJwAABicAAAABAAAGKAAABigAAAACAAAGRAAABkQAAAAD" +
		"AAD+kAAA/pAAAAAIAAD+kQAA/pEAAAAIAAD++wAA/vsAAAAJAAEAAAAKACQAVgABYXJhYgAIAAQAAAAA//8ABAAAAAEAAgAD" +
		"AARmaW5hABppbml0ACBtZWRpACZybGlnACwAAAABAAAAAAABAAEAAAABAAIAAAABAAMABAAKAB4APABSAAEAAAABAAgAAQAG" +
		"AAIAAQABAAIABwAAAAEACAABAAEAAAAIAAIACAABAAUAAQABAAIAAQAAAAEACAACAAgAAQAGAAEAAQACAAQAAAABAAgAAQAS" +
		"AAEACAABAAQABwACAAEAAQABAAM=";
	static final arabicFallbackFont =
		"AAEAAAAHAAAAAAAAaGVhZAAAAAAAAAB8AAAANmhoZWEAAAAAAAAAsgAAACRtYXhwAAAAAAAAANYAAAAGaG10eAAAAAAAAADc" +
		"AAAACGxvY2EAAAAAAAAA5AAAABZnbHlmAAAAAAAAAPoAAAAeY21hcAAAAAAAAAEYAAAAZAAAAAAAAAAAAAAAAAAAAAAAAAPo" +
		"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAB" +
		"AAAACgPoAAAD6AAAAAAAAAAPAA8ADwAPAA8ADwAPAA8ADwABAGQAZAOEA4QAAgAAAQEBAGQBkAGQAGQDIPzgAAAAAAEAAwAK" +
		"AAAADAAMAAAAAABYAAAAAAAAAAYAAAYnAAAGJwAAAAEAAAYoAAAGKAAAAAIAAAZEAAAGRAAAAAMAAP6QAAD+kAAAAAgAAP6R" +
		"AAD+kQAAAAgAAP77AAD++wAAAAk=";

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

	#if sys
	@:visionTestId("vision.formats._internal.fonts.TextShaper.shape#arialHarfBuzz")
	function test_shape__arialHarfBuzz() {
		// Optional Windows Arial fixture. Expected IDs and positions are
		// HarfBuzz output with RTL, Arabic script and default ignorables removed.
		final path = Sys.getEnv("VISION_ARIAL_TEST_FONT");
		if (path == null || path == "") {
			Assert.pass();
			return;
		}
		final font = Font.fromBytes(sys.io.File.getBytes(path));
		final hebrew = TextShaper.shapeGlyphs("שָׁ", font.data, true, true);
		Assert.same([661, 711], [for (glyph in hebrew) glyph.id]);
		Assert.same([[0, 489, 0], [1422, 0, 0]], [
			for (glyph in TextShaper.positionGlyphs(hebrew, font.data)) [glyph.advance, glyph.x, glyph.y]
		]);
		final cases = [
			{text: "سَلَام", ids: [993, 756, 1020, 756, 947],
				positions: [[692, 0, 0], [0, 650, 140], [1230, 0, 0], [0, 50, -239], [1087, 0, 0]]},
			{text: "بِّ", ids: [758, 759, 911],
				positions: [[0, 58, -190], [0, 283, -60], [1461, 0, 0]]},
			{text: "بَْ", ids: [760, 756, 911],
				positions: [[0, 353, 160], [0, 288, -220], [1461, 0, 0]]},
			{text: "الله", ids: [3020], positions: [[1624, 0, 0]]}
		];
		for (sample in cases) {
			final glyphs = TextShaper.shapeGlyphs(sample.text, font.data, true, true);
			Assert.same(sample.ids, [for (glyph in glyphs) glyph.id]);
			if (sample.positions != null) {
				final positions = TextShaper.positionGlyphs(glyphs, font.data);
				Assert.same(sample.positions, [for (glyph in positions) [glyph.advance, glyph.x, glyph.y]]);
			}
		}
	}
	#end

	@:visionTestId("vision.formats._internal.fonts.TextShaper.shape#arabicGsub")
	function test_shape__arabicGsub() {
		final font = Font.fromBytes(Base64.decode(arabicFont));
		Assert.same([4, 6, 5], TextShaper.shape("ببب", font.data, true, false));
		Assert.same([7], TextShaper.shape("لا", font.data, true, false));
		Assert.same([2, 2], TextShaper.shape("ب\u200cب", font.data, true, false));
	}

	@:visionTestId("vision.formats._internal.fonts.TextShaper.shape#arabicPresentationFallback")
	function test_shape__arabicPresentationFallback() {
		final font = Font.fromBytes(Base64.decode(arabicFallbackFont));
		Assert.same([8, 8], TextShaper.shape("بب", font.data, true, false));
		Assert.same([9], TextShaper.shape("لا", font.data, true, false));
	}

	@:visionTestId("vision.ds.Image.drawText#portableOutline")
	function test_drawText__portableOutline() {
		final font = Font.fromBytes(Base64.decode(fixture));
		final image = new Image(40, 40);
		image.drawText(0, 0, "A", {font: font, size: 40, color: Color.WHITE});
		Assert.equals(255, image.getPixel(20, 20).alpha);
		Assert.equals(0, image.getPixel(0, 0).alpha);
		Assert.equals(0, image.getPixel(39, 39).alpha);
		Assert.isTrue(image.toArray().filter(pixel -> pixel.alpha > 0).length > 400);
	}

	@:visionTestId("vision.ds.Font.fromBytes#woff")
	function test_fromBytes__readsCompressedWoff() {
		final original = new Image(40, 40);
		final compressed = new Image(40, 40);
		original.drawText(0, 0, "A", {font: Font.fromBytes(Base64.decode(fixture)), size: 40});
		compressed.drawText(0, 0, "A", {font: Font.fromBytes(Base64.decode(wrapped)), size: 40});
		Assert.equals(0, original.exportToBytes().compare(compressed.exportToBytes()));
	}

	@:visionTestId("vision.ds.Font.fromBytes#woff2")
	function test_fromBytes__readsTransformedWoff2() {
		final original = new Image(40, 40);
		final compressed = new Image(40, 40);
		original.drawText(0, 0, "A", {font: Font.fromBytes(Base64.decode(fixture)), size: 40});
		compressed.drawText(0, 0, "A", {font: Font.fromBytes(Base64.decode(woff2)), size: 40});
		Assert.equals(0, original.exportToBytes().compare(compressed.exportToBytes()));
	}

	@:visionTestId("vision.ds.Font.fromBytes#truncatedWoff2")
	function test_fromBytes__rejectsTruncatedWoff2() {
		final data = Base64.decode(woff2);
		// Keep the container length consistent so decoding reaches the damaged Brotli stream.
		final truncated = data.sub(0, data.length - 8);
		truncated.set(11, truncated.length);
		truncated.set(23, truncated.get(23) - 8);
		ExceptionAssertions.throwsType(() -> Font.fromBytes(truncated), FontLoadingError);
	}

	@:visionTestId("vision.ds.Font.getCharacters#mappedCharacters")
	function test_getCharacters__listsMappedCharacters() {
		final font = Font.fromBytes(Base64.decode(fixture), "Fixture");
		Assert.equals("Fixture", font.family);
		Assert.equals(1000, font.unitsPerEm);
		Assert.equals(2, font.glyphCount);
		final characters = font.getCharacters();
		Assert.equals(1, characters.length);
		Assert.equals("A", characters[0]);
		characters.pop();
		Assert.equals("A", font.getCharacters()[0]);
		Assert.isNull(font.getGlyph("Z"));
		Assert.isNull(font.getGlyph("AA"));
		Assert.isNull(font.getGlyphById(-1));
	}

	@:visionTestId("vision.ds.Font.getCharacters#supplementary")
	function test_getCharacters__listsSupplementaryCodePoints() {
		final character = String.fromCharCode(0x1f600);
		final font = fontWithSingleCharacter(0x1f600);
		Assert.equals(character, font.getCharacters()[0]);
		Assert.equals(1, font.getGlyph(character).id);
	}

	@:visionTestId("vision.ds.Font.getGlyph#encodedLigatureRequiresExactCharacter")
	function test_getGlyph__encodedLigatureRequiresExactCharacter() {
		final character = String.fromCharCode(0xfb01);
		final font = fontWithSingleCharacter(0xfb01);
		Assert.isNull(font.getGlyph("fi"));
		final glyph = font.getGlyph(character);
		Assert.equals(1, glyph.id);
		Assert.same([character], glyph.getRepresentations());
	}

	function fontWithSingleCharacter(code:Int):Font {
		final data = Base64.decode(fixture);
		final cmap = new BytesOutput();
		cmap.bigEndian = true;
		cmap.writeUInt16(0);
		cmap.writeUInt16(1);
		cmap.writeUInt16(3);
		cmap.writeUInt16(10);
		cmap.writeInt32(12);
		cmap.writeUInt16(12);
		cmap.writeUInt16(0);
		cmap.writeInt32(28);
		cmap.writeInt32(0);
		cmap.writeInt32(1);
		cmap.writeInt32(code);
		cmap.writeInt32(code);
		cmap.writeInt32(1);
		final mapping = cmap.getBytes();
		data.blit(data.length - 44, mapping, 0, mapping.length);

		return Font.fromBytes(data);
	}

	@:visionTestId("vision.formats._internal.fonts.TextShaper.shape#hangulComposition")
	function test_shape__hangulComposition() {
		final font = fontWithSingleCharacter(0xd55c);
		Assert.same([1], TextShaper.shape("한", font.data, false, true));
		Assert.same([1], TextShaper.shape("한", font.data, false, true));
	}


	@:visionTestId("vision.ds.Glyph.toImage#singleOutline")
	function test_toImage__rendersGlyphOutline() {
		final font = Font.fromBytes(Base64.decode(fixture));
		final glyph = font.getGlyph("A");
		Assert.notNull(glyph);
		Assert.equals(glyph, font.getGlyphById(1));
		Assert.equals("A", glyph.text);
		Assert.equals(1000, glyph.advance);
		final bounds = glyph.getBounds(40);
		Assert.equals(4, bounds.x);
		Assert.equals(-36, bounds.y);
		Assert.equals(32, bounds.width);
		Assert.equals(32, bounds.height);
		Assert.isNull(font.getGlyphById(0).text);
		final image = glyph.toImage(40, Color.WHITE, 2);
		Assert.equals(36, image.width);
		Assert.equals(36, image.height);
		Assert.equals(0, image.getPixel(0, 0).alpha);
		Assert.equals(255, image.getPixel(18, 18).alpha);
	}

	@:visionTestId("vision.ds.Font.toImage#multiline")
	function test_toImage__fitsTextAndPadding() {
		final font = Font.fromBytes(Base64.decode(fixture));
		final image = font.toImage("AA\nA", {size: 40, lineHeight: 44}, 2);
		Assert.equals(84, image.width);
		Assert.equals(88, image.height);
		Assert.equals(0, image.getPixel(0, 0).alpha);
		Assert.equals(255, image.getPixel(22, 22).alpha);
		Assert.equals(255, image.getPixel(22, 66).alpha);
		Assert.equals(0, font.toImage("").width);
	}

	@:visionTestId("vision.ds.Font.fromBytes#invalidFont")
	function test_fromBytes__rejectsTruncatedFont() {
		ExceptionAssertions.throwsType(() -> Font.fromBytes(Bytes.ofString("font")), FontLoadingError);
	}
	@:visionTestId("vision.formats._internal.fonts.otf.GposKerning.adjustment#pairAdvance")
	function test_adjustment__readsGposPairAdvance() {
		final bytes = Base64.decode("AAEAAAAAAAoAGAABa2VybgAIAAAAAQAAAAEABAACAAAAAQAIAAEADAAEAAAAAQASAAEAAQABAAEAAv/u");
		final kerning = new GposKerning(new FontTable(bytes, 0, bytes.length));
		Assert.equals(-18, kerning.adjustment(1, 2));
		Assert.equals(0, kerning.adjustment(2, 1));
	}
}
