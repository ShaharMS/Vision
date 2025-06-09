package tests;

import TestResult;
import TestStatus;

import vision.ds.Image;
import vision.formats.ImageIO;
import vision.ds.ByteArray;
import vision.exceptions.Unimplemented;
import vision.algorithms.BilinearInterpolation;
import haxe.ds.List;
import haxe.Int64;
import vision.ds.Color;
import vision.ds.Rectangle;
import vision.ds.ImageView;
import vision.ds.ImageResizeAlgorithm;
import vision.exceptions.OutOfBounds;
import vision.tools.ImageTools;

@:access(vision.ds.Image)
class ImageTests {
    public static function vision_ds_Image__view__ShouldWork():TestResult {
        try {
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.view;
        
            return {
                testName: "vision.ds.Image#view",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#view",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__from2DArray_Array_Image__ShouldWork():TestResult {
        try {
            var array = [];
			
            var result = vision.ds.Image.from2DArray(array);

            return {
                testName: "vision.ds.Image.from2DArray",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image.from2DArray",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__getSafePixel_Int_Int_Color__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.getSafePixel(x, y);
            
            return {
                testName: "vision.ds.Image#getSafePixel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#getSafePixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__getFloatingPixel_Float_Float_Color__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.getFloatingPixel(x, y);
            
            return {
                testName: "vision.ds.Image#getFloatingPixel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#getFloatingPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__setPixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.setPixel(x, y, color);
            
            return {
                testName: "vision.ds.Image#setPixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#setPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__setSafePixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.setSafePixel(x, y, color);
            
            return {
                testName: "vision.ds.Image#setSafePixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#setSafePixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__setFloatingPixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.setFloatingPixel(x, y, color);
            
            return {
                testName: "vision.ds.Image#setFloatingPixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#setFloatingPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__paintPixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.paintPixel(x, y, color);
            
            return {
                testName: "vision.ds.Image#paintPixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#paintPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__paintFloatingPixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.paintFloatingPixel(x, y, color);
            
            return {
                testName: "vision.ds.Image#paintFloatingPixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#paintFloatingPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__paintSafePixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var color = 0;
			
            var object = new vision.ds.Image(width, height, color);
            object.paintSafePixel(x, y, color);
            
            return {
                testName: "vision.ds.Image#paintSafePixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#paintSafePixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__hasPixel_Float_Float_Bool__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.hasPixel(x, y);
            
            return {
                testName: "vision.ds.Image#hasPixel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#hasPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__movePixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var fromX = 0;
			var fromY = 0;
			var toX = 0;
			var toY = 0;
			var oldPixelResetColor:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.movePixel(fromX, fromY, toX, toY, oldPixelResetColor);
            
            return {
                testName: "vision.ds.Image#movePixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#movePixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__moveSafePixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var fromX = 0;
			var fromY = 0;
			var toX = 0;
			var toY = 0;
			var oldPixelResetColor:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.moveSafePixel(fromX, fromY, toX, toY, oldPixelResetColor);
            
            return {
                testName: "vision.ds.Image#moveSafePixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#moveSafePixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__moveFloatingPixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var fromX = 0.0;
			var fromY = 0.0;
			var toX = 0.0;
			var toY = 0.0;
			var oldPixelResetColor:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.moveFloatingPixel(fromX, fromY, toX, toY, oldPixelResetColor);
            
            return {
                testName: "vision.ds.Image#moveFloatingPixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#moveFloatingPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__moveUnsafePixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var fromX = 0;
			var fromY = 0;
			var toX = 0;
			var toY = 0;
			var oldPixelResetColor:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.moveUnsafePixel(fromX, fromY, toX, toY, oldPixelResetColor);
            
            return {
                testName: "vision.ds.Image#moveUnsafePixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#moveUnsafePixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__copyPixelFrom_Image_Int_Int_Color__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var image = new vision.ds.Image(100, 100);
			var x = 0;
			var y = 0;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.copyPixelFrom(image, x, y);
            
            return {
                testName: "vision.ds.Image#copyPixelFrom",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#copyPixelFrom",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__copyPixelTo_Image_Int_Int_Color__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var image = new vision.ds.Image(100, 100);
			var x = 0;
			var y = 0;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.copyPixelTo(image, x, y);
            
            return {
                testName: "vision.ds.Image#copyPixelTo",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#copyPixelTo",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__copyImageFrom_Image_Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var image = new vision.ds.Image(100, 100);
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.copyImageFrom(image);
            
            return {
                testName: "vision.ds.Image#copyImageFrom",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#copyImageFrom",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__getImagePortion_Rectangle_Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var rect:Rectangle = null;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.getImagePortion(rect);
            
            return {
                testName: "vision.ds.Image#getImagePortion",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#getImagePortion",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__setImagePortion__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var rect:Rectangle = null;
			var image = new vision.ds.Image(100, 100);
			
            var object = new vision.ds.Image(width, height, color);
            object.setImagePortion(rect, image);
            
            return {
                testName: "vision.ds.Image#setImagePortion",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#setImagePortion",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__drawLine__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x1 = 0;
			var y1 = 0;
			var x2 = 0;
			var y2 = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawLine(x1, y1, x2, y2, color);
            
            return {
                testName: "vision.ds.Image#drawLine",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#drawLine",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__drawRay2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var line = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawRay2D(line, color);
            
            return {
                testName: "vision.ds.Image#drawRay2D",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#drawRay2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__drawLine2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawLine2D(line, color);
            
            return {
                testName: "vision.ds.Image#drawLine2D",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#drawLine2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__fillRect__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var width = 0;
			var height = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillRect(x, y, width, height, color);
            
            return {
                testName: "vision.ds.Image#fillRect",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#fillRect",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__drawRect__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var width = 0;
			var height = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawRect(x, y, width, height, color);
            
            return {
                testName: "vision.ds.Image#drawRect",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#drawRect",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__drawQuadraticBezier__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var control = new vision.ds.IntPoint2D(0, 0);
			var color:Color = null;
			var accuracy = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawQuadraticBezier(line, control, color, accuracy);
            
            return {
                testName: "vision.ds.Image#drawQuadraticBezier",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#drawQuadraticBezier",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__drawCubicBezier__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var control1 = new vision.ds.IntPoint2D(0, 0);
			var control2 = new vision.ds.IntPoint2D(0, 0);
			var color:Color = null;
			var accuracy = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawCubicBezier(line, control1, control2, color, accuracy);
            
            return {
                testName: "vision.ds.Image#drawCubicBezier",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#drawCubicBezier",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__fillCircle__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var X = 0;
			var Y = 0;
			var r = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillCircle(X, Y, r, color);
            
            return {
                testName: "vision.ds.Image#fillCircle",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#fillCircle",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__drawCircle__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var X = 0;
			var Y = 0;
			var r = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawCircle(X, Y, r, color);
            
            return {
                testName: "vision.ds.Image#drawCircle",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#drawCircle",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__fillEllipse__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var centerX = 0;
			var centerY = 0;
			var radiusX = 0;
			var radiusY = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillEllipse(centerX, centerY, radiusX, radiusY, color);
            
            return {
                testName: "vision.ds.Image#fillEllipse",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#fillEllipse",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__drawEllipse__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var centerX = 0;
			var centerY = 0;
			var radiusX = 0;
			var radiusY = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawEllipse(centerX, centerY, radiusX, radiusY, color);
            
            return {
                testName: "vision.ds.Image#drawEllipse",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#drawEllipse",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__fillColorRecursive__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var position = new vision.ds.IntPoint2D(0, 0);
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillColorRecursive(position, color);
            
            return {
                testName: "vision.ds.Image#fillColorRecursive",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#fillColorRecursive",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__fillColor__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var position = new vision.ds.IntPoint2D(0, 0);
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillColor(position, color);
            
            return {
                testName: "vision.ds.Image#fillColor",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#fillColor",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__fillUntilColor__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var position = new vision.ds.IntPoint2D(0, 0);
			var color:Color = null;
			var borderColor:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillUntilColor(position, color, borderColor);
            
            return {
                testName: "vision.ds.Image#fillUntilColor",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#fillUntilColor",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__clone__Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            var result = object.clone();
            
            return {
                testName: "vision.ds.Image#clone",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#clone",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__mirror__Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            var result = object.mirror();
            
            return {
                testName: "vision.ds.Image#mirror",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#mirror",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__flip__Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            var result = object.flip();
            
            return {
                testName: "vision.ds.Image#flip",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#flip",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__stamp_Int_Int_Image_Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var X = 0;
			var Y = 0;
			var image = new vision.ds.Image(100, 100);
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.stamp(X, Y, image);
            
            return {
                testName: "vision.ds.Image#stamp",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#stamp",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__resize_Int_Int_ImageResizeAlgorithm_Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var newWidth = 0;
			var newHeight = 0;
			var algorithm:ImageResizeAlgorithm = null;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.resize(newWidth, newHeight, algorithm);
            
            return {
                testName: "vision.ds.Image#resize",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#resize",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__rotate_Float_Bool_Bool_Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var angle = 0.0;
			var degrees = false;
			var expandImageBounds = false;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.rotate(angle, degrees, expandImageBounds);
            
            return {
                testName: "vision.ds.Image#rotate",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#rotate",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__toString_Bool_String__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var special = false;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.toString(special);
            
            return {
                testName: "vision.ds.Image#toString",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#toString",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__forEachPixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var callback = (_, _, _) -> null;
			
            var object = new vision.ds.Image(width, height, color);
            object.forEachPixel(callback);
            
            return {
                testName: "vision.ds.Image#forEachPixel",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#forEachPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__forEachPixelInView__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var callback = (_, _, _) -> null;
			
            var object = new vision.ds.Image(width, height, color);
            object.forEachPixelInView(callback);
            
            return {
                testName: "vision.ds.Image#forEachPixelInView",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#forEachPixelInView",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__iterator__IteratorPixel__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            var result = object.iterator();
            
            return {
                testName: "vision.ds.Image#iterator",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#iterator",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__center__Point2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            var result = object.center();
            
            return {
                testName: "vision.ds.Image#center",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#center",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__pixelToRelative_Point2D_Point2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.pixelToRelative(point);
            
            return {
                testName: "vision.ds.Image#pixelToRelative",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#pixelToRelative",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__pixelToRelative_Float_Float_Point2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.pixelToRelative(x, y);
            
            return {
                testName: "vision.ds.Image#pixelToRelative",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#pixelToRelative",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__relativeToPixel_Point2D_Point2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.relativeToPixel(point);
            
            return {
                testName: "vision.ds.Image#relativeToPixel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#relativeToPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__relativeToPixel_Float_Float_Point2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.relativeToPixel(x, y);
            
            return {
                testName: "vision.ds.Image#relativeToPixel",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#relativeToPixel",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__hasView__Bool__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            var result = object.hasView();
            
            return {
                testName: "vision.ds.Image#hasView",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#hasView",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__setView_ImageView_Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var view:ImageView = null;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.setView(view);
            
            return {
                testName: "vision.ds.Image#setView",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#setView",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__getView__ImageView__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            var result = object.getView();
            
            return {
                testName: "vision.ds.Image#getView",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#getView",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__removeView__Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            var result = object.removeView();
            
            return {
                testName: "vision.ds.Image#removeView",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#removeView",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__copyViewFrom_Image_Image__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var from = new vision.ds.Image(100, 100);
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.copyViewFrom(from);
            
            return {
                testName: "vision.ds.Image#copyViewFrom",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#copyViewFrom",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Image__hasPixelInView_Int_Int_ImageView_Bool__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var v:ImageView = null;
			
            var object = new vision.ds.Image(width, height, color);
            var result = object.hasPixelInView(x, y, v);
            
            return {
                testName: "vision.ds.Image#hasPixelInView",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Image#hasPixelInView",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}