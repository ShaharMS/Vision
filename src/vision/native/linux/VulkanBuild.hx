package vision.native.linux;

#if macro
import haxe.macro.Context;
import haxe.io.Path;

class VulkanBuild {
	public static function configure():Array<haxe.macro.Expr.Field> {
		final directory = Path.directory(sys.FileSystem.absolutePath(Context.resolvePath("vision/native/linux/VulkanDevice.hpp")));
		final escaped = StringTools.htmlEscape(directory, true);
		final xml = '<files id="haxe"><compilerflag value="-I' + escaped + '" />'
			+ '<depend name="' + escaped + '/VulkanDevice.hpp" /><depend name="' + escaped + '/VulkanWindow.hpp" />'
			+ '<depend name="' + escaped + '/VulkanShader.hpp" /></files>'
			+ '<target id="haxe"><lib name="-lvulkan" /><lib name="-lX11" /></target>';
		Context.getLocalClass().get().meta.add(":buildXml", [macro $v{xml}], Context.currentPos());
		return Context.getBuildFields();
	}
}
#end
