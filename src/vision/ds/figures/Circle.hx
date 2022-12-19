package vision.ds.figures;

//@:structInit
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

	public function new(?x:Int, ?y:Int, width:Int, height:Int, radius:Int, centered:Bool = true) {
		if(centered) {
			if(x == null) x = width / 2;
			if(y == null) y = height / 2;
		} else {
			if(x == null) x = 0;
			if(y == null) y = 0;
		}
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.radius = radius;
	}
	public function forEachPixel(callback:(x:Int, y:Int) -> Void) {
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
		for(ae in locatedCoords) {
			callback(ae.x, ae.y);
		}
	}
	public function coordinateExists(X:Int, Y:Int):Bool {
		var e:Bool = false;
		forEachPixel((x, y) -> {
			if(x == X && y == Y)
			e = true;
		});
		return e;
	}
}
