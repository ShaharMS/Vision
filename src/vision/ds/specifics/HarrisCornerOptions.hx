package vision.ds.specifics;

@:structInit
class HarrisCornerOptions extends HarrisResponseOptions {
	/** Keeps points whose score is at least this share of the strongest corner score. **/
	public var relativeThreshold:Float = 0.01;
	/** Keeps accepted corners at least this many pixels apart. **/
	public var minimumDistance:Float = 1;
	/** Stops after this many strongest corners. `0` keeps every accepted corner. **/
	public var maxCorners:Int = 0;
	/** Ignores points this close to the image border. **/
	public var borderMargin:Int = 1;

	public function new() {
		super();
	}
}
