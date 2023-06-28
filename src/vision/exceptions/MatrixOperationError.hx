package vision.exceptions;

import vision.tools.MathTools;
import vision.ds.Matrix2D;
using StringTools;

class MatrixOperationError extends VisionException {
    
    /**
    	Notice - assumes 2 matrices
    	@param op mathematical operation theat caused the error, named (e.g. `+` -> addition, `-` -> subtraction)
    	@param matrices the two offending matrices
    **/
    public function new(op:String, matrices:Array<Matrix2D>) {
        super(errorByType(op, matrices), 'Matrix ${op.charAt(0).toUpperCase() + op.substr(1)} Error');
    }

    function errorByType(type:String, mats:Array<Matrix2D>):String {
        var sign = "";
        switch type {
            case "mult" | "multiplication" | "Mult" | "Multiplication": sign = "●";
            case "div" | "division" | "Div" | "Division": sign = "÷";
            case "add" | "addition" | "Add" | "Addition": sign = "+";
            case "sub" | "subtraction" | "Sub" | "Subtraction": sign = "-";
        }

        var msg = "Cannot calculate:\n\n";
        var rows = [for (i in 0...MathTools.max(mats[0].rows, mats[1].rows)) []];
        var signRow = MathTools.floor(MathTools.max(mats[0].rows, mats[1].rows) / 2);

        return null;
    }
}