package vision.algorithms;

import vision.tools.ImageTools;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.ds.ImageResizeAlgorithm;

/**
	An implementation of the following image hashing algorithms:

     - Average Hashing (`ahash`)
**/
class ImageHashing {
    
    public static function ahash(image:Image, hashByteSize:Int = 4):ByteArray {
        var clone = image.clone();
        var length = Math.floor(Math.sqrt(hashByteSize));

        // Resize
        clone.resize(length, length, BilinearInterpolation);

        // Grayscale
        for (x in 0...length) {
            for (y in 0...length) {
                var color = clone.getUnsafePixel(x, y);
                clone.setUnsafePixel(x, y, color.grayscale());
            }
        }

        var bytes = new ByteArray(hashByteSize);
        for (i in 0...Math.round(Math.pow(length, 2))) 
            bytes[i] = clone.getUnsafePixel(i % length, Math.floor(i / length));

        return bytes;
    }

}