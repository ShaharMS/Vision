package vision.native.linux;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.Process;

class VulkanBuild {
	public static function supportsX11():Bool return pkgConfig(["--exists", "x11"]) != null;

	public static function waylandProtocols():Null<String> {
		if (pkgConfig(["--exists", "wayland-client"]) == null) return null;
		final data = pkgConfig(["--variable=pkgdatadir", "wayland-protocols"]);
		return data != null && FileSystem.exists(Path.join([data, "stable/xdg-shell/xdg-shell.xml"])) ? data : null;
	}

	public static function hasSdk():Bool {
		return pkgConfig(["--exists", "vulkan"]) != null && (supportsX11() || waylandProtocols() != null);
	}

	public static function configure():Array<haxe.macro.Expr.Field> {
		final directory = Path.directory(FileSystem.absolutePath(Context.resolvePath("vision/native/linux/VulkanDevice.hpp")));
		final escaped = StringTools.htmlEscape(directory, true);
		var files = '<compilerflag value="-I' + escaped + '" />';
		for (header in ["VulkanDevice.hpp", "VulkanWindow.hpp", "VulkanX11Window.hpp", "VulkanWaylandWindow.hpp", "VulkanShader.hpp"])
			files += '<depend name="' + escaped + '/' + header + '" />';
		var libraries = '<lib name="-lvulkan" />';
		if (supportsX11()) {
			files += '<compilerflag value="-DVISION_VULKAN_X11" />';
			libraries += '<lib name="-lX11" />';
		}
		final protocols = waylandProtocols();
		if (protocols != null) {
			final output = Path.join([Compiler.getOutput(), "vision-wayland"]);
			FileSystem.createDirectory(output);
			final generated = StringTools.htmlEscape(FileSystem.absolutePath(output), true);
			files += '<compilerflag value="-DVISION_VULKAN_WAYLAND" /><compilerflag value="-I' + generated + '" />';
			for (protocol in [
				{path: "stable/xdg-shell/xdg-shell.xml", name: "xdg-shell"},
				{path: "unstable/xdg-decoration/xdg-decoration-unstable-v1.xml", name: "xdg-decoration"}
			]) {
				final xml = Path.join([protocols, protocol.path]);
				final header = protocol.name + "-client.h";
				final source = protocol.name + "-protocol.c";
				scan("client-header", xml, Path.join([output, header]));
				scan("private-code", xml, Path.join([output, source]));
				files += '<depend name="' + generated + '/' + header + '" /><file name="' + generated + '/' + source + '" />';
			}
			libraries += '<lib name="-lwayland-client" />';
		}
		final xml = '<files id="haxe">' + files + '</files><target id="haxe">' + libraries + '</target>';
		Context.getLocalClass().get().meta.add(":buildXml", [macro $v{xml}], Context.currentPos());
		return Context.getBuildFields();
	}

	static function pkgConfig(args:Array<String>):Null<String> {
		try {
			final probe = new Process("pkg-config", args);
			final value = StringTools.trim(probe.stdout.readAll().toString());
			final status = probe.exitCode();
			probe.close();
			return status == 0 ? value : null;
		} catch (_:Dynamic) {
			return null;
		}
	}

	static function scan(mode:String, input:String, output:String):Void {
		final scanner = pkgConfig(["--variable=wayland_scanner", "wayland-scanner"]);
		if (Sys.command(scanner == null || scanner == "" ? "wayland-scanner" : scanner, [mode, input, output]) != 0)
			Context.error("Could not generate Wayland bindings from " + input, Context.currentPos());
	}
}
#end
