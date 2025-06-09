package tests;

import TestResult;
import TestStatus;

import vision.tools.ImageTools;
import haxe.Http;
import vision.formats.ImageIO;
import haxe.io.Path;
import haxe.crypto.Base64;
import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.exceptions.ImageLoadingFailed;
import vision.exceptions.ImageSavingFailed;
import vision.exceptions.LibraryRequired;
import vision.ds.ImageFormat;
import vision.ds.Array2D;
import vision.exceptions.Unimplemented;
import vision.exceptions.WebResponseError;
import vision.ds.ImageResizeAlgorithm;
import haxe.ds.Vector;
import vision.ds.IntPoint2D;
import vision.ds.Point2D;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.tools.ImageTools)
class ImageToolsTests {
    public static function vision_tools_ImageTools__loadFromFile__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var path = "";
			var onComplete = (_) -> null;
			
            vision.tools.ImageTools.loadFromFile(image, path, onComplete);

            return {
                testName: "vision.tools.ImageTools.loadFromFile",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.loadFromFile",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__saveToFile__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var pathWithFileName = "";
			var saveFormat:ImageFormat = null;
			
            vision.tools.ImageTools.saveToFile(image, pathWithFileName, saveFormat);

            return {
                testName: "vision.tools.ImageTools.saveToFile",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.saveToFile",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__loadFromBytes_Image_ByteArray_ImageFormat_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var bytes = vision.ds.ByteArray.from(0);
			var fileFormat:ImageFormat = null;
			
            var result = vision.tools.ImageTools.loadFromBytes(image, bytes, fileFormat);

            return {
                testName: "vision.tools.ImageTools.loadFromBytes",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.loadFromBytes",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__loadFromFile_Image_String_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var path = "";
			
            var result = vision.tools.ImageTools.loadFromFile(image, path);

            return {
                testName: "vision.tools.ImageTools.loadFromFile",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.loadFromFile",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__loadFromURL_Image_String_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var url = "";
			
            var result = vision.tools.ImageTools.loadFromURL(image, url);

            return {
                testName: "vision.tools.ImageTools.loadFromURL",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.loadFromURL",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__exportToBytes_Image_ImageFormat_ByteArray__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var format:ImageFormat = null;
			
            var result = vision.tools.ImageTools.exportToBytes(image, format);

            return {
                testName: "vision.tools.ImageTools.exportToBytes",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.exportToBytes",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__exportToFile__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var pathWithFileName = "";
			var format:ImageFormat = null;
			
            vision.tools.ImageTools.exportToFile(image, pathWithFileName, format);

            return {
                testName: "vision.tools.ImageTools.exportToFile",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.exportToFile",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__addToScreen_Image_Int_Int_xUnitsStringyUnitsStringzIndexString_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var x = 0;
			var y = 0;
			var units:{?xUnits:String, ?yUnits:String, ?zIndex:String} = null;
			
            var result = vision.tools.ImageTools.addToScreen(image, x, y, units);

            return {
                testName: "vision.tools.ImageTools.addToScreen",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.addToScreen",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__getNeighborsOfPixel_Image_Int_Int_Int_Array2DColor__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var x = 0;
			var y = 0;
			var kernelSize = 0;
			
            var result = vision.tools.ImageTools.getNeighborsOfPixel(image, x, y, kernelSize);

            return {
                testName: "vision.tools.ImageTools.getNeighborsOfPixel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.getNeighborsOfPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_ImageTools__grayscalePixel_Color_Color__ShouldWork():TestResult {
        try {
            var pixel:Color = null;
			
            var result = vision.tools.ImageTools.grayscalePixel(pixel);

            return {
                testName: "vision.tools.ImageTools.grayscalePixel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.ImageTools.grayscalePixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}