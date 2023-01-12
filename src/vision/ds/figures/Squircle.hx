package vision.ds.figures;

//import vision.ds.figures.Rectangle;

//@:structInit
class Squircle /*extends Rectangle*/ {
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
	public var rounded:Int;

	public var accumulatedPoints:Array<{x:Int, y:Int}> = [];

	public function new(x:Int = 0, y:Int = 0, width:Int, height:Int, rounded:Int, accumulatePoints:Bool = true) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.rounded = rounded;

		if(accumulatePoints) {
			for (x in this.rounded...(this.width - this.rounded)) {
				/*if(x > (this.width - this.rounded) / 2)
					continue;*/

				for (y in this.rounded...(this.height - this.rounded)) {
					/*if(y > (this.width - this.rounded) / 2)
						continue;*/

					accumulatedPoints.push({x: x, y: y});
				}
			}
			for (pointt in accumulatedPoints)
				trace('RoundedRectangle: Pixel added at (x: ' + pointt.x + ', y: ' + pointt.y + ') round value: ' + this.rounded);
		}
	}
}
