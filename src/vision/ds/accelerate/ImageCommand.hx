package vision.ds.accelerate;

import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.IntPoint2D;
import vision.ds.Circle2D;
import vision.ds.Polygon;
import vision.ds.MultiPolygon;
import vision.ds.Image;
import vision.ds.Color;
import vision.ds.ImageResizeAlgorithm;
import vision.ds.Matrix2D;
import vision.ds.Rectangle;

@:noCompletion
enum ImageCommand {
	Clear(color:Color);
	SetPixel(x:Int, y:Int, color:Color);
	DrawLine(line:Line2D, color:Color);
	DrawRectangle(bounds:Rectangle, color:Color);
	Ellipse(x:Int, y:Int, radiusX:Int, radiusY:Int, color:Color, fill:Bool);
	PolygonShape(polygon:Polygon, color:Color, fill:Bool);
	MultiPolygonShape(polygons:MultiPolygon, color:Color, fill:Bool);
	Crop(bounds:Rectangle);
	Blit(source:Image, x:Int, y:Int);
	FillRectangle(bounds:Rectangle, color:Color);
	Resize(width:Int, height:Int, algorithm:ImageResizeAlgorithm);
	Convolve(kernel:Matrix2D);
	ConvolveAxis(weights:Array<Float>, vertical:Bool);
	Transform(operation:ImageOperation, value:Int);
}
