package tests;

import TestResult;
import TestStatus;

import vision.algorithms.ImageHashing;
import haxe.Int64;
import vision.ds.Matrix2D;
import vision.ds.ByteArray;
import vision.ds.Image;

@:access(vision.algorithms.ImageHashing)
class ImageHashingTests {
    public static function vision_algorithms_ImageHashing__ahash_Image_Int_ByteArray__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var hashByteSize = 0;
			
            var result = vision.algorithms.ImageHashing.ahash(image, hashByteSize);

            return {
                testName: "vision.algorithms.ImageHashing.ahash",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.ImageHashing.ahash",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_ImageHashing__phash_Image_ByteArray__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.algorithms.ImageHashing.phash(image);

            return {
                testName: "vision.algorithms.ImageHashing.phash",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.ImageHashing.phash",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}