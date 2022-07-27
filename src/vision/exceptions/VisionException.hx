package vision.exceptions;

import js.Syntax;
#if js
class VisionException  {
    
    public function new(message:String, type:String) {
        Syntax.code("throw \"Vision Exception - \" + {0} + \":\\n\\n\\t\" + {1} + \"\\n\"", type, message);
    }
}
#else
class VisionException extends Exception {
    
    public function new(message:String, type:String) {
        super('$type: $message');
    }
}
#end