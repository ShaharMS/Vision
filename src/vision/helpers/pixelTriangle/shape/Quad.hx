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
import vision.helpers.pixelTriangle.shape.Triangle;

/**
  uses two triangles to create a filled quad using four coordinates a,b,c,d arranged clockwise 
**/
inline function quadFill( image: Image
                        , ax: Float, ay: Float
                        , bx: Float, by: Float
                        , cx: Float, cy: Float
                        , dx: Float, dy: Float 
                        , color: Int ){
  // tri e - a b d
  // tri f - b c d
  triangleFill( image, ax, ay, bx, by, dx, dy, color );
  triangleFill( image, bx, by, cx, cy, dx, dy, color );
}
/**
  uses two triangle to form a quad with clockwise coordinates a,b,c,d
  with respective colours after each coordinate pair
**/
inline function quadGradientFill( image: Image
                            , ax: Float, ay: Float, colorA: Int
                            , bx: Float, by: Float, colorB: Int
                            , cx: Float, cy: Float, colorC: Int 
                            , dx: Float, dy: Float, colorD: Int ){
  // tri e - a b d
  // tri f - b c d
  triangleGradientFill( image, ax, ay, colorA, bx, by, colorB, dx, dy, colorD );
  triangleGradientFill( image, bx, by, colorB, cx, cy, colorC, dx, dy, colorD );
}
