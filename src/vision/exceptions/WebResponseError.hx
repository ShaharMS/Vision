package vision.exceptions;

class WebResponseError extends VisionException {
    public function new(address:String, message:String) {
        super('Website $address returned an error message - $message', 'Web Response Error');
		error = message;
    }

    /**
    	The website-returned error message.
    **/
    public var error:String;
}