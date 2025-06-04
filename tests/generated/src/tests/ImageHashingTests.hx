package tests;

import TestResult;
import TestStatus;

import vision.algorithms.ImageHashing;
import haxe.Int64;
import vision.ds.Matrix2D;
import vision.tools.ImageTools;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.ds.ImageResizeAlgorithm;

class ImageHashingTests {
    public static function vision_algorithms_ImageHashing__phash__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.ImageHashing.phash((null : Image));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.ImageHashing.phash",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_ImageHashing__ahash__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.ImageHashing.ahash((null : Image), (null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.ImageHashing.ahash",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_ImageHashing__phash__ShouldWork, 
		vision_algorithms_ImageHashing__ahash__ShouldWork];
}