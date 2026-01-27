package vision.algorithms;

import vision.ds.Matrix2D;

class GaussJordan {

	/**
	    Finds the inverse of a matrix, or, in other words, find another matrix for which `matrix * inverse = IDENTITY_MATRIX`
	    @param matrix 
	    @return Matrix2D
	**/
	public static function invert(matrix:Matrix2D):Matrix2D {
		var n = matrix.height;

		// Create the identity matrix
		var identity = createIdentityMatrix(n);

		// Augment the original matrix with the identity matrix
		var augmentedMatrix = augmentMatrix(matrix, identity);

		// Perform Gauss-Jordan elimination
		for (i in 0...n) {
			// Find the pivot row
			var pivotRow = i;
			for (j in (i + 1)...n) {
				if (Math.abs(augmentedMatrix.get(i, j)) > Math.abs(augmentedMatrix.get(i, pivotRow))) {
					pivotRow = j;
				}
			}

			// Check if the matrix is invertible
			if (Math.abs(augmentedMatrix.get(i, pivotRow)) < 1e-12) {
				throw "Matrix is not invertible";
			}

			// Swap the pivot row with the current row (if needed)
			if (pivotRow != i) {
				swapRows(augmentedMatrix, i, pivotRow);
			}

			// Scale the pivot row to make the pivot element equal to 1
			var pivot = augmentedMatrix.get(i, i);
			for (j in 0...(2 * n)) {
				augmentedMatrix.set(j, i, augmentedMatrix.get(j, i) / pivot);
			}

			// Perform row operations to eliminate other elements in the column
			for (j in 0...n) {
				if (j != i) {
					var factor = augmentedMatrix.get(i, j);
					for (k in 0...(2 * n)) {
						augmentedMatrix.set(k, j, augmentedMatrix.get(k, j) - factor * augmentedMatrix.get(k, i));
					}
				}
			}
		}

		// Extract the inverted matrix from the augmented matrix
		var invertedMatrix = extractMatrix(augmentedMatrix, n, [for (l in n...(2 * n)) l]);

		return invertedMatrix;
	}

	static function createIdentityMatrix(size:Int):Matrix2D {
		var matrix = new Matrix2D(size, size);

		for (i in 0...size) {
			for (j in 0...size) {
				if (i == j) {
					matrix.set(i, j, 1.0);
				} else {
					matrix.set(i, j, 0.0);
				}
			}
		}

		return matrix;
	}

	static function augmentMatrix(matrix:Matrix2D, augmentation:Matrix2D):Matrix2D {
		var rows = matrix.height;
		var cols = matrix.width + augmentation.width;
		var augmentedMatrix = new Matrix2D(cols, rows);

		for (i in 0...rows) {
			for (j in 0...matrix.width) {
				augmentedMatrix.set(j, i, matrix.get(j, i));
			}
			for (j in 0...augmentation.width) {
				augmentedMatrix.set(j + matrix.width, i, augmentation.get(j, i));
			}
		}

		return augmentedMatrix;
	}

	static function swapRows(matrix:Matrix2D, row1:Int, row2:Int):Void {
		var cols = matrix.width;
		for (j in 0...cols) {
			var temp = matrix.get(j, row1);
			matrix.set(j, row1, matrix.get(j, row2));
			matrix.set(j, row2, temp);
		}
	}

	static function extractMatrix(matrix:Matrix2D, rows:Int, columns:Array<Int>):Matrix2D {
		var extractedMatrix = new Matrix2D(columns.length, rows);

		for (i in 0...rows) {
			for (jIdx in 0...columns.length) {
				var j = columns[jIdx];
				extractedMatrix.set(jIdx, i, matrix.get(j, i));
			}
		}

		return extractedMatrix;
	}
}
