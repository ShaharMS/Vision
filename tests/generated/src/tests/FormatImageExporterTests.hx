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

@:access(vision.formats.__internal.FormatImageExporter)
class FormatImageExporterTests {
    public static function vision_formats___internal_FormatImageExporter__png_Image_ByteArray__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.formats.__internal.FormatImageExporter.png(image);

            return {
                testName: "vision.formats.__internal.FormatImageExporter.png",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.formats.__internal.FormatImageExporter.png",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_formats___internal_FormatImageExporter__bmp_Image_ByteArray__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.formats.__internal.FormatImageExporter.bmp(image);

            return {
                testName: "vision.formats.__internal.FormatImageExporter.bmp",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.formats.__internal.FormatImageExporter.bmp",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_formats___internal_FormatImageExporter__jpeg_Image_ByteArray__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.formats.__internal.FormatImageExporter.jpeg(image);

            return {
                testName: "vision.formats.__internal.FormatImageExporter.jpeg",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.formats.__internal.FormatImageExporter.jpeg",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}