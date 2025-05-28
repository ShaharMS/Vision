package;

import sys.io.File;
import sys.FileSystem;

class Detector {

    static var packageFinder = ~/^package ([\w.]+)/m;
    static var classNameFinder = ~/^class (\w+)/m;
    static var staticFunctionFinder = ~/(?:public static inline|public inline static|inline public static|public static) function (\w+)\((.+)\)(?::\w+)?\s*(?:$|{)/m;
    static var staticFieldFinder = ~/(?:public static inline|public inline static|inline public static|public static) (?:var|final) (\w+)\(get, \w+\)/m;

    public static function detectOnFile(pathToHaxeFile:String) {
        var pathToHaxeFile = FileSystem.absolutePath(pathToHaxeFile);
        var fileContent = File.getContent(pathToHaxeFile), originalFileContent = fileContent;

        packageFinder.match(fileContent);
        var packageName = packageFinder.matched(1);
        fileContent = packageFinder.matchedRight();

        classNameFinder.match(fileContent);
        var className = classNameFinder.matched(1);
        fileContent = classNameFinder.matchedRight();

        originalFileContent = fileContent;

        var staticFunctions = new Map<String, String>();
        while (staticFunctionFinder.match(fileContent)) {
            var functionName = staticFunctionFinder.matched(1);
            var functionParameters = staticFunctionFinder.matched(2);
            fileContent = staticFunctionFinder.matchedRight();

            staticFunctions.set(functionName, functionParameters);
        }

        fileContent = originalFileContent;

        var staticFields = [];
        while (staticFieldFinder.match(fileContent)) {
            var fieldName = staticFieldFinder.matched(1);
            fileContent = staticFieldFinder.matchedRight();

            staticFields.push(fieldName);
        }


        return {
            packageName: packageName,
            className: className,
            staticFunctions: staticFunctions,
            staticFields: staticFields
        }
    }
}