package vision.ds;

/** A sequence of full-canvas images and their display durations. **/
class ImageAnimation {
	/** Frames in display order. All frames must have the same dimensions. **/
	public final frames:Array<AnimationFrame>;

	/** Total play count. Zero repeats indefinitely. **/
	public final loopCount:Int;

	/** Background color recorded in the animation container. **/
	public final background:Color;

	/**
		Creates a sequence of images in display order.

		@param frames The full-canvas images and their durations
		@param loopCount The number of plays, or zero for indefinite repetition
		@param background The background color to store in the container
	**/
	public function new(frames:Array<AnimationFrame>, loopCount:Int = 0, background:Color = 0) {
		this.frames = frames.copy();
		this.loopCount = loopCount;
		this.background = background;
	}
}

/** A composited animation frame. **/
typedef AnimationFrame = {
	final image:Image;
	/** Display duration in milliseconds. **/
	final duration:Int;
}
