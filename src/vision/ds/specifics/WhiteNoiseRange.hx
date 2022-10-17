package vision.ds.specifics;

enum abstract WhiteNoiseRange(Int) from Int to Int {

    /**
        Allows 2 shades of "gray" - either black or white.
    **/
    var RANGE_2 = 2;

    /**
        Allows 8 shades of gray
    **/
    var RANGE_8 = 8;

    /**
        Allows 16 shades of gray.
    **/
    var RANGE_16 = 16;

    /**
        Allows 64 shades of gray.
    **/
    var RANGE_64 = 64;

    /**
        Allows 256 shades of gray.
    **/
    var RANGE_256 = 256;
}