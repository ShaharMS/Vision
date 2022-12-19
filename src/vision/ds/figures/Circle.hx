package vision.ds.figures;

@:structInit
class Circle {
	/**
		The `x` position of this `Circle`
	**/
	public var x:Int;
	/**
		The `y` position of this `Circle`
	**/
	public var y:Int;
	/**
		The `width` of this `Circle`
	**/
	public var width:Int;
	/**
		The `height` of this `Circle`
	**/
	public var height:Int;

	public var radius:Int;

	public function coordinateExists(X:Int, Y:Int):Bool {
		var locatedCoords:Array<{x:Int, y:Int}> = [];
		var rectangleCoords:Array<{x:Int, y:Int}> = [];

		for (x in 0...width) {
			for (y in 0...height) {
				rectangleCoords.push({x: x, y: y});
			}
		}
		for(haha in rectangleCoords) {
			if((haha.x % radius) == 0 && (haha.y % radius) == 0)
				locatedCoords.push(haha);
		}

		return locatedCoords.contains({x: X, y: Y});
	}
}
