package vision.helpers;

// Module ImageBytes
/**
 Allows injection of Bytes data directly into the Image and direct extraction
 **/
@:access( vision.ds.Image.OFFSET )
final imageOff = vision.ds.Image.OFFSET;
inline 
function imageLen( image: vision.ds.Image ): Int
    return image.width * image.height * 4;
inline
function injectBytesInImage( bytes: haxe.io.Bytes, image: vision.ds.Image )
    image.underlying.blit( imageOff, bytes, 0, imageLen( image ) );
inline
function extractBytesFromImage( image: vision.ds.Image ): haxe.io.Bytes {
    var out = haxe.io.Bytes.alloc( imageLen( image ) );
    out.blit( 0, image.underlying, imageOff, imageLen( image ) );
    return out;
}
