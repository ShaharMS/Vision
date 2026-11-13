package vision.native.vulkan;

#if macro
import haxe.macro.Context;
import haxe.io.Path;

class VulkanBuild {
	public static function configure():Array<haxe.macro.Expr.Field> {
		final header = sys.FileSystem.absolutePath(Context.resolvePath("vision/native/vulkan/VulkanDevice.hpp"));
		final directory = Path.directory(header);
		final sdk = Sys.getEnv("VULKAN_SDK");
		final shader = Sys.getEnv("VISION_VULKAN_SHADER_DIR");
		if (shader == null) Context.error("Set VISION_VULKAN_SHADER_DIR to the directory containing VulkanShader.hpp.", Context.currentPos());
		final include = sdk == null ? "" : '<compilerflag value="-I' + StringTools.htmlEscape(sdk + "/include", true) + '" />';
		final library = Context.defined("windows") ? (sdk == null ? "vulkan-1.lib" : sdk + "/Lib/vulkan-1.lib") : "-lvulkan";
		final xml = '<files id="haxe"><compilerflag value="-I' + StringTools.htmlEscape(directory, true)
			+ '" /><compilerflag value="-I' + StringTools.htmlEscape(shader, true) + '" />' + include
			+ '<depend name="' + StringTools.htmlEscape(header, true) + '" /><depend name="'
			+ StringTools.htmlEscape(shader + "/VulkanShader.hpp", true) + '" /></files><target id="haxe"><lib name="'
			+ StringTools.htmlEscape(library, true) + '" /></target>';
		Context.getLocalClass().get().meta.add(":buildXml", [macro $v{xml}], Context.currentPos());
		return Context.getBuildFields();
	}
}
#end
