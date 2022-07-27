package vision.exceptions;

import haxe.Exception;

class InvalidGaussianKernalSize extends Exception {
    
    public function new(size:Int) {
        super('Creating a gaussian kernal of size $size is not allowed. Is the kernal size even?');
    }
}