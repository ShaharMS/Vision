package;

import Detector.TestDetections;
import sys.FileSystem;
import sys.io.File;

using StringTools;


class Generator {


    public static var instanceFunctionTemplate = File.getContent(FileSystem.absolutePath("generator/templates/InstanceFunctionTestTemplate.hx"));
    public static var instanceFieldTemplate = File.getContent(FileSystem.absolutePath("generator/templates/InstanceFieldTestTemplate.hx"));

    public static var staticFunctionTemplate = File.getContent(FileSystem.absolutePath("generator/templates/StaticFunctionTestTemplate.hx"));
    public static var staticFieldTemplate = File.getContent(FileSystem.absolutePath("generator/templates/StaticFieldTestTemplate.hx"));

    public static var testClassActuatorTemplate = File.getContent(FileSystem.absolutePath("generator/templates/TestClassActuator.hx"));
    public static var testClassHeaderTemplate = File.getContent(FileSystem.absolutePath("generator/templates/TestClassHeader.hx"));

    public static function generateFromFile(pathToHaxeFile:String, pathToOutputFile:String) {
        var detections = Detector.detectOnFile(pathToHaxeFile);
        var file = File.write(FileSystem.absolutePath(pathToOutputFile));

        file.writeString(generateFileHeader(detections.packageName, detections.className, detections.imports));

        trace(detections);

        for (field in detections.staticFields) {
            file.writeString(generateTest(staticFieldTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: field,
                testGoal: "ShouldWork"
            }));
        }

        for (field in detections.instanceFields) {
            file.writeString(generateTest(instanceFieldTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: field,
                testGoal: "ShouldWork",
                constructorParameters: extractParameters(detections.constructorParameters[0])
            }));
        }

        for (method => parameters in detections.staticFunctions) {
            file.writeString(generateTest(staticFunctionTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: method,
                testGoal: "ShouldWork",
                parameters: extractParameters(parameters)
            }));
        }

        for (method => parameters in detections.instanceFunctions) {
            file.writeString(generateTest(instanceFunctionTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: method,
                testGoal: "ShouldWork",
                parameters: extractParameters(parameters),
                constructorParameters: extractParameters(detections.constructorParameters[0])
            }));
        }

        file.writeString(generateConstructor(detections));

        file.writeString(generateFileFooter());

        file.close();
    }    

    static function generateFileHeader(packageName:String, className:String, imports:Array<String>):String {
        return testClassHeaderTemplate
            .replace("CLASS_NAME", className)
            .replace("PACKAGE_NAME", packageName)
            .replace("ADDITIONAL_IMPORTS", imports.map(classPath -> 'import $classPath;').join("\n"));
    }

    static function generateFileFooter() {
        return '\n}';
    }

    static function generateTest(template:String, testBase:TestBase):String {
        var cleanPackage = testBase.packageName.replace(".", "_") + '_${testBase.className}';
        testBase.parameters ??= "";
        testBase.constructorParameters ??= "";
        return template
            .replace("X1", cleanPackage)
            .replace("X2", testBase.fieldName)
            .replace("X3", testBase.testGoal)
            .replace("X4", '${testBase.packageName}.${testBase.className}')
            .replace("X5", testBase.parameters)
            .replace("X6", testBase.constructorParameters) + "\n\n";
            
    }

    static function generateConstructor(detections:TestDetections) {
        var cleanPackage = detections.packageName.replace(".", "_") + '_${detections.className}';
        var functionNames = [];
        for (method in detections.staticFunctions.keys()) {
            functionNames.push('${cleanPackage}__${method}__ShouldWork');
        }
        for (method in detections.instanceFunctions.keys()) {
            functionNames.push('${cleanPackage}__${method}__ShouldWork');
        }
        for (field in detections.staticFields) {
            functionNames.push('${cleanPackage}__${field}__ShouldWork');
        }
        for (field in detections.instanceFields) {
            functionNames.push('${cleanPackage}__${field}__ShouldWork');
        }

        functionNames = functionNames.map(x -> '\n\t\t$x');
        
        return testClassActuatorTemplate.replace("TEST_ARRAY", functionNames.join(", "));
    }


    static function extractParameters(parameters:String):String {
        var regex = ~/\w+:(\w+|\{.+\},?)/;
        var parameterList = [];
        while (regex.match(parameters)) {
            var type = regex.matched(1);
            parameters = regex.matchedRight();
            parameterList.push('(null : $type)');
        }

        return parameterList.join(", ");
    }
}

typedef TestBase = {
    packageName:String,
    className:String,
    fieldName:String,
    testGoal:String,
    ?parameters:String,
    ?constructorParameters:String
}