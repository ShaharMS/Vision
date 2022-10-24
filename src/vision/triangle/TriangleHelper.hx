package vision.triangle;
import vision.ds.Image;

public inline
function triangleFill( image: Image
                     , ax: Float, ay: Float
                     , bx: Float, by: Float
                     , cx: Float, cy: Float
                     , color: Int ){
  var adjustWinding = ( (ax * by - bx * ay) + (bx * cy - cx * by) + (cx * ay - ax * cy) )>0;
  if( !adjustWinding ){// TODO: this is inverse of cornerContour needs thought, but provides required protection
    // swap b and c
    // probably wrong way as y is down?
    // may need tweak for Vision 
    var bx_ = bx;
    var by_ = by;
    bx = cx;
    by = cy;
    cx = bx_;
    cy = by_;
  }
  fillTriangleUnsafe( this, ax, ay, bx, by, cx, cy, color );
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

inline function fillGradientTriangle( image: Image
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
        image.setPixel( px,py, Color.colorFromRGBA( r, g, b, a );                    
      }
    }
  }
}
inline function boundChannel( f: Float ): Int {
  var i = Std.int( f );
  if( i > 0xFF ) i = 0xFF;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  if( i < 0 ) i = 0;
  return i;
}
inline function dot( ax: Float, ay: Float, bx: Float, by: Float ): Float
  return ax * bx + ay * by;
inline function dotSame( ax: Float, ay: Float ): Float
  return dot( ax, ay, ax, ay );
/**
 Used for bounding box iteration, calculates lo...hi iterator from 3 values. 
 **/
inline function boundIterator3( a: Float, b: Float, c: Float ): IntIterator {
  return if( a > b ){
    if( a > c ){ // a,b a,c
      (( b > c )? Math.floor( c ): Math.floor( b ))...Math.ceil( a );
    } else { // c,a,b
      Math.floor( b )...Math.ceil( c );
    }
  } else {
    if( b > c ){ // b,a, b,c 
      (( a > c )? Math.floor( c ): Math.ceil( a ))...Math.ceil( b );
    } else { // c,b,a
      Math.floor( a )...Math.ceil( c );
    }
  }
}
/**
    Like a normal IntIterator but allows access of start and max after construction and reuse.
**/
@:access(IntIterator.min, IntIterator.max )
class IntIterStart {
    public var start: Int;
    public var max: Int;
    public function new( min_: Int, max_: Int ){
        start = min_;
        max = max_;
    }
}
@:transitive
@:access( IntIterator.min, IntIterator.max )
@:forward
abstract IteratorRange( IntIterStart ) from IntIterStart {
    public static inline
    function startLength( min: Int, len: Int ): IteratorRange {
        return new IteratorRange( min, min + len - 1 );
    }
    public inline
    function new( min: Int, max: Int ){
        this = new IntIterStart( min, max );
    }
    @:from
    static inline
    public function fromIterator( ii: IntIterator ): IteratorRange {
        return new IteratorRange( ii.min, ii.max );
    }
    @:to
    function toIterStart():IteratorRange {
       return new IteratorRange( this.start, this.max );
    }
    public inline function iterator(){
        return this.start...this.max;
    }
    @:op(A + B) public static inline
    function adding( a: IteratorRange, b: IteratorRange ): IteratorRange {
      	return a.add( b );
    }
    public inline
    function add( b: IteratorRange ): IteratorRange {
        var begin: Int = Std.int( Math.min( this.start, b.max ) );
        var end = ( begin == this.start )? b.max: this.max;
        return new IteratorRange( begin, end );
    }
    public
    var length( get, set ): Int; 
    inline
    function get_length(): Int {
        return this.max - this.start + 1;
    }
    inline
    function set_length( l: Int ): Int {
        this.max = l - 1;
        return l;
    }
    inline
    public function contains( v: Int ): Bool {
        return ( v > ( this.start - 1 ) && ( v < this.max + 1 ) );
    }
    inline
    public function isWithin( ir: IteratorRange ): Bool {
        return contains( ir.start ) && contains( ir.max );
    }
    inline
    public function moveRange( v: Int ){
        this.start += v;
        this.max += v;
    }
    @:op(A += B)
    public inline static
    function addAssign( a: IteratorRange, v: Int ){
        a.moveRange( v );
        return a;
    } 
    @:op(A -= B)
    public inline static
    function minusAssign( a: IteratorRange, v: Int ){
        return a+=-v;
    }
    inline
    public function ifContainMove( v: Int, amount: Int ): Bool {
        var ifHas = contains( v );
        if( ifHas ) moveRange( amount );
        return ifHas; 
    }
}

