package vision.exceptions;

import haxe.EnumTools;

class LibraryRequired extends VisionException {
    public function new(libraryName:String, classDotField:String, ?fieldType:String = "function") {
        super('The $fieldType $classDotField requires the $libraryName haxelib. Make sure $libraryName is installed & included (${getInclusionMethod(libraryName)})' , "Missing Library Required");
    }

    function getInclusionMethod(lib:String):String {
        #if (lime || openfl || flixel)
        return '<haxelib name="$lib"/>'
        #elseif kha
        return 'project.addLibrary(\'$lib\');'
        #elseif ceramic
        return "Add `- vision` to `plugins:`"
        #else
        return '--library $lib';
        #end
    }
}