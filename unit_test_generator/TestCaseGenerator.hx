package;

using StringTools;

class TestCaseGenerator {
    
    public static var packageRegex = ~/package *([a-zA-Z0-9\._]+);/;
    public static var classRegex = ~/class *([A-Z][a-zA-Z0-9\._]+)/;
    public static var functionRegex = ~/public *static *function *([a-zA-Z0-9_]+)/;

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
            tc.originalFile = {
                pack: mainPackage,
                name: mainClass,
                content: fileAsCode
            }
            parsed = functionRegex.replace(parsed, "");
            cases.push(tc);
        }

        return cases;
    }

}