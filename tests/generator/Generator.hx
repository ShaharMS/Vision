package;

import vision.tools.ArrayTools;
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

    public static function generateFromFile(pathToHaxeFile:String, pathToOutputFile:String):Bool {
        var detections = Detector.detectOnFile(pathToHaxeFile);
        if (detections == null) {
            Sys.println('INFO: No tests could be generated for $pathToHaxeFile');
            return false;
        }
        var file = File.write(FileSystem.absolutePath(pathToOutputFile));

        file.writeString(generateFileHeader(detections.packageName, detections.className, detections.imports));

        for (field in detections.staticFields) {
            file.writeString(generateTest(staticFieldTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: field,
                fieldType: "",
                testGoal: "ShouldWork",
                parameters: extractParameters(""),
                constructorParameters: extractParameters(""),

            }));
        }

        for (field in detections.instanceFields) {
            file.writeString(generateTest(instanceFieldTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: field,
                fieldType: "",
                testGoal: "ShouldWork",
                parameters: extractParameters(""),
                constructorParameters: extractParameters(detections.constructorParameters[0] ?? "")
            }));
        }

        for (method => parameters in detections.staticFunctions) {
            file.writeString(generateTest(staticFunctionTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: method.name,
                fieldType: method.type,
                testGoal: "ShouldWork",
                parameters: extractParameters(parameters),
                constructorParameters: extractParameters("")
            }));
        }

        for (method => parameters in detections.instanceFunctions) {
            file.writeString(generateTest(instanceFunctionTemplate, {
                packageName: detections.packageName,
                className: detections.className,
                fieldName: method.name,
                fieldType: method.type,
                testGoal: "ShouldWork",
                parameters: extractParameters(parameters),
                constructorParameters: extractParameters(detections.constructorParameters[0] ?? "")
            }));
        }

        // file.writeString(generateConstructor(detections));

        file.writeString(generateFileFooter());

        file.close();

        return true;
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
        if (testBase.fieldType == "Void") {
            template = template.replace("var result = ", "").replace("returned: result", "returned: null");
        } else if (testBase.fieldType != "") {
            template = template.replace("X2__", 'X2_${~/[^a-zA-Z0-9_]/g.replace('${testBase.parameters.types}_${testBase.fieldType}', "")}__');
        } 
        if (hasSpecialConstructor(testBase.className)) {
            template = template.replace("new X4(X6)", generateSpecialConstructorFor(testBase.className, testBase.parameters.injection));
        }
        return template
            .replace("X1", cleanPackage)
            .replace("X2", testBase.fieldName)
            .replace("X3", testBase.testGoal)
            .replace("X4", '${testBase.packageName}.${testBase.className}')
            .replace("X5", testBase.parameters.injection)
            .replace("X6", testBase.constructorParameters.injection)
            .replace("X7", testBase.parameters.declarations)
            .replace("X8", testBase.constructorParameters.declarations) + "\n\n";
            
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


    static function extractParameters(parameters:String):{declarations:String, injection:String, types:String} {
        if (parameters.contains("average")) {
            trace(parameters);
        }
        var regex = ~/(\w+):((?:\(.+?\)\s*->\s*\w+)|(?:\w+(?:<\w+>)?\s*->\s*\w+)|(?:(?:EitherType|Map)<.+, .+>)|(?:\w+(?:<\{.+\}>|<\w+>))|(?:\w|\.)+|\{.+\}),?/;
        var output = {declarations: "", injection: [], types: []}
        while (regex.match(parameters)) {
            var name = regex.matched(1);
            var type = regex.matched(2);
            parameters = regex.matchedRight();
            output.declarations += 'var $name${getDefaultValueOf(type) == "null" ? ':$type' : ""} = ${getDefaultValueOf(type)};\n\t\t\t';
            output.injection.push(name);
            output.types.push(type);
        }

        return {
            declarations: output.declarations,
            injection: output.injection.join(", "),
            types: output.types.join("_")
        };
    }

    static function getDefaultValueOf(valueType:String):String {
        return switch valueType {
            case "String": '""';
            case "Int": "0";
            case "Float": "0.0";
            case "Bool": "false";
            case "() -> Void" | "Void->Void": "() -> return";
            case "Array<T>->T": "(_) -> null";
            case (_.contains("->") => true):
                var commas = valueType.split("->")[0].split(",").length;
                '(${[for (i in 0...commas) "_"].join(", ")}) -> null';
            case (_.startsWith("Array") || _.startsWith("Map") => true): "[]";
            case "Point2D" | "IntPoint2D" | "Int16Point2D" | "UInt16Point2D": 'new vision.ds.$valueType(0, 0)';
            case "Line2D": 'new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10})';
            case "Ray2D": 'new vision.ds.Ray2D({x: 0, y: 0}, 1)';
            case "ByteArray": 'vision.ds.ByteArray.from(0)';
            case "Image": 'new vision.ds.Image(100, 100)';
            case "T": "0"; // A little insane but should work in most cases so idk
            case (_.startsWith("T") && _.contains("->") => true): "(_) -> null";
            case "QueueCell<T>": "new vision.ds.QueueCell<Int>(0, null, null)";
            default: "null";
        }
    }

    static function hasSpecialConstructor(className:String):Bool {
        return switch className {
            case "ImageView": true;
            default: false;
        }
    }

    static function generateSpecialConstructorFor(className:String, parameterInjection:String):String {
        return switch className {
            case "ImageView": '({} : ImageView)';
            default: "new X4(X6)";
        }
    }
}

typedef TestBase = {
    packageName:String,
    className:String,
    fieldName:String,
    testGoal:String,
    ?parameters:{declarations:String, injection:String, types:String},
    ?constructorParameters:{declarations:String, injection:String, types:String},
    fieldType:String
}