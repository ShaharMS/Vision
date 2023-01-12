package vision.helpers;

import haxe.io.Bytes;
import vision.ds.Image;
import vision.exceptions.LibraryRequired;

class TextDrawer {
    

    /**
     * Throws the correct error when dependencies of opentype.hx are missing, unless vison_quiet is defined
     */
    public static function reportDependencies() {
        #if ((!opentype.hx || !buddy || !promhx || !asynctools) && !vision_quiet)
        throw new LibraryRequired("opentype.hx", [] #if !promhx .concat(["promhx"]) #end  #if !buddy .concat(["buddy"]) #end  #if !asynctools .concat(["asynctools"]) #end, "Image.drawText");
        #elseif ((!opentype.hx || !buddy || !promhx || !asynctools) && vision_quiet)
        return false;
        #else
        return true;
        #end
    }

    public static function drawTextOnImage(image:Image, x:Int, y:Int, size:Int, text:String, font:Bytes) {
        //for the near future :)
        #if (opentype.hx && buddy && promhx && asynctools)
        final otFont = opentype.OpenType.parse(font);
        for (char in text.split("")) {
            var glyph = otFont.charToGlyph(char.charCodeAt(0));
            // Problem - glyph.path is an empty class, issue has been opened on opentype.hx's github https://github.com/Laerdal/opentype.hx/issues/2
        }
        #else
        reportDependencies();
        #end
    }

}