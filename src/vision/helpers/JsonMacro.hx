package vision.helpers;

class JsonMacro {
#if macro

public static macro function load(string:String) {
    return try {
        var json = haxe.Json.parse(string);
        macro $v{json}
    } catch (e) {
        haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
    }
}

#else

public static function load(string:String) {
    return haxe.Json.parse(string);
}

#end
}