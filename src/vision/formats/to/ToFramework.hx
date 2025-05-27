package vision.formats.to;

import vision.ds.Image;
import vision.formats.__internal.FrameworkImageIO;

/**
    A class for saving images to different frameworks
**/
@:noCompletion class ToFramework {
    #if js
    public var js = {
        canvas: (image:Image) -> FrameworkImageIO.toJsCanvas(image),
        image: (image:Image) -> FrameworkImageIO.toJsImage(image)
    }
    #end
    #if flixel
    public var flixel = {
        flxsprite: (image:Image) -> FrameworkImageIO.toFlxSprite(image)
    }
    #end
    #if flash
    public var flash = {
        bitmapdata: (image:Image) -> FrameworkImageIO.toBitmapData(image),
        sprite: (image:Image) -> FrameworkImageIO.toSprite(image),
        shape: (image:Image) -> FrameworkImageIO.toShape(image)
    }
    #end
    #if openfl
    public var openfl = {
        bitmapdata: (image:Image) -> FrameworkImageIO.toBitmapData(image),
        sprite: (image:Image) -> FrameworkImageIO.toSprite(image),
        shape: (image:Image) -> FrameworkImageIO.toShape(image)
    }
    #end
    #if lime
    public var lime = {
        image: (image:Image) -> FrameworkImageIO.toLimeImage(image)
    }
    #end
    #if heaps
    public var heaps = {
        pixels: (image:Image) -> FrameworkImageIO.toHeapsPixels(image)
    }
    #end
    #if kha
    public var kha = {
        image: (image:Image) -> FrameworkImageIO.toKhaImage(image)
    }
    #end
    #if (haxeui_core && (haxeui_flixel || haxeui_openfl || haxeui_heaps || haxeui_html5))
    public var haxeui = {
        image: (image:Image) -> FrameworkImageIO.toHaxeUIImage(image),
        imagedata: (image:Image) -> FrameworkImageIO.toHaxeUIImageData(image)
    }
    #end

    public function new() {}
}