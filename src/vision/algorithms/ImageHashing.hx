package vision.algorithms;

import haxe.Int64;
import vision.ds.Matrix2D;
import vision.tools.ImageTools;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.ds.ImageResizeAlgorithm;

using vision.tools.MathTools;

/**
	An implementation of the following image hashing algorithms:

     - Average Hashing (`ahash`)
     - Preceptual Hashing (`phash`)
**/
class ImageHashing {
    
    public static function ahash(image:Image, hashByteSize:Int = 16):ByteArray {
        var clone = image.clone();
        var length = Math.floor(Math.sqrt(hashByteSize / 4));

        // Resize
        clone.resize(length, length, BilinearInterpolation);

        // Grayscale
        for (x in 0...length) {
            for (y in 0...length) {
                var color = clone.getUnsafePixel(x, y);
                clone.setUnsafePixel(x, y, color.grayscale());
            }
        }

        return clone.exportToBytes();
    }

    public static function phash(image:Image):ByteArray {
        var clone = image.clone();

        clone.resize(32, 32);
        
        // Grayscale
        for (x in 0...32) {
            for (y in 0...32) {
                var color = clone.getUnsafePixel(x, y);
                clone.setUnsafePixel(x, y, color.grayscale());
            }
        }

        var dctMatrix = new Matrix2D(32, 32);

        var ci, cj, dct1, sum;

        for (i in 0...32) {
            for (j in 0...32) {
                ci = i == 0 ? 1 / 32.sqrt() : 2.sqrt() / 32.sqrt();
                cj = j == 0 ? 1 / 32.sqrt() : 2.sqrt() / 32.sqrt();
                sum = 0.;

                for (k in 0...32) {
                    for (l in 0...32) {
                        dct1 = clone.getUnsafePixel(k, l).red * 
                            Math.cos((2 * k + 1) * i * Math.PI / (2 * 32)) * 
                            Math.cos((2 * l + 1) * j * Math.PI / (2 * 32));
                        sum += dct1;
                    }
                }

                dctMatrix.set(i, j, ci * cj * sum);
            }
        }

        var submatrix = dctMatrix.getSubMatrix(0, 0, 8, 8);
        var average = submatrix.getAverage();

        // Construct the hash - each cell with its value above the
        // Average is assigned 1, whiel below is 0.
        var hash = Int64.make(0, 0);
        for (index in 0...submatrix.underlying.length) {
            var item = submatrix.underlying.inner[index];
            hash |= (item > average ? 1 : 0) << index;
        }

        return ByteArray.from(hash);
    }
}