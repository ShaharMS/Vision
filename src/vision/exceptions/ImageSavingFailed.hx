package vision.exceptions;

import vision.ds.ImageFormat;

class ImageSavingFailed extends VisionException {
    public function new(type:ImageFormat, reason:String) {
        super(reason, '$type Saving Failed');
    }
}