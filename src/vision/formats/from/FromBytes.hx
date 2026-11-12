package vision.formats.from;

import vision.exceptions.LibraryRequired;
import vision.ds.Image;
import vision.formats._internal.images.Avif;
import vision.formats._internal.images.Heic;
import vision.formats._internal.images.Jpeg;
import vision.formats._internal.images.Webp;
import vision.formats._internal.images.webp.WebpAnimation;
import vision.ds.ImageAnimation;
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
        return vision.formats._internal.images.FormatImageLoader.png(bytes);
        #elseif js
        return vision.formats._internal.images.JsImageLoader.loadBytesSync(bytes, "image/png");
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
        return vision.formats._internal.images.FormatImageLoader.bmp(bytes);
        #elseif js
        return vision.formats._internal.images.JsImageLoader.loadBytesSync(bytes, "image/bmp");
        #else
        throw new LibraryRequired("format", [], "vision.formats.from.FromBytes.bmp", "function");    
        #end
        
    }

    /**
        Decodes an 8-bit sequential or progressive JPEG image from bytes.
        CMYK and Adobe YCCK are converted to RGB without applying ICC profiles.

        @param bytes The complete JPEG file
        @return An opaque image with the decoded pixels
        @throws ImageLoadingFailed If the file is invalid or uses unsupported JPEG coding
    **/
    public function jpeg(bytes:ByteArray):Image {
        return Jpeg.read(bytes);
    }

    /**
        Decodes a still lossless WebP image.

        @param bytes The complete WebP file
        @return The decoded image, including alpha
        @throws ImageLoadingFailed If the file is invalid, lossy, or animated
    **/
    public function webp(bytes:ByteArray):Image {
        return Webp.read(bytes);
    }
    /**
        Decodes animated WebP containing lossless frames.

        @param bytes The complete animated WebP file
        @return The animation composited on a transparent canvas
        @throws ImageLoadingFailed If the container or any lossless frame is invalid
    **/
    public function webpAnimation(bytes:ByteArray):ImageAnimation {
        return WebpAnimation.read(bytes);
    }

    /**
        Decodes a directly coded HEIC still image using HEVC PCM.

        @param bytes The complete HEIC file
        @return The decoded opaque image
        @throws HeifContainerError If the file container is invalid
        @throws HevcBitstreamError If the HEVC coding or color configuration is invalid or unsupported
    **/
    public function heic(bytes:ByteArray):Image {
        return Heic.read(bytes);
    }

    /**
        Decodes an opaque AVIF still image using AV1 RGB palettes.

        @param bytes The complete AVIF file
        @return The decoded image
        @throws HeifContainerError If the file container is invalid
        @throws Av1BitstreamError If the AV1 coding or color configuration is invalid or unsupported
    **/
    public function avif(bytes:ByteArray):Image {
        return Avif.read(bytes);
    }
}
