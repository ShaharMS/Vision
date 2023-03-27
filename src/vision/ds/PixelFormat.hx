package vision.ds;

import vision.exceptions.VisionException;

enum abstract PixelFormat(Int) from Int to Int {
    var ARGB;
    var RGBA;
    var ABGR;
    var BGRA;
    var RGB;
    var BGR;



    public static function convertPixelFormat(bytes:ByteArray, from:PixelFormat, ?to:PixelFormat = ARGB) {

        if (from == to) return bytes;

        var i = 0;
        while (i < bytes.length) {
            var red   = if (from == RGBA || from == RGB) bytes[i] else if (from == ARGB) bytes[i + 1] else if (from == BGR || from == BGRA) bytes[i + 2] else if (from == ABGR) bytes[i + 3] else throw new VisionException("Unknown Pixel Format", "Pixel Conversion");
            var green = if (from == BGR || from == BGRA || from == RGB || from == RGBA) bytes[i + 1] else if (from == ABGR || from == ARGB) bytes[i + 2] else throw new VisionException("Unknown Pixel Format", "Pixel Conversion");
            var blue  = if (from == BGR || from == BGRA) bytes[i] else if (from == ABGR) bytes[i + 1] else if (from == RGB || from == RGBA) bytes[i + 2] else if (from == ARGB) bytes[i + 3] else throw new VisionException("Unknown Pixel Format", "Pixel Conversion");
            var alpha = if (from == ARGB || from == ABGR) bytes[i] else if (from == RGBA || from == BGRA) bytes[i + 3] else -1;
            
            var redIndex   = if (to == RGBA || to == RGB) i else if (to == ARGB) i + 1 else if (to == BGR || to == BGRA) i + 2 else if (to == ABGR) i + 3 else throw new VisionException("Unknown Pixel Format", "Pixel Conversion");
            var greenIndex = if (to == BGR || to == BGRA || to == RGB || to == RGBA) i + 1 else if (to == ABGR || to == ARGB) i + 2 else throw new VisionException("Unknown Pixel Format", "Pixel Conversion");
            var blueIndex  = if (to == BGR || to == BGRA) i else if (to == ABGR) i + 1 else if (to == RGB || to == RGBA) i + 2 else if (to == ARGB) i + 3 else throw new VisionException("Unknown Pixel Format", "Pixel Conversion");
            var alphaIndex = if (to == ARGB || to == ABGR) i else if (to == RGBA || to == BGRA) i + 3 else -1;

            bytes[redIndex] = red;
            bytes[greenIndex] = green;
            bytes[blueIndex] = blue;
            if (alphaIndex != -1) bytes[alphaIndex] = alpha;

            if ((from : Int) > 3) i += 3;
            else i += 4;
        }

        return bytes;
    }
}