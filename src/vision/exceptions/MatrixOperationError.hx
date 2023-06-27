package vision.exceptions;

import vision.ds.Matrix2D;
using StringTools;

class MatrixOperationError extends VisionException {
    
    public function new(op:String, matrices:Array<Matrix2D>) {
        super(errorByType(op, matrices), 'Matrix ${op.charAt(0).toUpperCase() + op.substr(1)} Error');
    }

    function errorByType(type:String, mats:Array<Matrix2D>):String {
        // switch type {
        //     case "mult" | "multiplication" | "Mult" | "Multiplication":
        // }
        return null;
    }
}