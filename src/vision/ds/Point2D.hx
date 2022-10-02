package vision.ds;

@:structInit
class Point2D {
    
    /**
        The x-coordinate of the point.
    **/
    public var x:Float;

    /**
        The y-coordinate of the point.
    **/
    public var y:Float;

    /**
        Initializes a new instance of the Point2D class with the specified x and y coordinates.

        you can construct a Point2D object by using the following syntax too:
        ```haxe
        var point:Point2D = {x: 10, y: 20};
        ```    
    **/
    public inline function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }

    public inline function toString() {
        return '($x, $y)';
    }

    public inline function copy():Point2D {
        return {x: x, y: y};
    }
}