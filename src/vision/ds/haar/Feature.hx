package vision.ds.haar;

import vision.tools.MathTools.*;
@:structInit
class Feature {

    public static var groupRectangles:Bool;
    
    @:optional public var x:Float = 0;
    @:optional public var y:Float = 0;
    @:optional public var width:Float = 0;
    @:optional public var height:Float = 0;
    @:optional public var index:Int = 0;

    @:optional public var isInside:Bool = false;
    
    public var area(get, never):Float;
	function get_area():Float return width * height;

    public function data(x:Dynamic, ?y, ?w, ?h, ?i) {
        var self = this;
        if (x is Feature)
        {
            self.copy(x);
        }
        else if (x is Dynamic)
        {
            self.x = x.x != null ? x.x : 0;
            self.y = x.y != null ? x.y : 0;
            self.width = x.width != null ? x.width : 0;
            self.height = x.height != null ? x.height : 0;
            self.index = x.index != null ? x.index : 0;
            self.isInside = x.isInside || false;
        }
        else if (x is Array)
        {
            self.x = x[0] != null ? x[0] : 0;
            self.y = x[1] != null ? x[1] : 0;
            self.width = x[2] != null ? x[2] : 0;
            self.height = x[3] != null ? x[3] : 0;
            self.index = x[4] != null ? x[4] : 0;
            self.isInside = x[5] || false;
        }
        else
        {
            self.x = x != null ? cast x : 0;
            self.y = y != null ? y : 0;
            self.width = width != null ? width : 0;
            self.height = height != null ? height : 0;
            self.index = index != null ? index : 0;
            self.isInside = isInside || false;
        }

        return self;
    }

    public function add(f:Feature) {
        this.x += f.x;
        this.y += f.y;
        this.width += f.width;
        this.height += f.height;
        return this;
    }

    public function scale(s:Float) {
        this.x *= s;
        this.y *= s;
        this.width *= s;
        this.height *= s;
        return this;
    }

    public function round() {
        this.x = cropDecimal(this.x+0.5);
        this.y = cropDecimal(this.y+0.5);
        this.width = cropDecimal(this.width+0.5);
        this.height = cropDecimal(this.height+0.5);
        return this;
    }

    public function inside(f:Feature, ?eps:Float) {
        if (eps == null) eps = 0.1;
        if (0 > eps) eps = 0;
        var dx = f.width * eps, dy = f.height * eps;
        return (this.x >= f.x - dx) &&
            (this.y >= f.y - dy) &&
            (this.x + this.width <= f.x + f.width + dx) &&
            (this.y + this.height <= f.y + f.height + dy);
    }

    public function contains(f:Feature, eps:Float) {
        return f.inside(this, null == eps ? 0.1 : eps);
    }

    public function equals(f:Feature, eps:Float) {
        if (null == eps) eps = 0.2;
        if (0 > eps) eps = 0;
        var delta = eps * (minFloat(this.width, f.width) + minFloat(this.height, f.height)) * 0.5;
        return abs(this.x - f.x) <= delta &&
            abs(this.y - f.y) <= delta &&
            abs(this.x + this.width - f.x - f.width) <= delta &&
            abs(this.y + this.height - f.y - f.height) <= delta;
    }

    public function clone() {
        var f:Feature = {};
        f.x = this.x;
        f.y = this.y;
        f.width = this.width;
        f.height = this.height;
        f.index = this.index;
        f.isInside = this.isInside;
        return f;
    }

    public function copy(f:Feature) {
        if (f != null)
        {
            this.x = f.x;
            this.y = f.y;
            this.width = f.width;
            this.height = f.height;
            this.index = f.index;
            this.isInside = f.isInside;
        }
        return this;
    }

    public function toString() {
        return (['[ x:', this.x, 'y:', this.y, 'width:', this.width, 'height:', this.height, ']'] : Array<Dynamic>).join(' ');
    }

}