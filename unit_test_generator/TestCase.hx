package;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
using StringTools;

class TestCase {
    public var originalFile:{
        ?pack:String,
        ?module:String,
        ?name:String,
        ?content:String
    }
    public var method:String;
    public var args:Array<String>;
    public var optionals:{
        ?pack:String,
        ?classDoc:String,
        ?imageLinkOrFile:String,
        ?attempts:Int
    };
    var t:String = "    ";
    public var splitter:String = "----------";

    public var indent(get, set):String;
    public var generatedClassName(get, null):String;
    
    public function new(packPath:String, module:String, method:String, ?args:Array<String>) {
        if (args == null) args = [];
        optionals = {};
        originalFile = {};
        optionals.imageLinkOrFile = "https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png";
        optionals.attempts = 5;
        originalFile.pack = packPath;
        originalFile.module = module;
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
--main ${if (optionals.pack != null) optionals.pack + "." else ""}Test_${originalFile.pack.replace(".", "_")}_${originalFile.module}_${method}
-debug
--interp
--library vision
--library format
        ';
        File.saveContent(path + "/" + name + "/compile.hxml", hxml);
        FileSystem.createDirectory(path + "/" + name + "/src");
        var sourceFolder = path + "/" + name + "/src";
        File.saveContent(sourceFolder + '${if (optionals.pack != null) optionals.pack.replace(".", "/") + "/" else "/"}Test_${originalFile.pack.replace(".", "_")}_${originalFile.module}_${method}.hx', toString());
        
        #end
    }

    public function getMainTestClass():String {
        return this.toString();        
    }


































































    function toString() {
        return 
'package${if (optionals.pack != null) " " + optionals.pack else ""};
${if (optionals.classDoc != null) "\n/**\n" else ""}${if (optionals.classDoc != null) t + optionals.classDoc else ""}${if (optionals.classDoc != null) "\n**/\n" else ""}
class Test_${originalFile.pack.replace(".", "_")}_${originalFile.module}_${method}
{
${t}public static function main()
${t}{
${t}${t}var start:Float = 0, end:Float = 0, sum:Float = 0, best:Float = Math.POSITIVE_INFINITY, worst:Float = 0;
${t}${t}var attempts = ${optionals.attempts};
${t}${t}vision.tools.ImageTools.loadFromFile("${optionals.imageLinkOrFile}", function(image)
${t}${t}{
${t}${t}${t}for (i in 0...attempts)
${t}${t}${t}{
${t}${t}${t}${t}start = haxe.Timer.stamp();
${t}${t}${t}${t}${originalFile.pack}.${originalFile.module}.$method(image${argsAsString()});
${t}${t}${t}${t}end = haxe.Timer.stamp();
${t}${t}${t}${t}if (end - start > worst) worst = end - start;
${t}${t}${t}${t}if (end - start < best) best = end - start;
${t}${t}${t}${t}sum += end - start;
${t}${t}${t}}
${t}${t}${t}trace("${splitter}${originalFile.pack}.${originalFile.module}.$method()${splitter}");
${t}${t}${t}trace("attempts: " + attempts);
${t}${t}${t}trace("worst: " + worst);
${t}${t}${t}trace("best: " + best);
${t}${t}${t}trace("average: " + sum / attempts);
${t}${t}${t}trace("${splitter}${getSplitterAtLength((originalFile.pack + originalFile.module + method).length + 4)}${splitter}");
${t}${t}});
${t}}
}
        
        ';
    }

	function get_indent():String {
		return t;
	}

	function set_indent(value:String):String {
		return t = value;
	}

	function get_generatedClassName():String {
		return 'Test_${originalFile.pack.replace(".", "_")}_${originalFile.module}_${method}';
	}
}