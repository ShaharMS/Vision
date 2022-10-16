package;

#if sys
import sys.io.File;
import sys.FileSystem;
#end
using StringTools;

class TestCaseGenerator {
    
    static var packageRegex = ~/package *([a-zA-Z0-9\._]+);/;
    static var classRegex = ~/class *([A-Z][a-zA-Z0-9\._]+)/;
    static var functionRegex = ~/public *static *function *([a-zA-Z0-9_]+)/;

    public static function generateFromCode(fileAsCode:String, ?imageUrlOrLocation:String, ?argumentsPerFunction:Map<String, Array<String>>):Array<TestCase> {
        var cases = [];
        var mainPackage = "";
        var mainClass = "";
        //prepare the file for parsing
        //to make our job easier, lets work without line breaks
        var parsed = fileAsCode.replace("\n", "").replace("\r", "").replace("\t", " ");
        packageRegex.match(parsed);
        classRegex.match(parsed);
        mainPackage = packageRegex.matched(1);
        mainClass = classRegex.matched(1);

        //we have the package & class now
        //lets go over each public static method and extract the details
        while (functionRegex.match(parsed)) {
            var name = functionRegex.matched(1);
            var tc = new TestCase(mainPackage, mainClass, name, if (argumentsPerFunction != null) argumentsPerFunction[name] else []);
            tc.originalFile.content = fileAsCode;
            parsed = functionRegex.replace(parsed, "");
            cases.push(tc);
        }

        return cases;
    }

    public static function generateFromClass(module:Class<Dynamic>, ?imageUrlOrLocation:String, ?argumentsPerFunction:Map<String, Array<String>>) {
        return generateFromFunctions(Type.getClassFields(module), Type.getClassName(module).substring(0, Type.getClassName(module).lastIndexOf(".")), Type.getClassName(module).split(".").pop(), imageUrlOrLocation, argumentsPerFunction);
    }

    public static function generateFromFunctions(functions:Array<String>, pack:String, module:String, ?imageUrlOrLocation:String, ?argumentsPerFunction:Map<String, Array<String>>):Array<TestCase> {
        var cases = [];
        for (name in functions) {
            var tc = new TestCase(pack, module, name, if (argumentsPerFunction != null) argumentsPerFunction[name] else []);
            cases.push(tc);
        }

        return cases;
    }

    public static function generateHaxeProjectOfMultipleTestCases(cases:Array<TestCase>, path:String, name:String) {
        #if sys
        FileSystem.createDirectory(path + "/" + name);
        final hxml = 
'--class-path src
--main Main
-debug
--interp
--library vision
--library format
        ';
        File.saveContent(path + "/" + name + "/compile.hxml", hxml);
        FileSystem.createDirectory(path + "/" + name + "/src/tests");
        var sourceFolder = path + "/" + name + "/src";
        var main = generateMainClassOfCases(cases);
        File.saveContent(sourceFolder + "/Main.hx", main);
        for (c in cases) {
            c.optionals.pack = "tests";
            File.saveContent(sourceFolder + '${if (c.optionals.pack != null) "/" + c.optionals.pack.replace(".", "/") + "/" else "/"}${c.generatedClassName}.hx', c.getMainTestClass());
        }
        #end
    }

    static function generateMainClassOfCases(cases:Array<TestCase>):String {
        return
'package;

class Main {

    public static function main() {
        var start:Float, end:Float;
        trace("${cases[0].splitter}Launching Tests${cases[0].splitter}\\n");
        start = haxe.Timer.stamp();
        tests.${[for (c in cases) c.functionCallOfTestMain].join(";\n\t\ttests.")};
        end = haxe.Timer.stamp();
        trace("${cases[0].splitter}---------------${cases[0].splitter}\\n");
        trace("${cases.length} Tests, " + ((end - start) + "") + "s");
    }
}
';
    }
}