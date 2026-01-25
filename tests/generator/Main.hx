package;

import sys.io.File;
import sys.FileSystem;

using StringTools;

/**
 * Test generator main entry point.
 * 
 * Commands:
 *   generate [--utest] [--legacy]  - Generate test files
 *   hxml [--quick] [--ci]          - Generate platform hxml files  
 *   fixtures [--clear]             - Manage golden image fixtures
 *   
 * Config loaded from config.json
 */
class Main {

    static function main() {
        var args = Sys.args();
        
        // When run via haxe --interp, Sys.args() contains compiler flags
        // Filter them out - our commands don't start with --
        args = args.filter(a -> !a.startsWith("--") || a == "--utest" || a == "--legacy" || a == "--quick" || a == "--ci" || a == "--list" || a == "--clear" || a == "--help" || a == "-h");
        // Also filter library paths and class paths
        args = filterCompilerArgs(args);
        
        var command = args.length > 0 ? args[0] : "generate";
        
        switch (command) {
            case "generate":
                runGenerate(args.slice(1));
            case "hxml":
                runHxml(args.slice(1));
            case "fixtures":
                runFixtures(args.slice(1));
            case "help" | "--help" | "-h":
                printHelp();
            default:
                // If unknown command and no args, default to generate
                if (args.length == 0 || command.contains("/") || command.contains("\\") || command.endsWith(".hx")) {
                    runGenerate([]);
                } else {
                    Sys.println('Unknown command: $command');
                    printHelp();
                }
        }
    }
    
    static function filterCompilerArgs(args:Array<String>):Array<String> {
        var result = [];
        var skipNext = false;
        var validCommands = ["generate", "hxml", "fixtures", "help"];
        var validFlags = ["--utest", "--legacy", "--quick", "--ci", "--list", "--clear", "--help", "-h"];
        
        for (arg in args) {
            if (skipNext) {
                skipNext = false;
                continue;
            }
            // Skip known haxe compiler args that take a value
            if (arg == "-cp" || arg == "-lib" || arg == "-main" || arg == "-D" || 
                arg.startsWith("-") && !arg.startsWith("--")) {
                skipNext = true;
                continue;
            }
            // Skip paths, haxe files, and package names
            if (arg.contains("/") || arg.contains("\\") || arg.endsWith(".hx") || arg.endsWith(".hxml")) {
                continue;
            }
            // Only keep known commands and flags
            if (validCommands.contains(arg) || validFlags.contains(arg)) {
                result.push(arg);
            }
        }
        return result;
    }
    
    static function runGenerate(args:Array<String>) {
        var useUtest = args.contains("--utest") || !args.contains("--legacy");
        var config = Config.load("config.json");
        var files = [];
        
        if (config.regenerateAll) {
            files = readFileStructure(FileSystem.absolutePath(config.source));
        }

        var source = FileSystem.absolutePath(config.source);
        var destination = FileSystem.absolutePath(config.destination);
        var resultingClassArray = [];

        for (file in files) {
            if (file.endsWith(".js.hx")) {
                Sys.println('Skipping: $file (js interface file)');
                continue;
            }
            
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
            var outputFile = destination + "/" + className + "Test.hx";
            
            if (!config.overwrite && FileSystem.exists(outputFile)) {
                Sys.println('Skipping: $file (output exists)');
                resultingClassArray.push(className + "Test");
                continue;
            }
            
            Sys.println('Generating: $file -> $outputFile');
            
            var success = if (useUtest) {
                // Extract class path from file path
                var classPath = extractClassPath(file, source);
                UtestGenerator.generateTestFile(classPath, outputFile, "fixtures");
            } else {
                Sys.println('ERROR: Legacy generator not available');
                false;
            };
            
            if (success) {
                resultingClassArray.push(className + "Test");
            }
        }

        Sys.println("\n✓ Generation complete!");
        Sys.println('  Generated ${resultingClassArray.length} test classes');
        
        // Write test runner file for utest
        if (useUtest && config.testsToRunFile.length > 0) {
            var runnerPath = FileSystem.absolutePath(config.testsToRunFile);
            var runnerContent = generateUtestRunner(resultingClassArray);
            File.saveContent(runnerPath, runnerContent);
            Sys.println('  Test runner: $runnerPath');
        } else if (config.testsToRunFile.length > 0) {
            // Legacy format
            File.saveContent(
                FileSystem.absolutePath(config.testsToRunFile), 
                'package;\n\nimport tests.*;\n\nfinal tests:Array<Class<Dynamic>> = [\n\t${resultingClassArray.join(", \n\t")}\n];'
            );
        }
    }
    
    static function runHxml(args:Array<String>) {
        var quick = args.contains("--quick");
        var ci = args.contains("--ci");
        
        var classPaths = ["src", "../src"];
        var libraries = ["vision", "utest"];
        var mainClass = "TestMain";
        
        if (ci) {
            PlatformHxmlGenerator.generateCiHxml(mainClass, classPaths, libraries, "generated/ci.hxml");
        } else if (quick) {
            PlatformHxmlGenerator.generateQuickTestHxml(mainClass, classPaths, libraries, "generated/quick.hxml");
        } else {
            PlatformHxmlGenerator.generateAllPlatformsHxml(mainClass, classPaths, libraries, "generated/all-platforms.hxml");
            PlatformHxmlGenerator.generateSeparateHxmlFiles(mainClass, classPaths, libraries, "generated/platforms");
        }
        
        Sys.println("✓ Hxml files generated");
    }
    
    static function runFixtures(args:Array<String>) {
        if (args.contains("--clear")) {
            FixtureManager.clearFixtures();
        } else if (args.contains("--list")) {
            var fixtures = FixtureManager.listFixtures();
            Sys.println('Fixtures (${fixtures.length}):');
            for (f in fixtures) {
                Sys.println('  - $f');
            }
        } else {
            Sys.println("Fixture commands:");
            Sys.println("  fixtures --list   - List all fixtures");
            Sys.println("  fixtures --clear  - Delete all fixtures");
            Sys.println("\nFixtures are auto-generated on first test run.");
        }
    }
    
    static function printHelp() {
        Sys.println("Vision Test Generator");
        Sys.println("");
        Sys.println("Commands:");
        Sys.println("  generate [--utest] [--legacy]");
        Sys.println("      Generate test files from source code");
        Sys.println("      --utest   Use utest framework (default)");
        Sys.println("      --legacy  Use legacy custom test format");
        Sys.println("");
        Sys.println("  hxml [--quick] [--ci]");
        Sys.println("      Generate platform build files");
        Sys.println("      --quick   Only fast targets (interp, neko, hl, jvm)");
        Sys.println("      --ci      CI mode (interp only, error on failure)");
        Sys.println("");
        Sys.println("  fixtures [--list] [--clear]");
        Sys.println("      Manage golden image fixtures");
        Sys.println("");
        Sys.println("  help");
        Sys.println("      Show this help");
    }
    
    static function generateUtestRunner(testClasses:Array<String>):String {
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
        
        return buf.toString();
    }
    
    static function extractClassPath(filePath:String, sourceRoot:String):String {
        // Convert file path to class path
        // sourceRoot is like .../src/vision, we need paths like vision.Vision
        // So we need to go one level up to include "vision" in the path
        
        // Normalize paths
        var normalizedFile = filePath.replace("\\", "/");
        var normalizedRoot = sourceRoot.replace("\\", "/");
        
        // Find where "vision" starts in the path
        var visionIndex = normalizedFile.indexOf("/vision/");
        if (visionIndex == -1) {
            // Try looking for vision at different position
            visionIndex = normalizedFile.indexOf("\\vision\\");
        }
        
        if (visionIndex != -1) {
            // Extract from "vision" onwards
            var relative = normalizedFile.substr(visionIndex + 1); // +1 to skip the leading /
            return relative.replace("/", ".").replace(".hx", "");
        }
        
        // Fallback: just use the filename
        var parts = normalizedFile.split("/");
        return parts[parts.length - 1].replace(".hx", "");
    }

    static function readFileStructure(from:String):Array<String> {
        var files = FileSystem.readDirectory(from);
        var result = [];
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
}