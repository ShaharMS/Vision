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
import vision.exceptions.OutOfBounds;
import vision.tools.ImageTools;
import vision.ds.ImageView;
import vision.ds.ImageResizeAlgorithm;
import vision.ds.Rectangle;

@:access(vision.ds.Image)
class ImageTests {
    public static function vision_ds_Image__view__ShouldWork():TestResult {
        var result = null;
        try {
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.view;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#view",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    #if flixel

    public static function vision_ds_Image__toFlxSprite__flixelFlxSprite__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toFlxSprite();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toFlxSprite",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromFlxSprite_flixelFlxSprite_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var sprite:flixel.FlxSprite = null;
			
            result = vision.ds.Image.fromFlxSprite(sprite);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromFlxSprite",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    #end

    #if (flash || openfl)

    public static function vision_ds_Image__toBitmapData__flashdisplayBitmapData__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toBitmapData();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toBitmapData",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__toShape__flashdisplayShape__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toShape();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toShape",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__toSprite__flashdisplaySprite__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toSprite();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toSprite",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromBitmapData_flashdisplayBitmapData_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var bitmapData:flash.display.BitmapData = null;
			
            result = vision.ds.Image.fromBitmapData(bitmapData);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromBitmapData",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromShape_flashdisplayShape_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var shape:flash.display.Shape = null;
			
            result = vision.ds.Image.fromShape(shape);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromShape",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromSprite_flashdisplaySprite_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var sprite:flash.display.Sprite = null;
			
            result = vision.ds.Image.fromSprite(sprite);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromSprite",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    #end

    #if lime    

    public static function vision_ds_Image__toLimeImage__limegraphicsImage__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toLimeImage();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toLimeImage",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


    public static function vision_ds_Image__fromLimeImage_limegraphicsImage_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var image:lime.graphics.Image = null;
			
            result = vision.ds.Image.fromLimeImage(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromLimeImage",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    #end

    #if kha

    public static function vision_ds_Image__fromKhaImage_khaImage_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var image:kha.Image = null;
			
            result = vision.ds.Image.fromKhaImage(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromKhaImage",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    #end

    #if heaps

    public static function vision_ds_Image__toHeapsPixels__hxdPixels__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toHeapsPixels();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toHeapsPixels",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromHeapsPixels_hxdPixels_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var pixels:hxd.Pixels = null;
			
            result = vision.ds.Image.fromHeapsPixels(pixels);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromHeapsPixels",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    #end

    #if js

    public static function vision_ds_Image__toJsCanvas__jshtmlCanvasElement__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toJsCanvas();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toJsCanvas",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__toJsImage__jshtmlImageElement__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toJsImage();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toJsImage",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromJsCanvas_jshtmlCanvasElement_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var canvas:js.html.CanvasElement = null;
			
            result = vision.ds.Image.fromJsCanvas(canvas);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromJsCanvas",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromJsImage_jshtmlImageElement_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var image:js.html.ImageElement = null;
			
            result = vision.ds.Image.fromJsImage(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromJsImage",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    #end

    #if haxeui

    public static function vision_ds_Image__toHaxeUIImage__haxeuicomponentsImage__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toHaxeUIImage();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toHaxeUIImage",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__toHaxeUIImageData__haxeuibackendImageData__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toHaxeUIImageData();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toHaxeUIImageData",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromHaxeUIImage_haxeuicomponentsImage_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var image:haxe.ui.components.Image = null;
			
            result = vision.ds.Image.fromHaxeUIImage(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromHaxeUIImage",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fromHaxeUIImageData_haxeuibackendImageData_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var image:haxe.ui.backend.ImageData = null;
			
            result = vision.ds.Image.fromHaxeUIImageData(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.fromHaxeUIImageData",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    #end

    public static function vision_ds_Image__from2DArray_Array_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var array = [];
			
            result = vision.ds.Image.from2DArray(array);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.from2DArray",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__loadFromBytes_ByteArray_Int_Int_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var bytes = vision.ds.ByteArray.from(0);
			var width = 0;
			var height = 0;
			
            result = vision.ds.Image.loadFromBytes(bytes, width, height);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image.loadFromBytes",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__getPixel_Int_Int_Color__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.getPixel(x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#getPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__getSafePixel_Int_Int_Color__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.getSafePixel(x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#getSafePixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__getFloatingPixel_Float_Float_Color__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.getFloatingPixel(x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#getFloatingPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__setPixel__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.setPixel(x, y, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#setPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__setSafePixel__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.setSafePixel(x, y, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#setSafePixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__setFloatingPixel__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.setFloatingPixel(x, y, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#setFloatingPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__paintPixel__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.paintPixel(x, y, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#paintPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__paintFloatingPixel__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.paintFloatingPixel(x, y, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#paintFloatingPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__paintSafePixel__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var color = 0;
			
            var object = new vision.ds.Image(width, height, color);
            object.paintSafePixel(x, y, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#paintSafePixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__hasPixel_Float_Float_Bool__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.hasPixel(x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#hasPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__movePixel__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#movePixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__moveSafePixel__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#moveSafePixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__moveFloatingPixel__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#moveFloatingPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__moveUnsafePixel__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#moveUnsafePixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__copyPixelFrom_Image_Int_Int_Color__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var image = new vision.ds.Image(100, 100);
			var x = 0;
			var y = 0;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.copyPixelFrom(image, x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#copyPixelFrom",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__copyPixelTo_Image_Int_Int_Color__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var image = new vision.ds.Image(100, 100);
			var x = 0;
			var y = 0;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.copyPixelTo(image, x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#copyPixelTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__copyImageFrom_Image_Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var image = new vision.ds.Image(100, 100);
			
            var object = new vision.ds.Image(width, height, color);
            result = object.copyImageFrom(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#copyImageFrom",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__getImagePortion_Rectangle_Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var rect:Rectangle = null;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.getImagePortion(rect);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#getImagePortion",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__setImagePortion__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var rect:Rectangle = null;
			var image = new vision.ds.Image(100, 100);
			
            var object = new vision.ds.Image(width, height, color);
            object.setImagePortion(rect, image);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#setImagePortion",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__drawLine__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#drawLine",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__drawRay2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var line = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawRay2D(line, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#drawRay2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__drawLine2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.drawLine2D(line, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#drawLine2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fillRect__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#fillRect",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__drawRect__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#drawRect",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__drawQuadraticBezier__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#drawQuadraticBezier",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__drawCubicBezier__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#drawCubicBezier",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fillCircle__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#fillCircle",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__drawCircle__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#drawCircle",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fillEllipse__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#fillEllipse",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__drawEllipse__ShouldWork():TestResult {
        var result = null;
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
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#drawEllipse",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fillColorRecursive__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var position = new vision.ds.IntPoint2D(0, 0);
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillColorRecursive(position, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#fillColorRecursive",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fillColor__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var position = new vision.ds.IntPoint2D(0, 0);
			var color:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillColor(position, color);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#fillColor",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__fillUntilColor__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var position = new vision.ds.IntPoint2D(0, 0);
			var color:Color = null;
			var borderColor:Color = null;
			
            var object = new vision.ds.Image(width, height, color);
            object.fillUntilColor(position, color, borderColor);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#fillUntilColor",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__clone__Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.clone();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#clone",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__mirror__Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.mirror();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#mirror",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__flip__Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.flip();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#flip",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__stamp_Int_Int_Image_Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var X = 0;
			var Y = 0;
			var image = new vision.ds.Image(100, 100);
			
            var object = new vision.ds.Image(width, height, color);
            result = object.stamp(X, Y, image);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#stamp",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__resize_Int_Int_ImageResizeAlgorithm_Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var newWidth = 0;
			var newHeight = 0;
			var algorithm:ImageResizeAlgorithm = null;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.resize(newWidth, newHeight, algorithm);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#resize",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__rotate_Float_Bool_Bool_Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var angle = 0.0;
			var degrees = false;
			var expandImageBounds = false;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.rotate(angle, degrees, expandImageBounds);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#rotate",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__toString_Bool_String__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var special = false;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.toString(special);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__forEachPixel__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var callback = (_, _, _) -> null;
			
            var object = new vision.ds.Image(width, height, color);
            object.forEachPixel(callback);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#forEachPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__forEachPixelInView__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var callback = (_, _, _) -> null;
			
            var object = new vision.ds.Image(width, height, color);
            object.forEachPixelInView(callback);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#forEachPixelInView",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__iterator__IteratorPixel__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.iterator();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#iterator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__center__Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.center();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#center",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__pixelToRelative_Point2D_Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Image(width, height, color);
            result = object.pixelToRelative(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#pixelToRelative",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__pixelToRelative_Float_Float_Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.pixelToRelative(x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#pixelToRelative",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__relativeToPixel_Point2D_Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Image(width, height, color);
            result = object.relativeToPixel(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#relativeToPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__relativeToPixel_Float_Float_Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0.0;
			var y = 0.0;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.relativeToPixel(x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#relativeToPixel",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__hasView__Bool__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.hasView();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#hasView",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__setView_ImageView_Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var view:ImageView = null;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.setView(view);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#setView",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__getView__ImageView__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.getView();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#getView",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__removeView__Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.removeView();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#removeView",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__copyViewFrom_Image_Image__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var from = new vision.ds.Image(100, 100);
			
            var object = new vision.ds.Image(width, height, color);
            result = object.copyViewFrom(from);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#copyViewFrom",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__hasPixelInView_Int_Int_ImageView_Bool__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            var x = 0;
			var y = 0;
			var v:ImageView = null;
			
            var object = new vision.ds.Image(width, height, color);
            result = object.hasPixelInView(x, y, v);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#hasPixelInView",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }
    
    public static function vision_ds_Image__to2DArray__ArrayArrayColor__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.to2DArray();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#to2DArray",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Image__toArray__ArrayColor__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var color:Color = null;
			
            
            var object = new vision.ds.Image(width, height, color);
            result = object.toArray();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Image#toArray",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }
}