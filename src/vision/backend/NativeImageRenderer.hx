package vision.backend;

#if (lime && lime_cffi && (cpp || hl))
import lime._internal.backend.native.NativeApplication;
import lime._internal.backend.native.NativeCFFI;
import lime.app.Application;
import lime.graphics.Image as LimeImage;
import lime.graphics.cairo.CairoImageSurface;
import lime.math.Rectangle;
import lime.math.Vector2;
import lime.ui.Window;
import lime.utils.BytePointer;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.VisionException;

/** Standalone desktop drawing through Lime's native bindings. **/
@:noCompletion
@:access(lime.app.Application)
@:access(lime.ui.Window)
@:access(lime._internal.backend.native.NativeApplication)
@:access(lime._internal.backend.native.NativeCFFI)
class NativeImageRenderer {
	static var standalone:Application;

	final application:Application;
	var window:Window;
	var texture:NativeTextureRenderer;
	final frame:LimeImage;
	final bounds:Rectangle;
	var open = true;

	public function new(width:Int, height:Int, preferGpu:Bool = true, visible:Bool = true, x:Int = 0, y:Int = 0) {
		if (Application.current == null) {
			standalone = new ScreenApplication();
			final backend:NativeApplication = cast standalone.__backend;
			NativeCFFI.lime_window_event_manager_register(backend.handleWindowEvent, backend.windowEventInfo);
			NativeCFFI.lime_application_init(backend.handle);
		}
		application = Application.current;
		window = createWindow(x, y, width, height, visible, preferGpu);
		if (window.context != null && window.context.gl != null) {
			try {
				window.__backend.render();
				texture = new NativeTextureRenderer();
			} catch (_:VisionException) {
				window.close();
				window = createWindow(x, y, width, height, visible, false);
			}
		}
		if (window.context == null) {
			window.close();
			throw new VisionException("Lime could not open a desktop drawing context", "Screen");
		}
		frame = new LimeImage(null, 0, 0, width, height);
		frame.format = BGRA32;
		bounds = new Rectangle(0, 0, width, height);
		clear(Color.BLACK);
		window.onClose.add(() -> {
			open = false;
		});
		window.onExpose.add(() -> {
			present();
		});
	}

	function createWindow(x:Int, y:Int, width:Int, height:Int, visible:Bool, hardware:Bool):Window {
		return application.createWindow({
			x: x,
			y: y,
			width: width,
			height: height,
			hidden: !visible,
			title: "Vision",
			context: {hardware: hardware}
		});
	}

	public function poll():Bool {
		if (open && application == standalone) {
			final backend:NativeApplication = cast application.__backend;
			NativeCFFI.lime_application_update(backend.handle);
		}
		return open;
	}

	public function clear(color:Color):Void {
		frame.fillRect(bounds, color | 0xFF000000, ARGB32);
	}

	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		if (!open || image.width <= 0 || image.height <= 0) return;
		final source = new LimeImage(null, 0, 0, image.width, image.height);
		final region = new Rectangle(0, 0, image.width, image.height);
		source.setPixels(region, new BytePointer(image.exportToBytes()), ARGB32);
		frame.copyPixels(source, region, new Vector2(x, y), null, null, true);
	}

	public function present():Bool {
		if (!open) return false;
		window.__backend.render();
		if (texture != null) {
			texture.draw(frame, bounds);
		} else {
			final cairo = window.context.cairo;
			if (cairo == null) return false;
			cairo.setSourceSurface(CairoImageSurface.fromImage(frame), 0, 0);
			cairo.paint();
		}
		window.__backend.contextFlip();
		return true;
	}

	public function dispose():Void {
		if (open) window.close();
	}
}

private class ScreenApplication extends Application {
	override function __checkForAllWindowsClosed():Void {}
}
#end
