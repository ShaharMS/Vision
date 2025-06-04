package tests;

import TestResult;
import TestStatus;

import vision.formats.__internal.FormatImageExporter;
import vision.ds.PixelFormat;
import vision.ds.ByteArray;
import haxe.io.BytesOutput;
import vision.ds.Image;
import vision.ds.ImageFormat;
import vision.exceptions.ImageSavingFailed;
import format.png.Writer;
import format.png.Tools;
import format.bmp.Writer;
import format.bmp.Tools;
import format.jpg.Writer;
import format.jpg.Data;

class FormatImageExporterTests {
    public static function vision_formats___internal_FormatImageExporter__png__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.formats.__internal.FormatImageExporter.png((null : Image));
        } catch (e) {
            
        }

        return {
            testName: "vision.formats.__internal.FormatImageExporter.png",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_formats___internal_FormatImageExporter__jpeg__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.formats.__internal.FormatImageExporter.jpeg((null : Image));
        } catch (e) {
            
        }

        return {
            testName: "vision.formats.__internal.FormatImageExporter.jpeg",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_formats___internal_FormatImageExporter__bmp__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.formats.__internal.FormatImageExporter.bmp((null : Image));
        } catch (e) {
            
        }

        return {
            testName: "vision.formats.__internal.FormatImageExporter.bmp",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_formats___internal_FormatImageExporter__png__ShouldWork, 
		vision_formats___internal_FormatImageExporter__jpeg__ShouldWork, 
		vision_formats___internal_FormatImageExporter__bmp__ShouldWork];
}