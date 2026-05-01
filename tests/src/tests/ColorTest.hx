package tests;

import utest.Assert;
import vision.ds.Color;

@:access(vision.ds.Color)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class ColorTest extends utest.Test {

	@:visionTestId("vision.ds.Color.red#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_red__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.red;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.blue#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_blue__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.blue;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.green#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_green__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.green;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.alpha#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_alpha__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.alpha;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.redFloat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_redFloat__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.redFloat;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.blueFloat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_blueFloat__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.blueFloat;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.greenFloat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_greenFloat__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.greenFloat;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.alphaFloat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_alphaFloat__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.alphaFloat;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.cyan#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_cyan__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.cyan;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.magenta#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_magenta__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.magenta;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.yellow#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_yellow__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.yellow;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.black#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_black__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.black;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.rgb#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_rgb__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.rgb;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.hue#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_hue__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.hue;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.saturation#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_saturation__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.saturation;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.brightness#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_brightness__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.brightness;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.lightness#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_lightness__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.lightness;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.fromInt#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromInt__default() {
		var value = 1;
		var result = vision.ds.Color.fromInt(value);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.fromRGBA#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromRGBA__default() {
		var Red = 1;
		var Green = 1;
		var Blue = 1;
		var Alpha = 1;
		var result = vision.ds.Color.fromRGBA(Red, Green, Blue, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.from8Bit#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_from8Bit__default() {
		var Value = 1;
		var result = vision.ds.Color.from8Bit(Value);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.fromFloat#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromFloat__default() {
		var Value = 1.0;
		var result = vision.ds.Color.fromFloat(Value);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.fromRGBAFloat#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromRGBAFloat__default() {
		var Red = 1.0;
		var Green = 1.0;
		var Blue = 1.0;
		var Alpha = 1.0;
		var result = vision.ds.Color.fromRGBAFloat(Red, Green, Blue, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.fromCMYK#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromCMYK__default() {
		var Cyan = 1.0;
		var Magenta = 1.0;
		var Yellow = 1.0;
		var Black = 1.0;
		var Alpha = 1.0;
		var result = vision.ds.Color.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.fromHSB#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromHSB__default() {
		var Hue = 1.0;
		var Saturation = 1.0;
		var Brightness = 1.0;
		var Alpha = 1.0;
		var result = vision.ds.Color.fromHSB(Hue, Saturation, Brightness, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.fromHSL#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromHSL__default() {
		var Hue = 1.0;
		var Saturation = 1.0;
		var Lightness = 1.0;
		var Alpha = 1.0;
		var result = vision.ds.Color.fromHSL(Hue, Saturation, Lightness, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.fromString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromString__default() {
		var str = "42";
		var result = vision.ds.Color.fromString(str);
		Assert.pass();
	}

	@:visionTestId("vision.ds.Color.getHSBColorWheel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_getHSBColorWheel__default() {
		var Alpha = 1;
		var result = vision.ds.Color.getHSBColorWheel(Alpha);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.ds.Color.interpolate#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_interpolate__default() {
		var Color1 = (0xFF336699 : vision.ds.Color);
		var Color2 = (0xFF336699 : vision.ds.Color);
		var Factor = 1.0;
		var result = vision.ds.Color.interpolate(Color1, Color2, Factor);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.gradient#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_gradient__default() {
		var Color1 = (0xFF336699 : vision.ds.Color);
		var Color2 = (0xFF336699 : vision.ds.Color);
		var Steps = 1;
		var Ease = null;
		var result = vision.ds.Color.gradient(Color1, Color2, Steps, Ease);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.ds.Color.makeRandom#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_makeRandom__default() {
		var alphaLock = null;
		var alphaValue = 1;
		var result = vision.ds.Color.makeRandom(alphaLock, alphaValue);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.multiply#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_multiply__default() {
		var lhs = (0xFF336699 : vision.ds.Color);
		var rhs = (0xFF336699 : vision.ds.Color);
		var result = vision.ds.Color.multiply(lhs, rhs);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.add#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_add__default() {
		var lhs = (0xFF336699 : vision.ds.Color);
		var rhs = (0xFF336699 : vision.ds.Color);
		var result = vision.ds.Color.add(lhs, rhs);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.subtract#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_subtract__default() {
		var lhs = (0xFF336699 : vision.ds.Color);
		var rhs = (0xFF336699 : vision.ds.Color);
		var result = vision.ds.Color.subtract(lhs, rhs);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.divide#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_divide__default() {
		var lhs = (0xFF336699 : vision.ds.Color);
		var rhs = (0xFF336699 : vision.ds.Color);
		var result = vision.ds.Color.divide(lhs, rhs);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.distanceBetween#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceBetween__default() {
		var lhs = (0xFF336699 : vision.ds.Color);
		var rhs = (0xFF336699 : vision.ds.Color);
		var considerTransparency = false;
		var result = vision.ds.Color.distanceBetween(lhs, rhs, considerTransparency);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.differenceBetween#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_differenceBetween__default() {
		var lhs = (0xFF336699 : vision.ds.Color);
		var rhs = (0xFF336699 : vision.ds.Color);
		var considerTransparency = false;
		var result = vision.ds.Color.differenceBetween(lhs, rhs, considerTransparency);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Color.getAverage#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getAverage__default() {
		var fromColors = [cast 1, cast 2, cast 3];
		var considerTransparency = false;
		var result = vision.ds.Color.getAverage(fromColors, considerTransparency);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.getAverage#duplicates")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getAverage__duplicates() {
		var fromColors = [cast 1, cast 1, cast 2];
		var considerTransparency = false;
		var result = vision.ds.Color.getAverage(fromColors, considerTransparency);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.getComplementHarmony#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getComplementHarmony__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.getComplementHarmony();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.getAnalogousHarmony#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getAnalogousHarmony__default() {
		var Threshold = 1;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.getAnalogousHarmony(Threshold);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.getSplitComplementHarmony#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getSplitComplementHarmony__default() {
		var Threshold = 1;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.getSplitComplementHarmony(Threshold);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.getTriadicHarmony#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getTriadicHarmony__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.getTriadicHarmony();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.to24Bit#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_to24Bit__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.to24Bit();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.toHexString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toHexString__default() {
		var Alpha = true;
		var Prefix = false;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.toHexString(Alpha, Prefix);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.toWebString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toWebString__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.toWebString();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.darken#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_darken__default() {
		var Factor = 1.0;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.darken(Factor);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.lighten#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_lighten__default() {
		var Factor = 1.0;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.lighten(Factor);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.invert#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_invert__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.invert();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.setRGBA#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setRGBA__default() {
		var Red = 1;
		var Green = 1;
		var Blue = 1;
		var Alpha = 1;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.setRGBA(Red, Green, Blue, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.setRGBAFloat#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setRGBAFloat__default() {
		var Red = 1.0;
		var Green = 1.0;
		var Blue = 1.0;
		var Alpha = 1.0;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.setRGBAFloat(Red, Green, Blue, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.setCMYK#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setCMYK__default() {
		var Cyan = 1.0;
		var Magenta = 1.0;
		var Yellow = 1.0;
		var Black = 1.0;
		var Alpha = 1.0;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.setCMYK(Cyan, Magenta, Yellow, Black, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.setHSB#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setHSB__default() {
		var Hue = 1.0;
		var Saturation = 1.0;
		var Brightness = 1.0;
		var Alpha = 1.0;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.setHSB(Hue, Saturation, Brightness, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.setHSL#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setHSL__default() {
		var Hue = 1.0;
		var Saturation = 1.0;
		var Lightness = 1.0;
		var Alpha = 1.0;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.setHSL(Hue, Saturation, Lightness, Alpha);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.grayscale#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_grayscale__default() {
		var simple = false;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.grayscale(simple);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.blackOrWhite#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_blackOrWhite__default() {
		var threshold = 1;
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.blackOrWhite(threshold);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.toString();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Color.toInt#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toInt__default() {
		var instance = (0xFF336699 : vision.ds.Color);
		var result = instance.toInt();
		Assert.notNull(result);
	}

}
