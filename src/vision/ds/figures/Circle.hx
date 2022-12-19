package vision.ds.figures;

@:structInit
class Circle {
	/**
		The `x` position of this `Rectangle`
	**/
	public var x:Int;
	/**
		The `y` position of this `Rectangle`
	**/
	public var y:Int;
	/**
		The `width` of this `Rectangle`
	**/
	public var width:Int;
	/**
		The `height` of this `Rectangle`
	**/
	public var height:Int;

	public var radius:Int;

	public function coordinateExists(X:Int, Y:Int):Bool {
		var locatedCoordinates:Array<{x:Int, y:Int}> = [];
		var rectangleCoordinates:Array<{x:Int, y:Int}> = [];

		for (x in 0...width) {
			for (y in 0...height) {
				rectangleCoordinates.push({x: x, y: y});
			}
		}

		

		return false;
	}
}
