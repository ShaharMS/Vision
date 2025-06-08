package;

import sys.io.File;
import sys.FileSystem;

using StringTools;

class Detector {

    static var packageFinder = ~/^package ([\w.]+)/m;
    static var importFinder = ~/^import ([\w.*]+)/m;
    static var classNameFinder = ~/^(?:class|abstract) (\w+)/m;
    static var staticFunctionFinder = ~/public static (?:inline )?function (\w+)(?:<T>)?\((.*)\)(:.+\s*|\s*)\{/m;
    static var staticFieldFinder = ~/public static (?:inline )?(?:var|final) (\w+)\(get, \w+\)/m;
    static var instanceFieldFinder = ~/public (?:inline )?(?:var|final) (\w+)\(get, \w+\)/m;
    static var instanceFunctionFinder = ~/public (?:inline )?function (\w+)(?:<T>)?\((.*)\)(:.+\s*|\s*)\{/m;
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

        if (!classNameFinder.match(fileContent)) {
            return null;
        }

        var className = classNameFinder.matched(1);
        fileContent = classNameFinder.matchedRight();

        originalFileContent = fileContent;


        var staticFunctions = new Map<{name:String, type:String}, String>();
        while (staticFunctionFinder.match(fileContent)) {
            var functionName = staticFunctionFinder.matched(1);
            var functionParameters = staticFunctionFinder.matched(2);
            var functionReturnType = staticFunctionFinder.matched(3).trim();
            if (functionReturnType == "") functionReturnType = "Void";
            
            fileContent = staticFunctionFinder.matchedRight();

            staticFunctions.set({name: functionName, type: functionReturnType}, functionParameters);
        }

        fileContent = originalFileContent;

        var staticFields = [];
        while (staticFieldFinder.match(fileContent)) {
            var fieldName = staticFieldFinder.matched(1);
            fileContent = staticFieldFinder.matchedRight();

            staticFields.push(fieldName);
        }

        fileContent = originalFileContent;

        var instanceFunctions = new Map<{name:String, type:String}, String>();

        while (instanceFunctionFinder.match(fileContent)) {
            var functionName = instanceFunctionFinder.matched(1);
            var functionParameters = instanceFunctionFinder.matched(2);
            var functionReturnType = instanceFunctionFinder.matched(3).trim();
            if (functionReturnType == "") functionReturnType = "Void";

            fileContent = instanceFunctionFinder.matchedRight();
            
            if (functionName == "new") {
                continue;
            }

            instanceFunctions.set({name: functionName, type: functionReturnType}, functionParameters);
        }

        fileContent = originalFileContent;

        var instanceFields = [];
        while (instanceFieldFinder.match(fileContent)) {
            var fieldName = instanceFieldFinder.matched(1);
            fileContent = instanceFieldFinder.matchedRight();

            instanceFields.push(fieldName);
        }

        fileContent = originalFileContent;

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
    staticFunctions:Map<{name:String, type:String}, String>,
    staticFields:Array<String>,
    instanceFunctions:Map<{name:String, type:String}, String>,
    instanceFields:Array<String>
}