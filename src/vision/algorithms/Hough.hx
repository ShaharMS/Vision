package vision.algorithms;

import vision.ds.Circle2D;
import vision.ds.Color;
import vision.ds.HoughLine2D;
import vision.ds.Image;
import vision.ds.Line2D;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.specifics.HoughCircleOptions;
import vision.ds.specifics.HoughLineOptions;
import vision.ds.specifics.ProbabilisticHoughLineOptions;

class Hough {
	public static function createAccumulator(thetaBins:Int, rhoBins:Int):Matrix2D {
		var accumulator = new Matrix2D(thetaBins, rhoBins);
		accumulator.fill(0);
		return accumulator;
	}

	public static function detectLines(image:Image, ?options:HoughLineOptions):Array<HoughLine2D> {
		resolveLineOptions(options);
		return [];
	}

	public static function detectLinesFromPoints(points:Array<Point2D>, width:Int, height:Int, ?options:HoughLineOptions):Array<HoughLine2D> {
		resolveLineOptions(options);
		return [];
	}

	public static function detectLineSegments(image:Image, ?options:ProbabilisticHoughLineOptions):Array<Line2D> {
		resolveProbabilisticOptions(options);
		return [];
	}

	public static function detectCircles(image:Image, ?options:HoughCircleOptions):Array<Circle2D> {
		resolveCircleOptions(options);
		return [];
	}

	public static function mapLines(image:Image, lines:Array<HoughLine2D>, color:Color = Color.CYAN):Image {
		for (line in lines) {
			var clipped = line.toLine2D(image.width, image.height);
			if (clipped != null) {
				image.drawLine2D(clipped, color);
			}
		}
		return image;
	}

	static inline function resolveLineOptions(?options:HoughLineOptions):HoughLineOptions {
		return options == null ? new HoughLineOptions() : options;
	}

	static inline function resolveProbabilisticOptions(?options:ProbabilisticHoughLineOptions):ProbabilisticHoughLineOptions {
		return options == null ? new ProbabilisticHoughLineOptions() : options;
	}

	static inline function resolveCircleOptions(?options:HoughCircleOptions):HoughCircleOptions {
		return options == null ? new HoughCircleOptions() : options;
	}
}