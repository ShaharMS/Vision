package;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
using StringTools;

class TestCase {
    public var originalFile:{
        ?pack:String,
        ?name:String,
        ?content:String
    }
    public var method:String;
    public var args:Array<String>;
    public var module:String;
    public var modulePackage:String;
    public var optionals:{
        ?pack:String,
        ?classDoc:String,
        ?imageLinkOrFile:String,
        ?attempts:Int
    };
    public var t:String = "    ";
    public var splitter:String = "----------";
    
    public function new(packPath:String, module:String, method:String, ?args:Array<String>) {
        if (args == null) args = [];
        optionals = {};
        originalFile = {};
        optionals.imageLinkOrFile = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG";
        optionals.attempts = 5;
        modulePackage = packPath;
        this.module = module;
        this.method = method;
        args = args != null ? args : [];
    }

    function getSplitterAtLength(length:Int) {
        var s = splitter;
        if (s.length == 0) return s;
        while (s.length < length) s += s;
        return s.substring(0, length);
    }

    function argsAsString() {
        var r = "";

        if (args == null || args == []) return "";
        for (value in args) {
            r += ", " + value;
        }
        return r.substring(0, r.length - 2);
    }

    public function writeHaxeProject(path:String, name:String) {
        #if sys
        FileSystem.createDirectory(path + "/" + name);
        final hxml = 
'--class-path src
--main ${if (optionals.pack != null) optionals.pack + "." else ""}Test_${modulePackage.replace(".", "_")}_${module}_${method}
-debug
--interp
--library vision
        ';
        File.saveContent(path + "/" + name + "/compile.hxml", hxml);
        FileSystem.createDirectory(path + "/" + name + "/src");
        var sourceFolder = path + "/" + name + "/src";
        File.saveContent(sourceFolder + '${if (optionals.pack != null) optionals.pack.replace(".", "/") + "/" else "/"}Test_${modulePackage.replace(".", "_")}_${module}_${method}.hx', toString());
        
        #end
    }




































































    public function toString() {
        return 
'package${if (optionals.pack != null) " " + optionals.pack else ""};
${if (optionals.classDoc != null) "\n/**\n" else ""}${if (optionals.classDoc != null) t + optionals.classDoc else ""}${if (optionals.classDoc != null) "\n**/\n" else ""}
class Test_${modulePackage.replace(".", "_")}_${module}_${method}
{
${t}public static function main()
${t}{
${t}${t}var start:Float, end:Float, sum:Float, best:Float, worst:Float;
${t}${t}vision.tools.ImageTools.loadFromFile("${optionals.imageLinkOrFile}", function(image)
${t}${t}{
${t}${t}${t}for (i in 0...${optionals.attempts})
${t}${t}${t}{
${t}${t}${t}${t}start = haxe.Timer.stamp();
${t}${t}${t}${t}$modulePackage.$module.$method(image${argsAsString()});
${t}${t}${t}${t}end = haxe.Timer.stamp();
${t}${t}${t}${t}if (end - start > worst) worst = end - start;
${t}${t}${t}${t}if (end - start < best) best = end - start;
${t}${t}${t}${t}sum += end - start;
${t}${t}${t}}
${t}${t}${t}trace("${splitter}$modulePackage.$module.$method()${splitter}");
${t}${t}${t}trace("attempts: ${optionals.attempts}");
${t}${t}${t}trace("worst: " + worst);
${t}${t}${t}trace("best: " + best);
${t}${t}${t}trace("average: " + sum / ${optionals.attempts});
${t}${t}${t}trace("${splitter}${getSplitterAtLength((modulePackage + module + method).length + 4)}${splitter}");
${t}${t}});
${t}}
}
        
        ';
    }
}