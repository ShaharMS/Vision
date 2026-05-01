package;

/**
 * Generates utest-compatible test files from Vision source code.
 * Delegates to the shared macro generator pipeline.
 */
class UtestGenerator {
    
    /**
     * Generate a utest test class for a given source file.
     * 
     * @param sourceClassPath Full class path like "vision.Vision"
     * @param outputPath Where to write the test file
     * @param fixturesPath Path to golden image fixtures (optional)
     */
    public static function generateTestFile(sourceClassPath:String, outputPath:String, ?fixturesPath:String):Bool {
        #if macro
        return GeneratorCore.generateTestFile(sourceClassPath, outputPath, fixturesPath);
        #else
        // Macro-only: no runtime generation available
        Sys.println('ERROR: Test generation requires macro context');
        return false;
        #end
    }
    
}
