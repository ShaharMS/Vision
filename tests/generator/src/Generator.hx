package;

import sys.FileSystem;
import sys.io.File;



class Generator {


    public static var instanceFunctionTemplate = File.getContent("templates/InstanceFunctionTestTemplate.hx");
    public static var instanceFieldTemplate = File.getContent("templates/InstanceFieldTestTemplate.hx");

    public static var staticFunctionTemplate = File.getContent("templates/StaticFunctionTestTemplate.hx");
    public static var staticFieldTemplate = File.getContent("templates/StaticFieldTestTemplate.hx");


    public static function generateFromFile(pathToHaxeFile:String, pathToOutputFile:String) {
        var detections = Detector.detectOnFile(pathToHaxeFile);


        trace(detections);
    }    

    static function generateFileHeader(packageName:String, className:String) {
        return 'package ${packageName};\n\nclass ${className} {\n';
    }

    static function generateFileFooter() {
        return '\n}';
    }

    static function generateTest(template:String, testBase:TestBase) {
        
    }
}

typedef TestBase = {
    packageName:String,
    className:String,
    fieldName:String,
    testGoal:String,
    ?parameters:String
}