package vision.native.apple;

#if macro
import haxe.macro.Context;
import haxe.io.Path;

class MetalBuild {
	public static function configure():Array<haxe.macro.Expr.Field> {
		final header = sys.FileSystem.absolutePath(Context.resolvePath("vision/native/apple/MetalDevice.hpp"));
		final directory = Path.directory(header);
		final window = (Context.defined("mac") || Context.defined("ios")) ? '<depend name="' + StringTools.htmlEscape(directory + "/MetalWindow.hpp", true) + '" />' : "";
		final frameworks = Context.defined("mac") ? '<lib name="-Wl,-framework,AppKit" /><lib name="-Wl,-framework,QuartzCore" />' : Context.defined("ios") ? '<lib name="-Wl,-framework,UIKit" /><lib name="-Wl,-framework,QuartzCore" />' : "";
		final xml = '<files id="haxe"><compilerflag value="-I' + StringTools.htmlEscape(directory, true)
			+ '" /><depend name="' + StringTools.htmlEscape(header, true)
			+ '" />' + window + '</files><target id="haxe"><lib name="-Wl,-framework,Metal" />'
			+ '<lib name="-Wl,-framework,Foundation" /><lib name="-lobjc" />' + frameworks + '</target>';
		Context.getLocalClass().get().meta.add(":buildXml", [macro $v{xml}], Context.currentPos());
		return Context.getBuildFields();
	}
}
#end
