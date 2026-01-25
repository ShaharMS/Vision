package;

import MacroDetector;
import sys.FileSystem;
import sys.io.File;

using StringTools;
using Lambda;

/**
 * Generates utest-compatible test files from Vision source code.
 * Uses MacroDetector for compile-time function introspection.
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
        var testables = MacroDetector.detectClass(sourceClassPath);
        if (testables.length == 0) {
            Sys.println('INFO: No testable members found in $sourceClassPath');
            return false;
        }
        
        var parts = sourceClassPath.split(".");
        var className = parts.pop();
        var packageName = parts.join(".");
        
        var output = new StringBuf();
        
        // Header
        output.add('package tests;\n\n');
        output.add('import utest.Assert;\n');
        output.add('import utest.Async;\n');
        output.add('import $sourceClassPath;\n');
        
        // Collect unique imports from parameter types
        var imports = collectImports(testables);
        for (imp in imports) {
            output.add('import $imp;\n');
        }
        
        output.add('\n@:access($sourceClassPath)\n');
        output.add('class ${className}Test extends utest.Test {\n');
        
        // Shared test fixtures
        output.add('\n    // Shared test fixtures\n');
        output.add('    static var testImage:vision.ds.Image;\n');
        output.add('    static var blackImage:vision.ds.Image;\n');
        output.add('    static var gradientImage:vision.ds.Image;\n');
        output.add('\n');
        
        // Setup method - use function setup() which utest calls automatically
        output.add('    public function setup() {\n');
        output.add('        if (testImage == null) {\n');
        output.add('            testImage = new vision.ds.Image(100, 100);\n');
        output.add('            blackImage = new vision.ds.Image(100, 100, 0xFF000000);\n');
        output.add('            gradientImage = createGradientImage(100, 100);\n');
        output.add('        }\n');
        output.add('    }\n\n');
        
        // Helper to create gradient image for fixtures
        output.add('    static function createGradientImage(w:Int, h:Int):vision.ds.Image {\n');
        output.add('        var img = new vision.ds.Image(w, h);\n');
        output.add('        for (y in 0...h) {\n');
        output.add('            for (x in 0...w) {\n');
        output.add('                var r = Std.int((x / w) * 255);\n');
        output.add('                var g = Std.int((y / h) * 255);\n');
        output.add('                var b = Std.int(((x + y) / (w + h)) * 255);\n');
        output.add('                img.setPixel(x, y, vision.ds.Color.fromRGBA(r, g, b, 255));\n');
        output.add('            }\n');
        output.add('        }\n');
        output.add('        return img;\n');
        output.add('    }\n\n');
        
        // Generate test for each testable
        for (t in testables) {
            output.add(generateTestMethod(t, sourceClassPath, fixturesPath));
            output.add('\n');
        }
        
        output.add('}\n');
        
        // Write file
        var dir = haxe.io.Path.directory(outputPath);
        if (!FileSystem.exists(dir)) {
            FileSystem.createDirectory(dir);
        }
        File.saveContent(outputPath, output.toString());
        return true;
        #else
        // Macro-only: no runtime generation available
        Sys.println('ERROR: Test generation requires macro context');
        return false;
        #end
    }
    
    #if macro
    static function generateTestMethod(t:TestableFunction, sourceClassPath:String, ?fixturesPath:String):String {
        var buf = new StringBuf();
        
        // Simple test name: test_methodName
        buf.add('    function test_${t.name}() {\n');
        
        // Parameter declarations using shared fixtures where possible
        var paramNames:Array<String> = [];
        for (p in t.params) {
            var defaultVal = if (p.type == "Image") {
                "gradientImage"; // Use shared fixture
            } else {
                MacroDetector.getDefaultForType(p.type);
            };
            buf.add('        var ${p.name} = $defaultVal;\n');
            paramNames.push(p.name);
        }
        
        var callTarget = if (t.isStatic) {
            sourceClassPath;
        } else {
            // Need to construct instance
            var ctorArgs:Array<String> = [];
            for (cp in t.constructorParams) {
                var defaultVal = MacroDetector.getDefaultForType(cp.type);
                buf.add('        var ctor_${cp.name} = $defaultVal;\n');
                ctorArgs.push('ctor_${cp.name}');
            }
            buf.add('        var instance = new $sourceClassPath(${ctorArgs.join(", ")});\n');
            "instance";
        };
        
        // Method call with assertion
        var call = t.kind == TKProperty 
            ? '$callTarget.${t.name}'
            : '$callTarget.${t.name}(${paramNames.join(", ")})';
        
        if (t.returnType == "Void") {
            buf.add('        $call;\n');
            buf.add('        Assert.pass(); // Function executed without throwing\n');
        } else if (t.returnType == "Image") {
            buf.add('        var result = $call;\n');
            buf.add('        Assert.notNull(result);\n');
            buf.add('        // TODO: Add golden image fixture comparison\n');
            buf.add('        // var expected = FixtureLoader.load("${t.name}");\n');
            buf.add('        // Assert.isTrue(ImageCompare.perceptualMatch(result, expected));\n');
        } else {
            buf.add('        var result = $call;\n');
            buf.add('        Assert.notNull(result); // TODO: Replace with actual expected value\n');
        }
        
        buf.add('    }\n');
        return buf.toString();
    }
    
    static function collectImports(testables:Array<TestableFunction>):Array<String> {
        var imports = new Map<String, Bool>();
        
        for (t in testables) {
            for (p in t.params) {
                var imp = extractImportFromType(p.type);
                if (imp != null) imports.set(imp, true);
            }
            for (cp in t.constructorParams) {
                var imp = extractImportFromType(cp.type);
                if (imp != null) imports.set(imp, true);
            }
        }
        
        return [for (k in imports.keys()) k];
    }
    
    static function extractImportFromType(typeName:String):String {
        // Vision types that need imports
        var visionTypes = [
            "Image" => "vision.ds.Image",
            "Color" => "vision.ds.Color",
            "Point2D" => "vision.ds.Point2D",
            "IntPoint2D" => "vision.ds.IntPoint2D",
            "Line2D" => "vision.ds.Line2D",
            "Ray2D" => "vision.ds.Ray2D",
            "ByteArray" => "vision.ds.ByteArray",
            "Kernel2D" => "vision.ds.Kernel2D",
            "Matrix2D" => "vision.ds.Matrix2D",
            "Histogram" => "vision.ds.Histogram",
        ];
        
        for (t => imp in visionTypes) {
            if (typeName.contains(t)) return imp;
        }
        return null;
    }
    #end
}
