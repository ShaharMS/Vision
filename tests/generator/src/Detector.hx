package;

import sys.io.File;
import sys.FileSystem;

class Detector {

    static var packageFinder = ~/^package ([\w.]+)/m;
    static var classNameFinder = ~/^(?:class|abstract) (\w+)/m;
    static var staticFunctionFinder = ~/(?:public static inline|public inline static|inline public static|public static) function (\w+)\((.+)\)(?::\w+)?\s*(?:$|{)/m;
    static var staticFieldFinder = ~/(?:public static inline|public inline static|inline public static|public static) (?:var|final) (\w+)\(get, \w+\)/m;
    static var instanceFieldFinder = ~/(?:public inline|inline public|public) (?:var|final) (\w+)\(get, \w+\)/m;
    static var instanceFunctionFinder = ~/(?:public inline|inline public|public) function (\w+)\((.+)\)(?::\w+)?\s*(?:$|{)/m;


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

        fileContent = originalFileContent;

        var instanceFunctions = new Map<String, String>();

        while (instanceFunctionFinder.match(fileContent)) {
            var functionName = instanceFunctionFinder.matched(1);
            var functionParameters = instanceFunctionFinder.matched(2);
            fileContent = instanceFunctionFinder.matchedRight();

            instanceFunctions.set(functionName, functionParameters);
        }

        fileContent = originalFileContent;

        var instanceFields = [];
        while (instanceFieldFinder.match(fileContent)) {
            var fieldName = instanceFieldFinder.matched(1);
            fileContent = instanceFieldFinder.matchedRight();

            instanceFields.push(fieldName);
        }

        return {
            packageName: packageName,
            className: className,
            staticFunctions: staticFunctions,
            staticFields: staticFields,
            instanceFunctions: instanceFunctions,
            instanceFields: instanceFields
        }
    }
}