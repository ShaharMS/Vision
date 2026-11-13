package vision.native.browser;

#if (js && !nodejs)
import js.Browser;
import js.html.CanvasElement;
import vision.ds.Image;

/**
	A browser canvas that presents WebGPU batches without copying their pixels to the CPU.

	Each draw replaces the canvas frame and presents RGB on a black background.
	The caller owns the supplied device and should dispose the screen before it.
**/
class WebGpuScreen {
	public final canvas:CanvasElement;
	final device:WebGpuBatchDevice;
	final context:Dynamic;
	var closed = false;

	/** Opens a WebGPU canvas on the supplied compute device. **/
	public function new(device:WebGpuBatchDevice, width:Int, height:Int) {
		this.device = device;
		canvas = Browser.document.createCanvasElement();
		canvas.width = width;
		canvas.height = height;
		context = device.configure(canvas);
		Browser.document.body.appendChild(canvas);
	}

	/** Associates an image with the screen's WebGPU device. **/
	public function attach(image:Image):Bool return !closed && device.attach(image);

	/** Draws a committed image at the supplied canvas position. **/
	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		if (closed) throw new vision.exceptions.WebGpuError("This WebGPU screen is disposed.");
		device.draw(context, image, x, y);
	}

	/** Releases the canvas configuration and removes it from the page. **/
	public function dispose():Void {
		if (closed) return;
		closed = true;
		context.unconfigure();
		canvas.remove();
	}
}
#end
