package vision.ds;

import vision.exceptions.MatrixOperationError;
import vision.algorithms.GaussJordan;
import vision.ds.Array2D;
import vision.tools.MathTools.*;
using vision.tools.MathTools;
/**
	Represents a transformation matrix, used for warping images in one way or another.  
	A matrix warps an image by multiplying each pixel's coordinates by the matrix, as follows:
	```txt
	┌             ┐   
	│ a₀₀ a₀₁ a₀₂ │   ┌       ┐
	│ a₁₀ a₁₁ a₁₂ │ ● │ x y 1 │
	│ a₂₀ a₂₁ a₂₂ │   └       ┘
	└             ┘   
	```
	where `x` and `y` are the coordinates of the pixel, `1` is, well, `1`, and `aₙ ₙ` represents a value in the matrix.

	multiplication is done by multiplying each row in one matrix by its corresponding column in the other (nₜₕ row to nₜₕ column):
	```txt
	┌             ┐   
	│ a₀₀ a₀₁ a₀₂ │   ┌       ┐    ┌                                                          ┐
	│ a₁₀ a₁₁ a₁₂ │ ● │ x y 1 │ ⟹ │ x(a₀₀ + a₀₁ + a₀₂) y(a₁₀ + a₁₁ + a₁₂) 1(a₂₀ + a₂₁ + a₂₂) │
	│ a₂₀ a₂₁ a₂₂ │   └       ┘    └                                                          ┘
	└             ┘   
	```

	---

	For your comfort, some simple transformation matrices are already provided, and accessible as a static property of `Matrix2D`.


	@see For a general purpose, not-necessarily-mathematic matrix - `Array2D`
	@see For provided convolution matrices - `Kernel2D`
**/
@:forward(get, set, fill, width, height)
abstract Matrix2D(Array2D<Float>) to Array2D<Float> from Array2D<Float> {

	public var underlying(get, set):Array2D<Float>;

	inline function get_underlying() {
		return this;
	}

	inline function set_underlying(arr2d:Array2D<Float>) {
		return this = arr2d;
	}

	public var rows(get, set):Int;

	@:noCompletion inline function get_rows():Int {
		return this.width;
	} 
	@:noCompletion inline function set_rows(amount:Int):Int {
		return this.width = amount;
	}

	public var columns(get, set):Int;

	@:noCompletion inline function get_columns():Int {
		return this.height;
	} 
	@:noCompletion inline function set_columns(amount:Int):Int {
		return this.height = amount;
	}
    
    

	public inline function new(rows:Int, columns:Int) {
		this = new Array2D(rows, columns);
	}

    public inline function invert():Matrix2D {
        return this = GaussJordan.invert(this);
    }

    public inline function clone():Matrix2D {
        return cast this.clone();
    }

    public inline function toString(?precision:Int, pretty:Bool = true) {
        if (!pretty) return this.toString();

        // Get the longest item, this will be the cell width
        var maxLen = 1; // Minimum space
        for (item in underlying.inner) {
            var len;
            if (precision == -1) len = Std.string(item).length;
            else len = Std.string(item.truncate(precision)).length;
            if (len > maxLen) maxLen = len;
        }
        maxLen++; //Include elipsis

        inline function multiplyString(s:String, times:Int) {
            var st = "";
            for (i in 0...times) st += s;
            return st;
        }

        inline function fixItem(item:Float) {
            var itemString = Std.string(if (precision != -1) item.truncate(precision) else item);
            if (precision != -1 && item != item.truncate(precision)) itemString += "…";
            if (itemString.length < maxLen) itemString = multiplyString(' ', ((maxLen - itemString.length) / 2).floor()) + itemString + multiplyString(' ', ((maxLen - itemString.length) / 2).ceil());
            return itemString;
        }
        
        // The matrix's width on screen should be maxLen * mat width + walls + padding + (padding between items) * width
        var top = '\n┌ ${multiplyString(' ', maxLen * columns + 2 * (columns - 1))} ┐';
        var bottom = '└ ${multiplyString(' ', maxLen * columns + 2 * (columns - 1))} ┘';

        // Now, rows

        var rows:Array<String> = [""];
        var counter = 0;
        var floor = 0;
        for (item in underlying.inner) {
			if (counter < columns) {
				var add = ', ${fixItem(item)}';
				if (counter == 0) add = add.substr(2);
				rows[floor] += add;
				counter++;
			} else {
				counter = 0;
				floor++;
                rows[floor] = "";
                var add = '${fixItem(item)}';
				rows[floor] += add;
				counter++;
			}
		}

        var string = top + "\n";
        for (r in rows) {
            string += '│ $r │\n';
        }
        string += bottom;

        return string;
    }


















    //-----------------------------------------------------------------------------------------
	// Static matrix creation
	//-----------------------------------------------------------------------------------------

    /**
        Generates a rotation matrix of `angle` degrees/radians.

        @param angle The angle at which to rotate. goes counter-clockwise.
        @param degrees Whether `angle` is given in degrees or radians. Defaults to degrees.
    **/
    public static inline function ROTATION(angle:Float, ?degrees:Bool = true):Matrix2D {
        return Matrix2D.createTransformation(
            [if (degrees) cosd(angle) else cos(angle), if (degrees) -sind(angle) else -sin(angle), 0],
            [if (degrees) sind(angle) else sin(angle), if (degrees) cosd(angle) else cos(angle), 0],
            [0, 0, 1]
        );
    }

    /**
        Generates a translation matrix that displaces the graphic 
        inside the image `x` pixels to the right and `y` pixels to the bottom.

        @param x Displacement in pixels to the right. Default value is 1.
        @param y Displacement in pixels to the bottom. Default value is 1.
    **/
    public static inline function TRANSLATION(x:Float = 0, y:Float = 0):Matrix2D {
        return Matrix2D.createTransformation(
            [1, 0, x],
            [0, 1, y],
            [0, 0, 1]
        );
    }

    /**
        Generates a scaling matrix that "stretches" the width to the new width of `scaleX` * `width`,
        and the height to the new height of `scaleY` * `height`.
        @param scaleX Scaling along the X axis. Default value is 1.
        @param scaleY Scealing along the Y axis. Default value is 1.
    **/
    public static inline function SCALE(scaleX:Float = 1, scaleY:Float = 1):Matrix2D {
        return Matrix2D.createTransformation(
            [scaleX, 0,      0],
            [0,      scaleY, 0],
            [0,      0,      1]
        );
    }

    /**
        Generates a shearing matrix that "skews" the slope of the image's edges in the x & y axis by `-1/shear`.
        For example, if `shearX` is `0.5`, the image is skewed horizontally, such that the slope of the two vertical edges becomes `-2`.

        @param shearX The amount of shearing done on the x-axis, or in other words, when dividing `-1` by `shearX`, determines the slope of the image on the vertical edges.
        @param shearY The amount of shearing done on the y-axis, or in other words, when dividing `-1` by `shearY`, determines the slope of the image on the horizontal edges.
    **/
    public static inline function SHEAR(shearX:Float = 0, shearY:Float = 0):Matrix2D {
        return Matrix2D.createTransformation(
            [1,      shearX, 0],
            [shearY, 1,      0],
            [0,      0,      1]
        );
    }

    /**
    	Generates a reflection matrix that "mirrors" an image along the axis which is `angle` degrees/radians form the `x` axis.
    	@param angle The angle at which to reflect. goes counter-clockwise.
        @param degrees Whether `angle` is given in degrees or radians. Defaults to degrees.
    **/
    public static inline function REFLECTION(angle:Float, ?degrees:Bool = true):Matrix2D {
        angle *= 2;
        return Matrix2D.createTransformation(
            [if (degrees) cosd(angle) else cos(angle), if (degrees) sind(angle) else sin(angle), 0],
            [if (degrees) sind(angle) else sin(angle), if (degrees) -cosd(angle) else -cos(angle), 0],
            [0, 0, 1]
        );
    }
    

	public static inline function createFilled(...rows:Array<Float>):Matrix2D {
		var arr = new Array2D(rows[0].length, rows.length);
		arr.inner = [];
		for (r in rows) arr.inner.concat(r);
		return cast arr;
	}

	public static inline function createTransformation(xRow:Array<Float>, yRow:Array<Float>, ?homogeneousRow:Array<Float>):Matrix2D {
		if (homogeneousRow == null) homogeneousRow = [0, 0, 1];
		var arr = new Array2D(3 , 3, null);
		arr.inner = xRow.concat(yRow).concat(homogeneousRow);
		return cast arr;
	}










    //-----------------------------------------------------------------------------------------
	// Matrix math
	//-----------------------------------------------------------------------------------------
    
    @:op(A * B) public static inline function multiplyMatrices(a:Matrix2D, b:Matrix2D):Matrix2D {    
		if (a.columns != b.rows) {
            throw new MatrixOperationError("mult", [a, b], Mult_MismatchingDimensions);
        }

        var result = new Matrix2D(a.rows, b.columns);

        for (x in 0...result.columns) {
            for (y in 0...result.rows) {
                var sum: Float = 0.0;

                for (k in 0...a.columns) {
                    sum += a.get(k, y) * b.get(x, k);
                }

                result.set(x, y, sum);
            }
        }
		return result;
	}
	@:op(A + B) public static inline function addMatrices(a:Matrix2D, b:Matrix2D): Matrix2D {
        if (a.rows != b.rows || a.columns != b.columns) {
            throw new MatrixOperationError("add", [a, b], Add_MismatchingDimensions);
        }

        var result = new Matrix2D(a.rows, a.columns);

        for (x in 0...result.columns) {
            for (y in 0...result.rows) {
                result.set(x, y, a.get(x, y) + b.get(x, y));
            }
        }

        return result;
    }
    @:op(A - B) public static inline function subtractMatrices(a:Matrix2D, b:Matrix2D): Matrix2D {
        if (a.rows != b.rows || a.columns != b.columns) {
            throw new MatrixOperationError("sub", [a, b], Sub_MismatchingDimensions);
        }

        var result = new Matrix2D(a.rows, a.columns);

        for (x in 0...result.columns) {
            for (y in 0...result.rows) {
                result.set(x, y, a.get(x, y) - b.get(x, y));
            }
        }

        return result;
    }
    @:op(A / B) public static inline function divideMatrices(a:Matrix2D, b:Matrix2D):Matrix2D {    
		if (a.columns != b.rows) {
            throw new MatrixOperationError("div", [a, b], Div_MismatchingDimensions);
        }

        var result = new Matrix2D(a.rows, b.columns);

        for (x in 0...result.columns) {
            for (y in 0...result.rows) {
                var sum: Float = 0.0;

                for (k in 0...a.columns) {
                    sum += a.get(k, y) / b.get(x, k);
                }

                result.set(x, y, sum);
            }
        }
		return result;
	}
	@:op(A *= B) public inline function multiply(b:Matrix2D):Matrix2D {
        if (columns != b.rows) {
            throw new MatrixOperationError("mult", [this, b], Mult_MismatchingDimensions);
        }

        var result = new Matrix2D(rows, b.columns);

        for (x in 0...result.columns) {
            for (y in 0...result.rows) {
                var sum: Float = 0.0;

                for (k in 0...columns) {
                    sum += this.get(k, y) * b.get(x, k);
                }

                result.set(x, y, sum);
            }
        }
        this = result.underlying;
        return cast this;
    }
    
	@:op(A += B) public inline function add(b:Matrix2D) {
        if (rows != b.rows || columns != b.columns) {
            throw new MatrixOperationError("add", [this, b], Add_MismatchingDimensions);
        }

        for (x in 0...columns) {
            for (y in 0...rows) {
                this.set(x, y, this.get(x, y) + b.get(x, y));
            }
        }

        return cast this;
    }

	@:op(A -= B) public inline function subtract(b:Matrix2D) {
        if (rows != b.rows || columns != b.columns) {
            throw new MatrixOperationError("sub", [this, b], Sub_MismatchingDimensions);

        }

        for (x in 0...columns) {
            for (y in 0...rows) {
            	this.set(x, y, this.get(x, y) - b.get(x, y));
            }
        }

        return cast this;
    }

	@:op(A /= B) public inline function divide(b:Matrix2D):Matrix2D {
        if (columns != b.rows) {
            throw new MatrixOperationError("div", [this, b], Div_MismatchingDimensions);
        }

        var result = new Matrix2D(rows, b.columns);

        for (x in 0...result.columns) {
            for (y in 0...result.rows) {
                var sum: Float = 0.0;

                for (k in 0...columns) {
                    sum += this.get(k, y) / b.get(x, k);
                }

                result.set(x, y, sum);
            }
        }
        this = result.underlying;
        return cast this;
    }










    //-----------------------------------------------------------------------------------------
	// From/To
	//-----------------------------------------------------------------------------------------

    @:to function to_array_array_float():Array<Array<Float>> {
        return this.inner.raise(this.width);
    }

    @:from static function from_array_array_float(array:Array<Array<Float>>):Matrix2D {
        var arr2d = new Array2D(array[0].length, array.length);
        arr2d.inner = array.flatten();
        return cast arr2d;
    }

    @:from static function from_array_array_int(array:Array<Array<Int>>):Matrix2D {
        var arr2d = new Array2D(array[0].length, array.length);
        arr2d.inner = array.flatten();
        return cast arr2d;
    }
}
