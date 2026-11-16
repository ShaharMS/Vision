package vision.helpers;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import sys.io.Process;

/** Detects the SDL2 SDK for native desktop builds of the Vision haxelib. **/
@:noCompletion
class NativeScreenConfig {
	public static function configure():Void {
		if (!Context.defined("cpp") || Context.defined("cppia") || Context.defined("windows")
			|| Context.defined("android") || Context.defined("ios") || Context.defined("iphone")
			|| Context.defined("emscripten")) return;
		final host = Sys.systemName();
		if (host != "Linux" && host != "Mac") return;

		try {
			final probe = new Process("pkg-config", ["--variable=prefix", "sdl2"]);
			final prefix = StringTools.trim(probe.stdout.readAll().toString());
			final status = probe.exitCode();
			probe.close();
			if (status == 0 && prefix != "" && sys.FileSystem.exists(prefix + "/include/SDL2/SDL.h"))
				Compiler.define("VISION_SDL_PREFIX", prefix);
		} catch (_:Dynamic) {
			// Keep the in-memory backend available without a desktop SDK.
		}
	}
}
#end
