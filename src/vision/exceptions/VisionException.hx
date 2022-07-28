package vision.exceptions;
#if js
import js.Syntax;
/**
    A type of error, thrown by components of the `Vision` library
**/
class VisionException  {
    
    public function new(message:String, type:String) {
        Syntax.code("throw \"Exception - \" + {0} + \":\\n\\n\\t\" + {1} + \"\\n\"", type, message);
    }
}
#else
import haxe.Exception;
/**
    A type of error, thrown by components of the `Vision` library
**/
class VisionException extends Exception {
    
    public function new(message:String, type:String) {
        super('$type: $message');
    }
}
#end