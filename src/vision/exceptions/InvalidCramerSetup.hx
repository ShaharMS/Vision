package vision.exceptions;

import vision.ds.Matrix2D;

class InvalidCramerSetup extends VisionException {
    public function new(coefficients:Matrix2D, solutions:Array<Float>) {
        super('Coefficients\' size must match solutions\' length (coefficients: ${coefficients.rows}x${coefficients.columns}, solutions: ${solutions.length})', 'Invalid Cramer Setup');
    }
    
}