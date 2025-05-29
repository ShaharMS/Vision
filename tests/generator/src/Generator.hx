package;

import Detector.TestDetections;
import sys.FileSystem;
import sys.io.File;

using StringTools;


class Generator {


    public static var instanceFunctionTemplate = File.getContent(FileSystem.absolutePath("templates/InstanceFunctionTestTemplate.hx"));
    public static var instanceFieldTemplate = File.getContent(FileSystem.absolutePath("templates/InstanceFieldTestTemplate.hx"));

    public static var staticFunctionTemplate = File.getContent(FileSystem.absolutePath("templates/StaticFunctionTestTemplate.hx"));
    public static var staticFieldTemplate = File.getContent(FileSystem.absolutePath("templates/StaticFieldTestTemplate.hx"));

    public static var testClassActuatorTemplate = File.getContent(FileSystem.absolutePath("templates/TestClassActuator.hx"));

    public static function generateFromFile(pathToHaxeFile:String, pathToOutputFile:String) {
        var detections = Detector.detectOnFile(pathToHaxeFile);
        var file = File.write(FileSystem.absolutePath(pathToOutputFile));

        file.writeString(generateFileHeader(detections.packageName, detections.className));

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
                testGoal: "ShouldWork"
            }));
        }

        for (method => parameters in detections.staticFunctions) {
            var nulledOutParameters = parameters.split(",").map(x -> "null").join(",");
            file.writeString(generateTest(staticFunctionTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: method,
                testGoal: "ShouldWork",
                parameters: nulledOutParameters
            }));
        }

        for (method => parameters in detections.instanceFunctions) {
            var nulledOutParameters = parameters.split(",").map(x -> "null").join(",");
            file.writeString(generateTest(instanceFunctionTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: method,
                testGoal: "ShouldWork",
                parameters: nulledOutParameters
            }));
        }

        file.writeString(generateConstructor(detections));

        file.writeString(generateFileFooter());

        file.close();
    }    

    static function generateFileHeader(packageName:String, className:String) {
        return 'package;\n\nimport vision.exceptions.Unimplemented;\nimport TestResult;\n\nclass ${className} {\n';
    }

    static function generateFileFooter() {
        return '\n}';
    }

    static function generateTest(template:String, testBase:TestBase):String {
        var cleanPackage = testBase.packageName.replace(".", "_") + '_${testBase.className}';
        testBase.parameters ??= "";
        return template
            .replace("X1", cleanPackage)
            .replace("X2", testBase.fieldName)
            .replace("X3", testBase.testGoal)
            .replace("X4", '${testBase.packageName}.${testBase.className}')
            .replace("X5", testBase.parameters) + "\n\n";
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

        functionNames = functionNames.map(x -> '\n\t\t{testFunction: $x, testName: "$x"}');
        
        return testClassActuatorTemplate.replace("TEST_ARRAY", functionNames.join(", "));
    }
}

typedef TestBase = {
    packageName:String,
    className:String,
    fieldName:String,
    testGoal:String,
    ?parameters:String
}