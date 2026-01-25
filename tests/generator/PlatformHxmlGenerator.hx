package;

import sys.FileSystem;
import sys.io.File;

using StringTools;

/**
 * Generates consolidated multi-platform hxml files using Haxe's --each/--next pattern.
 * Reduces 12 separate hxml files per test to a single all-platforms.hxml.
 */
class PlatformHxmlGenerator {
    
    // All supported Haxe targets
    public static var allTargets:Array<TargetConfig> = [
        { name: "interp", flag: "--interp", output: null },
        { name: "neko", flag: "--neko", output: "bin/neko/tests.n" },
        { name: "hl", flag: "--hl", output: "bin/hl/tests.hl" },
        { name: "js", flag: "--js", output: "bin/js/tests.js" },
        { name: "cpp", flag: "--cpp", output: "bin/cpp" },
        { name: "jvm", flag: "--jvm", output: "bin/jvm/tests.jar" },
        { name: "python", flag: "--python", output: "bin/python/tests.py" },
        { name: "lua", flag: "--lua", output: "bin/lua/tests.lua" },
        { name: "php", flag: "--php", output: "bin/php" },
        { name: "cs", flag: "--cs", output: "bin/cs" },
        { name: "java", flag: "--java", output: "bin/java" },
        { name: "cppia", flag: "--cppia", output: "bin/cppia/tests.cppia" },
    ];
    
    // Quick test targets (fastest compilation)
    public static var quickTargets:Array<String> = ["interp", "neko", "hl", "jvm"];
    
    /**
     * Generate a single hxml that builds for all platforms using --each/--next.
     */
    public static function generateAllPlatformsHxml(
        mainClass:String,
        classPaths:Array<String>,
        libraries:Array<String>,
        outputPath:String,
        ?selectedTargets:Array<String>
    ):Void {
        var targets = selectedTargets != null 
            ? allTargets.filter(t -> selectedTargets.contains(t.name))
            : allTargets;
        
        var buf = new StringBuf();
        
        // Comment header
        buf.add("# Auto-generated multi-platform test build\n");
        buf.add("# Run with: haxe all-platforms.hxml\n");
        buf.add("# Or run single target: haxe all-platforms.hxml --run interp\n\n");
        
        // Common options (apply to all targets via --each)
        for (cp in classPaths) {
            buf.add('--class-path $cp\n');
        }
        buf.add('--main $mainClass\n');
        buf.add('-debug\n');
        for (lib in libraries) {
            buf.add('--library $lib\n');
        }
        
        buf.add('\n--each\n\n');
        
        // Platform-specific sections
        var first = true;
        for (target in targets) {
            if (!first) {
                buf.add('\n--next\n');
            }
            first = false;
            
            buf.add('# ${target.name}\n');
            buf.add('${target.flag}');
            if (target.output != null) {
                buf.add(' ${target.output}');
            }
            buf.add('\n');
        }
        
        // Write file
        var dir = haxe.io.Path.directory(outputPath);
        if (dir != "" && !FileSystem.exists(dir)) {
            FileSystem.createDirectory(dir);
        }
        File.saveContent(outputPath, buf.toString());
        Sys.println('Generated: $outputPath');
    }
    
    /**
     * Generate individual platform hxml files (legacy compatibility).
     * Each file includes a common base hxml.
     */
    public static function generateSeparateHxmlFiles(
        mainClass:String,
        classPaths:Array<String>,
        libraries:Array<String>,
        outputDir:String
    ):Void {
        if (!FileSystem.exists(outputDir)) {
            FileSystem.createDirectory(outputDir);
        }
        
        // Generate common base
        var baseBuf = new StringBuf();
        for (cp in classPaths) {
            baseBuf.add('--class-path $cp\n');
        }
        baseBuf.add('--main $mainClass\n');
        baseBuf.add('-debug\n');
        for (lib in libraries) {
            baseBuf.add('--library $lib\n');
        }
        File.saveContent('$outputDir/common.hxml', baseBuf.toString());
        
        // Generate per-platform files
        for (target in allTargets) {
            var buf = new StringBuf();
            buf.add('common.hxml\n');
            buf.add('${target.flag}');
            if (target.output != null) {
                buf.add(' ${target.output}');
            }
            buf.add('\n');
            File.saveContent('$outputDir/${target.name}.hxml', buf.toString());
        }
        
        Sys.println('Generated ${allTargets.length + 1} hxml files in $outputDir');
    }
    
    /**
     * Generate a quick-test hxml for fast iteration (interpreter + fastest targets).
     */
    public static function generateQuickTestHxml(
        mainClass:String,
        classPaths:Array<String>,
        libraries:Array<String>,
        outputPath:String
    ):Void {
        generateAllPlatformsHxml(mainClass, classPaths, libraries, outputPath, quickTargets);
    }
    
    /**
     * Generate a CI hxml that runs tests and fails on any error.
     */
    public static function generateCiHxml(
        mainClass:String,
        classPaths:Array<String>,
        libraries:Array<String>,
        outputPath:String
    ):Void {
        var buf = new StringBuf();
        
        buf.add("# CI test build - exits with error code on test failure\n\n");
        
        for (cp in classPaths) {
            buf.add('--class-path $cp\n');
        }
        buf.add('--main $mainClass\n');
        for (lib in libraries) {
            buf.add('--library $lib\n');
        }
        buf.add('-D CI_MODE\n');
        buf.add('--interp\n');
        
        File.saveContent(outputPath, buf.toString());
        Sys.println('Generated: $outputPath');
    }
}

typedef TargetConfig = {
    name:String,
    flag:String,
    output:Null<String>
}
