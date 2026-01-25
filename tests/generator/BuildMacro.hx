package;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import MacroDetector;

using StringTools;

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
        
        var sourceDir = FileSystem.absolutePath(config.source);
        var destDir = FileSystem.absolutePath(config.destination);
        
        // Ensure destination exists
        ensureDirectory(destDir);
        
        var files = readFileStructure(sourceDir);
        var generatedClasses:Array<String> = [];
        
        for (file in files) {
            // Skip js interface files
            if (file.endsWith(".js.hx")) {
                Sys.println('Skipping: $file (js interface file)');
                continue;
            }
            
            // Check exclusions
            var shouldSkip = false;
            for (exclude in config.exclude) {
                if (file.contains(exclude)) {
                    Sys.println('Skipping: $file (excluded: $exclude)');
                    shouldSkip = true;
                    break;
                }
            }
            if (shouldSkip) continue;
            
            var className = file.split("/").pop().replace(".hx", "");
            var outputFile = destDir + "/" + className + "Test.hx";
            
            // Check if output exists and overwrite setting
            if (!config.overwrite && FileSystem.exists(outputFile)) {
                Sys.println('Skipping: $file (output exists)');
                generatedClasses.push(className + "Test");
                continue;
            }
            
            // Extract class path
            var classPath = extractClassPath(file, sourceDir);
            Sys.println('Generating: $classPath -> $outputFile');
            
            if (generateTestFile(classPath, outputFile)) {
                generatedClasses.push(className + "Test");
            }
        }
        
        Sys.println('\n✓ Generation complete!');
        Sys.println('  Generated ${generatedClasses.length} test classes');
        
        // Write test runner
        if (config.testsToRunFile.length > 0) {
            var runnerPath = FileSystem.absolutePath(config.testsToRunFile);
            writeTestRunner(runnerPath, generatedClasses);
            Sys.println('  Test runner: $runnerPath');
        }
    }
    
    /**
     * Generate a single test file for a class.
     */
    public static function generateTestFile(sourceClassPath:String, outputPath:String):Bool {
        var testables:Array<TestableFunction>;
        try {
            testables = MacroDetector.detectClass(sourceClassPath);
        } catch (e:Dynamic) {
            Sys.println('  INFO: Could not analyze $sourceClassPath: $e');
            return false;
        }
        
        if (testables == null || testables.length == 0) {
            Sys.println('  INFO: No testable members found in $sourceClassPath');
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
        
        // Setup method
        output.add('    public function setup() {\n');
        output.add('        if (testImage == null) {\n');
        output.add('            testImage = new vision.ds.Image(100, 100);\n');
        output.add('            blackImage = new vision.ds.Image(100, 100, 0xFF000000);\n');
        output.add('            gradientImage = createGradientImage(100, 100);\n');
        output.add('        }\n');
        output.add('    }\n\n');
        
        // Gradient helper
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
            output.add(generateTestMethod(t, sourceClassPath));
            output.add('\n');
        }
        
        output.add('}\n');
        
        // Write file
        var dir = haxe.io.Path.directory(outputPath);
        ensureDirectory(dir);
        File.saveContent(outputPath, output.toString());
        return true;
    }
    
    static function generateTestMethod(t:TestableFunction, sourceClassPath:String):String {
        var buf = new StringBuf();
        
        buf.add('    function test_${t.name}() {\n');
        
        // Parameter declarations
        var paramNames:Array<String> = [];
        for (p in t.params) {
            var defaultVal = if (p.type == "Image") {
                "gradientImage";
            } else {
                MacroDetector.getDefaultForType(p.type);
            };
            buf.add('        var ${p.name} = $defaultVal;\n');
            paramNames.push(p.name);
        }
        
        var callTarget = if (t.isStatic) {
            sourceClassPath;
        } else {
            var ctorArgs:Array<String> = [];
            for (cp in t.constructorParams) {
                var defaultVal = MacroDetector.getDefaultForType(cp.type);
                buf.add('        var ctor_${cp.name} = $defaultVal;\n');
                ctorArgs.push('ctor_${cp.name}');
            }
            buf.add('        var instance = new $sourceClassPath(${ctorArgs.join(", ")});\n');
            "instance";
        };
        
        var call = t.kind == TKProperty 
            ? '$callTarget.${t.name}'
            : '$callTarget.${t.name}(${paramNames.join(", ")})';
        
        if (t.returnType == "Void") {
            buf.add('        $call;\n');
            buf.add('        Assert.pass();\n');
        } else if (t.returnType == "Image") {
            buf.add('        var result = $call;\n');
            buf.add('        Assert.notNull(result);\n');
        } else {
            buf.add('        var result = $call;\n');
            buf.add('        Assert.notNull(result);\n');
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
    
    static function writeTestRunner(path:String, testClasses:Array<String>):Void {
        var buf = new StringBuf();
        buf.add("package;\n\n");
        buf.add("import utest.Runner;\n");
        buf.add("import utest.ui.Report;\n");
        buf.add("import tests.*;\n\n");
        buf.add("class TestMain {\n");
        buf.add("    static function main() {\n");
        buf.add("        var runner = new Runner();\n\n");
        
        for (cls in testClasses) {
            buf.add('        runner.addCase(new $cls());\n');
        }
        
        buf.add("\n        Report.create(runner);\n");
        buf.add("        runner.run();\n");
        buf.add("    }\n");
        buf.add("}\n");
        
        ensureDirectory(haxe.io.Path.directory(path));
        File.saveContent(path, buf.toString());
    }
    
    static function loadConfig(path:String):{
        regenerateAll:Bool,
        overwrite:Bool,
        source:String,
        exclude:Array<String>,
        destination:String,
        testsToRunFile:String
    } {
        if (!FileSystem.exists(path)) return null;
        
        var content = File.getContent(path);
        try {
            return haxe.Json.parse(content);
        } catch (e:Dynamic) {
            return null;
        }
    }
    
    static function extractClassPath(filePath:String, sourceRoot:String):String {
        var normalizedFile = filePath.replace("\\", "/");
        
        var visionIndex = normalizedFile.indexOf("/vision/");
        if (visionIndex != -1) {
            var relative = normalizedFile.substr(visionIndex + 1);
            return relative.replace("/", ".").replace(".hx", "");
        }
        
        var parts = normalizedFile.split("/");
        return parts[parts.length - 1].replace(".hx", "");
    }
    
    static function readFileStructure(from:String):Array<String> {
        var files = FileSystem.readDirectory(from);
        var result:Array<String> = [];
        for (file in files) {
            var path = from + "/" + file;
            if (FileSystem.isDirectory(path)) {
                result = result.concat(readFileStructure(path));
            } else {
                result.push(path);
            }
        }
        return result;
    }
    
    static function ensureDirectory(path:String):Void {
        if (!FileSystem.exists(path)) {
            var parent = haxe.io.Path.directory(path);
            if (parent != "" && parent != path) {
                ensureDirectory(parent);
            }
            FileSystem.createDirectory(path);
        }
    }
}
#end
