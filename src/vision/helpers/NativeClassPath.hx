package vision.helpers;

#if macro
import haxe.io.Path;
import haxe.macro.Compiler;
import haxe.macro.Context;

class NativeClassPath {
	public static function add() {
		var source = Context.resolvePath("vision/ds/Screen.hx");
		Compiler.addClassPath(Path.join([Path.directory(source), "../../.."]));
	}
}
#end
