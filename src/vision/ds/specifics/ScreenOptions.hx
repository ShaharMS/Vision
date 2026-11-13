package vision.ds.specifics;

/** Settings for the destination owned by a Screen. **/
@:structInit
class ScreenOptions {
	/** Prefer GPU presentation when the backend offers it. **/
	public var preferGpu:Bool = true;
	#if (js && !nodejs)
	/** An initialized WebGPU device. Draws replace the canvas frame. **/
	public var webGpu:Null<vision.native.browser.WebGpuBatchDevice> = null;
	#end
	/** Shows the presentation surface when it opens. **/
	public var visible:Bool = true;
	/** Uses an in-memory surface without opening a window or adding a canvas. **/
	public var offscreen:Bool = false;
	/** Initial target frames per second for polling. **/
	public var frameRate:Int = 60;
}
