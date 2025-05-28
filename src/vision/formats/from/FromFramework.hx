package vision.formats.from;

import vision.formats.__internal.FrameworkImageIO;

/**
    A class for loading images from different frameworks
**/
@:noCompletion class FromFramework {

    #if js
    public var js = {
        canvas: (canvas:js.html.CanvasElement) -> FrameworkImageIO.fromJsCanvas(canvas),
        image: (image:js.html.ImageElement) -> FrameworkImageIO.fromJsImage(image)
    }
    #end
    #if flixel
    public var flixel = {
        flxsprite: (sprite:flixel.FlxSprite) -> FrameworkImageIO.fromFlxSprite(sprite)
    }
    #end
    #if flash
    public var flash = {
        bitmapdata: (bitmapData:flash.display.BitmapData) -> FrameworkImageIO.fromBitmapData(bitmapData),
        sprite: (sprite:flash.display.Sprite) -> FrameworkImageIO.fromSprite(sprite),
        shape: (shape:flash.display.Shape) -> FrameworkImageIO.fromShape(shape)
    }
    #end
    #if openfl
    public var openfl = {
        bitmapdata: (bitmapData:openfl.display.BitmapData) -> FrameworkImageIO.fromBitmapData(bitmapData),
        sprite: (sprite:openfl.display.Sprite) -> FrameworkImageIO.fromSprite(sprite),
        shape: (shape:openfl.display.Shape) -> FrameworkImageIO.fromShape(shape)
    }
    #end
    #if lime
    public var lime = {
        image: (image:lime.graphics.Image) -> FrameworkImageIO.fromLimeImage(bitmapData)
    }
    #end
    #if heaps
    public var heaps = {
        pixels: (pixels:hxd.Pixels) -> FrameworkImageIO.fromHeapsPixels(pixels)
    }
    #end
    #if kha
    public var kha = {
        image: (image:kha.Image) -> FrameworkImageIO.fromKhaImage(image)
    }
    #end
    #if (haxeui_core && (haxeui_flixel || haxeui_openfl || haxeui_heaps || haxeui_html5))
    public var haxeui = {
        image: (image:haxe.ui.components.Image) -> FrameworkImageIO.fromHaxeUIImage(image),
        imagedata: (imageData:haxe.ui.backend.ImageData) -> FrameworkImageIO.fromHaxeUIImageData(imageData)
    }
    #end

    public function new() {}
}