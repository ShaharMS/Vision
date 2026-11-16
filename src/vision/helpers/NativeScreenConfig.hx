package vision.helpers;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import sys.io.Process;

/** Detects Linux Vulkan and X11 development libraries for hxcpp. **/
@:noCompletion
class NativeScreenConfig {
	public static function configure():Void {
		if (!Context.defined("cpp") || Context.defined("cppia") || Context.defined("windows")
			|| Context.defined("android") || Context.defined("ios") || Context.defined("iphone")
			|| Context.defined("emscripten")) return;
		if (Sys.systemName() == "Mac") {
			Compiler.define("mac");
			return;
		}
		if (Sys.systemName() != "Linux" || Context.defined("mac")) return;
		try {
			final probe = new Process("pkg-config", ["--exists", "vulkan", "x11"]);
			final status = probe.exitCode();
			probe.close();
			if (status == 0) Compiler.define("vision_vulkan");
		} catch (_:Dynamic) {
			// Keep the in-memory backend available without a Vulkan SDK.
		}
	}
}
#end
