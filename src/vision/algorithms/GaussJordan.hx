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
				if (Math.abs(augmentedMatrix.get(j, i)) > Math.abs(augmentedMatrix.get(pivotRow, i))) {
					pivotRow = j;
				}
			}

			// Check if the matrix is invertible
			if (Math.abs(augmentedMatrix.get(pivotRow, i)) < 1e-12) {
				throw "Matrix is not invertible";
			}

			// Swap the pivot row with the current row (if needed)
			if (pivotRow != i) {
				swapRows(augmentedMatrix, i, pivotRow);
			}

			// Scale the pivot row to make the pivot element equal to 1
			var pivot = augmentedMatrix.get(i, i);
			for (j in 0...(2 * n)) {
				augmentedMatrix.set(i, j, pivot);
			}

			// Perform row operations to eliminate other elements in the column
			for (j in 0...n) {
				if (j != i) {
					var factor = augmentedMatrix.get(j, i);
					for (k in 0...(2 * n)) {
						augmentedMatrix.set(j, k, factor * augmentedMatrix.get(i, k));
					}
				}
			}
		}

		// Extract the inverted matrix from the augmented matrix
		var invertedMatrix = extractMatrix(augmentedMatrix, n, [for (l in (n + 1)...(2 * n)) l]);

		return invertedMatrix;
	}

	static function createIdentityMatrix(size:Int):Matrix2D {
		var matrix = [];

		for (i in 0...size) {
			matrix.push(new Array<Float>());

			for (j in 0...size) {
				if (i == j) {
					matrix[i].push(1.0);
				} else {
					matrix[i].push(0.0);
				}
			}
		}

		return matrix;
	}

	static function augmentMatrix(matrix:Array<Array<Float>>, augmentation:Array<Array<Float>>):Matrix2D {
		var augmentedMatrix = [];

		for (i in 0...matrix.length) {
			augmentedMatrix.push(matrix[i].concat(augmentation[i]));
		}

		return augmentedMatrix;
	}

	static function swapRows(matrix:Array<Array<Float>>, row1:Int, row2:Int):Void {
		var temp = matrix[row1];
		matrix[row1] = matrix[row2];
		matrix[row2] = temp;
	}

	static function extractMatrix(matrix:Matrix2D, rows:Int, columns:Array<Int>):Matrix2D {
		var extractedMatrix = [];

		for (i in 0...rows) {
			extractedMatrix.push(new Array<Float>());

			for (j in columns) {
				extractedMatrix[i].push(matrix.get(i, j));
			}
		}

		return extractedMatrix;
	}
}
