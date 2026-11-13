package vision.native.windows;

#if macro
import haxe.macro.Context;
import haxe.io.Path;

class D3D11Build {
	public static function configure():Array<haxe.macro.Expr.Field> {
		final header = sys.FileSystem.absolutePath(Context.resolvePath("vision/native/windows/D3D11Device.hpp"));
		final directory = Path.directory(header);
		final xml = '<files id="haxe"><compilerflag value="-I' + StringTools.htmlEscape(directory, true)
			+ '" /><depend name="' + StringTools.htmlEscape(header, true) + '" /></files><target id="haxe"><lib name="d3d11.lib" /><lib name="d3dcompiler.lib" /></target>';
		Context.getLocalClass().get().meta.add(":buildXml", [macro $v{xml}], Context.currentPos());
		return Context.getBuildFields();
	}
}
#end
