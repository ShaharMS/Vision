package vision.native.apple;

#if macro
import haxe.macro.Context;
import haxe.io.Path;

class MetalBuild {
	public static function configure():Array<haxe.macro.Expr.Field> {
		final header = sys.FileSystem.absolutePath(Context.resolvePath("vision/native/apple/MetalDevice.hpp"));
		final directory = Path.directory(header);
		final xml = '<files id="haxe"><compilerflag value="-I' + StringTools.htmlEscape(directory, true)
			+ '" /><depend name="' + StringTools.htmlEscape(header, true)
			+ '" /></files><target id="haxe"><lib name="-Wl,-framework,Metal" />'
			+ '<lib name="-Wl,-framework,Foundation" /><lib name="-lobjc" /></target>';
		Context.getLocalClass().get().meta.add(":buildXml", [macro $v{xml}], Context.currentPos());
		return Context.getBuildFields();
	}
}
#end
