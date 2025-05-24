package vision.ds;

/**
    The image format to encode in.
**/
enum abstract ImageFormat(Int) {

    /**
        PNG encoding
    **/
    var PNG;

    /**
        BMP encoding
    **/
    var BMP;

    /**
        JPEG encoding
    **/
    var JPEG;

    /**
        Raw `vision.ds.Image` bytes
    **/
    var RAW;
}