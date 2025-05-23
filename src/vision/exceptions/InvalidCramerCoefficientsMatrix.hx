package vision.exceptions;

import vision.ds.TransformationMatrix2D;
import vision.ds.Matrix2D;

class InvalidCramerCoefficientsMatrix extends VisionException {
	public function new(coefficients:Matrix2D) {
		super('Cramer coefficients matrix must be square (given matrix is ${coefficients.rows}x${coefficients.columns})', "Invalid Cramer Coefficients Matrix");
	}
}