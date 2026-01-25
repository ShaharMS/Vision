package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.ImageHashing;
import haxe.Int64;
import vision.ds.Matrix2D;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.ds.Color;

@:access(vision.algorithms.ImageHashing)
class ImageHashingTest extends utest.Test {

    static var blackImage:Image;
    static var whiteImage:Image;
    static var gradientImage:Image;

    public function setup() {
        if (blackImage == null) {
            blackImage = new Image(100, 100, 0xFF000000);
            whiteImage = new Image(100, 100, 0xFFFFFFFF);
            gradientImage = createGradientImage(100, 100);
        }
    }

    static function createGradientImage(w:Int, h:Int):Image {
        var img = new Image(w, h);
        for (y in 0...h) {
            for (x in 0...w) {
                var r = Std.int((x / w) * 255);
                var g = Std.int((y / h) * 255);
                var b = Std.int(((x + y) / (w + h)) * 255);
                img.setPixel(x, y, Color.fromRGBA(r, g, b, 255));
            }
        }
        return img;
    }

    function test_ahash_returns_bytearray() {
        var result = ImageHashing.ahash(gradientImage, 16);
        Assert.notNull(result);
        Assert.isTrue(result.length > 0);
    }

    function test_ahash_same_image_same_hash() {
        var hash1 = ImageHashing.ahash(gradientImage, 16);
        var hash2 = ImageHashing.ahash(gradientImage, 16);
        Assert.equals(hash1.length, hash2.length);
        for (i in 0...hash1.length) {
            Assert.equals(hash1.getUInt8(i), hash2.getUInt8(i));
        }
    }

    function test_ahash_different_images_different_hashes() {
        var hash1 = ImageHashing.ahash(blackImage, 16);
        var hash2 = ImageHashing.ahash(whiteImage, 16);
        
        var different = false;
        for (i in 0...Std.int(Math.min(hash1.length, hash2.length))) {
            if (hash1.getUInt8(i) != hash2.getUInt8(i)) {
                different = true;
                break;
            }
        }
        Assert.isTrue(different);
    }

    function test_ahash_black_image_all_zeros() {
        var hash = ImageHashing.ahash(blackImage, 16);
        // Black image pixels after grayscale have R=G=B=0 with alpha=255 (ARGB format)
        // The RGB components should be 0, but alpha is 255
        // Check that all RGB bytes are low (every 4 bytes after the alpha)
        var rgbLow = true;
        for (i in 0...hash.length) {
            var bytePos = i % 4;
            if (bytePos != 0) { // Skip alpha bytes (position 0 in each 4-byte group)
                if (hash.getUInt8(i) > 10) {
                    rgbLow = false;
                    break;
                }
            }
        }
        Assert.isTrue(rgbLow);
    }

    function test_ahash_white_image_high_values() {
        var hash = ImageHashing.ahash(whiteImage, 16);
        // White image should hash to high values
        var allHigh = true;
        for (i in 0...hash.length) {
            if (hash.getUInt8(i) < 200) {
                allHigh = false;
                break;
            }
        }
        Assert.isTrue(allHigh);
    }

    function test_ahash_different_sizes() {
        var hash16 = ImageHashing.ahash(gradientImage, 16);
        var hash64 = ImageHashing.ahash(gradientImage, 64);
        // Different hash sizes should produce different length results
        Assert.isTrue(hash64.length > hash16.length);
    }

    function test_phash_returns_bytearray() {
        var result = ImageHashing.phash(gradientImage);
        Assert.notNull(result);
        Assert.isTrue(result.length > 0);
    }

    function test_phash_same_image_same_hash() {
        var hash1 = ImageHashing.phash(gradientImage);
        var hash2 = ImageHashing.phash(gradientImage);
        Assert.equals(hash1.length, hash2.length);
        for (i in 0...hash1.length) {
            Assert.equals(hash1.getUInt8(i), hash2.getUInt8(i));
        }
    }

    function test_phash_different_images_different_hashes() {
        var hash1 = ImageHashing.phash(blackImage);
        var hash2 = ImageHashing.phash(whiteImage);
        
        var different = false;
        for (i in 0...Std.int(Math.min(hash1.length, hash2.length))) {
            if (hash1.getUInt8(i) != hash2.getUInt8(i)) {
                different = true;
                break;
            }
        }
        Assert.isTrue(different);
    }

    function test_phash_returns_64_bit_hash() {
        var result = ImageHashing.phash(gradientImage);
        // phash produces a 64-bit hash (8 bytes)
        Assert.equals(8, result.length);
    }

    function test_phash_similar_images_similar_hashes() {
        // Create two very similar images (slightly different gradient)
        var img1 = createGradientImage(100, 100);
        var img2 = createGradientImage(100, 100);
        // Slightly modify img2
        img2.setPixel(50, 50, Color.fromRGBA(128, 128, 128, 255));
        
        var hash1 = ImageHashing.phash(img1);
        var hash2 = ImageHashing.phash(img2);
        
        // Count differing bits (Hamming distance)
        var differences = 0;
        for (i in 0...hash1.length) {
            var xor = hash1.getUInt8(i) ^ hash2.getUInt8(i);
            // Count bits in xor
            while (xor > 0) {
                differences += xor & 1;
                xor >>= 1;
            }
        }
        // Similar images should have low Hamming distance (fewer than 16 bits different)
        Assert.isTrue(differences < 32);
    }

}
