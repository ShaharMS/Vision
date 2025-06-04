package;

import sys.io.File;
import sys.FileSystem;

class Detector {

    static var packageFinder = ~/^package ([\w.]+)/m;
    static var importFinder = ~/^import ([\w.]+)/m;
    static var classNameFinder = ~/^(?:class|abstract) (\w+)/m;
    static var staticFunctionFinder = ~/(?:public static inline|public inline static|inline public static|public static) function (\w+)\((.+)\)(?::\w+)?\s*(?:$|{)/m;
    static var staticFieldFinder = ~/(?:public static inline|public inline static|inline public static|public static) (?:var|final) (\w+)\(get, \w+\)/m;
    static var instanceFieldFinder = ~/(?:public inline|inline public|public) (?:var|final) (\w+)\(get, \w+\)/m;
    static var instanceFunctionFinder = ~/(?:public inline|inline public|public) function (\w+)\((.+)\)(?::\w+)?\s*(?:$|{)/m;
    static var constructorFinder = ~/function new\s*\((.*)\)/;

    public static function detectOnFile(pathToHaxeFile:String):TestDetections {
        var pathToHaxeFile = FileSystem.absolutePath(pathToHaxeFile);
        var fileContent = File.getContent(pathToHaxeFile), originalFileContent = fileContent;

        packageFinder.match(fileContent);
        var packageName = packageFinder.matched(1);
        fileContent = packageFinder.matchedRight();

        var imports = [];
        while (importFinder.match(fileContent)) {
            var classPath = importFinder.matched(1);
            fileContent = importFinder.matchedRight();
            imports.push(classPath);
        }

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

        fileContent = originalFileContent;
        trace(originalFileContent);
        var constructorParameters = [];
        while (constructorFinder.match(fileContent)) {
            var parameters = constructorFinder.matched(1);
            fileContent = constructorFinder.matchedRight();
            constructorParameters.push(parameters);
        }

        return {
            packageName: packageName,
            imports: imports,
            className: className,
            staticFunctions: staticFunctions,
            staticFields: staticFields,
            instanceFunctions: instanceFunctions,
            instanceFields: instanceFields,
            constructorParameters: constructorParameters
        }
    }
}

typedef TestDetections = {
    packageName:String,
    imports:Array<String>,
    className:String,
    constructorParameters:Array<String>,
    staticFunctions:Map<String, String>,
    staticFields:Array<String>,
    instanceFunctions:Map<String, String>,
    instanceFields:Array<String>
}