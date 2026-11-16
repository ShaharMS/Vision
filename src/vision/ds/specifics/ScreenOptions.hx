package vision.ds.specifics;

/** Settings for the destination owned by a Screen. **/
@:structInit
class ScreenOptions {
	/** Prefer WebGL over Canvas 2D in browsers. Native windows use their platform graphics API. **/
	public var preferGpu:Bool = true;
	/** Shows the presentation surface when it opens. **/
	public var visible:Bool = true;
	/** Uses an in-memory surface without opening a window or adding a canvas. **/
	public var offscreen:Bool = false;
	/** Initial target frames per second for polling. **/
	public var frameRate:Int = 60;
}
