package vision.native.apple;

#if macro
import haxe.macro.Context;
import haxe.io.Path;

class MetalBuild {
	public static function configure():Array<haxe.macro.Expr.Field> {
		final header = sys.FileSystem.absolutePath(Context.resolvePath("vision/native/apple/MetalDevice.hpp"));
		final directory = Path.directory(header);
		final window = (Context.defined("mac") || Context.defined("ios")) ? '<depend name="' + StringTools.htmlEscape(directory + "/MetalWindow.hpp", true) + '" />' : "";
		// iOS produces a static archive. Its host app links the Apple frameworks.
		final frameworks = Context.defined("ios") ? "" :
			'<target id="haxe"><lib name="-Wl,-framework,Metal" /><lib name="-Wl,-framework,Foundation" />'
			+ '<lib name="-lobjc" /><lib name="-Wl,-framework,AppKit" /><lib name="-Wl,-framework,QuartzCore" /></target>';
		final xml = '<files id="haxe"><compilerflag value="-I' + StringTools.htmlEscape(directory, true)
			+ '" /><depend name="' + StringTools.htmlEscape(header, true)
			+ '" />' + window + '</files>' + frameworks;
		Context.getLocalClass().get().meta.add(":buildXml", [macro $v{xml}], Context.currentPos());
		return Context.getBuildFields();
	}
}
#end
