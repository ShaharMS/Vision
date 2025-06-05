package vision.formats.from;

/**
    A container class for image loader types
**/
@:noCompletion class From {
    
    public function new() {}

    /**
        Load an image from bytes
    **/
    public var bytes:FromBytes = new FromBytes();

    /**
        Convert an image from a specific framework's image type to `vision.ds.Image`
    **/
    public var framework:FromFramework = new FromFramework();

}