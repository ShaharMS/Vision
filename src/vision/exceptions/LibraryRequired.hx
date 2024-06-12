package vision.exceptions;

class LibraryRequired extends VisionException {
    public function new(library:String, dependencies:Array<String>, classDotField:String, ?fieldType:String = "function") {
        super('The $fieldType $classDotField requires the `${library}` haxelib.\n\tMake sure ${library + if (dependencies.length > 0) " and it's dependencies are" else " is"} installed & included:\n\n${getInclusionMethod([library].concat(dependencies))}' , "Missing Library Required");
    }

    static function getInclusionMethod(libs:Array<String>):String {
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
