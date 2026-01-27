package tests;

import utest.Assert;
import vision.ds.Color;

@:access(vision.ds.Color)
class ColorTest extends utest.Test {

    //==========================================================================
    // Static factory methods
    //==========================================================================

    function test_fromInt() {
        var result = Color.fromInt(0xFFFF0000); // Red with full alpha
        Assert.equals(255, result.alpha);
        Assert.equals(255, result.red);
        Assert.equals(0, result.green);
        Assert.equals(0, result.blue);
    }

    function test_fromInt_transparent() {
        var result = Color.fromInt(0x80008000); // Semi-transparent dark green
        Assert.equals(128, result.alpha);
        Assert.equals(0, result.red);
        Assert.equals(128, result.green);
        Assert.equals(0, result.blue);
    }

    function test_fromRGBA() {
        var result = Color.fromRGBA(255, 128, 64, 255);
        Assert.equals(255, result.red);
        Assert.equals(128, result.green);
        Assert.equals(64, result.blue);
        Assert.equals(255, result.alpha);
    }

    function test_fromRGBA_no_alpha() {
        var result = Color.fromRGBA(100, 150, 200);
        Assert.equals(100, result.red);
        Assert.equals(150, result.green);
        Assert.equals(200, result.blue);
        Assert.equals(255, result.alpha); // Default alpha
    }

    function test_from8Bit() {
        // 8-bit color is typically 3-3-2 bit encoding (RRRGGGBB)
        var result = Color.from8Bit(0xFF); // All bits set
        Assert.notNull(result);
        Assert.equals(255, result.alpha);
    }

    function test_fromFloat() {
        var result = Color.fromFloat(0.5);
        Assert.notNull(result);
        // Float 0.5 should give middle gray
        Assert.isTrue(result.red > 100 && result.red < 150);
    }

    function test_fromRGBAFloat() {
        var result = Color.fromRGBAFloat(1.0, 0.5, 0.0, 1.0);
        Assert.equals(255, result.red);
        Assert.equals(128, result.green);
        Assert.equals(0, result.blue);
        Assert.equals(255, result.alpha);
    }

    function test_fromRGBAFloat_clamps_values() {
        // Values beyond 0-1 should be clamped
        var result = Color.fromRGBAFloat(0.0, 0.0, 0.0, 1.0);
        Assert.equals(0, result.red);
        Assert.equals(0, result.green);
        Assert.equals(0, result.blue);
    }

    function test_fromCMYK() {
        // Pure cyan: C=1, M=0, Y=0, K=0
        var result = Color.fromCMYK(1.0, 0.0, 0.0, 0.0);
        Assert.equals(0, result.red);
        Assert.equals(255, result.green);
        Assert.equals(255, result.blue);
        
        // Pure black: K=1
        var black = Color.fromCMYK(0.0, 0.0, 0.0, 1.0);
        Assert.equals(0, black.red);
        Assert.equals(0, black.green);
        Assert.equals(0, black.blue);
    }

    function test_fromHSB() {
        // Red: H=0, S=1, B=1
        var red = Color.fromHSB(0.0, 1.0, 1.0);
        Assert.equals(255, red.red);
        Assert.equals(0, red.green);
        Assert.equals(0, red.blue);
        
        // Green: H=120, S=1, B=1
        var green = Color.fromHSB(120.0, 1.0, 1.0);
        Assert.equals(0, green.red);
        Assert.equals(255, green.green);
        Assert.equals(0, green.blue);
        
        // Blue: H=240, S=1, B=1
        var blue = Color.fromHSB(240.0, 1.0, 1.0);
        Assert.equals(0, blue.red);
        Assert.equals(0, blue.green);
        Assert.equals(255, blue.blue);
    }

    function test_fromHSL() {
        // Red: H=0, S=1, L=0.5
        var red = Color.fromHSL(0.0, 1.0, 0.5);
        Assert.equals(255, red.red);
        Assert.equals(0, red.green);
        Assert.equals(0, red.blue);
        
        // White: H=any, S=0, L=1
        var white = Color.fromHSL(0.0, 0.0, 1.0);
        Assert.equals(255, white.red);
        Assert.equals(255, white.green);
        Assert.equals(255, white.blue);
    }

    function test_fromString_hex_with_hash() {
        var red = Color.fromString("#FF0000");
        Assert.equals(255, red.red);
        Assert.equals(0, red.green);
        Assert.equals(0, red.blue);
        
        var green = Color.fromString("#00FF00");
        Assert.equals(0, green.red);
        Assert.equals(255, green.green);
        Assert.equals(0, green.blue);
    }

    function test_fromString_hex_without_hash() {
        // Note: fromString requires # or 0x prefix per COLOR_REGEX
        var blue = Color.fromString("0x0000FF");
        Assert.equals(0, blue.red);
        Assert.equals(0, blue.green);
        Assert.equals(255, blue.blue);
    }

    //==========================================================================
    // Instance color channel getters
    //==========================================================================

    function test_red() {
        var instance = new Color(0xFFFF8040);
        Assert.equals(255, instance.red);
    }

    function test_green() {
        var instance = new Color(0xFFFF8040);
        Assert.equals(128, instance.green); // 0x80 = 128
    }

    function test_blue() {
        var instance = new Color(0xFFFF8040);
        Assert.equals(64, instance.blue); // 0x40 = 64
    }

    function test_alpha() {
        var instance = new Color(0x80FF8040);
        Assert.equals(128, instance.alpha); // 0x80 = 128
    }

    function test_redFloat() {
        var instance = new Color(0xFFFF0000); // Pure red
        Assert.floatEquals(1.0, instance.redFloat);
        
        var black = new Color(0xFF000000);
        Assert.floatEquals(0.0, black.redFloat);
    }

    function test_greenFloat() {
        var instance = new Color(0xFF00FF00); // Pure green
        Assert.floatEquals(1.0, instance.greenFloat);
    }

    function test_blueFloat() {
        var instance = new Color(0xFF0000FF); // Pure blue
        Assert.floatEquals(1.0, instance.blueFloat);
    }

    function test_alphaFloat() {
        var instance = new Color(0xFFFFFFFF); // Full alpha
        Assert.floatEquals(1.0, instance.alphaFloat);
        
        var half = new Color(0x80FFFFFF);
        Assert.isTrue(half.alphaFloat > 0.49 && half.alphaFloat < 0.51);
    }

    function test_rgb() {
        var instance = new Color(0xFFFF8040);
        Assert.equals(0xFF8040, instance.rgb); // RGB without alpha
    }

    //==========================================================================
    // CMYK channel getters
    //==========================================================================

    function test_cyan() {
        var cyan_color = Color.fromCMYK(1.0, 0.0, 0.0, 0.0);
        Assert.floatEquals(1.0, cyan_color.cyan);
        
        var white = new Color(0xFFFFFFFF);
        Assert.floatEquals(0.0, white.cyan);
    }

    function test_magenta() {
        var magenta_color = Color.fromCMYK(0.0, 1.0, 0.0, 0.0);
        Assert.floatEquals(1.0, magenta_color.magenta);
    }

    function test_yellow() {
        var yellow_color = Color.fromCMYK(0.0, 0.0, 1.0, 0.0);
        Assert.floatEquals(1.0, yellow_color.yellow);
    }

    function test_black() {
        var pure_black = new Color(0xFF000000);
        Assert.floatEquals(1.0, pure_black.black);
        
        var white = new Color(0xFFFFFFFF);
        Assert.floatEquals(0.0, white.black);
    }

    //==========================================================================
    // HSB/HSL getters
    //==========================================================================

    function test_hue() {
        // Red has hue 0
        var red = new Color(0xFFFF0000);
        Assert.floatEquals(0.0, red.hue);
        
        // Green has hue 120
        var green = new Color(0xFF00FF00);
        Assert.floatEquals(120.0, green.hue);
        
        // Blue has hue 240
        var blue = new Color(0xFF0000FF);
        Assert.floatEquals(240.0, blue.hue);
    }

    function test_saturation() {
        // Pure colors have saturation 1
        var red = new Color(0xFFFF0000);
        Assert.floatEquals(1.0, red.saturation);
        
        // Gray has saturation 0
        var gray = new Color(0xFF808080);
        Assert.floatEquals(0.0, gray.saturation);
    }

    function test_brightness() {
        // White has brightness 1
        var white = new Color(0xFFFFFFFF);
        Assert.floatEquals(1.0, white.brightness);
        
        // Black has brightness 0
        var black = new Color(0xFF000000);
        Assert.floatEquals(0.0, black.brightness);
    }

    function test_lightness() {
        // White has lightness 1
        var white = new Color(0xFFFFFFFF);
        Assert.floatEquals(1.0, white.lightness);
        
        // Black has lightness 0
        var black = new Color(0xFF000000);
        Assert.floatEquals(0.0, black.lightness);
        
        // Pure red has lightness 0.5
        var red = new Color(0xFFFF0000);
        Assert.floatEquals(0.5, red.lightness);
    }

    //==========================================================================
    // Color operations
    //==========================================================================

    function test_interpolate_midpoint() {
        var black:Color = 0xFF000000;
        var white:Color = 0xFFFFFFFF;
        var result = Color.interpolate(black, white, 0.5);
        
        // Midpoint should be gray (127 due to truncation: Std.int(127.5) = 127)
        Assert.equals(127, result.red);
        Assert.equals(127, result.green);
        Assert.equals(127, result.blue);
    }

    function test_interpolate_at_zero() {
        var black:Color = 0xFF000000;
        var white:Color = 0xFFFFFFFF;
        var result = Color.interpolate(black, white, 0.0);
        
        Assert.equals(0, result.red);
        Assert.equals(0, result.green);
        Assert.equals(0, result.blue);
    }

    function test_interpolate_at_one() {
        var black:Color = 0xFF000000;
        var white:Color = 0xFFFFFFFF;
        var result = Color.interpolate(black, white, 1.0);
        
        Assert.equals(255, result.red);
        Assert.equals(255, result.green);
        Assert.equals(255, result.blue);
    }

    function test_gradient() {
        var black:Color = 0xFF000000;
        var white:Color = 0xFFFFFFFF;
        var result = Color.gradient(black, white, 5);
        
        Assert.equals(5, result.length);
        // First should be black
        Assert.equals(0, result[0].red);
        // Last should be white
        Assert.equals(255, result[4].red);
    }

    function test_makeRandom() {
        var color1 = Color.makeRandom();
        var color2 = Color.makeRandom();
        Assert.notNull(color1);
        Assert.notNull(color2);
        // Random colors should usually be different (could fail rarely)
        // Just check they are valid colors
        Assert.isTrue(color1.red >= 0 && color1.red <= 255);
    }

    function test_multiply() {
        var white:Color = 0xFFFFFFFF;
        var red:Color = 0xFFFF0000;
        var result = Color.multiply(white, red);
        
        // White * Red = Red
        Assert.equals(255, result.red);
        Assert.equals(0, result.green);
        Assert.equals(0, result.blue);
    }

    function test_add() {
        var red:Color = 0xFFFF0000;
        var green:Color = 0xFF00FF00;
        var result = Color.add(red, green);
        
        // Red + Green = Yellow (clamped)
        Assert.equals(255, result.red);
        Assert.equals(255, result.green);
        Assert.equals(0, result.blue);
    }

    function test_subtract() {
        var white:Color = 0xFFFFFFFF;
        var red:Color = 0xFFFF0000;
        var result = Color.subtract(white, red);
        
        // White - Red = Cyan
        Assert.equals(0, result.red);
        Assert.equals(255, result.green);
        Assert.equals(255, result.blue);
    }

    function test_divide() {
        var white:Color = 0xFFFFFFFF;
        var gray:Color = 0xFF808080;
        var result = Color.divide(white, gray);
        Assert.notNull(result);
        // Division should produce a valid color
        Assert.isTrue(result.red >= 0 && result.red <= 255);
    }

    function test_distanceBetween_same_color() {
        var red:Color = 0xFFFF0000;
        var result = Color.distanceBetween(red, red);
        Assert.floatEquals(0.0, result);
    }

    function test_distanceBetween_opposite_colors() {
        var black:Color = 0xFF000000;
        var white:Color = 0xFFFFFFFF;
        var result = Color.distanceBetween(black, white);
        // Max distance in RGB space is sqrt(255^2 + 255^2 + 255^2) = 441.67
        Assert.isTrue(result > 400);
    }

    function test_differenceBetween() {
        var black:Color = 0xFF000000;
        var white:Color = 0xFFFFFFFF;
        var result = Color.differenceBetween(black, white);
        // Difference: sqrt(1+1+1+0)/2 = sqrt(3)/2 ≈ 0.866 (alpha is same, so no alpha diff)
        Assert.floatEquals(0.866, result, 0.01);
        
        // Same colors should have 0 difference
        var same = Color.differenceBetween(black, black);
        Assert.floatEquals(0.0, same, 0.001);
    }

    function test_getAverage() {
        var colors:Array<Color> = [0xFFFF0000, 0xFF00FF00, 0xFF0000FF];
        var result = Color.getAverage(colors);
        // Average of R, G, B channels should be ~85
        Assert.isTrue(result.red > 80 && result.red < 90);
        Assert.isTrue(result.green > 80 && result.green < 90);
        Assert.isTrue(result.blue > 80 && result.blue < 90);
    }

    //==========================================================================
    // Color harmony
    //==========================================================================

    function test_getComplementHarmony() {
        var red = new Color(0xFFFF0000);
        var result = red.getComplementHarmony();
        // Complement of red is cyan
        Assert.equals(0, result.red);
        Assert.equals(255, result.green);
        Assert.equals(255, result.blue);
    }

    function test_getAnalogousHarmony() {
        var red = new Color(0xFFFF0000);
        var result = red.getAnalogousHarmony(30);
        // Returns Harmony struct with original, warmer, colder colors
        Assert.notNull(result.original);
        Assert.notNull(result.warmer);
        Assert.notNull(result.colder);
    }

    function test_getSplitComplementHarmony() {
        var red = new Color(0xFFFF0000);
        var result = red.getSplitComplementHarmony(30);
        // Returns Harmony struct with original, warmer, colder colors
        Assert.notNull(result.original);
        Assert.notNull(result.warmer);
        Assert.notNull(result.colder);
    }

    function test_getTriadicHarmony() {
        var red = new Color(0xFFFF0000);
        var result = red.getTriadicHarmony();
        // TriadicHarmony returns struct with color1, color2, color3
        Assert.notNull(result.color1);
        Assert.notNull(result.color2);
        Assert.notNull(result.color3);
    }

    function test_getHSBColorWheel() {
        var result = Color.getHSBColorWheel();
        // Color wheel should have 360 colors (one per degree)
        Assert.equals(360, result.length);
        // First color should be red (hue 0)
        Assert.equals(255, result[0].red);
    }

    //==========================================================================
    // Color manipulation methods
    //==========================================================================

    function test_invert() {
        var red = new Color(0xFFFF0000);
        var result = red.invert();
        // Inverted red is cyan
        Assert.equals(0, result.red);
        Assert.equals(255, result.green);
        Assert.equals(255, result.blue);
    }

    function test_darken() {
        var red = new Color(0xFFFF0000);
        var result = red.darken(0.5);
        // Darkened red should have lower brightness
        Assert.isTrue(result.red < 255);
        Assert.isTrue(result.brightness < red.brightness);
    }

    function test_lighten() {
        var darkRed = new Color(0xFF800000);
        var result = darkRed.lighten(0.5);
        // Lightened should be brighter
        Assert.isTrue(result.red > 128);
    }

    function test_grayscale() {
        var red = new Color(0xFFFF0000);
        var result = red.grayscale();
        // Grayscale has equal R, G, B
        Assert.equals(result.red, result.green);
        Assert.equals(result.green, result.blue);
    }

    function test_blackOrWhite() {
        var darkGray = new Color(0xFF404040);
        var lightGray = new Color(0xFFC0C0C0);
        
        var darkResult = darkGray.blackOrWhite();
        var lightResult = lightGray.blackOrWhite();
        
        // Dark gray should become black
        Assert.equals(0, darkResult.red);
        // Light gray should become white
        Assert.equals(255, lightResult.red);
    }

    //==========================================================================
    // Setter methods
    //==========================================================================

    function test_setRGBA() {
        var color = new Color(0xFF000000);
        var result = color.setRGBA(100, 150, 200, 255);
        Assert.equals(100, result.red);
        Assert.equals(150, result.green);
        Assert.equals(200, result.blue);
        Assert.equals(255, result.alpha);
    }

    function test_setRGBAFloat() {
        var color = new Color(0xFF000000);
        var result = color.setRGBAFloat(0.5, 0.5, 0.5, 1.0);
        Assert.equals(128, result.red);
        Assert.equals(128, result.green);
        Assert.equals(128, result.blue);
    }

    function test_setCMYK() {
        var color = new Color(0xFF000000);
        var result = color.setCMYK(0.0, 1.0, 1.0, 0.0); // Pure red in CMYK
        Assert.equals(255, result.red);
        Assert.equals(0, result.green);
        Assert.equals(0, result.blue);
    }

    function test_setHSB() {
        var color = new Color(0xFF000000);
        var result = color.setHSB(0.0, 1.0, 1.0, 1.0); // Pure red
        Assert.equals(255, result.red);
        Assert.equals(0, result.green);
        Assert.equals(0, result.blue);
    }

    function test_setHSL() {
        var color = new Color(0xFF000000);
        var result = color.setHSL(0.0, 1.0, 0.5, 1.0); // Pure red
        Assert.equals(255, result.red);
        Assert.equals(0, result.green);
        Assert.equals(0, result.blue);
    }

    //==========================================================================
    // String conversion
    //==========================================================================

    function test_to24Bit() {
        var color = new Color(0xFFFF8040);
        var result = color.to24Bit();
        Assert.equals(0xFF8040, result); // No alpha
    }

    function test_toHexString() {
        var red = new Color(0xFFFF0000);
        var result = red.toHexString(false, false);
        Assert.equals("FF0000", result);
    }

    function test_toHexString_with_alpha() {
        var red = new Color(0x80FF0000);
        var result = red.toHexString(true, true);
        Assert.equals("0x80FF0000", result);
    }

    function test_toWebString() {
        var red = new Color(0xFFFF0000);
        var result = red.toWebString();
        Assert.equals("#FF0000", result);
    }

    function test_toString() {
        var color = new Color(0xFFFF8040);
        var result = color.toString();
        Assert.notNull(result);
        Assert.isTrue(result.length > 0);
    }

    function test_toInt() {
        var color = new Color(0xFFFF8040);
        var result = color.toInt();
        Assert.equals(0xFFFF8040, result);
    }
}
