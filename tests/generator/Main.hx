package;

import vision.ds.IntPoint2D;
import vision.ds.Array2D;
import vision.tools.ImageTools;
import sys.io.File;
import sys.FileSystem;

using StringTools;

class Main {

    static function main() {
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
                Sys.println('Skipping: $file: $file is a js interface file');
                continue;
            }
            var shouldSkip = false;
            for (exclude in config.exclude) {
                trace(file, exclude);
                if (file.contains(exclude)) {
                    Sys.println('Skipping: $file: $file contains `$exclude`');
                    shouldSkip = true;
                    break;
                }
            }
            if (shouldSkip) {
                continue;
            }

            var outputFile = destination + "/" + file.split("/").pop().replace(".hx", "Tests.hx");
            if (!config.overwrite && FileSystem.exists(outputFile)) {
                Sys.println('Skipping: $file: $outputFile already exists');
            } else {
                Sys.println('Generating: $file -> $outputFile');
                if (!Generator.generateFromFile(file, outputFile)) {
                    continue;
                }
            }

            resultingClassArray.push(outputFile.split("/").pop().replace(".hx", ""));
        }

        Sys.println("Job Done! Use this array to test the classes:");
        Sys.println('   [${resultingClassArray.join(", ")}]');
        if (config.testsToRunFile.length > 0) {
            Sys.println("Found tests-to-run file! writing test cases there as well...");
            File.saveContent(FileSystem.absolutePath(config.testsToRunFile), 'package;\n\nimport tests.*;\n\nfinal tests:Array<Class<Dynamic>> = [\n\t${resultingClassArray.join(", \n\t")}\n];');
        }
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