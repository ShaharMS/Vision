package vision.formats.to;

/**
    A container class for image saver types
**/
@:noCompletion class To {
    
    public function new() {}

    /**
        Save an image to bytes
    **/
    public var bytes:ToBytes = new ToBytes();

    /**
        Convert an image to a specific framework's image type
    **/
    public var framework:ToFramework = new ToFramework();
}