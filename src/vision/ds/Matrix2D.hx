package vision.ds;

import vision.exceptions.MatrixOperationError;
import vision.exceptions.MatrixShapeError;
import vision.algorithms.GaussJordan;
import vision.ds.Array2D;
import vision.tools.MathTools.*;
using vision.tools.MathTools;
using vision.tools.ArrayTools;
/**
	A mutable rectangular matrix of floating-point values. Index using `get(x, y)`
	and `set(x, y, value)`, where x is the column and y is the row.

	See `Kernels` for convolution coefficients and `Transform2D` for coordinate maps.
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
	    Creates a new `Matrix2D`.
	    @param width the amount of elements in each row
	    @param height the amount of rows
		@param fillWith Optional value to place in every cell. When omitted, each target uses its normal default value.
	**/
	public inline function new(width:Int, height:Int, ?fillWith:Float) {
		this = new Array2D(width, height, fillWith);
	}

    /**
        Inverts this `Matrix2D` using Gauss-Jordan elimination
        @return this `Matrix2D`, after it has been inverted
    **/
    public inline function invert():Matrix2D {
        return this = GaussJordan.invert(this);
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
		Returns the trace of this `Matrix2D`.

		Trace is the sum of the elements on the diagonal, spanning from `(0, 0)` to `(w, h)` when `w = h`.
		
		@throws MatrixOperationError if the matrix is not a square matrix, i.e. `w != h`
	**/
	public inline function getTrace():Float {
        if (this.width != this.height) {
            #if vision_quiet
            var limit = MathTools.min(this.width, this.height);
            var sum = 0.;
            for (i in 0...limit) {
                sum += this.get(i, i);
            }
            return sum;
            #else
            throw new MatrixShapeError("Trace requires a square matrix.", "Matrix Trace Error");
            #end
        }
		var sum = 0.;
		for (i in 0...this.width) 
			sum += this.get(i, i);

		return sum;
	}
	
    public inline function getAverage():Float {
        var sum = 0.;
        for (i in this.iterator()) 
            sum += i;
        return sum / this.inner.length;
    }

    /**
    	Multiplies this `Matrix2D` with a given scalar (a number).
    **/
	public inline function multiplyWithScalar(scalar:Float):Matrix2D {
		for (i in 0... this.inner.length) {
			this.inner[i] *= scalar;
		}
		return this;
	}

	//--------------------------------------------------------------
	// Convenience methods
	//--------------------------------------------------------------


    /**
        Return a copy of this `Matrix2D`    
    **/
    public inline function clone():Matrix2D {
        var arr = new Array2D(this.width, this.height);
        arr.inner = this.inner.copy();
        return arr;
    }

    /**
    	Manipulates each element of this `Matrix2D` with the given function, and
		returns a new `Matrix2D` with the manipulated elements.

		@param mappingFunction the function to apply to each element. Should take a `Float`, and return a `Float`.
    **/
	public inline function map(mappingFunction:Float -> Float):Matrix2D {
		var m = new Matrix2D(this.width, this.height);
		for (i in 0...this.inner.length) {
			m.underlying.inner[i] = mappingFunction(this.inner[i]);
		}

		return m;
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
        var flat:Array<Float> = [];
        for (row in copy) {
            for (value in row) {
                flat.push(value);
            }
        }
        arr2d.inner = flat;
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
        if (arr.length < this.height) {
            #if vision_quiet
            var limit = MathTools.min(arr.length, this.height);
            for (y in 0...limit) this.set(x, y, arr[y]);
            return;
            #else
            throw new MatrixShapeError("Column length must match matrix height.", "Matrix Set Column Error");
            #end
        }
        for (y in 0...this.height) this.set(x, y, arr[y]);
    }

    /**
        Replaces the elements of the row at index `y` with the elements in `arr`

        @param y the 0-based index of the row
        @param arr the new row. Must be at least of the same length as the matrix' width
    **/
    public inline function setRow(y:Int, arr:Array<Float>) {
        if (arr.length < this.width) {
            #if vision_quiet
            var limit = MathTools.min(arr.length, this.width);
            for (x in 0...limit) this.set(x, y, arr[x]);
            return;
            #else
            throw new MatrixShapeError("Row length must match matrix width.", "Matrix Set Row Error");
            #end
        }
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
        var newWidth = this.width - 1;
        var newInner:Array<Float> = [];
        newInner.resize(newWidth * this.height);
        var idx = 0;
        for (y in 0...this.height) {
            for (col in 0...this.width) {
                if (col == x) continue;
                newInner[idx++] = this.get(col, y);
            }
        }
        this.inner = newInner;
        this.width = newWidth;

        return this;
    }

    /**
        Removes an entire row from this `Matrix2D`.

        @param y the 0-based index of the row to remove
        @return this modified `Matrix2D`
    **/
    public inline function removeRow(y:Int):Matrix2D {
        var newHeight = this.height - 1;
        var newInner:Array<Float> = [];
        newInner.resize(this.width * newHeight);
        var idx = 0;
        for (row in 0...this.height) {
            if (row == y) continue;
            for (col in 0...this.width) {
                newInner[idx++] = this.get(col, row);
            }
        }
        this.inner = newInner;
        this.height = newHeight;

        return this;
    }

    /**
        Returns a string representation of this `Matrix2D`.

        @param precision How many numbers beyond the decimal point to display. Only relevant when `pretty` is set to `true`
        @param pretty Whether to return a pretty-print of the matrix or not. 
        A pretty print adds a distinct matrix border, centered numbers, and ellipsis where numbers are truncated.
    **/
    public inline function toString(precision:Int = 5, pretty:Bool = true):String {
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


	/** Creates a square identity matrix of the given size. **/
	public static function identity(size:Int):Matrix2D {
		if (size <= 0) throw new MatrixShapeError("Identity matrix size must be positive.", "Matrix Error");
		var matrix = new Matrix2D(size, size, 0);
		for (i in 0...size) matrix.set(i, i, 1);
		return matrix;
	}

	/** Creates a matrix by copying a rectangular array of rows. An empty array gives a 0x0 matrix. **/
	public static function fromRows(rows:Array<Array<Float>>):Matrix2D {
		if (rows.length == 0) return new Matrix2D(0, 0);
		var width = rows[0].length;
		var array = new Array2D<Float>(width, rows.length);
		for (y in 0...rows.length) {
			var row = rows[y];
			if (row.length != width) throw new MatrixShapeError("Matrix rows must have equal lengths.", "Matrix Error");
			for (x in 0...width) array.set(x, y, row[x]);
		}
		return array;
	}

	/** Creates a matrix from a variable number of rows. **/
	public static inline function createFilled(...rows:Array<Float>):Matrix2D {
		return fromRows(rows.toArray());
	}

    //-----------------------------------------------------------------------------------------
	// Matrix math
	//-----------------------------------------------------------------------------------------
    
    @:op(A * B) public static inline function multiplyMatrices(a:Matrix2D, b:Matrix2D):Matrix2D {    
		if (a.columns != b.rows) {
            throw new MatrixOperationError("mult", [a, b], Mult_MismatchingDimensions);
        }

        var result = new Matrix2D(b.width, a.height);
        for (y in 0...a.height) {
            for (x in 0...b.width) {
                var sum = 0.;
                for (k in 0...a.width) {
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

        var result = new Matrix2D(a.columns, b.rows);

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

        var result = new Matrix2D(a.columns, b.rows);

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

        var result = new Matrix2D(b.width, a.height);

        for (y in 0...a.height) {
            for (x in 0...b.width) {
                var sum = 0.;
                for (k in 0...a.width) {
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

        var result = new Matrix2D(b.width, this.height);

        for (y in 0...this.height) {
            for (x in 0...b.width) {
                var sum = 0.;
                for (k in 0...this.width) {
                    sum += this.get(k, y) * b.get(x, k);
                }
                result.set(x, y, sum);
            }
        }
        this = result.underlying;
        return cast this;
    }
    
	@:op(A += B) public inline function add(b:Matrix2D):Matrix2D {
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

	@:op(A -= B) public inline function subtract(b:Matrix2D):Matrix2D {
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

        var result = new Matrix2D(b.width, this.height);

        for (y in 0...this.height) {
            for (x in 0...b.width) {
                var sum = 0.;
                for (k in 0...this.width) {
                    sum += this.get(k, y) * b.get(x, k);
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
        return fromRows(array);
    }

    @:from static function from_array_array_int(array:Array<Array<Int>>):Matrix2D {
        return fromRows([for (row in array) [for (value in row) (value : Float)]]);
    }
}
