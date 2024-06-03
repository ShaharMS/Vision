package vision.ds;

import vision.tools.MathTools;

abstract Color(Int) from Int from UInt to Int to UInt {
	#if (!vision_hlc_color_compile)
	#if hl
	/**
		**WARNING:** using this color, or compiling this source file without DCE in hashlink/c
		may result in compilation errors post c code generation due to conflicting #defines.

		Use `Color.TRANSPARENT_COLOR` instead.
	**/
	#else
	/**
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
	**/
	#end
	public static inline var TRANSPARENT:Color = 0x00000000;
	#end

	/**
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
		&nbsp;  
	**/
	public static inline var TRANSPARENT_COLOR:Color = 0x00000000;
	/**
		![color](https://www.colorhexa.com/ffffff.png)![color](https://www.colorhexa.com/ffffff.png)
	**/
	public static inline var WHITE:Color = 0xFFFFFFFF;

	/**
		![color](https://www.colorhexa.com/ffffe4.png)![color](https://www.colorhexa.com/ffffe4.png)
	**/
	public static inline var OFFWHITE:Color = 0xFFFFFFE4;

	/**
		![color](https://www.colorhexa.com/808080.png)![color](https://www.colorhexa.com/808080.png)
	**/
	public static inline var GRAY:Color = 0xFF808080;

	/**
		![color](https://www.colorhexa.com/000000.png)![color](https://www.colorhexa.com/000000.png)
	**/
	public static inline var BLACK:Color = 0xFF000000;

	/**
		![color](https://www.colorhexa.com/00ff00.png)![color](https://www.colorhexa.com/00ff00.png)
	**/
	public static inline var GREEN:Color = 0xFF00FF00;

	/**
		![color](https://www.colorhexa.com/FFFF00.png)![color](https://www.colorhexa.com/FFFF00.png)
	**/
	public static inline var YELLOW:Color = 0xFFFFFF00;

	/**
		![color](https://www.colorhexa.com/FFA500.png)![color](https://www.colorhexa.com/FFA500.png)
	**/
	public static inline var ORANGE:Color = 0xFFFFA500;

	/**
		![color](https://www.colorhexa.com/FF0000.png)![color](https://www.colorhexa.com/FF0000.png)
	**/
	public static inline var RED:Color = 0xFFFF0000;

	/**
		![color](https://www.colorhexa.com/800080.png)![color](https://www.colorhexa.com/800080.png)
	**/
	public static inline var PURPLE:Color = 0xFF800080;

	/**
		![color](https://www.colorhexa.com/0000ff.png)![color](https://www.colorhexa.com/0000ff.png)
	**/
	public static inline var BLUE:Color = 0xFF0000FF;

	/**
		![color](https://www.colorhexa.com/8B4513.png)![color](https://www.colorhexa.com/8B4513.png)
	**/
	public static inline var BROWN:Color = 0xFF8B4513;

	/**
	    ![color](https://www.colorhexa.com/704214.png)![color](https://www.colorhexa.com/704214.png)
	**/
	public static inline var SEPIA:Color = 0xFF704214;

	/**
		![color](https://www.colorhexa.com/FFC0CB.png)![color](https://www.colorhexa.com/FFC0CB.png)
	**/
	public static inline var PINK:Color = 0xFFFFC0CB;

	/**
		![color](https://www.colorhexa.com/FF00FF.png)![color](https://www.colorhexa.com/FF00FF.png)
	**/
	public static inline var MAGENTA:Color = 0xFFFF00FF;

	/**
		![color](https://www.colorhexa.com/00FFFF.png)![color](https://www.colorhexa.com/00FFFF.png)
	**/
	public static inline var CYAN:Color = 0xFF00FFFF;

	/**
		![color](https://www.colorhexa.com/C0C0C0.png)![color](https://www.colorhexa.com/C0C0C0.png)
	**/
	public static inline var SILVER:Color = 0xC0C0C0;

	/**
		![color](https://www.colorhexa.com/FFD700.png)![color](https://www.colorhexa.com/FFD700.png)
	**/
	public static inline var GOLD:Color = 0xFFFFD700;

	/**
		![color](https://www.colorhexa.com/808000.png)![color](https://www.colorhexa.com/808000.png)
	**/
	public static inline var OLIVE:Color = 0xFF808000;

	/**
		![color](https://www.colorhexa.com/800000.png)![color](https://www.colorhexa.com/800000.png)
	**/
	public static inline var MAROON:Color = 0xFF800000;

	/**
		![color](https://www.colorhexa.com/722F37.png)![color](https://www.colorhexa.com/722F37.png)
	**/
	public static inline var BORDEAUX:Color = 0xFF722F37;

	/**
		![color](https://www.colorhexa.com/000080.png)![color](https://www.colorhexa.com/000080.png)
	**/
	public static inline var NAVY:Color = 0xFF000080;

	/**
		![color](https://www.colorhexa.com/008080.png)![color](https://www.colorhexa.com/008080.png)
	**/
	public static inline var TEAL:Color = 0xFF008080;

	/**
		![color](https://www.colorhexa.com/FF00FF.png)![color](https://www.colorhexa.com/FF00FF.png)
	**/
	public static inline var FUCHSIA:Color = 0xFFFF00FF;

	/**
		![color](https://www.colorhexa.com/00FFFF.png)![color](https://www.colorhexa.com/00FFFF.png)
	**/
	public static inline var AQUA:Color = 0xFF00FFFF;

	/**
		![color](https://www.colorhexa.com/32CD32.png)![color](https://www.colorhexa.com/32CD32.png)
	**/
	public static inline var LIME:Color = 0xFF32CD32;

	/**
		![color](https://www.colorhexa.com/36454F.png)![color](https://www.colorhexa.com/36454F.png)
	**/
	public static inline var CHARCOAL:Color = 0xFF36454F;

	/**
		![color](https://www.colorhexa.com/353839.png)![color](https://www.colorhexa.com/353839.png)
	**/
	public static inline var ONYX:Color = 0xFF353839;

	/**
		![color](https://www.colorhexa.com/343434.png)![color](https://www.colorhexa.com/343434.png)
	**/
	public static inline var JET:Color = 0xFF343434;

	/**
		![color](https://www.colorhexa.com/0E0E10.png)![color](https://www.colorhexa.com/0E0E10.png)
	**/
	public static inline var JET_BLACK:Color = 0xFF0E0E10;

	/**
		![color](https://www.colorhexa.com/4169E1.png)![color](https://www.colorhexa.com/4169E1.png)
	**/
	public static inline var ROYAL_BLUE:Color = 0xFF4169E1;

	public var red(get, set):Int;
	public var blue(get, set):Int;
	public var green(get, set):Int;
	public var alpha(get, set):Int;

	public var redFloat(get, set):Float;
	public var blueFloat(get, set):Float;
	public var greenFloat(get, set):Float;
	public var alphaFloat(get, set):Float;

	public var cyan(get, set):Float;
	public var magenta(get, set):Float;
	public var yellow(get, set):Float;
	public var black(get, set):Float;

	/**
		The red, green and blue channels of this color as a 24 bit integer (from 0 to 0xFFFFFF, does not include alpha values)
	**/
	public var rgb(get, set):Color;

	/** 
		The hue of the color in degrees (from 0 to 359)
	**/
	public var hue(get, set):Float;

	/**
		The saturation of the color (from 0 to 1)
	**/
	public var saturation(get, set):Float;

	/**
		The brightness (aka value) of the color (from 0 to 1)
	**/
	public var brightness(get, set):Float;

	/**
		The lightness of the color (from 0 to 1)
	**/
	public var lightness(get, set):Float;

	static var COLOR_REGEX:EReg = ~/^(0x|#)(([A-F0-9]{2}){3,4})$/i;

	/**
		Create a color from the least significant four bytes of an `Int`

		@param value `Int` with bytes in the format 0xAARRGGBB
		@return	The color as a `Color`
	**/
	public static inline function fromInt(value:Int):Color {
		return new Color(value);
	}

	/**
		Generate a color from integer RGB values (0 to 255)

		@param Red	The red value of the color from 0 to 255
		@param Green	The green value of the color from 0 to 255
		@param Blue	The green value of the color from 0 to 255
		@param Alpha	How opaque the color should be, from 0 to 255, default is 255
		@return The color as a Color
	**/
	public static inline function fromRGBA(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Color {
		var color = new Color();
		return color.setRGBA(Red, Green, Blue, Alpha);
	}

	/**
		Generate a grayscale color from a single color channel value (0 to 255)

		@param Value	The channel value of the red, green & blue channels of the color
		@return The color as a Color
	**/
	public static inline function from8Bit(Value:Int) {
		var color = new Color();
		return color.setRGBA(Value, Value, Value, 1);
	}

	/**
		Generate a color from float RGB values (0 to 1)

		@param Red	The red value of the color from 0 to 1
		@param Green	The green value of the color from 0 to 1
		@param Blue	The green value of the color from 0 to 1
		@param Alpha	How opaque the color should be, from 0 to 1, default is 1
		@return The color as a `Color`
	**/
	public static inline function fromRGBAFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Color {
		var color = new Color();
		return color.setRGBAFloat(Red, Green, Blue, Alpha);
	}

	/**
		Generate a color from CMYK values (0 to 1)

		@param Cyan		The cyan value of the color from 0 to 1
		@param Magenta	The magenta value of the color from 0 to 1
		@param Yellow	The yellow value of the color from 0 to 1
		@param Black		The black value of the color from 0 to 1
		@param Alpha		How opaque the color should be, from 0 to 1, default is 1
		@return The color as a `Color`
	**/
	public static inline function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Color {
		var color = new Color();
		return color.setCMYK(Cyan, Magenta, Yellow, Black, Alpha);
	}

	/**
		Generate a color from HSB (aka HSV) components.

		@param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
		@param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
		@param	Brightness	(aka Value) A number between 0 and 1, indicating how bright the color should be.  0 is black, 1 is full bright (default).
		@param	Alpha		How opaque the color should be, either between 0 and 1 or 0 and 255, default is 1.
		@return	The color as a `Color`
	**/
	public static function fromHSB(Hue:Float, Saturation:Float, Brightness:Float, Alpha:Float = 1):Color {
		var color = new Color();
		return color.setHSB(Hue, Saturation, Brightness, Alpha);
	}

	/**
		Generate a color from HSL components.

		@param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
		@param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
		@param	Lightness	A number between 0 and 1, indicating the lightness of the color
		@param	Alpha		How opaque the color should be, either between 0 and 1 or 0 and 255, default is 1.
		@return	The color as a `Color`
	**/
	public static inline function fromHSL(Hue:Float, Saturation:Float, Lightness:Float, Alpha:Float = 1):Color {
		var color = new Color();
		return color.setHSL(Hue, Saturation, Lightness, Alpha);
	}

	/**
		Parses a `String` and returns a `Color` or `null` if the `String` couldn't be parsed.

		Examples (input -> output in hex):

		- `0x00FF00`    -> `0xFF00FF00`
		- `0xAA4578C2`  -> `0xAA4578C2`
		- `#0000FF`     -> `0xFF0000FF`
		- `#3F000011`   -> `0x3F000011`
		- `GRAY`        -> `0xFF808080`
		- `blue`        -> `0xFF0000FF`

		@param	str 	The string to be parsed
		@return	A `Color` or `null` if the `String` couldn't be parsed
	**/
	public static function fromString(str:String):Null<Color> {
		var result:Null<Color> = null;
		str = StringTools.trim(str);

		if (COLOR_REGEX.match(str)) {
			var hexColor:String = "0x" + COLOR_REGEX.matched(2);
			result = new Color(Std.parseInt(hexColor));
			if (hexColor.length == 8) {
				result.alphaFloat = 1;
			}
		}

		return result;
	}

	/**
		Get HSB color wheel values in an array which will be 360 elements in size

		@param	Alpha Alpha value for each color of the color wheel, between 0 (transparent) and 255 (opaque) (default)
		@return	HSB color wheel as Array of Colors
	**/
	public static function getHSBColorWheel(Alpha:Int = 255):Array<Color> {
		return [for (c in 0...360) fromHSB(c, 1.0, 1.0, Alpha)];
	}

	/**
		Get an interpolated color based on two different colors.

		@param 	Color1 The first color
		@param 	Color2 The second color
		@param 	Factor Value from 0 to 1 representing how much to shift Color1 toward Color2, default is 0.5
		@return	The interpolated color as a `Color`
	**/
	public static inline function interpolate(Color1:Color, Color2:Color, Factor:Float = 0.5):Color {
		final r:Int = Std.int((Color2.red - Color1.red) * Factor + Color1.red);
		final g:Int = Std.int((Color2.green - Color1.green) * Factor + Color1.green);
		final b:Int = Std.int((Color2.blue - Color1.blue) * Factor + Color1.blue);
		final a:Int = Std.int((Color2.alpha - Color1.alpha) * Factor + Color1.alpha);

		return fromRGBA(r, g, b, a);
	}

	/**
		Create a gradient from one color to another

		@param Color1 The color to shift from
		@param Color2 The color to shift to
		@param Steps How many colors the gradient should have
		@param Ease An optional easing function.
		@return An array of colors of length Steps, shifting from Color1 to Color2
	**/
	public static function gradient(Color1:Color, Color2:Color, Steps:Int, ?Ease:Float->Float):Array<Color> {
		var output = new Array<Color>();

		if (Ease == null) {
			Ease = function(t:Float):Float {
				return t;
			}
		}

		for (step in 0...Steps) {
			output[step] = interpolate(Color1, Color2, Ease(step / (Steps - 1)));
		}

		return output;
	}

	/**
		Generate a random color, with randomized red, green, blue and optionally alpha values.

		@param alphaLock When set to `false`, the alpha channel will get a randomized value to. `true` by default, which makes a color with `alpha = 255`.
		@param alphaValue When `alphaLock` is true, you can provide this value to override the default alpha value. Since the first argument is optional, you can do `Color.makeRandom(128)` (a random color with `alpha` set to `128`)	
	**/
	public static inline function makeRandom(?alphaLock:Bool = true, alphaValue:Int = 255) {
		return Color.fromRGBAFloat(Math.random(), Math.random(), Math.random(), if (alphaLock) alphaValue else Math.random());
	}

	/**
		Multiply the RGB and alpha channels of two Colors
	**/
	@:op(A * B)
	public static inline function multiply(lhs:Color, rhs:Color):Color {
		return Color.fromRGBAFloat(lhs.redFloat * rhs.redFloat, lhs.greenFloat * rhs.greenFloat, lhs.blueFloat * rhs.blueFloat,
			lhs.alphaFloat * rhs.alphaFloat);
	}

	/**
		Add the RGB and alpha channels of two Colors
	**/
	@:op(A + B)
	public static inline function add(lhs:Color, rhs:Color):Color {
		return Color.fromRGBA(lhs.red + rhs.red, lhs.green + rhs.green, lhs.blue + rhs.blue, lhs.alpha + rhs.alpha);
	}

	/**
		Subtract the RGB and alpha channels of one Color from another
	**/
	@:op(A - B)
	public static inline function subtract(lhs:Color, rhs:Color):Color {
		return Color.fromRGBA(lhs.red - rhs.red, lhs.green - rhs.green, lhs.blue - rhs.blue, lhs.alpha - rhs.alpha);
	}

	/**
	 * Divide the RGB and alpha channels of one Color from another.
	 * 
	 * If a color channel value on the right hand side is `0`, the left hand side's channel will get divided by `1`.
	 */
	@:op(A / B)
	public static inline function divide(lhs:Color, rhs:Color):Color {
		return Color.fromRGBA(Std.int(lhs.red / rhs.red == 0 ? 1 : rhs.red), Std.int(lhs.green / rhs.green == 0 ? 1 : rhs.green), Std.int(lhs.blue / rhs.blue == 0 ? 1 : rhs.blue), Std.int(lhs.alpha / rhs.alpha == 0 ? 1 : rhs.alpha));
	}

	/**
		Returns a Complementary Color Harmony of this color.
		A complementary hue is one directly opposite the color given on the color wheel

		@return	The complimentary color
	**/
	public inline function getComplementHarmony():Color {
		return fromHSB(MathTools.wrapInt(Std.int(hue) + 180, 0, 350), brightness, saturation, alphaFloat);
	}

	/**
		Returns an Analogous Color Harmony for the given color.
		An Analogous harmony are hues adjacent to each other on the color wheel

		@param	Threshold Control how adjacent the colors will be (default +- 30 degrees)
		@return 	Object containing 3 properties: original (the original color), warmer (the warmer analogous color) and colder (the colder analogous color)
	**/
	public inline function getAnalogousHarmony(Threshold:Int = 30):Harmony {
		final warmer:Int = fromHSB(MathTools.wrapInt(Std.int(hue) - Threshold, 0, 350), saturation, brightness, alphaFloat);
		final colder:Int = fromHSB(MathTools.wrapInt(Std.int(hue) + Threshold, 0, 350), saturation, brightness, alphaFloat);

		return {original: this, warmer: warmer, colder: colder};
	}

	/**
		Returns an Split Complement Color Harmony for this color.
		A Split Complement harmony are the two hues on either side of the color's Complement

		@param	Threshold Control how adjacent the colors will be to the Complement (default +- 30 degrees)
		@return 	Object containing 3 properties: original (the original color), warmer (the warmer analogous color) and colder (the colder analogous color)
	**/
	public inline function getSplitComplementHarmony(Threshold:Int = 30):Harmony {
		final oppositeHue:Int = MathTools.wrapInt(Std.int(hue) + 180, 0, 350);
		final warmer:Color = fromHSB(MathTools.wrapInt(oppositeHue - Threshold, 0, 350), saturation, brightness, alphaFloat);
		final colder:Color = fromHSB(MathTools.wrapInt(oppositeHue + Threshold, 0, 350), saturation, brightness, alphaFloat);

		return {original: this, warmer: warmer, colder: colder};
	}

	/**
		Returns a Triadic Color Harmony for this color. A Triadic harmony are 3 hues equidistant
		from each other on the color wheel.

		@return 	Object containing 3 properties: color1 (the original color), color2 and color3 (the equidistant colors)
	**/
	public inline function getTriadicHarmony():TriadicHarmony {
		final triadic1:Color = fromHSB(MathTools.wrapInt(Std.int(hue) + 120, 0, 359), saturation, brightness, alphaFloat);
		final triadic2:Color = fromHSB(MathTools.wrapInt(Std.int(triadic1.hue) + 120, 0, 359), saturation, brightness, alphaFloat);

		return {color1: this, color2: triadic1, color3: triadic2};
	}

	/**
		Return a 24 bit version of this color (i.e. without an alpha value)

		@return A 24 bit version of this color
	**/
	public inline function to24Bit():Color {
		return this & 0xffffff;
	}

	/**
		Return a String representation of the color in the format

		@param Alpha Whether to include the alpha value in the hes string
		@param Prefix Whether to include "0x" prefix at start of string
		@return	A string of length 10 in the format 0xAARRGGBB
	**/
	public inline function toHexString(Alpha:Bool = true, Prefix:Bool = true):String {
		return (Prefix ? "0x" : "") + (Alpha ? StringTools.hex(alpha,
			2) : "") + StringTools.hex(red, 2) + StringTools.hex(green, 2) + StringTools.hex(blue, 2);
	}

	/**
		Return a String representation of the color in the format #RRGGBB

		@return	A string of length 7 in the format #RRGGBB
	**/
	public inline function toWebString():String {
		return "#" + toHexString(false, false);
	}

	/**
		Get a darkened version of this color

		@param	Factor Value from 0 to 1 of how much to progress toward black.
		@return 	A darkened version of this color
	**/
	public function darken(Factor:Float = 0.2):Color {
		Factor = MathTools.boundFloat(Factor, 0, 1);
		var output:Color = this;
		output.lightness = output.lightness * (1 - Factor);
		return output;
	}

	/**
		Get a lightened version of this color

		@param	Factor Value from 0 to 1 of how much to progress toward white.
		@return 	A lightened version of this color
	**/
	public inline function lighten(Factor:Float = 0.2):Color {
		Factor = MathTools.boundFloat(Factor, 0, 1);
		var output:Color = this;
		output.lightness = output.lightness + (1 - lightness) * Factor;
		return output;
	}

	/**
		Get the inversion of this color

		@return The inversion of this color
	**/
	public inline function invert():Color {
		final oldAlpha = alpha;
		var output:Color = Color.WHITE - this;
		output.alpha = oldAlpha;
		return output;
	}

	/**
		Set RGB values as integers (0 to 255)

		@param Red	The red value of the color from 0 to 255
		@param Green	The green value of the color from 0 to 255
		@param Blue	The green value of the color from 0 to 255
		@param Alpha	How opaque the color should be, from 0 to 255, default is 255
		@return This color
	**/
	public inline function setRGBA(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Color {
		red = Red;
		green = Green;
		blue = Blue;
		alpha = Alpha;
		return this;
	}

	/**
		Set RGB values as floats (0 to 1)

		@param Red	The red value of the color from 0 to 1
		@param Green	The green value of the color from 0 to 1
		@param Blue	The green value of the color from 0 to 1
		@param Alpha	How opaque the color should be, from 0 to 1, default is 1
		@return This color
	**/
	public inline function setRGBAFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Color {
		redFloat = Red;
		greenFloat = Green;
		blueFloat = Blue;
		alphaFloat = Alpha;
		return this;
	}

	/**
		Set CMYK values as floats (0 to 1)

		@param Cyan		The cyan value of the color from 0 to 1
		@param Magenta	The magenta value of the color from 0 to 1
		@param Yellow	The yellow value of the color from 0 to 1
		@param Black		The black value of the color from 0 to 1
		@param Alpha		How opaque the color should be, from 0 to 1, default is 1
		@return This color
	**/
	public inline function setCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Color {
		redFloat = (1 - Cyan) * (1 - Black);
		greenFloat = (1 - Magenta) * (1 - Black);
		blueFloat = (1 - Yellow) * (1 - Black);
		alphaFloat = Alpha;
		return this;
	}

	/**
		Set HSB (aka HSV) components

		@param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
		@param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
		@param	Brightness	(aka Value) A number between 0 and 1, indicating how bright the color should be.  0 is black, 1 is full bright.
		@param	Alpha		How opaque the color should be, either between 0 and 1 or 0 and 255.
		@return	This color
	**/
	public inline function setHSB(Hue:Float, Saturation:Float, Brightness:Float, Alpha:Float):Color {
		final chroma = Brightness * Saturation;
		final match = Brightness - chroma;
		return setHSChromaMatch(Hue, Saturation, chroma, match, Alpha);
	}

	/**
		Set HSL components.

		@param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
		@param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
		@param	Lightness	A number between 0 and 1, indicating the lightness of the color
		@param	Alpha		How opaque the color should be, either between 0 and 1 or 0 and 255
		@return	This color
	**/
	public inline function setHSL(Hue:Float, Saturation:Float, Lightness:Float, Alpha:Float):Color {
		final chroma = (1 - Math.abs(2 * Lightness - 1)) * Saturation;
		final match = Lightness - chroma / 2;
		return setHSChromaMatch(Hue, Saturation, chroma, match, Alpha);
	}

	/**
		Private utility function to perform common operations between setHSB and setHSL
	**/
	inline function setHSChromaMatch(Hue:Float, Saturation:Float, Chroma:Float, Match:Float, Alpha:Float):Color {
		Hue %= 360;
		final hueD = Hue / 60;
		final mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + Match;
		Chroma += Match;

		switch (Std.int(hueD)) {
			case 0:
				setRGBAFloat(Chroma, mid, Match, Alpha);
			case 1:
				setRGBAFloat(mid, Chroma, Match, Alpha);
			case 2:
				setRGBAFloat(Match, Chroma, mid, Alpha);
			case 3:
				setRGBAFloat(Match, mid, Chroma, Alpha);
			case 4:
				setRGBAFloat(mid, Match, Chroma, Alpha);
			case 5:
				setRGBAFloat(Chroma, Match, mid, Alpha);
		}

		return this;
	}

	/**
		@param simple When enabled, gets the gray by averaging this color's channel values, instead of using a special ratio for more accurate grayscaling. Defaults to `false`
	**/
	public inline function grayscale(simple:Bool = false):Color {
		final gray = if (simple) Std.int((red + green + blue) / 3) else Std.int(0.2126 * red + 0.7152 * green + 0.0722 * blue);
		return this = setRGBA(gray, gray, gray, alpha);
	}

	/**
		Turns this color black/white, according to the values of the color channels.

		@param threshold The threshold for converting to black and white: `threshold` is the maximum average of the three color components, that will still be considered black. `threshold` is a value between 0 and 255. The higher the value, the more "sensitive" the conversion. The default value is 128.
	**/
	public inline function blackOrWhite(threshold:Int = 128):Color {
		final colorValue:Int = MathTools.max(red, green, blue);
		var a = alpha;
		if (colorValue > threshold) {
			this = 0xFFFFFFFF;
		} else {
			this = 0xFF000000;
		}
		alpha = a;
		return this;
	}

	public inline function new(value:Int = 0) {
		this = value;
	}

	inline function getThis():Int {
		#if neko
		return Std.int(this);
		#else
		return this;
		#end
	}

	inline function validate():Void {
		#if neko
		this = Std.int(this);
		#end
	}

	inline function get_red():Int {
		return (getThis() >> 16) & 0xff;
	}

	inline function get_green():Int {
		return (getThis() >> 8) & 0xff;
	}

	inline function get_blue():Int {
		return getThis() & 0xff;
	}

	inline function get_alpha():Int {
		return (getThis() >> 24) & 0xff;
	}

	inline function get_redFloat():Float {
		return red / 255;
	}

	inline function get_greenFloat():Float {
		return green / 255;
	}

	inline function get_blueFloat():Float {
		return blue / 255;
	}

	inline function get_alphaFloat():Float {
		return alpha / 255;
	}

	inline function set_red(value:Int):Int {
		validate();
		this &= 0xff00ffff;
		this |= boundChannel(value) << 16;
		return value;
	}

	inline function set_green(value:Int):Int {
		validate();
		this &= 0xffff00ff;
		this |= boundChannel(value) << 8;
		return value;
	}

	inline function set_blue(value:Int):Int {
		validate();
		this &= 0xffffff00;
		this |= boundChannel(value);
		return value;
	}

	inline function set_alpha(value:Int):Int {
		validate();
		this &= 0x00ffffff;
		this |= boundChannel(value) << 24;
		return value;
	}

	inline function set_redFloat(value:Float):Float {
		red = Math.round(value * 255);
		return value;
	}

	inline function set_greenFloat(value:Float):Float {
		green = Math.round(value * 255);
		return value;
	}

	inline function set_blueFloat(value:Float):Float {
		blue = Math.round(value * 255);
		return value;
	}

	inline function set_alphaFloat(value:Float):Float {
		alpha = Math.round(value * 255);
		return value;
	}

	inline function get_cyan():Float {
		return (1 - redFloat - black) / brightness;
	}

	inline function get_magenta():Float {
		return (1 - greenFloat - black) / brightness;
	}

	inline function get_yellow():Float {
		return (1 - blueFloat - black) / brightness;
	}

	inline function get_black():Float {
		return 1 - brightness;
	}

	inline function set_cyan(value:Float):Float {
		setCMYK(value, magenta, yellow, black, alphaFloat);
		return value;
	}

	inline function set_magenta(value:Float):Float {
		setCMYK(cyan, value, yellow, black, alphaFloat);
		return value;
	}

	inline function set_yellow(value:Float):Float {
		setCMYK(cyan, magenta, value, black, alphaFloat);
		return value;
	}

	inline function set_black(value:Float):Float {
		setCMYK(cyan, magenta, yellow, value, alphaFloat);
		return value;
	}

	function get_hue():Float {
		var hueRad = Math.atan2(Math.sqrt(3) * (greenFloat - blueFloat), 2 * redFloat - greenFloat - blueFloat);
		var hue:Float = 0;
		if (hueRad != 0) {
			hue = 180 / Math.PI * Math.atan2(Math.sqrt(3) * (greenFloat - blueFloat), 2 * redFloat - greenFloat - blueFloat);
		}

		return hue < 0 ? hue + 360 : hue;
	}

	inline function get_brightness():Float {
		return maxColor();
	}

	inline function get_saturation():Float {
		return (maxColor() - minColor()) / brightness;
	}

	inline function get_lightness():Float {
		return (maxColor() + minColor()) / 2;
	}

	inline function set_hue(value:Float):Float {
		setHSB(value, saturation, brightness, alphaFloat);
		return value;
	}

	inline function set_saturation(value:Float):Float {
		setHSB(hue, value, brightness, alphaFloat);
		return value;
	}

	inline function set_brightness(value:Float):Float {
		setHSB(hue, saturation, value, alphaFloat);
		return value;
	}

	inline function set_lightness(value:Float):Float {
		setHSL(hue, saturation, value, alphaFloat);
		return value;
	}

	inline function set_rgb(value:Color):Color {
		validate();
		this = (this & 0xff000000) | (value & 0x00ffffff);
		return value;
	}

	inline function get_rgb():Color {
		return this & 0x00ffffff;
	}

	inline function maxColor():Float {
		return Math.max(redFloat, Math.max(greenFloat, blueFloat));
	}

	inline function minColor():Float {
		return Math.min(redFloat, Math.min(greenFloat, blueFloat));
	}

	inline function boundChannel(value:Int):Int {
		return value > 0xff ? 0xff : value < 0 ? 0 : value;
	}

	public function toString() {
		#if console.hx
		return '<bg${toWebString()}>  </>';
		#else
		return toHexString(true, true);
		#end
	}

	public function toInt():Int {
		return getThis();
	}

	//--------------------------------------------------------------------------
	// Special Operator Overloads
	//--------------------------------------------------------------------------

	@:op(A > B)
	static inline function color_greater_than_color(lhs:Color, rhs:Color):Bool {
		return lhs.getThis() > rhs.getThis();
	}

	@:op(A > B)
	static inline function color_greater_than_int(lhs:Color, rhs:Int):Bool {
		return lhs.getThis() > rhs;
	}

	@:op(A > B)
	static inline function int_greater_than_color(lhs:Int, rhs:Color):Bool {
		return lhs > rhs.getThis();
	}

	@:op(A > B)
	static inline function color_greater_than_float(lhs:Color, rhs:Float):Bool {
		return lhs.getThis() > rhs;
	}

	@:op(A > B)
	static inline function float_greater_than_color(lhs:Float, rhs:Color):Bool {
		return lhs > rhs.getThis();
	}

	@:op(A >= B)
	static inline function color_greater_than_equal_color(lhs:Color, rhs:Color):Bool {
		return lhs.getThis() >= rhs.getThis();
	}

	@:op(A >= B)
	static inline function color_greater_than_equal_int(lhs:Color, rhs:Int):Bool {
		return lhs.getThis() >= rhs;
	}

	@:op(A >= B)
	static inline function int_greater_than_equal_color(lhs:Int, rhs:Color):Bool {
		return lhs >= rhs.getThis();
	}

	@:op(A >= B)
	static inline function color_greater_than_equal_float(lhs:Color, rhs:Float):Bool {
		return lhs.getThis() >= rhs;
	}

	@:op(A >= B)
	static inline function float_greater_than_equal_color(lhs:Float, rhs:Color):Bool {
		return lhs >= rhs.getThis();
	}

	@:op(A < B)
	static inline function color_less_than_color(lhs:Color, rhs:Color):Bool {
		return lhs.getThis() < rhs.getThis();
	}

	@:op(A < B)
	static inline function color_less_than_int(lhs:Color, rhs:Int):Bool {
		return lhs.getThis() < rhs;
	}

	@:op(A < B)
	static inline function int_less_than_color(lhs:Int, rhs:Color):Bool {
		return lhs < rhs.getThis();
	}

	@:op(A < B)
	static inline function color_less_than_float(lhs:Color, rhs:Float):Bool {
		return lhs.getThis() < rhs;
	}

	@:op(A < B)
	static inline function float_less_than_color(lhs:Float, rhs:Color):Bool {
		return lhs < rhs.getThis();
	}

	@:op(A <= B)
	static inline function color_less_than_equal_color(lhs:Color, rhs:Color):Bool {
		return lhs.getThis() <= rhs.getThis();
	}

	@:op(A <= B)
	static inline function color_less_than_equal_int(lhs:Color, rhs:Int):Bool {
		return lhs.getThis() <= rhs;
	}

	@:op(A <= B)
	static inline function int_less_than_equal_color(lhs:Int, rhs:Color):Bool {
		return lhs <= rhs.getThis();
	}

	@:op(A <= B)
	static inline function color_less_than_equal_float(lhs:Color, rhs:Float):Bool {
		return lhs.getThis() <= rhs;
	}

	@:op(A <= B)
	static inline function float_less_than_equal_color(lhs:Float, rhs:Color):Bool {
		return lhs <= rhs.getThis();
	}

	@:op(A == B)
	static inline function color_equal_color(lhs:Color, rhs:Color):Bool {
		return lhs.getThis() == rhs.getThis();
	}

	@:op(A == B)
	static inline function color_equal_int(lhs:Color, rhs:Int):Bool {
		return lhs.getThis() == rhs;
	}

	@:op(A == B)
	static inline function int_equal_color(lhs:Int, rhs:Color):Bool {
		return lhs == rhs.getThis();
	}

	@:op(A == B)
	static inline function color_equal_float(lhs:Color, rhs:Float):Bool {
		return lhs.getThis() == rhs;
	}

	@:op(A == B)
	static inline function float_equal_color(lhs:Float, rhs:Color):Bool {
		return lhs == rhs.getThis();
	}

	@:op(A != B)
	static inline function color_not_equal_color(lhs:Color, rhs:Color):Bool {
		return lhs.getThis() != rhs.getThis();
	}

	@:op(A != B)
	static inline function color_not_equal_int(lhs:Color, rhs:Int):Bool {
		return lhs.getThis() != rhs;
	}

	@:op(A != B)
	static inline function int_not_equal_color(lhs:Int, rhs:Color):Bool {
		return lhs != rhs.getThis();
	}

	@:op(A != B)
	static inline function color_not_equal_float(lhs:Color, rhs:Float):Bool {
		return lhs.getThis() != rhs;
	}

	@:op(A != B)
	static inline function float_not_equal_color(lhs:Float, rhs:Color):Bool {
		return lhs != rhs.getThis();
	}

	@:op(A & B)
	static inline function color_bitwise_and_color(lhs:Color, rhs:Color):Color {
		return lhs.getThis() & rhs.getThis();
	}

	@:op(A & B)
	static inline function color_bitwise_and_int(lhs:Color, rhs:Int):Color {
		return lhs.getThis() & rhs;
	}

	@:op(A & B)
	static inline function int_bitwise_and_color(lhs:Int, rhs:Color):Color {
		return lhs & rhs.getThis();
	}

	@:op(A | B)
	static inline function color_bitwise_or_color(lhs:Color, rhs:Color):Color {
		return lhs.getThis() | rhs.getThis();
	}

	@:op(A | B)
	static inline function color_bitwise_or_int(lhs:Color, rhs:Int):Color {
		return lhs.getThis() | rhs;
	}

	@:op(A | B)
	static inline function int_bitwise_or_color(lhs:Int, rhs:Color):Color {
		return lhs | rhs.getThis();
	}

	@:op(A ^ B)
	static inline function color_bitwise_xor_color(lhs:Color, rhs:Color):Color {
		return lhs.getThis() ^ rhs.getThis();
	}

	@:op(A ^ B)
	static inline function color_bitwise_xor_int(lhs:Color, rhs:Int):Color {
		return lhs.getThis() ^ rhs;
	}

	@:op(A ^ B)
	static inline function int_bitwise_xor_color(lhs:Int, rhs:Color):Color {
		return lhs ^ rhs.getThis();
	}

	@:op(A << B)
	static inline function color_bitwise_left_shift_color(lhs:Color, rhs:Color):Color {
		return lhs.getThis() << rhs.getThis();
	}

	@:op(A << B)
	static inline function color_bitwise_left_shift_int(lhs:Color, rhs:Int):Color {
		return lhs.getThis() << rhs;
	}

	@:op(A << B)
	static inline function int_bitwise_left_shift_color(lhs:Int, rhs:Color):Color {
		return lhs << rhs.getThis();
	}

	@:op(A >> B)
	static inline function color_bitwise_right_shift_color(lhs:Color, rhs:Color):Color {
		return lhs.getThis() >> rhs.getThis();
	}

	@:op(A >> B)
	static inline function color_bitwise_right_shift_int(lhs:Color, rhs:Int):Color {
		return lhs.getThis() >> rhs;
	}

	@:op(A >> B)
	static inline function int_bitwise_right_shift_color(lhs:Int, rhs:Color):Color {
		return lhs >> rhs.getThis();
	}

	@:op(A >>> B)
	static inline function color_bitwise_unsigned_right_shift_color(lhs:Color, rhs:Color):Color {
		return lhs.getThis() >>> rhs.getThis();
	}

	@:op(A >>> B)
	static inline function color_bitwise_unsigned_right_shift_int(lhs:Color, rhs:Int):Color {
		return lhs.getThis() >>> rhs;
	}

	@:op(A >>> B)
	static inline function int_bitwise_unsigned_right_shift_color(lhs:Int, rhs:Color):Color {
		return lhs >>> rhs.getThis();
	}
}

typedef Harmony = {
	original:Color,
	warmer:Color,
	colder:Color
}

typedef TriadicHarmony = {
	color1:Color,
	color2:Color,
	color3:Color
}
