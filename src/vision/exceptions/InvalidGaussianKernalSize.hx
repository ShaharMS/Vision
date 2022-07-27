package vision.exceptions;

import haxe.Exception;

class InvalidGaussianKernalSize extends VisionException {
    
    public function new(size:Int) {
        super('Creating a gaussian kernal of size $size is not allowed. Is the kernal size even?', "Invalid Gaussian Kernal Size");
    }
}