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
import vision.helpers.pixelTriangle.shape.Quad;

/**
  provides a thick line using two triangles vector p, q
**/
inline function lineFill( image: Image
                        , px: Float, py: Float, qx: Float, qy: Float
                        , thick: Float, color: Int ){
  var o = qy-py;
  var a = qx-py;
  var h = Math.pow( o*o + a*a, 0.5 );
  var theta = Math.atan2( o, a );
  rotateLine( image, px, py, thick, h, theta, color);
}
/**
  provides a thick line using two gradient triangle vector p,q
  the four colors are arranged clockwise a,b,c,d
**/
inline function lineGradientFill( image: Image, px: Float, py: Float, qx: Float, qy: Float
                            , thick: Float
                            , colorA: Int, colorB: Int, colorC: Int, colorD: Int ){
  var o = qy-py;
  var a = qx-py;
  var h = Math.pow( o*o + a*a, 0.5 );
  var theta = Math.atan2( o, a );
  rotateGradLine( image, px, py, thick, h, theta, colorA, colorB, colorC, colorD );
}

inline function rotateLine( image: Image
                          , px: Float, py: Float
                          , thick: Float, h: Float
                          , theta: Float, color: Int ){
    var sin = Math.sin( theta );
    var cos = Math.cos( theta );
    var radius = thick/2;
    var dx = 0.1;
    var dy = radius;
    var cx = h;
    var cy = radius;
    var bx = h;
    var by = -radius;
    var ax = 0.1;
    var ay = -radius;
    var temp = 0.;
    temp = px + rotX( ax, ay, sin, cos );
    ay = py + rotY( ax, ay, sin, cos );
    ax = temp;
               
    temp = px + rotX( bx, by, sin, cos );
    by = py + rotY( bx, by, sin, cos );
    bx = temp;

    temp = px + rotX( cx, cy, sin, cos );
    cy = py + rotY( cx, cy, sin, cos );
    cx = temp;

    temp = px + rotX( dx, dy, sin, cos );
    dy = py + rotY( dx, dy, sin, cos ); 
    dx = temp;
    quadFill( image, ax, ay, bx, by, cx, cy, dx, dy, color );
}

inline function rotateGradLine( image: Image
                              , px: Float, py: Float
                              , thick: Float, h: Float
                              , theta: Float
                              , colorA: Int, colorB: Int, colorC: Int, colorD: Int ){
    var sin = Math.sin( theta );
    var cos = Math.cos( theta );
    var radius = thick/2;
    var dx = 0.1;
    var dy = radius;
    var cx = h;
    var cy = radius;
    var bx = h;
    var by = -radius;
    var ax = 0.1;
    var ay = -radius;
    var temp = 0.;
    temp = px + rotX( ax, ay, sin, cos );
    ay = py + rotY( ax, ay, sin, cos );
    ax = temp;
               
    temp = px + rotX( bx, by, sin, cos );
    by = py + rotY( bx, by, sin, cos );
    bx = temp;

    temp = px + rotX( cx, cy, sin, cos );
    cy = py + rotY( cx, cy, sin, cos );
    cx = temp;

    temp = px + rotX( dx, dy, sin, cos );
    dy = py + rotY( dx, dy, sin, cos ); 
    dx = temp;

    quadGradientFill( image, ax, ay, colorA, bx, by, colorB, cx, cy, colorC, dx, dy, colorD );
}
inline function rotX( x: Float, y: Float, sin: Float, cos: Float )
  return x * cos - y * sin;
inline function rotY( x: Float, y: Float, sin: Float, cos: Float )
  return y * cos + x * sin;
