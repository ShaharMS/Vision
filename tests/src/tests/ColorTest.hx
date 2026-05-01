package tests;

import tests.support.ApproxAssertions;
import tests.support.ColorAssertions;
import utest.Assert;
import vision.ds.Color;

@:access(vision.ds.Color)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ColorTest extends utest.Test {
	function sample():Color {
		return cast 0x80336699;
	}

	function assertColor(expected:Color, actual:Color):Void {
		ColorAssertions.equalsColor(expected.toInt(), actual);
	}

	function assertStaticColors(entries:Array<{actual:Color, expected:Int}>):Void {
		for (entry in entries) {
			ColorAssertions.equalsColor(entry.expected, entry.actual);
		}
	}

	@:visionTestId("vision.ds.Color.TRANSPARENT_COLOR#palette")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_staticConstants__palette() {
		var entries = [
			{actual: Color.TRANSPARENT_COLOR, expected: 0x00000000},
			{actual: Color.WHITE, expected: 0xFFFFFFFF},
			{actual: Color.OFFWHITE, expected: 0xFFFFFFE4},
			{actual: Color.GRAY, expected: 0xFF808080},
			{actual: Color.BLACK, expected: 0xFF000000},
			{actual: Color.GREEN, expected: 0xFF00FF00},
			{actual: Color.YELLOW, expected: 0xFFFFFF00},
			{actual: Color.ORANGE, expected: 0xFFFFA500},
			{actual: Color.RED, expected: 0xFFFF0000},
			{actual: Color.PURPLE, expected: 0xFF800080},
			{actual: Color.BLUE, expected: 0xFF0000FF},
			{actual: Color.BROWN, expected: 0xFF8B4513},
			{actual: Color.SEPIA, expected: 0xFF704214},
			{actual: Color.PINK, expected: 0xFFFFC0CB},
			{actual: Color.MAGENTA, expected: 0xFFFF00FF},
			{actual: Color.CYAN, expected: 0xFF00FFFF},
			{actual: Color.SILVER, expected: 0x00C0C0C0},
			{actual: Color.GOLD, expected: 0xFFFFD700},
			{actual: Color.OLIVE, expected: 0xFF808000},
			{actual: Color.MAROON, expected: 0xFF800000},
			{actual: Color.BORDEAUX, expected: 0xFF722F37},
			{actual: Color.NAVY, expected: 0xFF000080},
			{actual: Color.TEAL, expected: 0xFF008080},
			{actual: Color.FUCHSIA, expected: 0xFFFF00FF},
			{actual: Color.AQUA, expected: 0xFF00FFFF},
			{actual: Color.LIME, expected: 0xFF32CD32},
			{actual: Color.CHARCOAL, expected: 0xFF36454F},
			{actual: Color.ONYX, expected: 0xFF353839},
			{actual: Color.JET, expected: 0xFF343434},
			{actual: Color.JET_BLACK, expected: 0xFF0E0E10},
			{actual: Color.ROYAL_BLUE, expected: 0xFF4169E1},
			{actual: Color.CHARTREUSE, expected: 0xFF7FFF00},
			{actual: Color.CERULEAN, expected: 0xFF007BA7},
			{actual: Color.PERIWINKLE, expected: 0xFFCCCCFF},
			{actual: Color.VERMILION, expected: 0xFFE34234},
			{actual: Color.MAUVE, expected: 0xFFE0B0FF},
			{actual: Color.AZURE, expected: 0xFF007FFF},
			{actual: Color.TANGERINE, expected: 0xFFF28500},
			{actual: Color.INDIGO, expected: 0xFF4B0082},
			{actual: Color.MARIGOLD, expected: 0xFFEAA221},
			{actual: Color.COBALT, expected: 0xFF0047AB},
			{actual: Color.LAVENDER, expected: 0xFFE6E6FA},
			{actual: Color.TURQUOISE, expected: 0xFF40E0D0},
			{actual: Color.OCHRE, expected: 0xFFCC7722},
			{actual: Color.AQUAMARINE, expected: 0xFF7FFFD4},
			{actual: Color.RUSSET, expected: 0xFF80461B},
			{actual: Color.TOPAZ, expected: 0xFFFFC87C},
			{actual: Color.APRICOT, expected: 0xFFFBCEB1},
			{actual: Color.AMETHYST, expected: 0xFF9966CC},
			{actual: Color.SAFFRON, expected: 0xFFF4C430},
			{actual: Color.LILAC, expected: 0xFFC8A2C8},
			{actual: Color.CRIMSON, expected: 0xFFDC143C},
			{actual: Color.SLATE, expected: 0xFF708090},
			{actual: Color.JADE, expected: 0xFF00A86B},
			{actual: Color.CORAL, expected: 0xFFFF7F50},
			{actual: Color.BURGUNDY, expected: 0xFF800020},
			{actual: Color.SIENNA, expected: 0xFF882D17},
			{actual: Color.IVORY, expected: 0xFFFFFFF0},
			{actual: Color.MULBERRY, expected: 0xFFC54B8C},
			{actual: Color.SANDALWOOD, expected: 0xFFAA8D6F},
			{actual: Color.GARNET, expected: 0xFF733635},
			{actual: Color.PEWTER, expected: 0xFF8BA8B7},
			{actual: Color.CARNATION, expected: 0xFFFFA6C9},
			{actual: Color.CITRINE, expected: 0xFFE4D00A},
			{actual: Color.CELADON, expected: 0xFFACE1AF},
			{actual: Color.HELIOTROPE, expected: 0xFFDF73FF},
			{actual: Color.PUCE, expected: 0xFFCC8899},
			{actual: Color.CINNABAR, expected: 0xFFE34234},
			{actual: Color.VIRIDIAN, expected: 0xFF40826D},
			{actual: Color.ECRU, expected: 0xFFC2B280},
			{actual: Color.ALABASTER, expected: 0xFFEDEAE0},
			{actual: Color.SAPPHIRE, expected: 0xFF0F52BA},
			{actual: Color.PEARL, expected: 0xFFEAE0C8},
			{actual: Color.SALMON, expected: 0xFFFA8072},
			{actual: Color.UMBER, expected: 0xFF635147},
			{actual: Color.TURMERIC, expected: 0xFFE4D00A},
			{actual: Color.MAHOGANY, expected: 0xFFC04000},
			{actual: Color.PERSIMMON, expected: 0xFFFF6347},
			{actual: Color.ROSEWOOD, expected: 0xFF65000B},
			{actual: Color.CARAMEL, expected: 0xFFFFD700},
			{actual: Color.DANDELION, expected: 0xFFF0E130},
			{actual: Color.FERN, expected: 0xFF71BC78},
			{actual: Color.LAPIS, expected: 0xFF26619C},
			{actual: Color.DENIM, expected: 0xFF1560BD},
			{actual: Color.SABLE, expected: 0xFF8E6D7B},
			{actual: Color.ORCHID, expected: 0xFFDA70D6},
			{actual: Color.TAWNY, expected: 0xFFCD5700},
			{actual: Color.PINE, expected: 0xFF01796F},
			{actual: Color.LEMON, expected: 0xFFFFF700},
			{actual: Color.SCARLET, expected: 0xFFFF2400},
			{actual: Color.TAUPE, expected: 0xFF483C32},
			{actual: Color.CERISE, expected: 0xFFDE3163},
			{actual: Color.AMBER, expected: 0xFFFFBF00},
			{actual: Color.CINNAMON, expected: 0xFFD2691E},
			{actual: Color.SADDLE_BROWN, expected: 0xFF8B4513},
			{actual: Color.TOMATO, expected: 0xFFFF6347},
			{actual: Color.CORNSILK, expected: 0xFFFFDAB9},
			{actual: Color.VIOLET, expected: 0xFF7F00FF}
		];
		#if (!vision_hlc_color_compile)
		entries.unshift({actual: Color.TRANSPARENT, expected: 0x00000000});
		#end
		assertStaticColors(entries);
	}

	@:visionTestId("vision.ds.Color.red#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_red__default() {
		Assert.equals(51, sample().red);
	}

	@:visionTestId("vision.ds.Color.blue#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_blue__default() {
		Assert.equals(153, sample().blue);
	}

	@:visionTestId("vision.ds.Color.green#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_green__default() {
		Assert.equals(102, sample().green);
	}

	@:visionTestId("vision.ds.Color.alpha#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_alpha__default() {
		Assert.equals(128, sample().alpha);
	}

	@:visionTestId("vision.ds.Color.redFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_redFloat__default() {
		ApproxAssertions.equalsFloat(0.2, sample().redFloat);
	}

	@:visionTestId("vision.ds.Color.blueFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_blueFloat__default() {
		ApproxAssertions.equalsFloat(0.6, sample().blueFloat);
	}

	@:visionTestId("vision.ds.Color.greenFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_greenFloat__default() {
		ApproxAssertions.equalsFloat(0.4, sample().greenFloat);
	}

	@:visionTestId("vision.ds.Color.alphaFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_alphaFloat__default() {
		ApproxAssertions.equalsFloat(128 / 255, sample().alphaFloat);
	}

	@:visionTestId("vision.ds.Color.cyan#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cyan__default() {
		ApproxAssertions.equalsFloat(2 / 3, sample().cyan);
	}

	@:visionTestId("vision.ds.Color.magenta#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_magenta__default() {
		ApproxAssertions.equalsFloat(1 / 3, sample().magenta);
	}

	@:visionTestId("vision.ds.Color.yellow#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_yellow__default() {
		ApproxAssertions.equalsFloat(0, sample().yellow);
	}

	@:visionTestId("vision.ds.Color.black#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_black__default() {
		ApproxAssertions.equalsFloat(0.4, sample().black);
	}

	@:visionTestId("vision.ds.Color.rgb#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_rgb__default() {
		assertColor(cast 0x00336699, sample().rgb);
	}

	@:visionTestId("vision.ds.Color.hue#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_hue__default() {
		ApproxAssertions.equalsFloat(210, sample().hue);
	}

	@:visionTestId("vision.ds.Color.saturation#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_saturation__default() {
		ApproxAssertions.equalsFloat(2 / 3, sample().saturation);
	}

	@:visionTestId("vision.ds.Color.brightness#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_brightness__default() {
		ApproxAssertions.equalsFloat(0.6, sample().brightness);
	}

	@:visionTestId("vision.ds.Color.lightness#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_lightness__default() {
		ApproxAssertions.equalsFloat(0.4, sample().lightness);
	}

	@:visionTestId("vision.ds.Color.fromInt#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromInt__default() {
		assertColor(sample(), Color.fromInt(sample().toInt()));
	}

	@:visionTestId("vision.ds.Color.fromRGBA#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromRGBA__default() {
		assertColor(sample(), Color.fromRGBA(51, 102, 153, 128));
	}

	@:visionTestId("vision.ds.Color.from8Bit#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_from8Bit__default() {
		assertColor(cast 0xFF333333, Color.from8Bit(51));
	}

	@:visionTestId("vision.ds.Color.fromFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromFloat__default() {
		assertColor(cast 0xFF808080, Color.fromFloat(0.5));
	}

	@:visionTestId("vision.ds.Color.fromRGBAFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromRGBAFloat__default() {
		assertColor(sample(), Color.fromRGBAFloat(0.2, 0.4, 0.6, 0.5));
	}

	@:visionTestId("vision.ds.Color.fromCMYK#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromCMYK__default() {
		assertColor(sample(), Color.fromCMYK(2 / 3, 1 / 3, 0, 0.4, 0.5));
	}

	@:visionTestId("vision.ds.Color.fromHSB#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromHSB__default() {
		assertColor(sample(), Color.fromHSB(210, 2 / 3, 0.6, 128 / 255));
	}

	@:visionTestId("vision.ds.Color.fromHSL#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromHSL__default() {
		assertColor(sample(), Color.fromHSL(210, 0.5, 0.4, 128 / 255));
	}

	@:visionTestId("vision.ds.Color.fromString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromString__default() {
		var result = Color.fromString("#336699");
		Assert.notNull(result);
		assertColor(cast 0xFF336699, cast result);
	}

	@:visionTestId("vision.ds.Color.getHSBColorWheel#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getHSBColorWheel__default() {
		var result = Color.getHSBColorWheel();
		Assert.equals(360, result.length);
		assertColor(Color.RED, result[0]);
	}

	@:visionTestId("vision.ds.Color.interpolate#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_interpolate__default() {
		assertColor(cast 0xFF7F7F7F, Color.interpolate(Color.BLACK, Color.WHITE, 0.5));
	}

	@:visionTestId("vision.ds.Color.gradient#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_gradient__default() {
		ColorAssertions.equalsColors([cast 0xFF000000, cast 0xFF7F7F7F, cast 0xFFFFFFFF], Color.gradient(Color.BLACK, Color.WHITE, 3));
	}

	@:visionTestId("vision.ds.Color.makeRandom#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_makeRandom__default() {
		var result = Color.makeRandom();
		Assert.equals(255, result.alpha);
		Assert.isTrue(result.red >= 0 && result.red <= 255);
		Assert.isTrue(result.green >= 0 && result.green <= 255);
		Assert.isTrue(result.blue >= 0 && result.blue <= 255);
	}

	@:visionTestId("vision.ds.Color.multiply#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_multiply__default() {
		assertColor(cast 0x400A295C, Color.multiply(sample(), sample()));
	}

	@:visionTestId("vision.ds.Color.add#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_add__default() {
		assertColor(cast 0xFF66CCFF, Color.add(sample(), sample()));
	}

	@:visionTestId("vision.ds.Color.subtract#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_subtract__default() {
		assertColor(cast 0x00000000, Color.subtract(sample(), sample()));
	}

	@:visionTestId("vision.ds.Color.divide#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_divide__default() {
		assertColor(sample(), Color.divide(sample(), sample()));
	}

	@:visionTestId("vision.ds.Color.distanceBetween#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceBetween__default() {
		ApproxAssertions.equalsFloat(190.824526725471, Color.distanceBetween(sample(), Color.BLACK, false));
	}

	@:visionTestId("vision.ds.Color.differenceBetween#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_differenceBetween__default() {
		ApproxAssertions.equalsFloat(0.43204937989385739, Color.differenceBetween(sample(), Color.BLACK, false));
	}

	@:visionTestId("vision.ds.Color.getAverage#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getAverage__default() {
		assertColor(cast 0xFF808080, Color.getAverage([Color.BLACK, Color.WHITE], false));
	}

	@:visionTestId("vision.ds.Color.getAverage#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getAverage__duplicates() {
		assertColor(cast 0xFF555555, Color.getAverage([Color.BLACK, Color.BLACK, Color.WHITE], false));
	}

	@:visionTestId("vision.ds.Color.getComplementHarmony#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getComplementHarmony__default() {
		assertColor(Color.CYAN, Color.RED.getComplementHarmony());
	}

	@:visionTestId("vision.ds.Color.getAnalogousHarmony#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getAnalogousHarmony__default() {
		var result = Color.RED.getAnalogousHarmony();
		assertColor(Color.RED, result.original);
		assertColor(cast 0xFFFF00A6, result.warmer);
		assertColor(cast 0xFFFF8000, result.colder);
	}

	@:visionTestId("vision.ds.Color.getSplitComplementHarmony#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getSplitComplementHarmony__default() {
		var result = Color.RED.getSplitComplementHarmony();
		assertColor(Color.RED, result.original);
		assertColor(cast 0xFF00FF80, result.warmer);
		assertColor(cast 0xFF0080FF, result.colder);
	}

	@:visionTestId("vision.ds.Color.getTriadicHarmony#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getTriadicHarmony__default() {
		var result = Color.RED.getTriadicHarmony();
		assertColor(Color.RED, result.color1);
		assertColor(Color.GREEN, result.color2);
		assertColor(Color.BLUE, result.color3);
	}

	@:visionTestId("vision.ds.Color.to24Bit#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_to24Bit__default() {
		assertColor(cast 0x00336699, sample().to24Bit());
	}

	@:visionTestId("vision.ds.Color.toHexString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toHexString__default() {
		Assert.equals("80336699", sample().toHexString(true, false));
	}

	@:visionTestId("vision.ds.Color.toWebString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toWebString__default() {
		Assert.equals("#336699", sample().toWebString());
	}

	@:visionTestId("vision.ds.Color.darken#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_darken__default() {
		var instance = sample();
		assertColor(cast 0x80000000, instance.darken(1));
	}

	@:visionTestId("vision.ds.Color.lighten#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_lighten__default() {
		var instance = sample();
		assertColor(cast 0x80FFFFFF, instance.lighten(1));
	}

	@:visionTestId("vision.ds.Color.invert#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_invert__default() {
		var instance = sample();
		assertColor(cast 0x80CC9966, instance.invert());
	}

	@:visionTestId("vision.ds.Color.setRGBA#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setRGBA__default() {
		var instance = sample();
		assertColor(cast 0x04010203, instance.setRGBA(1, 2, 3, 4));
	}

	@:visionTestId("vision.ds.Color.setRGBAFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setRGBAFloat__default() {
		var instance = sample();
		assertColor(sample(), instance.setRGBAFloat(0.2, 0.4, 0.6, 0.5));
	}

	@:visionTestId("vision.ds.Color.setCMYK#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setCMYK__default() {
		var instance = sample();
		assertColor(sample(), instance.setCMYK(2 / 3, 1 / 3, 0, 0.4, 0.5));
	}

	@:visionTestId("vision.ds.Color.setHSB#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setHSB__default() {
		var instance = sample();
		assertColor(sample(), instance.setHSB(210, 2 / 3, 0.6, 0.5));
	}

	@:visionTestId("vision.ds.Color.setHSL#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setHSL__default() {
		var instance = sample();
		assertColor(sample(), instance.setHSL(210, 0.5, 0.4, 0.5));
	}

	@:visionTestId("vision.ds.Color.grayscale#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_grayscale__default() {
		var instance = sample();
		assertColor(cast 0x805E5E5E, instance.grayscale(false));
	}

	@:visionTestId("vision.ds.Color.blackOrWhite#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_blackOrWhite__default() {
		var instance = sample();
		assertColor(cast 0x80FFFFFF, instance.blackOrWhite());
	}

	@:visionTestId("vision.ds.Color.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals("0x80336699", sample().toString());
	}

	@:visionTestId("vision.ds.Color.toInt#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toInt__default() {
		Assert.equals(-2144115047, sample().toInt());
	}
}
