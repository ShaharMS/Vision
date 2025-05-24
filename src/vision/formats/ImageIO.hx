package vision.formats;

import vision.formats.from.From;

/**
    A factory for loading/saving images to and from different file formats, frameworks and platforms.
**/
class ImageIO {
    
    /**
        Import a `vision.ds.Image` from different image formats
    **/
    public static var from:From = new From();
}