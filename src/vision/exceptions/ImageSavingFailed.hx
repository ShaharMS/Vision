package vision.exceptions;

import vision.ds.ImageFormat;

class ImageSavingFailed extends VisionException {
    public function new(type:ImageFormat, reason:String) {
        super(reason, '${formatName(type)} Saving Failed');
    }

    static function formatName(type:ImageFormat):String {
        return switch type {
            case PNG: "PNG";
            case BMP: "BMP";
            case JPEG: "JPEG";
            case VISION: "VISION";
        };
    }
}