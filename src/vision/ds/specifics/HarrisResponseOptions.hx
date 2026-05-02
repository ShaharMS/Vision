package vision.ds.specifics;

@:structInit
class HarrisResponseOptions {
	public var blockSize:Int = 2;
	public var apertureSize:Int = 3;
	public var k:Float = 0.04;
	public var useGaussianWindow:Bool = false;

	public function new() {}
}