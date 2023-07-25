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
    public function new(op:String, matrices:Array<Matrix2D>, offense:MatrixError) {
        super(MatrixOperationError.errorByType(op, matrices, offense), 'Matrix ${op.charAt(0).toUpperCase() + op.substr(1)} Error');
    }

    public static function errorByType(type:String, mats:Array<Matrix2D>, off:MatrixError):String {
        var sign = "";
        switch type {
            case "mult" | "multiplication" | "Mult" | "Multiplication": sign = "×";
            case "div" | "division" | "Div" | "Division": sign = "÷";
            case "add" | "addition" | "Add" | "Addition": sign = "+";
            case "sub" | "subtraction" | "Sub" | "Subtraction": sign = "-";
        }

        var msg = "Cannot calculate:\n\n";
        var rows = [for (i in 0...MathTools.max(mats[0].toString(3).split("\n").length, mats[1].toString(3).split("\n").length)) [if (mats[0].rows + 3 > i) mats[0].toString(3).split("\n")[i] else "", if (mats[1].rows + 3 > i) mats[1].toString(3).split("\n")[i] else ""]];
        var signRow = MathTools.ceil(MathTools.max(mats[0].rows + 2, mats[1].rows + 2) / 2);
        var currentRow = 0;
        for (r in rows) {
            trace(r);
            if (r[0].length == 0) r[0] = [for (i in 0...r[1].length) " "].join("");
            if (r[1].length == 0) r[1] = [for (i in 0...r[0].length) " "].join("");

            msg += "\t" + r[0] + "  ";

            if (currentRow == signRow)
                msg += sign;
            else
                msg += " ";

            msg += "  " + r[1];
            currentRow++;
            msg += "\n";
        }

        msg += "\n\t";

        switch off {
            case Mult_MismatchingDimensions: msg += 'Width of first matrix (${mats[0].columns}) is different from the height of the second (${mats[1].rows})';
            case Add_MismatchingDimensions: msg += 'Width & height of first matrix (${mats[0].columns}×${mats[0].rows}) are different from those of the second matrix (${mats[1].columns}×${mats[1].rows})';
            case Sub_MismatchingDimensions: msg += 'Width & height of first matrix (${mats[0].columns}×${mats[0].rows}) are different from those of the second matrix (${mats[1].columns}×${mats[1].rows})';
            case Div_MismatchingDimensions: msg += 'Width of first matrix (${mats[0].columns}) is different from the height of the second (${mats[1].rows})';
        }

        return msg;
    }
}

enum abstract MatrixError(Int) {
    var Mult_MismatchingDimensions;
    var Add_MismatchingDimensions;
    var Sub_MismatchingDimensions;
    var Div_MismatchingDimensions;
}
