package vision.formats.to;

import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.LibraryRequired;
import vision.formats._internal.images.Jpeg;
import vision.formats._internal.images.Webp;

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
        return vision.formats._internal.images.FormatImageExporter.png(image);
        #elseif js
        return vision.formats._internal.images.JsImageExporter.saveToBytesSync(image, "image/png");
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
        return vision.formats._internal.images.FormatImageExporter.bmp(image);
        #elseif js
        return vision.formats._internal.images.JsImageExporter.saveToBytesSync(image, "image/bmp");
        #else
        throw new LibraryRequired("format", [], "vision.formats.to.ToBytes.bmp", "function");
        #end
    }

    /**
        Encodes an image as an 8-bit sequential JPEG. The alpha channel is discarded.

        @param image The image to encode
        @param quality JPEG quality from 1 to 100
        @return The complete JPEG file
        @throws ImageSavingFailed If the image or quality is invalid
    **/
    public function jpeg(image:Image, quality:Int = 90):ByteArray {
        return Jpeg.write(image, quality);
    }

    /**
        Encodes a still lossless WebP image.

        @param image The image to encode, including alpha
        @return The complete WebP file
        @throws ImageSavingFailed If the image cannot be encoded
    **/
    public function webp(image:Image):ByteArray {
        return Webp.write(image);
    }
}
