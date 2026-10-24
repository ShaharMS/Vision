package vision.ds.specifics;

@:structInit
class HoughCircleOptions {
	public var dp:Float = 1;
	public var minimumDistance:Float = 20;
	public var cannyLowThreshold:Float = 50;
	public var cannyHighThreshold:Float = 100;
	public var centerThreshold:Float = 30;
	public var minimumRadius:Int = 0;
	public var maximumRadius:Int = 0;
	public var blurRadius:Int = 1;

	public function new() {}
}