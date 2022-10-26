/*
MIT License

Copyright (c) 2022 Nanjizal ( Justin L Mills )

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
package vision.helpers.pixelTriangle.shape;

import vision.ds.Image;
import vision.ds.Color;

import vision.helpers.pixelTriangle.iter.BoundIterators;
import vision.helpers.pixelTriangle.iter.IteratorRange;
import vision.helpers.pixelTriangle..pixelplus.ChannelHelp;

inline function triangleFill( image: Image
                            , ax: Float, ay: Float
                            , bx: Float, by: Float
                            , cx: Float, cy: Float
                            , color: Int ){
  var adjustWinding = ( (ax * by - bx * ay) + (bx * cy - cx * by) + (cx * ay - ax * cy) )>0;
  if( !adjustWinding ){ 
    var bx_ = bx;
    var by_ = by;
    bx = cx;
    by = cy;
    cx = bx_;
    cy = by_;
  }
  fillTriangleUnsafe( image, ax, ay, bx, by, cx, cy, color );
}

inline function fillTriangleUnsafe( image: Image
                                  , ax: Float, ay: Float
                                  , bx: Float, by: Float
                                  , cx: Float, cy: Float
                                  , color: Int ){
  var s0 = ay*cx - ax*cy;
  var sx = cy - ay;
  var sy = ax - cx;
  var t0 = ax*by - ay*bx;
  var tx = ay - by;
  var ty = bx - ax;
  var A = -by*cx + ay*(-bx + cx) + ax*(by - cy) + bx*cy; 
  var yIter3: IteratorRange = boundIterator3( ay, by, cy );
  var foundY = false;
  var s = 0.;
  var t = 0.;
  var sxx = 0.;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  var txx = 0.;
  for( x in boundIterator3( ax, bx, cx ) ){
    sxx = sx*x;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    txx = tx*x;
    foundY = false;
    for( y in yIter3 ){
      s = s0 + sxx + sy*y;
      t = t0 + txx + ty*y;
      if( s <= 0 || t <= 0 ){
        // after filling break
        if( foundY ) break;
      } else {
        if( (s + t) < A ) {
          // store first hit
          image.setPixel( x, y, color );
          foundY = true;
        } else {
          // after filling break
          if( foundY ) break;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
        }
     }
  }                                                                                                                                                                                                                                                                                                                                                                                                                              }
}

inline function triangleGradientFill( image: Image
                                    , ax: Float, ay: Float, colA: Int
                                    , bx: Float, by: Float, colB: Int
                                    , cx: Float, cy: Float, colC: Int ){
  var aA = ( colB >> 24 ) & 0xFF;
  var rA = ( colB >> 16 ) & 0xFF;
  var gA = ( colB >> 8 ) & 0xFF;
  var bA = colB & 0xFF;
  var aB = ( colA >> 24 ) & 0xFF;
  var rB = ( colA >> 16 ) & 0xFF;
  var gB = ( colA >> 8 ) & 0xFF;
  var bB = colA & 0xFF;
  var aC = ( colC >> 24 ) & 0xFF;
  var rC = ( colC >> 16 ) & 0xFF;
  var gC = ( colC >> 8 ) & 0xFF;
  var bC = colC & 0xFF;
  var bcx = bx - cx;
  var bcy = by - cy;
  var acx = ax - cx; 
  var acy = ay - cy;
  // Had to re-arrange algorithm to work so dot names may not quite make sense.
  var dot11 = dotSame( bcx, bcy );
  var dot12 = dot( bcx, bcy, acx, acy );
  var dot22 = dotSame( acx, acy );
  var denom1 = 1/( dot11 * dot22 - dot12 * dot12 );
  for( px in boundIterator3( cx, bx, ax ) ){
    var pcx = px - cx;
    for( py in boundIterator3( cy, by, ay ) ){
      var pcy = py - cy;
      var dot31 = dot( pcx, pcy, bcx, bcy );
      var dot32 = dot( pcx, pcy, acx, acy );
      var ratioA = (dot22 * dot31 - dot12 * dot32) * denom1;
      var ratioB = (dot11 * dot32 - dot12 * dot31) * denom1;
      var ratioC = 1.0 - ratioB - ratioA;
      if( ratioA >= 0 && ratioB >= 0 && ratioC >= 0 ){
        var a = boundChannel( aA*ratioA + aB*ratioB + aC*ratioC );
        var r = boundChannel( rA*ratioA + rB*ratioB + rC*ratioC );
        var g = boundChannel( gA*ratioA + gB*ratioB + gC*ratioC );
        var b = boundChannel( bA*ratioA + bB*ratioB + bC*ratioC );
        image.setPixel( px, py, Color.fromRGBA( r, g, b, a ) );                    
      }
    }
  }
}
inline function dot( ax: Float, ay: Float, bx: Float, by: Float ): Float
  return ax * bx + ay * by;
inline function dotSame( ax: Float, ay: Float ): Float
  return dot( ax, ay, ax, ay );
