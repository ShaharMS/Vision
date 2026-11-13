package vision.ds.accelerate;

import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.IntPoint2D;
import vision.ds.Circle2D;
import vision.ds.Polygon;
import vision.ds.MultiPolygon;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageResizeAlgorithm;
import vision.ds.Matrix2D;
import vision.ds.Rectangle;

/** Shared signatures for concrete platform image batches. **/
interface ImageBatch<Self> {
	function clear(color:Color):Self;
	function setPixel(x:Int, y:Int, color:Color):Self;
	function drawLine(line:Line2D, color:Color):Self;
	function drawRect(bounds:Rectangle, color:Color):Self;
	function drawCircle(circle:Circle2D, color:Color):Self;
	function fillCircle(circle:Circle2D, color:Color):Self;
	function drawEllipse(center:Point2D, radiusX:Float, radiusY:Float, color:Color):Self;
	function fillEllipse(center:Point2D, radiusX:Float, radiusY:Float, color:Color):Self;
	function drawPolygon(polygon:Polygon, color:Color):Self;
	function fillPolygon(polygon:Polygon, color:Color):Self;
	function drawMultiPolygon(polygons:MultiPolygon, color:Color):Self;
	function fillMultiPolygon(polygons:MultiPolygon, color:Color):Self;
	function crop(bounds:Rectangle):Self;
	function blit(source:Image, x:Int, y:Int):Self;
	function fillRect(bounds:Rectangle, color:Color):Self;
	function resize(width:Int, height:Int, algorithm:ImageResizeAlgorithm):Self;
	function convolve(kernel:Matrix2D):Self;
	function convolveHorizontal(weights:Array<Float>):Self;
	function convolveVertical(weights:Array<Float>):Self;
	function invert():Self;
	function grayscale(simple:Bool = false):Self;
	function threshold(level:Int):Self;
	function commit(mode:ImageCommitMode = NewImage):Image;
}
