package;

class Config {
	macro public static function load(path:String) {
		// Register a dependency to the external file so the Haxe compilation cache is invalidated if the file changes.
		haxe.macro.Context.registerModuleDependency(haxe.macro.Context.getLocalModule(), path);
		return try {
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			macro $v{json};
		} catch (e) {
			haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
		}
	}
}
