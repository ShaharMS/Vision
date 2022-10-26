package vision.helpers.pixelTriangle.pixelPlus;

import vision.ds.Image;
import vision.ds.Color;
// Pixeltransform

inline function pixelsTransform( imageTarget: Image, imageSource: Image
                                , transformFunc: ( colorTarget: Color, colorSource: Color ) -> Color
                                , xTarget:     Float, yTarget:     Float
                                , xSource:     Float, ySource:     Float
                                , w: Float, h: Float ){
    var p = Std.int( xSource );
    var xx = p;
    var q = Std.int( ySource );
    var dx = Std.int( xTarget ) - p;
    var dy = Std.int( yTarget ) - q;
    var maxX = Std.int( xSource + w );
    var maxY = Std.int( ySource + h );
    var xPos: Int;
    var yPos: Int;
    while( true ){
        xPos = p + dx;
        yPos = q + dy;
        imageTarget.setPixel( xPos, yPos
        , transformFunc( imageTarget.getPixel(xPos,yPos), imageSource.getPixel(p,q) )
        );
        p++;
        if( p > maxX ){
            p = xx;
            q++;
        } 
        if( q > maxY ) break;
    }
}
