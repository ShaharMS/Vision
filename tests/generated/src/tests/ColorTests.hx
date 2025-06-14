package tests;

import TestResult;
import TestStatus;

import vision.ds.Color;
import vision.tools.ArrayTools;
import vision.tools.MathTools;

@:access(vision.ds.Color)
class ColorTests {
    public static function vision_ds_Color__red__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.red;
        
            return {
                testName: "vision.ds.Color#red",
                returned: result,
                expected: 0xFF,
                status: TestStatus.of(result == 0xFF)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#red",
                returned: e,
                expected: 0xFF,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__blue__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.blue;
        
            return {
                testName: "vision.ds.Color#blue",
                returned: result,
                expected: 0x34,
                status: TestStatus.of(result == 0x34)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#blue",
                returned: e,
                expected: 0x34,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__green__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.green;
        
            return {
                testName: "vision.ds.Color#green",
                returned: result,
                expected: 0x76,
                status: TestStatus.of(result == 0x76)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#green",
                returned: e,
                expected: 0x76,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__alpha__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.alpha;
        
            return {
                testName: "vision.ds.Color#alpha",
                returned: result,
                expected: 0xFF,
                status: TestStatus.of(result == 0xFF)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#alpha",
                returned: e,
                expected: 0xFF,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__redFloat__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.redFloat;
        
            return {
                testName: "vision.ds.Color#redFloat",
                returned: result,
                expected: 1.0,
                status: TestStatus.of(result == 1.0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#redFloat",
                returned: e,
                expected: 1.0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__blueFloat__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.blueFloat;
        
            return {
                testName: "vision.ds.Color#blueFloat",
                returned: result,
                expected: 0x34 / 255.0,
                status: TestStatus.of(result == 0x34 / 255.0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#blueFloat",
                returned: e,
                expected: 0x34 / 255.0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__greenFloat__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.greenFloat;
        
            return {
                testName: "vision.ds.Color#greenFloat",
                returned: result,
                expected: 0x76 / 255.0,
                status: TestStatus.of(result == 0x76 / 255.0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#greenFloat",
                returned: e,
                expected: 0x76 / 255.0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__alphaFloat__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.alphaFloat;
        
            return {
                testName: "vision.ds.Color#alphaFloat",
                returned: result,
                expected: 1.0,
                status: TestStatus.of(result == 1.0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#alphaFloat",
                returned: e,
                expected: 1.0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__cyan__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.cyan;
        
            return {
                testName: "vision.ds.Color#cyan",
                returned: result,
                expected: 0,
                status: TestStatus.of(result == 0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#cyan",
                returned: e,
                expected: 0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__magenta__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.magenta;
        
            return {
                testName: "vision.ds.Color#magenta",
                returned: result,
                expected: 54,
                status: TestStatus.of(result == 54)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#magenta",
                returned: e,
                expected: 54,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__yellow__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.yellow;
        
            return {
                testName: "vision.ds.Color#yellow",
                returned: result,
                expected: 80,
                status: TestStatus.of(result == 80)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#yellow",
                returned: e,
                expected: 80,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__black__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.black;
        
            return {
                testName: "vision.ds.Color#black",
                returned: result,
                expected: 0,
                status: TestStatus.of(result == 0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#black",
                returned: e,
                expected: 0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__rgb__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.rgb;
        
            return {
                testName: "vision.ds.Color#rgb",
                returned: result,
                expected: 0xFF7634,
                status: TestStatus.of(result == 0xFF7634)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#rgb",
                returned: e,
                expected: 0xFF7634,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__hue__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.hue;
        
            return {
                testName: "vision.ds.Color#hue",
                returned: result,
                expected: 20.0,
                status: TestStatus.of(result == 20.0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#hue",
                returned: e,
                expected: 20.0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__saturation__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.saturation;
        
            return {
                testName: "vision.ds.Color#saturation",
                returned: result,
                expected: 1.0,
                status: TestStatus.of(result == 1.0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#saturation",
                returned: e,
                expected: 1.0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__brightness__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.brightness;
        
            return {
                testName: "vision.ds.Color#brightness",
                returned: result,
                expected: 1,
                status: TestStatus.of(result == 1)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#brightness",
                returned: e,
                expected: 1,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__lightness__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var object = new vision.ds.Color(value);
            var result = object.lightness;
        
            return {
                testName: "vision.ds.Color#lightness",
                returned: result,
                expected: 0.6,
                status: TestStatus.of(result == 0.6)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#lightness",
                returned: e,
                expected: 0.6,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__fromInt_Int_Color__ShouldWork():TestResult {
        try {
            var value = 0xFFFF7634;
			
            var result = vision.ds.Color.fromInt(value);

            return {
                testName: "vision.ds.Color.fromInt",
                returned: result,
                expected: 0xFFFF7634,
                status: TestStatus.of(result == 0xFFFF7634)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.fromInt",
                returned: e,
                expected: 0xFFFF7634,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__fromRGBA_Int_Int_Int_Int_Color__ShouldWork():TestResult {
        try {
            var Red = 128;
			var Green = 128;
			var Blue = 34;
			var Alpha = 44;
			
            var result = vision.ds.Color.fromRGBA(Red, Green, Blue, Alpha);

            return {
                testName: "vision.ds.Color.fromRGBA",
                returned: result,
                expected: 0x2C808022,
                status: TestStatus.of(result == 0x2C808022)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.fromRGBA",
                returned: e,
                expected: 0x2C808022,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__from8Bit_Int_Color__ShouldWork():TestResult {
        try {
            var Value = 0x11;
			
            var result = vision.ds.Color.from8Bit(Value);

            return {
                testName: "vision.ds.Color.from8Bit",
                returned: result,
                expected: 0xFF111111,
                status: TestStatus.of(result == 0xFF111111)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.from8Bit",
                returned: e,
                expected: 0xFF111111,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__fromFloat_Float_Color__ShouldWork():TestResult {
        try {
            var Value = 0.5;
			
            var result = vision.ds.Color.fromFloat(Value);

            return {
                testName: "vision.ds.Color.fromFloat",
                returned: result,
                expected: 0xFF808080,
                status: TestStatus.of(result == 0xFF808080)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.fromFloat",
                returned: e,
                expected: 0xFF808080,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__fromRGBAFloat_Float_Float_Float_Float_Color__ShouldWork():TestResult {
        try {
            var Red = 0.5;
			var Green = 0.5;
			var Blue = 0.5;
			var Alpha = 0.5;
			
            var result = vision.ds.Color.fromRGBAFloat(Red, Green, Blue, Alpha);

            return {
                testName: "vision.ds.Color.fromRGBAFloat",
                returned: result,
                expected: 0x80808080,
                status: TestStatus.of(result == 0x80808080)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.fromRGBAFloat",
                returned: e,
                expected: 0x80808080,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__fromCMYK_Float_Float_Float_Float_Float_Color__ShouldWork():TestResult {
        try {
            var Cyan = 0.0;
			var Magenta = 0.0;
			var Yellow = 0.0;
			var Black = 0.0;
			var Alpha = 0.0;
			
            var result = vision.ds.Color.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);

            return {
                testName: "vision.ds.Color.fromCMYK",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.fromCMYK",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__fromHSB_Float_Float_Float_Float_Color__ShouldWork():TestResult {
        try {
            var Hue = 0.0;
			var Saturation = 0.0;
			var Brightness = 0.0;
			var Alpha = 0.0;
			
            var result = vision.ds.Color.fromHSB(Hue, Saturation, Brightness, Alpha);

            return {
                testName: "vision.ds.Color.fromHSB",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.fromHSB",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__fromHSL_Float_Float_Float_Float_Color__ShouldWork():TestResult {
        try {
            var Hue = 0.0;
			var Saturation = 0.0;
			var Lightness = 0.0;
			var Alpha = 0.0;
			
            var result = vision.ds.Color.fromHSL(Hue, Saturation, Lightness, Alpha);

            return {
                testName: "vision.ds.Color.fromHSL",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.fromHSL",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__fromString_String_NullColor__ShouldWork():TestResult {
        try {
            var str = "";
			var sets = ["0x00FF00"      => 0xFF00FF00,
                        "0xAA4578C2"    => 0xAA4578C2,
                        "#0000FF"       => 0xFF0000FF,
                        "#3F000011"     => 0x3F000011,
                        "GRAY"          => 0xFF808080,
                        "blue"          => 0xFF0000FF];
            var result = [for (key in sets.keys()) key].map(key -> Color.fromString(key));

            return {
                testName: "vision.ds.Color.fromString",
                returned: result,
                expected: [for (value in sets.iterator()) value],
                status: TestStatus.of(result == [for (value in sets.iterator()) value])
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.fromString",
                returned: e,
                expected: [0xFF00FF00, 0xAA4578C2, 0xFF0000FF, 0x3F000011, 0xFF808080, 0xFF0000FF],
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__getHSBColorWheel_Int_ArrayColor__ShouldWork():TestResult {
        try {
            var Alpha = 0;
			
            var result = vision.ds.Color.getHSBColorWheel(Alpha);

            return {
                testName: "vision.ds.Color.getHSBColorWheel",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.getHSBColorWheel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__interpolate_Color_Color_Float_Color__ShouldWork():TestResult {
        try {
            var Color1:Color = 0xFF00FF00;
			var Color2:Color = 0x00FF00FF;
			var Factor = 0.5;
			
            var result = vision.ds.Color.interpolate(Color1, Color2, Factor);

            return {
                testName: "vision.ds.Color.interpolate",
                returned: result,
                expected: 0x7F7F7F7F,
                status: TestStatus.of(result == 0x7F7F7F7F)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.interpolate",
                returned: e,
                expected: 0x7F7F7F7F,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__gradient_Color_Color_Int_FloatFloat_ArrayColor__ShouldWork():TestResult {
        try {
            var Color1:Color = null;
			var Color2:Color = null;
			var Steps = 0;
			var Ease = (_) -> null;
			
            var result = vision.ds.Color.gradient(Color1, Color2, Steps, Ease);

            return {
                testName: "vision.ds.Color.gradient",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.gradient",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__makeRandom_Bool_Int_Color__ShouldWork():TestResult {
        try {
			var alphaValue = 0;
			
            var result = vision.ds.Color.makeRandom(alphaValue);

            return {
                testName: "vision.ds.Color.makeRandom",
                returned: result.alpha,
                expected: 0,
                status: TestStatus.of(result.alpha == 0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.makeRandom",
                returned: e,
                expected: 0,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__multiply_Color_Color_Color__ShouldWork():TestResult {
        try {
            var lhs:Color = 0x020202;
			var rhs:Color = 0x030303;
			
            var result = vision.ds.Color.multiply(lhs, rhs);

            return {
                testName: "vision.ds.Color.multiply",
                returned: result,
                expected: 0x060606,
                status: TestStatus.of(result == 0x060606)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.multiply",
                returned: e,
                expected: 0x060606,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__add_Color_Color_Color__ShouldWork():TestResult {
        try {
            var lhs:Color = 0x020202;
			var rhs:Color = 0x030303;
			
            var result = vision.ds.Color.add(lhs, rhs);

            return {
                testName: "vision.ds.Color.add",
                returned: result,
                expected: 0x050505,
                status: TestStatus.of(result == 0x050505)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.add",
                returned: e,
                expected: 0x050505,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__subtract_Color_Color_Color__ShouldWork():TestResult {
        try {
            var lhs:Color = 0x040404;
			var rhs:Color = 0x030303;
			
            var result = vision.ds.Color.subtract(lhs, rhs);

            return {
                testName: "vision.ds.Color.subtract",
                returned: result,
                expected: 0x010101,
                status: TestStatus.of(result == 0x010101)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.subtract",
                returned: e,
                expected: 0x010101,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__divide_Color_Color_Color__ShouldWork():TestResult {
        try {
            var lhs:Color = 0x060606;
			var rhs:Color = 0x010101;
			
            var result = vision.ds.Color.divide(lhs, rhs);

            return {
                testName: "vision.ds.Color.divide",
                returned: result,
                expected: 0x060606,
                status: TestStatus.of(result == 0x060606)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.divide",
                returned: e,
                expected: 0x060606,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__distanceBetween_Color_Color_Bool_Float__ShouldWork():TestResult {
        try {
            var lhs:Color = 0x020202;
			var rhs:Color = 0x010101;
			var considerTransparency = false;
			
            var result = vision.ds.Color.distanceBetween(lhs, rhs, considerTransparency);

            return {
                testName: "vision.ds.Color.distanceBetween",
                returned: result,
                expected: MathTools.SQRT3,
                status: TestStatus.of(result == MathTools.SQRT3)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.distanceBetween",
                returned: e,
                expected: MathTools.SQRT3,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__differenceBetween_Color_Color_Bool_Float__ShouldWork():TestResult {
        try {
            var lhs:Color = Color.WHITE;
			var rhs:Color = Color.BLACK;
			var considerTransparency = false;
			
            var result = vision.ds.Color.differenceBetween(lhs, rhs, considerTransparency);

            return {
                testName: "vision.ds.Color.differenceBetween",
                returned: result,
                expected: 1,
                status: TestStatus.of(result == 1)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.differenceBetween",
                returned: e,
                expected: 1,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__getAverage_ArrayColor_Bool_Color__ShouldWork():TestResult {
        try {
            var fromColors = [Color.RED, Color.GREEN, Color.BLUE];
			var considerTransparency = false;
			
            var result = vision.ds.Color.getAverage(fromColors, considerTransparency);

            return {
                testName: "vision.ds.Color.getAverage",
                returned: result,
                expected: 0xFF555555,
                status: TestStatus.of(result == 0xFF555555)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color.getAverage",
                returned: e,
                expected: 0xFF555555,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__getComplementHarmony__Color__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            
            var object = new vision.ds.Color(value);
            var result = object.getComplementHarmony();
            
            return {
                testName: "vision.ds.Color#getComplementHarmony",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#getComplementHarmony",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__getAnalogousHarmony_Int_Harmony__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            var Threshold = 0;
			
            var object = new vision.ds.Color(value);
            var result = object.getAnalogousHarmony(Threshold);
            
            return {
                testName: "vision.ds.Color#getAnalogousHarmony",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#getAnalogousHarmony",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__getSplitComplementHarmony_Int_Harmony__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            var Threshold = 0;
			
            var object = new vision.ds.Color(value);
            var result = object.getSplitComplementHarmony(Threshold);
            
            return {
                testName: "vision.ds.Color#getSplitComplementHarmony",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#getSplitComplementHarmony",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__getTriadicHarmony__TriadicHarmony__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            
            var object = new vision.ds.Color(value);
            var result = object.getTriadicHarmony();
            
            return {
                testName: "vision.ds.Color#getTriadicHarmony",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#getTriadicHarmony",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__to24Bit__Color__ShouldWork():TestResult {
        try { 
            var value = 0x55555555;
			
            
            var object = new vision.ds.Color(value);
            var result = object.to24Bit();
            
            return {
                testName: "vision.ds.Color#to24Bit",
                returned: result,
                expected: 0x555555,
                status: TestStatus.of(result == 0x555555)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#to24Bit",
                returned: e,
                expected: 0x555555,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__toHexString_Bool_Bool_String__ShouldWork():TestResult {
        try { 
            var value = Color.ROYAL_BLUE;
			
            var Alpha = true;
			var Prefix = true;
			
            var object = new vision.ds.Color(value);
            var result = object.toHexString(Alpha, Prefix);
            
            return {
                testName: "vision.ds.Color#toHexString",
                returned: result,
                expected: "0xFF4169E1",
                status: TestStatus.of(result == "0xFF4169E1")
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#toHexString",
                returned: e,
                expected: "0xFF4169E1",
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__toWebString__String__ShouldWork():TestResult {
        try { 
            var value = Color.ROYAL_BLUE;
			
            
            var object = new vision.ds.Color(value);
            var result = object.toWebString();
            
            return {
                testName: "vision.ds.Color#toWebString",
                returned: result,
                expected: "#4169E1",
                status: TestStatus.of(result == "#4169E1")
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#toWebString",
                returned: e,
                expected: "#4169E1",
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__darken_Float_Color__ShouldWork():TestResult {
        try { 
            var value = Color.WHITE;
			
            var Factor = 0.5;
			
            var object = new vision.ds.Color(value);
            var result = object.darken(Factor);
            
            return {
                testName: "vision.ds.Color#darken",
                returned: result,
                expected: 0xFF7F7F7F,
                status: TestStatus.of(result == 0xFF7F7F7F)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#darken",
                returned: e,
                expected: 0xFF7F7F7F,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__lighten_Float_Color__ShouldWork():TestResult {
        try { 
            var value = Color.BLACK;
			
            var Factor = 0.5;
			
            var object = new vision.ds.Color(value);
            var result = object.lighten(Factor);
            
            return {
                testName: "vision.ds.Color#lighten",
                returned: result,
                expected: 0xFF7F7F7F,
                status: TestStatus.of(result == 0xFF7F7F7F)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#lighten",
                returned: e,
                expected: 0xFF7F7F7F,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__invert__Color__ShouldWork():TestResult {
        try { 
            var value = Color.AMETHYST;
			
            
            var object = new vision.ds.Color(value);
            var result = object.invert();
            return {
                testName: "vision.ds.Color#invert",
                returned: result,
                expected: 0xFF669933,
                status: TestStatus.of(result == 0xFF669933)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#invert",
                returned: e,
                expected: 0xFF669933,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__setRGBA_Int_Int_Int_Int_Color__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            var Red = 10;
			var Green = 20;
			var Blue = 30;
			var Alpha = 40;
			
            var object = new vision.ds.Color(value);
            var result = object.setRGBA(Red, Green, Blue, Alpha);
            
            return {
                testName: "vision.ds.Color#setRGBA",
                returned: result,
                expected: 0x281E140A,
                status: TestStatus.of(result == 0x281E140A)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#setRGBA",
                returned: e,
                expected: 0x281E140A,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__setRGBAFloat_Float_Float_Float_Float_Color__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            var Red = 0.5;
			var Green = 0.5;
			var Blue = 0.5;
			var Alpha = 0.5;
			
            var object = new vision.ds.Color(value);
            var result = object.setRGBAFloat(Red, Green, Blue, Alpha);
            
            return {
                testName: "vision.ds.Color#setRGBAFloat",
                returned: result,
                expected: 0x7F7F7F7F,
                status: TestStatus.of(result == 0x7F7F7F7F)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#setRGBAFloat",
                returned: e,
                expected: 0x7F7F7F7F,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__setCMYK_Float_Float_Float_Float_Float_Color__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            var Cyan = 0.0;
			var Magenta = 0.0;
			var Yellow = 0.0;
			var Black = 0.0;
			var Alpha = 0.0;
			
            var object = new vision.ds.Color(value);
            var result = object.setCMYK(Cyan, Magenta, Yellow, Black, Alpha);
            
            return {
                testName: "vision.ds.Color#setCMYK",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#setCMYK",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__setHSB_Float_Float_Float_Float_Color__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            var Hue = 0.0;
			var Saturation = 0.0;
			var Brightness = 0.0;
			var Alpha = 0.0;
			
            var object = new vision.ds.Color(value);
            var result = object.setHSB(Hue, Saturation, Brightness, Alpha);
            
            return {
                testName: "vision.ds.Color#setHSB",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#setHSB",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__setHSL_Float_Float_Float_Float_Color__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            var Hue = 0.0;
			var Saturation = 0.0;
			var Lightness = 0.0;
			var Alpha = 0.0;
			
            var object = new vision.ds.Color(value);
            var result = object.setHSL(Hue, Saturation, Lightness, Alpha);
            
            return {
                testName: "vision.ds.Color#setHSL",
                returned: result,
                expected: null,
                status: Skipped
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#setHSL",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__grayscale_Bool_Color__ShouldWork():TestResult {
        try { 
            var object = Color.ALABASTER;

            var resultRegular = object.grayscale(false);
            var resultSimple = object.grayscale(true);
            
            return {
                testName: "vision.ds.Color#grayscale",
                returned: '${resultRegular.toHexString()}, Then: ${resultSimple.toHexString()}',
                expected: '${Color.from8Bit(Std.int(0.2126 * object.red + 0.7152 * object.green + 0.0722 * object.blue)).toHexString()}, Then: ${Color.from8Bit(Std.int((object.red + object.green + object.blue) / 3)).toHexString()}',
                status: TestStatus.multiple(
                    TestStatus.of(resultRegular.red == Std.int(0.2126 * object.red + 0.7152 * object.green + 0.0722 * object.blue)),
                    TestStatus.of(resultSimple.red == Std.int((object.red + object.green + object.blue) / 3))
                )
            }
        } catch (e) {
            var object = Color.ALABASTER;
            return {
                testName: "vision.ds.Color#grayscale",
                returned: e,
                expected: '${Color.from8Bit(Std.int(0.2126 * object.red + 0.7152 * object.green + 0.0722 * object.blue)).toHexString()}, Then: ${Color.from8Bit(Std.int((object.red + object.green + object.blue) / 3)).toHexString()}',
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__blackOrWhite_Int_Color__ShouldWork():TestResult {
        try { 
            var value = 0xFF45E312;
			
            var threshold = 0;
			
            var object = new vision.ds.Color(value);
            var result = object.blackOrWhite(threshold);
            
            return {
                testName: "vision.ds.Color#blackOrWhite",
                returned: result,
                expected: 0xFFFFFFFF,
                status: TestStatus.of(result == 0xFFFFFFFF)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#blackOrWhite",
                returned: e,
                expected: 0xFFFFFFFF,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__toString__ShouldWork():TestResult {
        try { 
            var value = Color.AZURE;
			
            
            var object = new vision.ds.Color(value);
            object.toString();
            
            return {
                testName: "vision.ds.Color#toString",
                returned: #if console.hx '<bg${object.toWebString()}>  </>' #else object.toHexString(true, true) #end,
                expected: #if console.hx '<bg#007FFF>  </>' #else "0xFF007FFF" #end,
                status: TestStatus.of(object.toString() == #if console.hx '<bg#007FFF>  </>' #else "0xFF007FFF" #end)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#toString",
                returned: e,
                expected: #if console.hx '<bg#007FFF>  </>' #else "0xFF007FFF" #end,
                status: Failure
            }
        }
    }

    public static function vision_ds_Color__toInt__Int__ShouldWork():TestResult {
        try { 
            var value = 0;
			
            
            var object = new vision.ds.Color(value);
            var result = object.toInt();
            
            return {
                testName: "vision.ds.Color#toInt",
                returned: result,
                expected: 0,
                status: TestStatus.of(result == 0)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Color#toInt",
                returned: e,
                expected: 0,
                status: Failure
            }
        }
    }


}