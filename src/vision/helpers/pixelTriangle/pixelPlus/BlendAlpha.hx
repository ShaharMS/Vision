package vision.heplers.pixelTriangle.pixelPlus;

import vision.ds.Image;
import vision.ds.Color;
import vision.helpers.pixelTriangle.pixelplus.ChannelHelp;
import  vision.helpers.pixelTriangle.pixelplus.PixelsTransform;

inline function alphaBlendImage( imageTarget: Image, imageSource: Image
                               , xTarget:     Float, yTarget:     Float
                               , xSource:     Float, ySource:     Float
                               , w: Float, h: Float ){
    pixelsTransform( imageTarget, imageSource, alphaBlend, xTarget, yTarget, xSource, ySource, w, h );
}
/**
    provides alpha channel blend which is commumative
**/
inline function alphaBlend( lhs: Color, rhs: Color ): Color {
    var a1: Float = channelFloat( lhs.alpha  );
    var r1: Float = channelFloat( lhs.red );
    var g1: Float = channelFloat( lhs.green );
    var b1: Float = channelFloat( lhs.blue );
    var a2: Float = channelFloat( rhs.alpha );
    var r2: Float = channelFloat( rhs.red );
    var g2: Float = channelFloat( rhs.green );
    var b2: Float = channelFloat( rhs.blue );
    var a3 = a1 * ( 1 - a2 );
    var r = colBlendFunc( r1, r2, a3, a2 );
    var g = colBlendFunc( g1, g2, a3, a2 );
    var b = colBlendFunc( b1, b2, a3, a2 );
    var a = alphaBlendFunc( a3, a2 );
    return Color.fromRGBA( r, g, b, a );
}
