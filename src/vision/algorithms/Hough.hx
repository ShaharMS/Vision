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

private typedef HoughVotePoint = {
	var x:Float;
	var y:Float;
	var vote:Float;
}

class Hough {
	public static function createAccumulator(thetaBins:Int, rhoBins:Int):Matrix2D {
		var accumulator = new Matrix2D(thetaBins, rhoBins);
		accumulator.fill(0);
		return accumulator;
	}

	public static function detectLines(image:Image, ?options:HoughLineOptions):Array<HoughLine2D> {
		var lineOptions = resolveLineOptions(options);
		var points = collectVotePointsFromImage(image, lineOptions);
		return detectLinesFromVotePoints(points, image.width, image.height, lineOptions);
	}

	public static function detectLinesFromPoints(points:Array<Point2D>, width:Int, height:Int, ?options:HoughLineOptions):Array<HoughLine2D> {
		var lineOptions = resolveLineOptions(options);
		var votePoints:Array<HoughVotePoint> = [];
		for (point in points) {
			votePoints.push({x: point.x, y: point.y, vote: 1.0});
		}
		return detectLinesFromVotePoints(votePoints, width, height, lineOptions);
	}

	public static function detectLineSegments(image:Image, ?options:ProbabilisticHoughLineOptions, ?edgeImage:Image):Array<Line2D> {
		var segmentOptions = resolveProbabilisticOptions(options);
		var sourceImage = edgeImage == null ? image : edgeImage;
		return HoughProbabilisticSegments.detect(sourceImage, segmentOptions);
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

	static function detectLinesFromVotePoints(points:Array<HoughVotePoint>, width:Int, height:Int, options:HoughLineOptions):Array<HoughLine2D> {
		if (width <= 0 || height <= 0 || points.length == 0) {
			return [];
		}

		var thetaBins = getThetaBinCount(options);
		var maxDistance = Math.sqrt((width - 1) * (width - 1) + (height - 1) * (height - 1));
		var maxRho = Math.ceil(maxDistance / options.rhoResolution) * options.rhoResolution;
		var minRho = -maxRho;
		var rhoBins = getRhoBinCount(minRho, maxRho, options.rhoResolution);
		if (thetaBins == 0 || rhoBins == 0) {
			return [];
		}

		var accumulator = createAccumulator(thetaBins, rhoBins);
		voteForLines(points, accumulator, options, minRho);
		return extractPeaks(accumulator, width, height, options, minRho);
	}

	static function collectVotePointsFromImage(image:Image, options:HoughLineOptions):Array<HoughVotePoint> {
		var points:Array<HoughVotePoint> = [];
		image.forEachPixel((x, y, color) -> {
			var vote = resolveEdgeVote(color, options.useEdgeValueWeights);
			if (vote <= 0) {
				return;
			}
			points.push({x: x, y: y, vote: vote});
		});
		return points;
	}

	static function voteForLines(points:Array<HoughVotePoint>, accumulator:Matrix2D, options:HoughLineOptions, minRho:Float):Void {
		for (point in points) {
			for (thetaIndex in 0...accumulator.width) {
				var theta = options.minTheta + thetaIndex * options.thetaResolution;
				var rho = point.x * Math.cos(theta) + point.y * Math.sin(theta);
				var rhoIndex = resolveRhoIndex(rho, minRho, options.rhoResolution, accumulator.height);
				var votes = accumulator.get(thetaIndex, rhoIndex) + point.vote;
				accumulator.set(thetaIndex, rhoIndex, votes);
			}
		}
	}

	static function extractPeaks(accumulator:Matrix2D, width:Int, height:Int, options:HoughLineOptions, minRho:Float):Array<HoughLine2D> {
		var lines:Array<HoughLine2D> = [];
		for (thetaIndex in 0...accumulator.width) {
			for (rhoIndex in 0...accumulator.height) {
				var votes = accumulator.get(thetaIndex, rhoIndex);
				if (votes < options.voteThreshold || !isPeak(accumulator, thetaIndex, rhoIndex, votes)) {
					continue;
				}
				var theta = options.minTheta + thetaIndex * options.thetaResolution;
				var rho = minRho + rhoIndex * options.rhoResolution;
				var line = new HoughLine2D(rho, theta, votes);
				if (line.toLine2D(width, height) != null) {
					lines.push(line);
				}
			}
		}
		lines.sort(compareLines);
		return lines;
	}

	static function compareLines(lhs:HoughLine2D, rhs:HoughLine2D):Int {
		if (lhs.votes > rhs.votes) {
			return -1;
		}
		if (lhs.votes < rhs.votes) {
			return 1;
		}
		if (lhs.theta < rhs.theta) {
			return -1;
		}
		if (lhs.theta > rhs.theta) {
			return 1;
		}
		if (lhs.rho < rhs.rho) {
			return -1;
		}
		if (lhs.rho > rhs.rho) {
			return 1;
		}
		return 0;
	}

	static function isPeak(accumulator:Matrix2D, thetaIndex:Int, rhoIndex:Int, votes:Float):Bool {
		for (neighborTheta in thetaIndex - 1...thetaIndex + 2) {
			if (neighborTheta < 0 || neighborTheta >= accumulator.width) {
				continue;
			}
			for (neighborRho in rhoIndex - 1...rhoIndex + 2) {
				if (neighborRho < 0 || neighborRho >= accumulator.height) {
					continue;
				}
				if (neighborTheta == thetaIndex && neighborRho == rhoIndex) {
					continue;
				}
				var neighborVotes = accumulator.get(neighborTheta, neighborRho);
				if (neighborVotes > votes) {
					return false;
				}
				if (neighborVotes == votes && isEarlierPeak(neighborTheta, neighborRho, thetaIndex, rhoIndex)) {
					return false;
				}
			}
		}
		return true;
	}

	static inline function isEarlierPeak(neighborTheta:Int, neighborRho:Int, thetaIndex:Int, rhoIndex:Int):Bool {
		return neighborTheta < thetaIndex || (neighborTheta == thetaIndex && neighborRho < rhoIndex);
	}

	static inline function resolveEdgeVote(color:Color, useWeights:Bool):Float {
		var intensity = Math.max(color.red, Math.max(color.green, color.blue));
		if (intensity <= 0) {
			return 0;
		}
		return useWeights ? intensity / 255 : 1.0;
	}

	static inline function getThetaBinCount(options:HoughLineOptions):Int {
		if (options.thetaResolution <= 0 || options.maxTheta <= options.minTheta) {
			return 0;
		}
		return Std.int(Math.ceil((options.maxTheta - options.minTheta) / options.thetaResolution));
	}

	static inline function getRhoBinCount(minRho:Float, maxRho:Float, resolution:Float):Int {
		if (resolution <= 0 || maxRho < minRho) {
			return 0;
		}
		return Std.int(Math.floor((maxRho - minRho) / resolution)) + 1;
	}

	static inline function resolveRhoIndex(rho:Float, minRho:Float, resolution:Float, rhoBins:Int):Int {
		var index = Std.int(Math.floor(((rho - minRho) / resolution) + 0.000001));
		if (index < 0) {
			return 0;
		}
		if (index >= rhoBins) {
			return rhoBins - 1;
		}
		return index;
	}

	static inline function resolveProbabilisticOptions(?options:ProbabilisticHoughLineOptions):ProbabilisticHoughLineOptions {
		return options == null ? new ProbabilisticHoughLineOptions() : options;
	}

	static inline function resolveCircleOptions(?options:HoughCircleOptions):HoughCircleOptions {
		return options == null ? new HoughCircleOptions() : options;
	}
}