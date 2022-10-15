package vision.exceptions;

import vision.ds.ImageFormat;

class ImageLoadingFailed extends VisionException {
    public function new(type:ImageFormat, reason:String) {
        super(reason, '$type Loading Failed');
    }
}