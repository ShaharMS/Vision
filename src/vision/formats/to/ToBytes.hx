package vision.formats.to;

import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.LibraryRequired;

/**
    A class for saving images to bytes
**/
@:noCompletion class ToBytes {
    
    public function new() {}

    /**
        Exports an image to `PNG` bytes

        @param image The image to export
        @return The bytes of the exported image
        @throws ImageSavingFailed If something goes wrong (for example, the image is invalid or device is out of memory)
        @throws LibraryRequired if used without installing & including `format` on non-`js` targets
    **/
    public function png(image:Image):ByteArray {
        #if format
        return vision.formats.__internal.FormatImageExporter.png(image);
        #elseif js
        return vision.formats.__internal.JsImageExporter.saveToBytesSync(image, "image/png");
        #else
        throw new LibraryRequired("format", [], "vision.formats.to.ToBytes.png", "function");
        #end
    }

    /**
        Exports an image to `BMP` bytes
        
        @param image The image to export
        @return The bytes of the exported image
        @throws ImageSavingFailed If something goes wrong (for example, the image is invalid or device is out of memory)
        @throws LibraryRequired if used without installing & including `format` on non-`js` targets
    **/
    public function bmp(image:Image):ByteArray {
        #if format
        return vision.formats.__internal.FormatImageExporter.bmp(image);
        #elseif js
        return vision.formats.__internal.JsImageExporter.saveToBytesSync(image, "image/bmp");
        #else
        throw new LibraryRequired("format", [], "vision.formats.to.ToBytes.bmp", "function");
        #end
    }

    /**
        Exports an image to `JPEG` bytes
        
        @param image The image to export
        @return The bytes of the exported image
        @throws ImageSavingFailed If something goes wrong (for example, the image is invalid or device is out of memory)
        @throws LibraryRequired if used without installing & including `format` on non-`js` targets
    **/
    public function jpeg(image:Image):ByteArray {
        #if format
        return vision.formats.__internal.FormatImageExporter.jpeg(image);        
        #elseif js
        return vision.formats.__internal.JsImageExporter.saveToBytesSync(image, "image/jpeg");
        #else
        throw new LibraryRequired("format", [], "vision.formats.to.ToBytes.jpeg", "function");
        #end
    }

}