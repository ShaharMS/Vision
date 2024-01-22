package vision.ds;

import vision.algorithms.PerspectiveWarp;
import vision.ds.specifics.PointTransformationPair;
import haxe.exceptions.NotImplementedException;
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

	/**
	    The underlying `Array2D` instance
	**/
	public var underlying(get, set):Array2D<Float>;

	inline function get_underlying() {
		return this;
	}

	inline function set_underlying(arr2d:Array2D<Float>) {
		return this = arr2d;
	}

	/**
	    The amount of rows this matrix contains. Equivalent to `this.height`
	**/
	public var rows(get, set):Int;

	@:noCompletion inline function get_rows():Int {
		return this.height;
	} 
	@:noCompletion inline function set_rows(amount:Int):Int {
		return this.height = amount;
	}

	/**
        The amount of columns this matrix contains. Equivalent to `this.width`
	**/
	public var columns(get, set):Int;

	@:noCompletion inline function get_columns():Int {
		return this.width;
	} 
	@:noCompletion inline function set_columns(amount:Int):Int {
		return this.width = amount;
	}
    
    

	/**
	    Creates a new, empty `Matrix2D`
	    @param width the amount of elements in each row
	    @param height the amount of rows
	**/
	public inline function new(width:Int, height:Int) {
		this = new Array2D(width, height);
	}

    /**
        Inverts this `Matrix2D` using Gauss-Jordan elimination
        @return this `Matrix2D`, after it has been inverted
    **/
    public inline function invert():Matrix2D {
        return this = GaussJordan.invert(this);
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

    /**
        Gets the determinant of this `Matrix2D`.
    **/
    public inline function getDeterminant():Float {
        var len = this.width;

        switch len {
            case 0: return 1;
            case 1: return this.get(0, 0);
            case 2: return this.get(0, 0) * this.get(1, 1) - this.get(0, 1) * this.get(1, 0);
            case _: {
                var determinantSum = 0.;

                var sign = 1;
                for (i in 0...this.width) {
                    var current = this.get(i, 0);
                    var childMatrix:Matrix2D = getSubMatrix(0, 1);
                    childMatrix.removeColumn(i);

                    determinantSum += sign * current * childMatrix.getDeterminant();
                    sign *= -1;
                }

                return determinantSum;
            }
        }
    }

    /**
        Return a copy of this `Matrix2D`    
    **/
    public inline function clone():Matrix2D {
        return this.clone();
    }

    /**
        Returns a new matrix, containing the elements of this matrix, starting at 
        (`fromX`, `fromY`) and ending at `toX`, `toY`.

        @param fromX The `x` coordinate of the top left corner from which we start reading. Defaults to `0`.
        @param fromY The `y` coordinate of the top left corner from which we start reading. Defaults to `0`.
        @param toX The `x` coordinate of the bottom right corner at which we stop reading. Defaults to `this.width`.
        @param toY The `y` coordinate of the bottom right corner at which we stop reading. Defaults to `this.height`.
        @return Matrix2D
    **/
    public inline function getSubMatrix(fromX:Int = 0, fromY:Int = 0, ?toX:Int, ?toY:Int):Matrix2D {
        var copy = this.to2DArray();

		toX = toX == null ? this.width : toX;
		toY = toY == null ? this.height : toY;


        for (_ in 0...fromY) copy.shift();
        for (_ in toX...copy.length) copy.pop();
        for (row in copy) {
            for (_ in 0...fromX) row.shift();
            for (_ in toY...row.length) row.pop();
        }

    
		if (copy.length == 0) return new Matrix2D(0, 0);
		
        var arr2d = new Array2D(copy[0].length, copy.length);
		arr2d.inner = copy.flatten();
		return arr2d;
    }

    /**
        Returns an array containing the elements at the column `x`, from top to bottom.
    **/
    public inline function getColumn(x:Int):Array<Float> {
        return this.column(x);
    }

    /**
        Returns an array containing the elements at the row `y`, from left to right.    
    **/
    public inline function getRow(y:Int):Array<Float> {
        return this.row(y);
    }

    /**
        Replaces the elements of the column at index `x` with the elements in `arr`

        @param x the 0-based index of the column
        @param arr the new column. Must be at least of the same length as the matrix' height
    **/
    public inline function setColumn(x:Int, arr:Array<Float>) {
        if (arr.length < this.height) throw ""; //Todo
        for (y in 0...this.height) this.set(x, y, arr[y]);
    }

    /**
        Replaces the elements of the row at index `y` with the elements in `arr`

        @param y the 0-based index of the row
        @param arr the new row. Must be at least of the same length as the matrix' width
    **/
    public inline function setRow(y:Int, arr:Array<Float>) {
        if (arr.length < this.width) throw ""; //Todo
        for (x in 0...this.width) this.set(x, y, arr[x]);
    }

    /**
        Inserts an entire column right before the column at index `x`.

        @param x the 0-based index of the column to insert at
        @param arr the column to insert
        @return this modified `Matrix2D`
    **/
    public inline function insertColumn(x:Int, arr:Array<Float>):Matrix2D {
        var n = new Array2D(this.width + 1, this.height);
        for (y in 0...this.height) {
            for (i in 0...x) n.set(i, y, this.get(i, y));
            for (i in x...this.width) n.set(i + 1, y, this.get(i, y));
            n.set(x, y, arr[y]);
        }

        return this = n;
    }

    /**
        Inserts an entire row right before the row at index `y`.

        @param y the 0-based index of the row to insert at
        @param arr the row to insert
        @return this modified `Matrix2D`
    **/
    public inline function insertRow(y:Int, arr:Array<Float>):Matrix2D {
        var n = new Array2D(this.width, this.height + 1);
        for (x in 0...this.width) {
            for (i in 0...y) n.set(x, i, this.get(x, i));
            for (i in y...this.height) n.set(x, i + 1, this.get(x, i));
            n.set(x, y, arr[x]);
        }

        return this = n;
    }

    /**
        Removes an entire column from this `Matrix2D`.

        @param x the 0-based index of the column to remove
        @return this modified `Matrix2D`
    **/
    public inline function removeColumn(x:Int):Matrix2D {
        var underlyingArray:Array<Null<Float>> = cast this.inner.copy();
        for (i in 0...this.height) underlyingArray[x + i * this.width] = null;
        underlyingArray = underlyingArray.filter(x -> x != null);
        this.width -= 1;
        this.inner = underlyingArray;

        return this;
    }

    /**
        Removes an entire row from this `Matrix2D`.

        @param y the 0-based index of the row to remove
        @return this modified `Matrix2D`
    **/
    public inline function removeRow(y:Int):Matrix2D {
        var underlyingArray:Array<Null<Float>> = cast this.inner.copy();
        for (i in 0...this.width) underlyingArray[y + this.width * i] = null;
        underlyingArray = underlyingArray.filter(x -> x != null);

        this.height -= 1;
        this.inner = underlyingArray;

        return this;
    }

    /**
        Returns a string representation of this `Matrix2D`.

        @param precision How many numbers beyond the decimal point to display. Only relevant when `pretty` is set to `true`
        @param pretty Whether to return a pretty-print of the matrix or not. 
        A pretty print adds a distinct matrix border, centered numbers, and ellipsis where numbers are truncated.
    **/
    public inline function toString(precision:Int = 5, pretty:Bool = true) {
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
        var top = '\n┌ ${multiplyString(' ', maxLen * columns + 2 * (columns - 1) - 1)} ┐';
        var bottom = '└ ${multiplyString(' ', maxLen * columns + 2 * (columns - 1) - 1)} ┘';

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
            string += '│ $r│\n';
        }
        string += bottom;

        return string;
    }


















    //-----------------------------------------------------------------------------------------
	// Static matrix creation
	//-----------------------------------------------------------------------------------------


    /**
        Generates an identity matrix.
    **/
    public static inline function IDENTITY():Matrix2D {
        return Matrix2D.createTransformation(
            [1, 0, 0],
            [0, 1, 0],
            [0, 0, 1]
        );
    }

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

    /**
        Generates a perspective warp matrix, that tweaks the perspective of an image, such
        that points at `pointPairs[n].from` will end up in the position `pointPairs[n].to`.

        @param pointPairs 4 pairs of points to "pin-point" the transform on. 
    **/
    public static inline function PERSPECTIVE(pointPairs:Array<PointTransformationPair>) {
        var src = [], dst = [];
		for (pair in pointPairs) {
			src.push(pair.from);
			dst.push(pair.to);
		}
		return PerspectiveWarp.generateMatrix(src, dst);
    }


	/**
	    Creates a new `Matrix2D` filled with `rows`, and of `rows.length` height.

	    @param rows multiple parameters of type `Array<Float>`, or a single, `Array<Array<Float>>` preceded by a `...` 
	    @return A `Matrix2D` instance.
	**/
	public static inline function createFilled(...rows:Array<Float>):Matrix2D {
		var arr = new Array2D(rows[0].length, rows.length);
		arr.inner = [];
		for (r in rows) arr.inner = arr.inner.concat(r); // WOAH that was a miss! need to report that. was previously just `arr.inner.concat(r)`
		return arr;
	}

	/**
        Helper function to generate a transformation matrix, 
        exists as sort of a guide for the creation of such matrix.

        @param xRow The first row of the matrix. Will be the row deciding the transformed `x` position of a point.
        @param yRow The second row of the matrix. Will be the row deciding the transformed `y` position of a point.
        @param homogeneousRow The third row of the matrix. On affine transformations (or, ones that are entirely 2D)
        This should be set to `[0, 0, 1]`. On perspective transformations, used to decide the `z` coordinate of a given point.
        When casted back into a 2D point, the point's `z` coordinate is used as a denominator for the other `x` and `y` coordinates.
        @return The newly created `Matrix2D`
	**/
	public static inline function createTransformation(xRow:Array<Float>, yRow:Array<Float>, ?homogeneousRow:Array<Float>):Matrix2D {
		if (homogeneousRow == null) homogeneousRow = [0, 0, 1];
		var arr = new Array2D(3 , 3, null);
		arr.inner = xRow.concat(yRow).concat(homogeneousRow);
		return arr;
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
