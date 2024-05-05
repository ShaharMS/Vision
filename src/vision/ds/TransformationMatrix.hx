package vision.ds;

import vision.ds.Matrix2D;

@:forward.variance
@:forward(getRow, getColumn, setRow, setColumn, map, clone, fill, toString)
abstract TransformationMatrix(Matrix2D) to Matrix2D {
    
    /**
		The underlying `Matrix2D` instance.
		you can safely use this for mathematical operations.
    **/
    public var underlying(get, never):Matrix2D;
    inline function get_underlying() return this;

    /**
        The top-left element in this matrix, at position `(0, 0)`:

		```haxe
		┌          ┐
		│ a  ᵇ  ᵗˣ │
		│ ᶜ  ᵈ  ᵗʸ │
		│ ᵉ  ᶠ  1  │
		└          ┘
		```

		Used for manipulation on the X axis, using a given point's X value.
    **/
    public var a(get, set):Float;
    inline function get_a() return this.get(0, 0);
    inline function set_a(a:Float) return this.set(0, 0, a);

    /**
        The top-middle element in this matrix, at position `(0, 1)`:

		```haxe
		┌          ┐
		│ ᵃ  b  ᵗˣ │
		│ ᶜ  ᵈ  ᵗʸ │
		│ ᵉ  ᶠ  1  │
		└          ┘
		```

		Used for manipulation on the X axis, using a given point's Y value.
    **/
    public var b(get, set):Float;
    inline function get_b() return this.get(0, 1);
    inline function set_b(b:Float) return this.set(0, 1, b);

    /**
		The middle-left element in this matrix, at position `(1, 0)`:

		```haxe
		┌          ┐
		│ ᵃ  ᵇ  ᵗˣ │
		│ c  ᵈ  ᵗʸ │
		│ ᵉ  ᶠ  1  │
		└          ┘
		```

		Used for manipulation on the Y axis, using a given point's X value.
    **/
    public var c(get, set):Float;
    inline function get_c() return this.get(1, 0);
    inline function set_c(c:Float) return this.set(1, 0, c);

	/**
		The center element in this matrix, at position `(1, 1)`:

		```haxe
		┌          ┐
		│ ᵃ  ᵇ  ᵗˣ │
		│ ᶜ  d  ᵗʸ │
		│ ᵉ  ᶠ  1  │
		└          ┘
		```

		Used for manipulation on the Y axis, using a given point's Y value.
    **/
    public var d(get, set):Float;
    inline function get_d() return this.get(1, 1);
    inline function set_d(d:Float) return this.set(1, 1, d);

	/**
		The bottom-left element in this matrix, at position `(0, 2)`:

		```haxe
		┌          ┐
		│ ᵃ  ᵇ  ᵗˣ │
		│ ᶜ  ᵈ  ᵗʸ │
		│ e  ᶠ  1  │
		└          ┘
		```

		Used for manipulation on the Z axis, using a given point's X value.
		The higher a pixel's value on the Z axis, the "deeper" it is in the image, 
		or in other terms, the closer it is to the vanishing point.
		
		The vanishing point is decided when we apply the matrix to each pixel - it is the X
		and Y offsets we add to each point before the main calculation. It also plays a 
		role in rotations and reflections, by acting like the rotation/reflection center.
    **/
    public var e(get, set):Float;
    inline function get_e() return this.get(0, 2);
    inline function set_e(e:Float) return this.set(0, 2, e);

	/**
		The bottom-middle element in this matrix, at position `(1, 2)`:

		```haxe
		┌          ┐
		│ ᵃ  ᵇ  ᵗˣ │
		│ ᶜ  ᵈ  ᵗʸ │
		│ ᵉ  f  1  │
		└          ┘
		```

		Used for manipulation on the Z axis, using a given point's Y value.
		The higher a pixel's value on the Z axis, the "deeper" it is in the image, 
		or in other terms, the closer it is to the vanishing point.
		
		The vanishing point is decided when we apply the matrix to each pixel - it is the X
		and Y offsets we add to each point before the main calculation. It also plays a 
		role in rotations and reflections, by acting like the rotation/reflection center.
    **/
    public var f(get, set):Float;
    inline function get_f() return this.get(1, 2);
    inline function set_f(f:Float) return this.set(1, 2, f);

	/**
		The top-left element in this matrix, at position `(2, 0)`:

		```haxe
		┌          ┐
		│ ᵃ  ᵇ  tx │
		│ ᶜ  ᵈ  ᵗʸ │
		│ ᵉ  ᶠ  1  │
		└          ┘
		```

		Used for manipulation on the Y axis, using a given point's Y value.
    **/
    public var tx(get, set):Float;
    inline function get_tx() return this.get(2, 0);
    inline function set_tx(tx:Float) return this.set(2, 0, tx);

    public var ty(get, set):Float;
    inline function get_ty() return this.get(2, 1);
    inline function set_ty(ty:Float) return this.set(2, 1, ty);

    function new(m:Matrix2D) {
        this = m;
    }

    /**
	    Multiplies the given point by this `Matrix2D`
	    @param point any 3D point
	    @return a new, transformed `Point3D` instance
	**/
	overload extern public inline function transformPoint(point:Point3D):Point3D {
		if (this.width != 3 || this.height != 3) throw ""; //Todo error
		var x = point.x * this.get(0, 0) + point.y * this.get(1, 0) + point.z * this.get(2, 0);
        var y = point.x * this.get(0, 1) + point.y * this.get(1, 1) + point.z * this.get(2, 1);
        var z = point.x * this.get(0, 2) + point.y * this.get(1, 2) + point.z * this.get(2, 2);
		return new Point3D(x, y, z);
	}

	/**
        Multiplies the given point by this `Matrix2D`
	    @param point any 2D point
	    @return a new, transformed `Point2D` instance
	**/
	overload extern public inline function transformPoint(point:Point2D):Point2D {
		if (this.width != 3 || this.height != 3) throw ""; //Todo error

        var x = point.x * this.get(0, 0) + point.y * this.get(1, 0) + 1 * this.get(2, 0);
        var y = point.x * this.get(0, 1) + point.y * this.get(1, 1) + 1 * this.get(2, 1);

        return new Point2D(x, y);
	}

    @:from static function fromMatrix2D(m:Matrix2D) {
        #if vision_quiet
        var f = new Matrix2D(3, 3);
        for (i in 0...9) {
            var value = 0;
            if (i % 3 < m.width && (i / 3).floor() < m.height)
                value = m.get(i % 3, (i / 3).floor());
            f.set(i % 3, (i / 3).floor(), value);
        }
        return new TransformationMatrix(f);
        #else
        return new TransformationMatrix(m);
        #end
    }
}