package tests;

import utest.Assert;
import utest.Async;
import vision.Vision;
import vision.algorithms.ImageHashing;
import vision.ds.ByteArray;
import vision.ds.kmeans.ColorCluster;
import haxe.io.Bytes;
import haxe.crypto.Sha256;
import vision.exceptions.Unimplemented;
import vision.ds.specifics.SimilarityScoringMechanism;
import vision.algorithms.KMeans;
import vision.ds.specifics.ColorChannel;
import vision.ds.TransformationMatrix2D;
import vision.ds.specifics.TransformationMatrixOrigination;
import vision.ds.Point3D;
import vision.ds.specifics.ImageExpansionMode;
import vision.algorithms.PerspectiveWarp;
import vision.ds.specifics.PointTransformationPair;
import vision.algorithms.BilinearInterpolation;
import vision.ds.Matrix2D;
import vision.ds.Int16Point2D;
import haxe.ds.Vector;
import vision.ds.specifics.WhiteNoiseRange;
import vision.algorithms.Laplace;
import vision.ds.specifics.ColorImportanceOrder;
import vision.algorithms.BilateralFilter;
import vision.algorithms.RobertsCross;
import vision.ds.IntPoint2D;
import haxe.extern.EitherType;
import vision.algorithms.Radix;
import haxe.ds.ArraySort;
import vision.ds.Histogram;
import vision.ds.specifics.AlgorithmSettings;
import vision.algorithms.Perwitt;
import vision.algorithms.Sobel;
import vision.ds.Kernel2D;
import vision.ds.canny.CannyObject;
import vision.algorithms.SimpleLineDetector;
import vision.ds.gaussian.GaussianKernelSize;
import vision.ds.Ray2D;
import vision.algorithms.Gauss;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools;
import vision.tools.ImageTools;
import vision.tools.MathTools.*;

/**
 * Golden image comparison tests for Vision image processing functions.
 * 
 * These tests use the golden images from the Vision documentation at:
 * https://spacebubble-io.pages.dev/vision/docs/
 * 
 * The tests compare perceptual hashes of computed results against 
 * the expected golden images to verify correctness across platforms.
 */
@:access(vision.Vision)
class VisionTest extends utest.Test {

    // Golden image base URL
    static inline var GOLDEN_BASE = "https://spacebubble-io.pages.dev/vision/docs/";
    
    // Hash comparison threshold (0 = exact, higher = more tolerant)
    // Allow some tolerance for floating point differences across platforms
    static inline var HASH_THRESHOLD = 10;
    
    // Retry settings for network requests
    // CRC check failures and invalid headers can occur due to network issues
    static inline var MAX_RETRIES = 3;
    static inline var RETRY_DELAY_MS = 500;
    
    // Cached source image
    static var sourceImage:Image;
    
    // Local test images for unit tests
    static var testImage:Image;
    static var blackImage:Image;
    static var gradientImage:Image;

    public function setup() {
        if (testImage == null) {
            testImage = new Image(100, 100);
            blackImage = new Image(100, 100, 0xFF000000);
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
    
    /**
     * Calculate Hamming distance between two perceptual hashes.
     */
    static function hammingDistance(hash1:ByteArray, hash2:ByteArray):Int {
        var count = 0;
        var len = hash1.length < hash2.length ? hash1.length : hash2.length;
        for (i in 0...len) {
            var xor = hash1.get(i) ^ hash2.get(i);
            while (xor != 0) {
                count += xor & 1;
                xor = xor >> 1;
            }
        }
        return count;
    }
    
    /**
     * Load an image from URL with retry logic.
     * 
     * CRC check failures and "Invalid header" errors can occur due to:
     * - Network issues causing incomplete/corrupted downloads
     * - Server returning partial responses or error pages
     * - Intermittent connectivity problems
     * 
     * This function retries the download up to MAX_RETRIES times with
     * a delay between attempts to handle transient network issues.
     * 
     * @param url The URL to load the image from
     * @param onSuccess Callback with the loaded image on success
     * @param onFailure Callback with error message after all retries exhausted
     * @param attempt Current attempt number (internal use)
     */
    static function loadImageWithRetry(url:String, onSuccess:Image->Void, onFailure:String->Void, attempt:Int = 0):Void {
        ImageTools.loadFromFile(url, function(image:Image) {
            if (image != null && image.width > 0 && image.height > 0) {
                onSuccess(image);
            } else if (attempt < MAX_RETRIES) {
                // Image loaded but is invalid, retry
                #if sys
                Sys.sleep(RETRY_DELAY_MS / 1000.0);
                #end
                loadImageWithRetry(url, onSuccess, onFailure, attempt + 1);
            } else {
                onFailure('$attempt Loading Failed: Invalid image data');
            }
        });
    }
    
    /**
     * Wrapper that catches exceptions during image loading and retries.
     * This handles CRC errors, invalid headers, and other PNG parsing failures.
     */
    static function tryLoadImageWithRetry(url:String, onSuccess:Image->Void, onFailure:String->Void, attempt:Int = 0):Void {
        try {
            ImageTools.loadFromFile(url, function(image:Image) {
                if (image != null && image.width > 0 && image.height > 0) {
                    onSuccess(image);
                } else if (attempt < MAX_RETRIES) {
                    #if sys
                    Sys.sleep(RETRY_DELAY_MS / 1000.0);
                    #end
                    tryLoadImageWithRetry(url, onSuccess, onFailure, attempt + 1);
                } else {
                    onFailure('$attempt Loading Failed: Invalid image data');
                }
            });
        } catch (e:Dynamic) {
            if (attempt < MAX_RETRIES) {
                #if sys
                Sys.sleep(RETRY_DELAY_MS / 1000.0);
                #end
                tryLoadImageWithRetry(url, onSuccess, onFailure, attempt + 1);
            } else {
                onFailure('$attempt Loading Failed: ${Std.string(e)}');
            }
        }
    }
    
    /**
     * Helper to load source and expected images with retry logic for golden tests.
     * This simplifies the common pattern of loading two images and comparing them.
     * 
     * @param sourceUrl URL of the source image
     * @param expectedUrl URL of the expected/golden image  
     * @param async The test's Async handle
     * @param testFn Function that receives (source, expected) and performs the test
     */
    static function loadGoldenTestImages(sourceUrl:String, expectedUrl:String, async:Async, testFn:(Image, Image)->Void):Void {
        tryLoadImageWithRetry(sourceUrl, 
            function(source:Image) {
                tryLoadImageWithRetry(expectedUrl,
                    function(expected:Image) {
                        testFn(source, expected);
                    },
                    function(err:String) {
                        Assert.fail('Expected image load failed: $err');
                        async.done();
                    }
                );
            },
            function(err:String) {
                Assert.fail('Source image load failed: $err');
                async.done();
            }
        );
    }

    // =====================================================
    // GOLDEN IMAGE COMPARISON TESTS (async with URL loading)
    // These tests load golden images from the documentation and compare
    // using perceptual hashing to verify correctness.
    // =====================================================
    
    @:timeout(30000)
    function test_golden_combine(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-combine.png", async, function(source:Image, expected:Image) {
            // Combine with itself at 50%
            var result = Vision.combine(source, source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'combine hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_tint(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-tint.png", async, function(source:Image, expected:Image) {
            var result = Vision.tint(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'tint hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_grayscale(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-grayscale.png", async, function(source:Image, expected:Image) {
            var result = Vision.grayscale(source, true); // simple grayscale
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'grayscale hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_invert(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-invert.png", async, function(source:Image, expected:Image) {
            var result = Vision.invert(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'invert hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_sepia(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-sepia.png", async, function(source:Image, expected:Image) {
            var result = Vision.sepia(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'sepia hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_blackAndWhite(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-blackAndWhite.png", async, function(source:Image, expected:Image) {
            var result = Vision.blackAndWhite(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'blackAndWhite hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_contrast(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-contrast.png", async, function(source:Image, expected:Image) {
            var result = Vision.contrast(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'contrast hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_smooth(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-smooth.png", async, function(source:Image, expected:Image) {
            var result = Vision.smooth(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'smooth hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_pixelate(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-pixelate.png", async, function(source:Image, expected:Image) {
            var result = Vision.pixelate(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'pixelate hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_posterize(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-posterize.png", async, function(source:Image, expected:Image) {
            var result = Vision.posterize(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'posterize hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_sharpen(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-sharpen.png", async, function(source:Image, expected:Image) {
            var result = Vision.sharpen(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'sharpen hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @Ignored("Algorithm changed - reference image needs regeneration")
    @:timeout(30000)
    function test_golden_deepfry(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-deepfry.png", async, function(source:Image, expected:Image) {
            var result = Vision.deepfry(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'deepfry hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @Ignored("Algorithm changed - reference image needs regeneration")
    @:timeout(30000)
    function test_golden_vignette(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-vignette%28ratioDependent%20=%20true%29.png", async, function(source:Image, expected:Image) {
            var result = Vision.vignette(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'vignette hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_fisheyeDistortion(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-fisheyeDistortion.png", async, function(source:Image, expected:Image) {
            var result = Vision.fisheyeDistortion(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'fisheyeDistortion hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @Ignored("Reference image missing from server")
    @:timeout(30000)
    function test_golden_barrelDistortion(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-barrelDistortion.png", async, function(source:Image, expected:Image) {
            var result = Vision.barrelDistortion(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'barrelDistortion hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @Ignored("Reference image missing from server")
    @:timeout(30000)
    function test_golden_pincushionDistortion(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-pincushionDistortion.png", async, function(source:Image, expected:Image) {
            var result = Vision.pincushionDistortion(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'pincushionDistortion hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @Ignored("Reference image missing from server")
    @:timeout(30000)
    function test_golden_mustacheDistortion(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-mustacheDistortion.png", async, function(source:Image, expected:Image) {
            var result = Vision.mustacheDistortion(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'mustacheDistortion hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_dilate(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-dilate.png", async, function(source:Image, expected:Image) {
            var result = Vision.dilate(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'dilate hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_erode(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-erode.png", async, function(source:Image, expected:Image) {
            var result = Vision.erode(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'erode hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_filterForColorChannel(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-filterForColorChannel%28channel%20=%20RED%29.png", async, function(source:Image, expected:Image) {
            var result = Vision.filterForColorChannel(source, ColorChannel.RED);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'filterForColorChannel hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_nearestNeighborBlur(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-nearestNeighborBlur%28iterations%20=%201%29.png", async, function(source:Image, expected:Image) {
            var result = Vision.nearestNeighborBlur(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'nearestNeighborBlur hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_gaussianBlur(async:Async) {
        // Use sigma=1 as documented in the golden image URL
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-gaussianBlur%28sigma%20=%201%29.png", async, function(source:Image, expected:Image) {
            var result = Vision.gaussianBlur(source, 1.0);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'gaussianBlur hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_medianBlur(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-medianBlur%28kernelRadius%20=%205%29.png", async, function(source:Image, expected:Image) {
            var result = Vision.medianBlur(source, 5);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'medianBlur hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_sobelEdgeDiffOperator(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-sobelEdgeDiffOperator.png", async, function(source:Image, expected:Image) {
            var result = Vision.sobelEdgeDiffOperator(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'sobelEdgeDiffOperator hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_perwittEdgeDiffOperator(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-perwittEdgeDiffOperator.png", async, function(source:Image, expected:Image) {
            var result = Vision.perwittEdgeDiffOperator(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'perwittEdgeDiffOperator hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_robertEdgeDiffOperator(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-robertEdgeDiffOperator.png", async, function(source:Image, expected:Image) {
            var result = Vision.robertEdgeDiffOperator(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'robertEdgeDiffOperator hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_laplacianEdgeDiffOperator(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-laplacianEdgeDiffOperator%28filterPositive%20=%20true%29.png", async, function(source:Image, expected:Image) {
            var result = Vision.laplacianEdgeDiffOperator(source, true);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'laplacianEdgeDiffOperator hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_cannyEdgeDetection(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-cannyEdgeDetection.png", async, function(source:Image, expected:Image) {
            var result = Vision.cannyEdgeDetection(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'cannyEdgeDetection hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_sobelEdgeDetection(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-sobelEdgeDetection.png", async, function(source:Image, expected:Image) {
            var result = Vision.sobelEdgeDetection(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'sobelEdgeDetection hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_perwittEdgeDetection(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-perwittEdgeDetection.png", async, function(source:Image, expected:Image) {
            var result = Vision.perwittEdgeDetection(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'perwittEdgeDetection hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_laplacianOfGaussianEdgeDetection(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-laplacianOfGaussianEdgeDetection%28filterPositive%20=%20true%29.png", async, function(source:Image, expected:Image) {
            var result = Vision.laplacianOfGaussianEdgeDetection(source, 2, true);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'laplacianOfGaussianEdgeDetection hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @Ignored("Algorithm changed - reference image needs regeneration")
    @:timeout(30000)
    function test_golden_convolutionRidgeDetection(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-convolutionRidgeDetection.png", async, function(source:Image, expected:Image) {
            var result = Vision.convolutionRidgeDetection(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'convolutionRidgeDetection hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_bilateralDenoise(async:Async) {
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-bilateralDenoise.png", async, function(source:Image, expected:Image) {
            var result = Vision.bilateralDenoise(source);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'bilateralDenoise hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }
    
    @:timeout(30000)
    function test_golden_kmeansPosterize(async:Async) {
        // Use maxColorCount=16 as documented
        loadGoldenTestImages(GOLDEN_BASE + "valve-original.png", GOLDEN_BASE + "valve-kmeansPosterize%28maxColorCount%20=%2016%29.png", async, function(source:Image, expected:Image) {
            var result = Vision.kmeansPosterize(source, 16);
            var resultHash = ImageHashing.phash(result);
            var expectedHash = ImageHashing.phash(expected);
            var distance = hammingDistance(resultHash, expectedHash);
            Assert.isTrue(distance <= HASH_THRESHOLD, 'kmeansPosterize hash distance $distance > $HASH_THRESHOLD');
            async.done();
        });
    }

    // =====================================================
    // UNIT TESTS (using local synthetic images)
    // =====================================================

    function test_invert_basic() {
        // Test invert on a simple image
        var img = new Image(2, 2);
        img.setPixel(0, 0, Color.fromRGBA(0, 0, 0, 255));       // Black
        img.setPixel(1, 0, Color.fromRGBA(255, 255, 255, 255)); // White
        img.setPixel(0, 1, Color.fromRGBA(255, 0, 0, 255));     // Red
        img.setPixel(1, 1, Color.fromRGBA(0, 255, 0, 255));     // Green
        
        var result = Vision.invert(img);
        
        Assert.equals(255, result.getPixel(0, 0).red); // Black -> White
        Assert.equals(0, result.getPixel(1, 0).red);   // White -> Black
        Assert.equals(0, result.getPixel(0, 1).red);   // Red -> Cyan
        Assert.equals(255, result.getPixel(0, 1).green);
        Assert.equals(255, result.getPixel(1, 1).red); // Green -> Magenta
        Assert.equals(0, result.getPixel(1, 1).green);
    }
    
    function test_grayscale_basic() {
        var img = new Image(2, 2);
        img.setPixel(0, 0, Color.fromRGBA(255, 0, 0, 255));     // Red
        img.setPixel(1, 0, Color.fromRGBA(0, 255, 0, 255));     // Green
        img.setPixel(0, 1, Color.fromRGBA(0, 0, 255, 255));     // Blue
        img.setPixel(1, 1, Color.fromRGBA(128, 128, 128, 255)); // Gray
        
        var result = Vision.grayscale(img, true); // simple average
        
        // Gray pixel should stay gray
        Assert.equals(result.getPixel(1, 1).red, result.getPixel(1, 1).green);
        Assert.equals(result.getPixel(1, 1).green, result.getPixel(1, 1).blue);
        
        // All pixels should have equal RGB values (grayscale)
        Assert.equals(result.getPixel(0, 0).red, result.getPixel(0, 0).green);
        Assert.equals(result.getPixel(0, 0).green, result.getPixel(0, 0).blue);
    }
    
    function test_blackAndWhite_basic() {
        var img = new Image(2, 2);
        img.setPixel(0, 0, Color.fromRGBA(200, 200, 200, 255)); // Light gray -> white
        img.setPixel(1, 0, Color.fromRGBA(50, 50, 50, 255));    // Dark gray -> black
        img.setPixel(0, 1, Color.fromRGBA(128, 128, 128, 255)); // Mid gray
        img.setPixel(1, 1, Color.fromRGBA(255, 0, 0, 255));     // Red
        
        var result = Vision.blackAndWhite(img, 127);
        
        // Light gray should become white
        Assert.equals(255, result.getPixel(0, 0).red);
        Assert.equals(255, result.getPixel(0, 0).green);
        Assert.equals(255, result.getPixel(0, 0).blue);
        
        // Dark gray should become black
        Assert.equals(0, result.getPixel(1, 0).red);
        Assert.equals(0, result.getPixel(1, 0).green);
        Assert.equals(0, result.getPixel(1, 0).blue);
    }
    
    function test_posterize_basic() {
        var result = Vision.posterize(gradientImage, 1); // 2 levels per channel
        
        // With 1 bit per channel, each channel should only have values 0 or 255
        for (y in 0...result.height) {
            for (x in 0...result.width) {
                var c = result.getPixel(x, y);
                Assert.isTrue(c.red == 0 || c.red == 255);
                Assert.isTrue(c.green == 0 || c.green == 255);
                Assert.isTrue(c.blue == 0 || c.blue == 255);
            }
        }
    }
    
    function test_simpleImageSimilarity_identical() {
        var result = Vision.simpleImageSimilarity(gradientImage, gradientImage);
        Assert.floatEquals(1.0, result, 0.001); // Identical images = 1.0 similarity
    }
    
    function test_simpleImageSimilarity_different() {
        // Use pure white vs pure black for maximum difference
        var whiteImg = new Image(100, 100, 0xFFFFFFFF);
        var result = Vision.simpleImageSimilarity(whiteImg, blackImage);
        Assert.isTrue(result < 0.5); // Very different images should have low similarity
    }
    
    function test_simpleLine2DDetection() {
        // Create an image with a known horizontal line
        var img = new Image(50, 50, 0xFF000000); // Black
        for (x in 10...40) {
            img.setPixel(x, 25, 0xFFFFFFFF); // White horizontal line
        }
        var result = Vision.simpleLine2DDetection(img);
        Assert.notNull(result);
    }
    
    function test_kmeansGroupImageColors() {
        var result = Vision.kmeansGroupImageColors(gradientImage, 5);
        Assert.notNull(result);
        Assert.isTrue(result.length > 0);
        Assert.isTrue(result.length <= 5);
        Assert.notNull(result[0].centroid);
    }
    
    function test_affineTransform_identity() {
        var img = gradientImage.clone();
        var identity = Matrix2D.IDENTITY();
        var result = Vision.affineTransform(img, identity);
        Assert.notNull(result);
        Assert.equals(img.width, result.width);
        Assert.equals(img.height, result.height);
    }
    
    function test_projectiveTransform_identity() {
        var img = gradientImage.clone();
        var identity = Matrix2D.IDENTITY();
        var result = Vision.projectiveTransform(img, identity);
        Assert.notNull(result);
        Assert.equals(img.width, result.width);
        Assert.equals(img.height, result.height);
    }
    
    function test_combine_50percent() {
        var white = new Image(10, 10, 0xFFFFFFFF);
        var black = new Image(10, 10, 0xFF000000);
        var result = Vision.combine(white, black, 50);
        
        // Result should be roughly gray (around 127-128)
        var pixel = result.getPixel(5, 5);
        Assert.isTrue(pixel.red >= 120 && pixel.red <= 135);
        Assert.isTrue(pixel.green >= 120 && pixel.green <= 135);
        Assert.isTrue(pixel.blue >= 120 && pixel.blue <= 135);
    }
    
    function test_normalize_expands_range() {
        // Create a low-contrast image
        var img = new Image(10, 10);
        for (y in 0...10) {
            for (x in 0...10) {
                var val = 100 + Std.int((x + y) * 2); // Range 100-136
                img.setPixel(x, y, Color.fromRGBA(val, val, val, 255));
            }
        }
        
        var result = Vision.normalize(img, 0x00000000, 0xFFFFFFFF);
        Assert.notNull(result);
        
        // After normalization, should use more of the 0-255 range
        var minVal = 255;
        var maxVal = 0;
        for (y in 0...10) {
            for (x in 0...10) {
                var c = result.getPixel(x, y);
                if (c.red < minVal) minVal = c.red;
                if (c.red > maxVal) maxVal = c.red;
            }
        }
        // Range should be expanded
        Assert.isTrue(maxVal - minVal > 100);
    }
    
    function test_limitColorRanges() {
        var img = new Image(10, 10);
        for (y in 0...10) {
            for (x in 0...10) {
                img.setPixel(x, y, Color.fromRGBA(x * 25, y * 25, 128, 255));
            }
        }
        
        var result = Vision.limitColorRanges(img, Color.fromRGBA(50, 50, 50, 255), Color.fromRGBA(200, 200, 200, 255));
        Assert.notNull(result);
        
        // All pixels should be within the limited range
        for (y in 0...10) {
            for (x in 0...10) {
                var c = result.getPixel(x, y);
                Assert.isTrue(c.red >= 50 && c.red <= 200);
                Assert.isTrue(c.green >= 50 && c.green <= 200);
                Assert.isTrue(c.blue >= 50 && c.blue <= 200);
            }
        }
    }
    
    function test_filterForColorChannel_red() {
        var result = Vision.filterForColorChannel(gradientImage, ColorChannel.RED);
        Assert.notNull(result);
        
        // Green and blue channels should be zeroed
        for (y in 0...result.height) {
            for (x in 0...result.width) {
                var c = result.getPixel(x, y);
                Assert.equals(0, c.green);
                Assert.equals(0, c.blue);
            }
        }
    }
}
