package vision.ds.specifics;

@:structInit
class HarrisCornerOptions extends HarrisResponseOptions {
	public var relativeThreshold:Float = 0.01;
	public var minimumDistance:Float = 1;
	public var maxCorners:Int = 0;
	public var borderMargin:Int = 1;

	public function new() {
		super();
	}
}