package vision.ds.specifics;

@:structInit
class HarrisResponseOptions {
	/** The width and height of the nearby area used to combine brightness changes. **/
	public var blockSize:Int = 2;
	/** The size of the brightness-change stencil. Values are adjusted to a positive odd number. **/
	public var apertureSize:Int = 3;
	/** Balances corner strength against long, straight edges. The usual Harris value is `0.04`. **/
	public var k:Float = 0.04;
	/** Uses a soft, center-weighted nearby area instead of giving every nearby pixel equal weight. **/
	public var useGaussianWindow:Bool = false;

	public function new() {}
}
