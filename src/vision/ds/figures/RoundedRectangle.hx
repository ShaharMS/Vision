package vision.ds.figures;

//import vision.ds.figures.Rectangle;

@:structInit
class RoundedRectangle /*extends Rectangle*/ {
	/**
		The `x` position of this `RoundedRectangle`
	**/
	public var x:Int;
	/**
		The `y` position of this `RoundedRectangle`
	**/
	public var y:Int;
	/**
		The `width` of this `RoundedRectangle`
	**/
	public var width:Int;
	/**
		The `height` of this `RoundedRectangle`
	**/
	public var height:Int;
	/**
		How rounded are the corners of this `RoundedRectangle`
	**/
	public var rounded:Float;

	public var accumulatedPoints:Array<{x:Int, y:Int}> = [];

	public function new(x:Int = 0, y:Int = 0, width:Int, height:Int, rounded:Float, accumulatePoints:Bool = true) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;

		if(accumulatePoints) {
			for (x in 0...this.width) {
				for (y in 0...this.height) {
					accumulatedPoints.push({x: x, y: y});
				}
			}
			for (pointt in accumulatedPoints)
				trace('RoundedRectangle: Pixel added at (x: ' + pointt.x + ', y: ' + pointt.y + ')');
		}
}
