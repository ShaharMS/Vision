package vision.algorithms;

import vision.ds.Color;
import vision.ds.HoughLine2D;
import vision.ds.Image;
import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.specifics.HoughLineOptions;
import vision.ds.specifics.ProbabilisticHoughLineOptions;

private typedef ProbabilisticSegment = {
	var line:Line2D;
	var supportVotes:Float;
	var candidateVotes:Float;
	var candidateRho:Float;
	var candidateTheta:Float;
}

class HoughProbabilisticSegments {
	public static function detect(edgeImage:Image, options:ProbabilisticHoughLineOptions):Array<Line2D> {
		if (edgeImage.width <= 0 || edgeImage.height <= 0) {
			return [];
		}

		var segments:Array<ProbabilisticSegment> = [];
		var candidates = Hough.detectLines(edgeImage, createCandidateOptions(options));
		for (candidate in candidates) {
			addCandidateSegments(segments, edgeImage, candidate, options);
		}

		segments.sort(compareSegments);
		return mergeSegments(segments, options);
	}

	static function createCandidateOptions(options:ProbabilisticHoughLineOptions):HoughLineOptions {
		var candidateOptions = new HoughLineOptions();
		candidateOptions.rhoResolution = options.rhoResolution;
		candidateOptions.thetaResolution = options.thetaResolution;
		candidateOptions.voteThreshold = resolveCandidateThreshold(options);
		candidateOptions.minTheta = options.minTheta;
		candidateOptions.maxTheta = options.maxTheta;
		candidateOptions.useEdgeValueWeights = options.useEdgeValueWeights;
		return candidateOptions;
	}

	static function addCandidateSegments(segments:Array<ProbabilisticSegment>, edgeImage:Image, candidate:HoughLine2D, options:ProbabilisticHoughLineOptions):Void {
		var clipped = candidate.toLine2D(edgeImage.width, edgeImage.height);
		if (clipped == null) {
			return;
		}

		var activeStart:Point2D = null;
		var lastSupport:Point2D = null;
		var supportVotes = 0.0;
		var gapDistance = 0.0;
		var previousPoint:Point2D = null;

		for (point in rasterize(clipped)) {
			var stepDistance = previousPoint == null ? 0.0 : previousPoint.distanceTo(point);
			var color = edgeImage.getPixel(Std.int(point.x), Std.int(point.y));
			var vote = resolveSupportVote(color, options.useEdgeValueWeights);

			if (vote > 0) {
				if (activeStart == null) {
					activeStart = point.copy();
				}
				lastSupport = point.copy();
				supportVotes += vote;
				gapDistance = 0.0;
				previousPoint = point;
				continue;
			}

			if (activeStart != null && lastSupport != null) {
				gapDistance += stepDistance;
				if (gapDistance > options.maxLineGap) {
					pushSegment(segments, activeStart, lastSupport, supportVotes, candidate, options);
					activeStart = null;
					lastSupport = null;
					supportVotes = 0.0;
					gapDistance = 0.0;
				}
			}

			previousPoint = point;
		}

		pushSegment(segments, activeStart, lastSupport, supportVotes, candidate, options);
	}

	static function pushSegment(segments:Array<ProbabilisticSegment>, start:Point2D, end:Point2D, supportVotes:Float, candidate:HoughLine2D, options:ProbabilisticHoughLineOptions):Void {
		if (start == null || end == null) {
			return;
		}

		var line = orderLine(new Line2D(start, end));
		if (line.length <= 0 || line.length < options.minLineLength || supportVotes < resolveSegmentThreshold(options)) {
			return;
		}

		segments.push({
			line: line,
			supportVotes: supportVotes,
			candidateVotes: candidate.votes,
			candidateRho: candidate.rho,
			candidateTheta: candidate.theta
		});
	}

	static function mergeSegments(segments:Array<ProbabilisticSegment>, options:ProbabilisticHoughLineOptions):Array<Line2D> {
		var merged:Array<ProbabilisticSegment> = [];
		for (segment in segments) {
			var matched = false;
			for (existing in merged) {
				if (!shouldMerge(existing, segment, options)) {
					continue;
				}
				existing.line = mergeLine(existing.line, segment.line);
				existing.supportVotes = Math.max(existing.supportVotes, segment.supportVotes);
				existing.candidateVotes = Math.max(existing.candidateVotes, segment.candidateVotes);
				matched = true;
				break;
			}
			if (!matched) {
				merged.push(segment);
			}
		}

		merged.sort(compareSegments);
		return [for (segment in merged) orderLine(segment.line)];
	}

	static function shouldMerge(lhs:ProbabilisticSegment, rhs:ProbabilisticSegment, options:ProbabilisticHoughLineOptions):Bool {
		var anglePadding = Math.max(options.thetaResolution * 2, Math.PI / 90);
		if (angleDifference(lhs.candidateTheta, rhs.candidateTheta) > anglePadding) {
			return false;
		}
		if (Math.abs(lhs.candidateRho - rhs.candidateRho) > Math.max(options.rhoResolution * 2, 0.75)) {
			return false;
		}
		if (!areColinear(lhs.line, rhs.line)) {
			return false;
		}
		return getAlongLineGap(lhs.line, rhs.line) <= Math.max(1.0, options.maxLineGap + 1.0);
	}

	static function mergeLine(lhs:Line2D, rhs:Line2D):Line2D {
		var reference = orderLine(lhs.length >= rhs.length ? lhs : rhs);
		var axis = getAxis(reference);
		var origin = reference.start;
		var points = [lhs.start, lhs.end, rhs.start, rhs.end];
		var minProjection = projectPoint(points[0], origin, axis.x, axis.y);
		var maxProjection = minProjection;
		for (index in 1...points.length) {
			var projection = projectPoint(points[index], origin, axis.x, axis.y);
			if (projection < minProjection) {
				minProjection = projection;
			}
			if (projection > maxProjection) {
				maxProjection = projection;
			}
		}
		var start = new Point2D(origin.x + axis.x * minProjection, origin.y + axis.y * minProjection);
		var end = new Point2D(origin.x + axis.x * maxProjection, origin.y + axis.y * maxProjection);
		return orderLine(new Line2D(start.copy(), end.copy()));
	}

	static function rasterize(line:Line2D):Array<Point2D> {
		var x1 = Std.int(Math.round(line.start.x));
		var y1 = Std.int(Math.round(line.start.y));
		var x2 = Std.int(Math.round(line.end.x));
		var y2 = Std.int(Math.round(line.end.y));
		var dx = Math.abs(x2 - x1);
		var dy = Math.abs(y2 - y1);
		var stepX = x1 < x2 ? 1 : -1;
		var stepY = y1 < y2 ? 1 : -1;
		var error = dx - dy;
		var points:Array<Point2D> = [];

		while (true) {
			points.push(new Point2D(x1, y1));
			if (x1 == x2 && y1 == y2) {
				return points;
			}
			var doubledError = error * 2;
			if (doubledError > -dy) {
				error -= dy;
				x1 += stepX;
			}
			if (doubledError < dx) {
				error += dx;
				y1 += stepY;
			}
		}
		return points;
	}

	static function compareSegments(lhs:ProbabilisticSegment, rhs:ProbabilisticSegment):Int {
		if (lhs.supportVotes > rhs.supportVotes) return -1;
		if (lhs.supportVotes < rhs.supportVotes) return 1;
		if (lhs.candidateVotes > rhs.candidateVotes) return -1;
		if (lhs.candidateVotes < rhs.candidateVotes) return 1;
		if (lhs.line.length > rhs.line.length) return -1;
		if (lhs.line.length < rhs.line.length) return 1;
		if (lhs.line.start.y < rhs.line.start.y) return -1;
		if (lhs.line.start.y > rhs.line.start.y) return 1;
		if (lhs.line.start.x < rhs.line.start.x) return -1;
		if (lhs.line.start.x > rhs.line.start.x) return 1;
		return 0;
	}

	static function orderLine(line:Line2D):Line2D {
		if (line.start.x < line.end.x || (line.start.x == line.end.x && line.start.y <= line.end.y)) {
			return line;
		}
		return new Line2D(line.end.copy(), line.start.copy());
	}

	static function areColinear(lhs:Line2D, rhs:Line2D):Bool {
		return maxOffsetFromLine(lhs, rhs) <= 0.500001 && maxOffsetFromLine(rhs, lhs) <= 0.500001;
	}

	static function maxOffsetFromLine(reference:Line2D, candidate:Line2D):Float {
		var axis = getAxis(reference);
		var origin = reference.start;
		var startOffset = distanceFromAxis(candidate.start, origin, axis.x, axis.y);
		var endOffset = distanceFromAxis(candidate.end, origin, axis.x, axis.y);
		return Math.max(startOffset, endOffset);
	}

	static function getAlongLineGap(lhs:Line2D, rhs:Line2D):Float {
		var reference = lhs.length >= rhs.length ? lhs : rhs;
		var axis = getAxis(reference);
		var origin = reference.start;
		var lhsRange = projectRange(lhs, origin, axis.x, axis.y);
		var rhsRange = projectRange(rhs, origin, axis.x, axis.y);
		if (lhsRange.max < rhsRange.min) {
			return rhsRange.min - lhsRange.max;
		}
		if (rhsRange.max < lhsRange.min) {
			return lhsRange.min - rhsRange.max;
		}
		return 0.0;
	}

	static function projectRange(line:Line2D, origin:Point2D, axisX:Float, axisY:Float):{min:Float, max:Float} {
		var startProjection = projectPoint(line.start, origin, axisX, axisY);
		var endProjection = projectPoint(line.end, origin, axisX, axisY);
		return {
			min: Math.min(startProjection, endProjection),
			max: Math.max(startProjection, endProjection)
		};
	}

	static function getAxis(line:Line2D):Point2D {
		var ordered = orderLine(line);
		if (ordered.length <= 0) {
			return new Point2D(1, 0);
		}
		return new Point2D((ordered.end.x - ordered.start.x) / ordered.length, (ordered.end.y - ordered.start.y) / ordered.length);
	}

	static inline function projectPoint(point:Point2D, origin:Point2D, axisX:Float, axisY:Float):Float {
		return (point.x - origin.x) * axisX + (point.y - origin.y) * axisY;
	}

	static inline function distanceFromAxis(point:Point2D, origin:Point2D, axisX:Float, axisY:Float):Float {
		return Math.abs((point.x - origin.x) * -axisY + (point.y - origin.y) * axisX);
	}

	static function angleDifference(lhs:Float, rhs:Float):Float {
		var diff = Math.abs(lhs - rhs);
		return diff > Math.PI / 2 ? Math.PI - diff : diff;
	}

	static inline function resolveCandidateThreshold(options:ProbabilisticHoughLineOptions):Int {
		var threshold = options.candidateThreshold > 0 ? options.candidateThreshold : options.voteThreshold;
		return threshold > 0 ? threshold : 1;
	}

	static inline function resolveSegmentThreshold(options:ProbabilisticHoughLineOptions):Float {
		return options.voteThreshold > 0 ? options.voteThreshold : 1;
	}

	static inline function resolveSupportVote(color:Color, useWeights:Bool):Float {
		var intensity = Math.max(color.red, Math.max(color.green, color.blue));
		if (intensity <= 0) {
			return 0;
		}
		return useWeights ? intensity / 255 : 1.0;
	}
}