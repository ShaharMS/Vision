package vision.exceptions;

import vision.ds.Matrix2D;

class SingularMatrixError extends VisionException {
	public function new(matrix:Matrix2D, operation:String, ?detail:String) {
		super(buildMessage(matrix, operation, detail), 'Singular Matrix Error');
	}

	static function buildMessage(matrix:Matrix2D, operation:String, ?detail:String):String {
		var message = 'Cannot ${operation} a singular matrix of size ${matrix.columns}x${matrix.rows} because its determinant is 0.';
		if (detail != null && detail != '') {
			message += ' ${detail}';
		}
		message += ' Provide a non-singular matrix with linearly independent rows/columns, or validate the determinant before calling this operation.';
		return message;
	}
}