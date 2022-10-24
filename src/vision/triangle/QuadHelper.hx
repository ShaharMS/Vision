package vision.triangle;
import vision.triangle.TriangleHelper;

// Module QuadHelper

/**
  uses two triangles to create a filled quad using four coordinates a,b,c,d arranged clockwise 
**/
inline function fillQuad( image: Image
                        , ax: Float, ay: Float
                        , bx: Float, by: Float
                        , cx: Float, cy: Float
                        , dx: Float, dy: Float 
                        , color: Int ){
  // tri e - a b d
  // tri f - b c d
  fillTri( ax, ay, bx, by, dx, dy, color );
  fillTri( bx, by, cx, cy, dx, dy, color );
}
/**
  uses two triangle to form a quad with clockwise coordinates a,b,c,d
  with respective colours after each coordinate pair
**/
inline function fillGradQuad( image: Image
                            , ax: Float, ay: Float, colorA: Pixel32
                            , bx: Float, by: Float, colorB: Pixel32
                            , cx: Float, cy: Float, colorC: Pixel32 
                            , dx: Float, dy: Float, colorD: Pixel32 ){
  // tri e - a b d
  // tri f - b c d
  fillGradientTriangle( image, ax, ay, colorA, bx, by, colorB, dx, dy, colorD );
  fillGradientTriangle( image, bx, by, colorB, cx, cy, colorC, dx, dy, colorD );
}
