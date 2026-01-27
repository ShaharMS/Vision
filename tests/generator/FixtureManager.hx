package;

import haxe.io.Bytes;
import vision.ds.Image;
import vision.ds.ByteArray;
import vision.ds.ImageFormat;
import vision.algorithms.ImageHashing;
import sys.FileSystem;
import sys.io.File;

using StringTools;

/**
 * Golden image fixture system for testing image processing functions.
 * Uses perceptual hashing to compare images, allowing for minor floating-point 
 * differences across platforms while still catching meaningful regressions.
 */
class FixtureManager {
    
    public static var fixturesPath = "fixtures";
    public static var hashesFile = "fixtures/hashes.json";
    
    // Perceptual hash threshold - lower = stricter matching
    // 0 = exact match, higher values allow more difference
    public static var hashThreshold:Int = 5;
    
    /**
     * Compare an image result against the golden fixture.
     * If no fixture exists, creates one and returns true (first run).
     * 
     * @param result The computed image result
     * @param testName Name of the test (used as fixture filename)
     * @return True if result matches fixture (or fixture was created)
     */
    public static function matches(result:Image, testName:String):Bool {
        var fixturePath = '$fixturesPath/$testName.png';
        var hashPath = '$fixturesPath/$testName.hash';
        
        if (!FileSystem.exists(fixturesPath)) {
            FileSystem.createDirectory(fixturesPath);
        }
        
        // Calculate perceptual hash of result
        var resultHash:ByteArray = ImageHashing.phash(result);
        
        if (!FileSystem.exists(fixturePath)) {
            // First run - create fixture
            Sys.println('[FIXTURE] Creating new fixture: $testName');
            saveFixture(result, testName);
            return true;
        }
        
        // Load expected hash
        if (FileSystem.exists(hashPath)) {
            var expectedHash:ByteArray = File.getBytes(hashPath);
            var distance = hammingDistance(resultHash, expectedHash);
            
            if (distance <= hashThreshold) {
                return true;
            } else {
                Sys.println('[FIXTURE] Hash mismatch for $testName: distance=$distance (threshold=$hashThreshold)');
                saveMismatch(result, testName);
                return false;
            }
        }
        
        // No hash file - compare images directly (slower)
        var expected = loadFixture(testName);
        if (expected == null) {
            Sys.println('[FIXTURE] Could not load fixture: $testName');
            return false;
        }
        
        var expectedHash:ByteArray = ImageHashing.phash(expected);
        var distance = hammingDistance(resultHash, expectedHash);
        
        // Save hash for future fast comparisons
        File.saveBytes(hashPath, (resultHash : Bytes));
        
        if (distance <= hashThreshold) {
            return true;
        } else {
            Sys.println('[FIXTURE] Hash mismatch for $testName: distance=$distance');
            saveMismatch(result, testName);
            return false;
        }
    }
    
    /**
     * Generate fixtures for all image-returning functions.
     * Run this once to create the golden fixtures.
     */
    public static function generateFixtures(functions:Array<{name:String, fn:Void->Image}>):Void {
        if (!FileSystem.exists(fixturesPath)) {
            FileSystem.createDirectory(fixturesPath);
        }
        
        for (f in functions) {
            Sys.println('[FIXTURE] Generating: ${f.name}');
            try {
                var result = f.fn();
                saveFixture(result, f.name);
            } catch (e) {
                Sys.println('[FIXTURE] ERROR generating ${f.name}: $e');
            }
        }
        
        Sys.println('[FIXTURE] Done. Generated ${functions.length} fixtures.');
    }
    
    /**
     * Save an image as a fixture with its perceptual hash.
     */
    public static function saveFixture(image:Image, testName:String):Void {
        var fixturePath = '$fixturesPath/$testName.png';
        var hashPath = '$fixturesPath/$testName.hash';
        
        // Save PNG
        var pngData:ByteArray = vision.tools.ImageTools.exportToBytes(image, PNG);
        File.saveBytes(fixturePath, (pngData : Bytes));
        
        // Save perceptual hash for fast comparison
        var hash:ByteArray = ImageHashing.phash(image);
        File.saveBytes(hashPath, (hash : Bytes));
    }
    
    /**
     * Load a fixture image.
     */
    public static function loadFixture(testName:String):Image {
        var fixturePath = '$fixturesPath/$testName.png';
        
        if (!FileSystem.exists(fixturePath)) {
            return null;
        }
        
        var bytes:ByteArray = File.getBytes(fixturePath);
        return vision.tools.ImageTools.loadFromBytes(bytes, PNG);
    }
    
    /**
     * Save a mismatched result for manual inspection.
     */
    static function saveMismatch(image:Image, testName:String):Void {
        var mismatchPath = '$fixturesPath/mismatches';
        if (!FileSystem.exists(mismatchPath)) {
            FileSystem.createDirectory(mismatchPath);
        }
        
        var pngData:ByteArray = vision.tools.ImageTools.exportToBytes(image, PNG);
        File.saveBytes('$mismatchPath/$testName.png', (pngData : Bytes));
    }
    
    /**
     * Calculate Hamming distance between two perceptual hashes.
     * Lower = more similar.
     */
    public static function hammingDistance(hash1:ByteArray, hash2:ByteArray):Int {
        var count = 0;
        var len = hash1.length < hash2.length ? hash1.length : hash2.length;
        
        for (i in 0...len) {
            var xor = hash1.get(i) ^ hash2.get(i);
            // Count set bits in xor
            while (xor != 0) {
                count += xor & 1;
                xor = xor >> 1;
            }
        }
        
        return count;
    }
    
    /**
     * Update a specific fixture (when intentionally changing behavior).
     */
    public static function updateFixture(testName:String, newImage:Image):Void {
        Sys.println('[FIXTURE] Updating fixture: $testName');
        saveFixture(newImage, testName);
    }
    
    /**
     * List all existing fixtures.
     */
    public static function listFixtures():Array<String> {
        if (!FileSystem.exists(fixturesPath)) {
            return [];
        }
        
        return [for (f in FileSystem.readDirectory(fixturesPath)) 
            if (f.endsWith(".png")) f.replace(".png", "")
        ];
    }
    
    /**
     * Delete all fixtures (for clean regeneration).
     */
    public static function clearFixtures():Void {
        if (!FileSystem.exists(fixturesPath)) return;
        
        for (f in FileSystem.readDirectory(fixturesPath)) {
            var path = '$fixturesPath/$f';
            if (!FileSystem.isDirectory(path)) {
                FileSystem.deleteFile(path);
            }
        }
        Sys.println('[FIXTURE] Cleared all fixtures');
    }
}
