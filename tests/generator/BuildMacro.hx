package;

#if macro
import haxe.macro.Context;
import TestModel.GeneratorConfig;

/**
 * Build-time macro that generates test files during compilation.
 * This runs at compile time, so MacroDetector can properly introspect types.
 */
class BuildMacro {
    
    /**
     * Call this as an initialization macro to generate all test files.
     * Usage in hxml: --macro BuildMacro.generateAll()
     */
    public static function generateAll():Void {
        var config = loadConfig("config.json");
        if (config == null) {
            Context.warning("Could not load config.json", Context.currentPos());
            return;
        }
        var result = GeneratorCore.generateAll(config);
        Sys.println('\n✓ Generation complete!');
        Sys.println('  Cataloged ${result.testClasses.length} test classes');
        Sys.println('  Wrote ${result.generatedFiles.length} generated files');
        Sys.println('  Skipped ${result.skippedFiles.length} existing files');
        Sys.println('  Protected ${result.protectedFiles.length} manual files');
    }
    
    /**
     * Generate a single test file for a class.
     */
    public static function generateTestFile(sourceClassPath:String, outputPath:String):Bool {
        return GeneratorCore.generateTestFile(sourceClassPath, outputPath);
    }
    
    static function loadConfig(path:String):GeneratorConfig {
        if (!sys.FileSystem.exists(path)) return null;
        
        var content = sys.io.File.getContent(path);
        try {
            return haxe.Json.parse(content);
        } catch (e:Dynamic) {
            return null;
        }
    }
    
}
#end
