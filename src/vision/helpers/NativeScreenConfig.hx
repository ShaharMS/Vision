package vision.helpers;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import vision.native.linux.VulkanBuild;

/** Detects Linux Vulkan windowing development libraries for hxcpp. **/
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
		if (VulkanBuild.hasSdk()) Compiler.define("vision_vulkan");
	}
}
#end
