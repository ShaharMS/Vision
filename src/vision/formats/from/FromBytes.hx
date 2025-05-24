package vision.formats.from;

import vision.exceptions.LibraryRequired;
import vision.ds.Image;
import vision.exceptions.Unimplemented;
import vision.ds.ByteArray;

/**
    A class for loading images from bytes.
**/
@:noCompletion class FromBytes {

    public function new() {}

    /**
        Loads an image from `PNG` bytes

        @param bytes The image's bytes 
        @throws ImageLoadingFailed if the loaded image is not a PNG
        @throws ImageLoadingFailed if the PNG has incorrect header data
        @throws LibraryRequired if used without installing & including `format`
        @return the loaded image
    **/
    public function png(bytes:ByteArray):Image {
        #if format
        return vision.formats.__internal.FormatImageLoader.png(bytes);
        #else
        throw new LibraryRequired("format", [], "vision.formats.from.FromBytes.png", "function");    
        #end
    }

    /**
        Loads an image from `BMP` bytes

        @param bytes The image's bytes 
        @throws ImageLoadingFailed if the loaded image is not a BMP
        @throws ImageLoadingFailed if the BMP has incorrect header data, and reports it has more bytes than it should.
        @throws LibraryRequired if used without installing & including `format` 
        @return the loaded image
    **/
    public function bmp(bytes:ByteArray):Image {
        #if format
        return vision.formats.__internal.FormatImageLoader.bmp(bytes);
        #else
        throw new LibraryRequired("format", [], "vision.formats.from.FromBytes.bmp", "function");    
        #end
        
    }
}