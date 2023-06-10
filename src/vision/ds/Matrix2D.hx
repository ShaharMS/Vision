package vision.ds;

import vision.ds.Array2D;
import haxe.ds.Vector;

/**
	Represents a transformation matrix, used for warping images in one way or another.  
	A matrix warps an image by multiplying each point by the matrix, as follows:
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
@:forward(get, set, fill)
abstract Matrix2D(Array2D<Float>) to Array2D<Float> {

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
    
    @:op(A * B) public static inline function multiplyMatrices(a:Matrix2D, b:Matrix2D):Matrix2D {    
		if (a.columns != b.rows) {
            throw "Matrix dimensions are not compatible for multiplication.";
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
            throw "Matrix dimensions are not compatible for addition.";
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
            throw "Matrix dimensions are not compatible for subtraction.";
        }

        var result = new Matrix2D(a.rows, a.columns);

        for (x in 0...result.columns) {
            for (y in 0...result.rows) {
                result.set(x, y, a.get(x, y) - b.get(x, y));
            }
        }

        return result;
    }
    @:op(A / B) public static inline function divideMatrices(a:Matrix2D, b:Float): Matrix2D {
        var result = new Matrix2D(a.rows, a.columns);

        for (x in 0...result.columns) {
            for (y in 0...result.rows) {
                result.set(x, y, a.get(x, y) / b);
            }
        }

        return result;
    }
	@:op(A *= B) public inline function multiply(b:Matrix2D) {
        if (columns != b.rows) {
            throw "Matrix dimensions are not compatible for multiplication.";
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
    }
	@:op(A += B) public inline function add_equals(b:Matrix2D) {
        if (rows != b.rows || columns != b.columns) {
            throw "Matrix dimensions are not compatible for addition.";
        }

        for (x in 0...columns) {
            for (y in 0...rows) {
                this.set(x, y, this.get(x, y) + b.get(x, y));
            }
        }
    }
	@:op(A -= B) public inline function subtract_equals(b:Matrix2D) {
        if (rows != b.rows || columns != b.columns) {
            throw "Matrix dimensions are not compatible for subtraction.";
        }

        for (x in 0...columns) {
            for (y in 0...rows) {
            	this.set(x, y, this.get(x, y) - b.get(x, y));
            }
        }
    }
	@:op(A /= B) public inline function divideBy(b:Float) {
        for (x in 0...columns) {
            for (y in 0...rows) {
                this.set(x, y, this.get(x, y) / b);
            }
        }
    }
}
