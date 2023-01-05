package vision.exceptions;

import haxe.EnumTools;

class LibraryRequired extends VisionException {
    public function new(libraries:Array<String>, classDotField:String, ?fieldType:String = "function") {
        super('The $fieldType $classDotField requires the ${libraries[0]} haxelib.\n\tMake sure ${libraries[0] + if (libraries.length > 1) " and it's dependencies are" else " is"} installed & included:\n\n${getInclusionMethod(libraries)}' , "Missing Library Required");
    }

    function getInclusionMethod(libs:Array<String>):String {
        #if (lime || openfl || flixel)
        return '${[for (lib in libs) '\t\t<haxelib name="$lib"/>\n'].join("")}';
        #elseif kha
        return '${[for (lib in libs) '\t\tproject.addLibrary(\'$lib\');\n'].join("")}';
        #elseif ceramic
        return '\t\tplugins:\n${[for (lib in libs) '\t\t\t- $lib\n'].join("")}';
        #else
        return '${[for (lib in libs) '\t\t--library $lib\n'].join("")}';
        #end
    }
}