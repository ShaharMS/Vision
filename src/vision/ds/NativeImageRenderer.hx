package vision.ds;

#if (vision_native && (cpp || hl))
import vision.exceptions.VisionException;
import vision.formats.__internal.NativeImageIO;
import vision.formats.__internal.NativeImageIO.NativeWindow;

/** A standalone Windows drawing window for hxcpp and HashLink. Use it from its creating thread. **/
class NativeImageRenderer {
	public final width:Int;
	public final height:Int;
	public var usesWebGpu(get, never):Bool;

	var window:NativeWindow;

	/** Opens a drawing window. Pass false for visible to render into a hidden window. **/
	public function new(width:Int, height:Int, preferWebGpu:Bool = true, visible:Bool = true) {
		this.width = width;
		this.height = height;
		window = NativeImageIO.open(width, height, visible, preferWebGpu);
		if (window == null) throw new VisionException("Could not create a native drawing window", "NativeImageRenderer");
	}

	inline function get_usesWebGpu():Bool {
		return window != null && NativeImageIO.gpu(window);
	}

	/** Pumps window events. Returns false after the window closes. **/
	public function poll():Bool {
		return window != null && NativeImageIO.poll(window);
	}

	/** Starts a frame with an opaque background. **/
	public function clear(color:Color = Color.BLACK):Void {
		checkOpen();
		NativeImageIO.clear(window, color);
	}

	/** Composites a Vision image at the supplied pixel position. **/
	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		checkOpen();
		if (image.width <= 0 || image.height <= 0) return;
		final bytes = image.exportToBytes();
		if (!NativeImageIO.draw(window, bytes.getData(), bytes.length, image.width, image.height, x,
			y)) throw new VisionException("Could not draw the image in the native window", "NativeImageRenderer");
	}

	/** Presents the completed frame. Returns false when the window is closed or drawing fails. **/
	public function present():Bool {
		return window != null && NativeImageIO.present(window);
	}

	/** Closes the window and releases its drawing resources. **/
	public function dispose():Void {
		if (window != null) {
			NativeImageIO.close(window);
			window = null;
		}
	}

	inline function checkOpen():Void {
		if (window == null) throw new VisionException("The native image renderer has been disposed", "NativeImageRenderer");
	}
}
#end
