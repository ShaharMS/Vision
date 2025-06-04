package tests;

import TestResult;
import TestStatus;

import vision.formats.__internal.FormatImageLoader;
import haxe.io.BytesInput;
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;
import vision.ds.ByteArray;
import format.png.Reader;
import format.png.Tools;
import format.bmp.Reader;
import format.bmp.Tools;

class FormatImageLoaderTests {
    public static function vision_formats___internal_FormatImageLoader__png__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.formats.__internal.FormatImageLoader.png((null : ByteArray));
        } catch (e) {
            
        }

        return {
            testName: "vision.formats.__internal.FormatImageLoader.png",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_formats___internal_FormatImageLoader__bmp__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.formats.__internal.FormatImageLoader.bmp((null : ByteArray));
        } catch (e) {
            
        }

        return {
            testName: "vision.formats.__internal.FormatImageLoader.bmp",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_formats___internal_FormatImageLoader__png__ShouldWork, 
		vision_formats___internal_FormatImageLoader__bmp__ShouldWork];
}