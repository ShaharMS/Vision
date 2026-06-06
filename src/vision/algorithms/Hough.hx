package vision.algorithms;

import haxe.ds.StringMap;
import vision.ds.Circle2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Line2D;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.Ray2D;
import vision.ds.canny.CannyObject;
import vision.ds.hough.HoughCircleCandidate;
import vision.ds.hough.HoughLineCandidate;
import vision.ds.hough.HoughVotePoint;
import vision.ds.hough.ProbabilisticSegment;
import vision.ds.specifics.HoughCircleOptions;
import vision.ds.specifics.HoughLineOptions;
import vision.ds.specifics.ProbabilisticHoughLineOptions;
import vision.Vision;
import vision.exceptions.HoughEdgeImageSizeMismatch;

using vision.algorithms.Canny;

/**
	Hough feature detection for lines and circles.

	This class only performs feature extraction. Visualization belongs in `Vision`
	or caller code.

	Three transforms live here:

	1. **Standard line Hough** — edge pixels vote in `(rho, theta)` space; peaks
	   become `Ray2D` lines.
	2. **Probabilistic line Hough** — reuses standard candidates, then extracts
	   bounded `Line2D` segments from supported edge runs along each candidate.
	3. **Circle Hough** — votes for circle centers and radii from Canny edges and
	   returns `Circle2D` geometry.

	Application wrappers: `Vision.houghLineSegmentDetection(...)`,
	`Vision.houghCircleDetection(...)`.
**/
@:allow(tests.HoughStandardTest)
@:allow(tests.HoughProbabilisticTest)
class Hough {

	/**
		Allocates a `(theta, rho)` vote accumulator filled with zeroes.
	**/
	public static function createAccumulator(thetaBins:Int, rhoBins:Int):Matrix2D {
		var accumulator = new Matrix2D(thetaBins, rhoBins);
		accumulator.fill(0);
		return accumulator;
	}

	/**
		Detects full lines using the standard Hough transform.

		Edge pixels vote into `(rho, theta)` bins. Peaks above `voteThreshold` become
		`Ray2D` values that can be clipped with `Ray2D.toLine2D(...)`.
	**/
	public static function detectLines(image:Image, ?options:HoughLineOptions):Array<Ray2D> {
		return [for (candidate in detectLineCandidates(image, options)) candidate.ray];
	}

	/**
		Same accumulator path as `detectLines(...)`, but votes from explicit `(x, y)` points.
	**/
	public static function detectLinesFromPoints(points:Array<Point2D>, width:Int, height:Int, ?options:HoughLineOptions):Array<Ray2D> {
		var lineOptions = options == null ? new HoughLineOptions() : options;
		var votePoints:Array<HoughVotePoint> = [for (point in points) {x: point.x, y: point.y, vote: 1.0}];
		return [for (candidate in detectLineCandidatesFromVotePoints(votePoints, width, height, lineOptions)) candidate.ray];
	}

	/**
		Detects bounded line segments with probabilistic Hough.

		Standard `(rho, theta)` candidates are found first, then each candidate is
		walked along the edge image to extract supported pixel runs as segments.

		`edgeImage` must match `image` dimensions when provided, because segment
		endpoints are bounded to that canvas.
	**/
	public static function detectLineSegments(image:Image, ?options:ProbabilisticHoughLineOptions, ?edgeImage:Image):Array<Line2D> {
		var segmentOptions = options == null ? new ProbabilisticHoughLineOptions() : options;
		if (edgeImage != null && (edgeImage.width != image.width || edgeImage.height != image.height)) {
			throw new HoughEdgeImageSizeMismatch(image, edgeImage);
		}
		return detectProbabilisticSegments(edgeImage == null ? image : edgeImage, segmentOptions);
	}

	/**
		Detects circles with a gradient-guided center accumulator.

		Input is grayscaled, optionally median-filtered, edge-detected, then searched
		over the configured radius range. Accumulator votes stay internal; only
		`Circle2D` geometry is returned.
	**/
	public static function detectCircles(image:Image, ?options:HoughCircleOptions):Array<Circle2D> {
		var circleOptions = options == null ? new HoughCircleOptions() : options;
		if (image.width <= 0 || image.height <= 0) return [];

		var scale = circleOptions.dp >= 1 ? circleOptions.dp : 1.0;
		var minRadius = circleOptions.minimumRadius > 0 ? circleOptions.minimumRadius : 1;
		var maxRadius = circleOptions.maximumRadius > 0
			? circleOptions.maximumRadius
			: Std.int(Math.floor(Math.min(image.width, image.height) / 2));
		if (maxRadius < minRadius) return [];

		var grayscaleImage = grayscaleCircleInput(image, circleOptions);
		var edgeImage = extractCircleEdgeMap(grayscaleImage, circleOptions);
		if (!imageHasEdges(edgeImage)) return [];

		var candidates = accumulateCircleCandidates(grayscaleImage, edgeImage, minRadius, maxRadius, scale, circleOptions, false);
		if (candidates.length == 0) {
			candidates = accumulateCircleCandidates(grayscaleImage, edgeImage, minRadius, maxRadius, scale, circleOptions, true);
		}

		candidates.sort(compareCircleCandidates);
		return [for (candidate in suppressCircleDuplicates(candidates, circleOptions.minimumDistance)) candidate.circle];
	}

	/**
		Collects edge vote points from an image and runs the standard line accumulator.
	**/
	static function detectLineCandidates(image:Image, ?options:HoughLineOptions):Array<HoughLineCandidate> {
		var lineOptions = options == null ? new HoughLineOptions() : options;
		var points:Array<HoughVotePoint> = [];
		image.forEachPixel((x, y, color) -> {
			var vote = edgeVoteWeight(color, lineOptions.useEdgeValueWeights);
			if (vote > 0) points.push({x: x, y: y, vote: vote});
		});
		return detectLineCandidatesFromVotePoints(points, image.width, image.height, lineOptions);
	}

	/**
		Test hook for the point-set entry path used by parity tests.
	**/
	static function detectLineCandidatesFromPoints(points:Array<Point2D>, width:Int, height:Int, ?options:HoughLineOptions):Array<HoughLineCandidate> {
		var lineOptions = options == null ? new HoughLineOptions() : options;
		var votePoints:Array<HoughVotePoint> = [for (point in points) {x: point.x, y: point.y, vote: 1.0}];
		return detectLineCandidatesFromVotePoints(votePoints, width, height, lineOptions);
	}

	/**
		Core standard Hough path: vote into `(theta, rho)` bins, then read local maxima.
	**/
	static function detectLineCandidatesFromVotePoints(points:Array<HoughVotePoint>, width:Int, height:Int, options:HoughLineOptions):Array<HoughLineCandidate> {
		if (width <= 0 || height <= 0 || points.length == 0) return [];
		if (options.thetaResolution <= 0 || options.maxTheta <= options.minTheta) return [];

		var thetaBins = Std.int(Math.ceil((options.maxTheta - options.minTheta) / options.thetaResolution));
		var maxDistance = Math.sqrt((width - 1) * (width - 1) + (height - 1) * (height - 1));
		var maxRho = Math.ceil(maxDistance / options.rhoResolution) * options.rhoResolution;
		var minRho = -maxRho;
		if (options.rhoResolution <= 0 || maxRho < minRho) return [];
		var rhoBins = Std.int(Math.floor((maxRho - minRho) / options.rhoResolution)) + 1;

		var accumulator = createAccumulator(thetaBins, rhoBins);
		for (point in points) {
			for (thetaIndex in 0...thetaBins) {
				var theta = options.minTheta + thetaIndex * options.thetaResolution;
				var rho = point.x * Math.cos(theta) + point.y * Math.sin(theta);
				var rhoIndex = rhoBinIndex(rho, minRho, options.rhoResolution, rhoBins);
				accumulator.set(thetaIndex, rhoIndex, accumulator.get(thetaIndex, rhoIndex) + point.vote);
			}
		}

		var lines:Array<HoughLineCandidate> = [];
		for (thetaIndex in 0...thetaBins) {
			for (rhoIndex in 0...rhoBins) {
				var votes = accumulator.get(thetaIndex, rhoIndex);
				if (votes < options.voteThreshold || !isAccumulatorPeak(accumulator, thetaIndex, rhoIndex, votes)) continue;
				var theta = options.minTheta + thetaIndex * options.thetaResolution;
				var rho = minRho + rhoIndex * options.rhoResolution;
				var ray = Ray2D.fromPolar(rho, theta);
				if (ray.toLine2D(width, height) != null) lines.push({ray: ray, votes: votes});
			}
		}
		lines.sort(compareLineCandidates);
		return lines;
	}

	/**
		Probabilistic Hough: find candidate lines, extract supported runs, merge duplicates.
	**/
	static function detectProbabilisticSegments(edgeImage:Image, options:ProbabilisticHoughLineOptions):Array<Line2D> {
		if (edgeImage.width <= 0 || edgeImage.height <= 0) return [];

		var candidateOptions = new HoughLineOptions();
		candidateOptions.rhoResolution = options.rhoResolution;
		candidateOptions.thetaResolution = options.thetaResolution;
		candidateOptions.voteThreshold = options.candidateThreshold > 0 ? options.candidateThreshold : (options.voteThreshold > 0 ? options.voteThreshold : 1);
		candidateOptions.minTheta = options.minTheta;
		candidateOptions.maxTheta = options.maxTheta;
		candidateOptions.useEdgeValueWeights = options.useEdgeValueWeights;

		var segments:Array<ProbabilisticSegment> = [];
		for (candidate in detectLineCandidates(edgeImage, candidateOptions)) {
			extractSegmentsAlongCandidate(segments, edgeImage, candidate.ray, candidate.votes, options);
		}
		segments.sort(compareProbabilisticSegments);
		return mergeProbabilisticSegments(segments, options);
	}

	/**
		Walks one clipped candidate line across the edge image and records supported runs.

		Each run becomes a segment when a gap larger than `maxLineGap` breaks continuity.
	**/
	static function extractSegmentsAlongCandidate(segments:Array<ProbabilisticSegment>, edgeImage:Image, candidate:Ray2D, candidateVotes:Float, options:ProbabilisticHoughLineOptions):Void {
		var clipped = candidate.toLine2D(edgeImage.width, edgeImage.height);
		if (clipped == null) return;

		var activeStart:Point2D = null;
		var lastSupport:Point2D = null;
		var supportVotes = 0.0;
		var gapDistance = 0.0;
		var previousPoint:Point2D = null;
		var segmentThreshold = options.voteThreshold > 0 ? options.voteThreshold : 1;

		var x = Std.int(Math.round(clipped.start.x));
		var y = Std.int(Math.round(clipped.start.y));
		var endX = Std.int(Math.round(clipped.end.x));
		var endY = Std.int(Math.round(clipped.end.y));
		var dx = Math.abs(endX - x);
		var dy = Math.abs(endY - y);
		var stepX = x < endX ? 1 : -1;
		var stepY = y < endY ? 1 : -1;
		var error = dx - dy;

		while (true) {
			var point = new Point2D(x, y);
			var stepDistance = previousPoint == null ? 0.0 : previousPoint.distanceTo(point);
			var vote = edgeVoteWeight(edgeImage.getPixel(x, y), options.useEdgeValueWeights);

			if (vote > 0) {
				if (activeStart == null) activeStart = point.copy();
				lastSupport = point.copy();
				supportVotes += vote;
				gapDistance = 0.0;
			} else if (activeStart != null && lastSupport != null) {
				gapDistance += stepDistance;
				if (gapDistance > options.maxLineGap) {
					pushProbabilisticSegment(segments, activeStart, lastSupport, supportVotes, candidate, candidateVotes, options, segmentThreshold);
					activeStart = null;
					lastSupport = null;
					supportVotes = 0.0;
					gapDistance = 0.0;
				}
			}

			previousPoint = point;
			if (x == endX && y == endY) break;
			var doubledError = error * 2;
			if (doubledError > -dy) {
				error -= dy;
				x += stepX;
			}
			if (doubledError < dx) {
				error += dx;
				y += stepY;
			}
		}

		pushProbabilisticSegment(segments, activeStart, lastSupport, supportVotes, candidate, candidateVotes, options, segmentThreshold);
	}

	/**
		Stores one supported run if it satisfies length and vote thresholds.
	**/
	static function pushProbabilisticSegment(segments:Array<ProbabilisticSegment>, start:Point2D, end:Point2D, supportVotes:Float, candidate:Ray2D, candidateVotes:Float, options:ProbabilisticHoughLineOptions, segmentThreshold:Float):Void {
		if (start == null || end == null) return;
		var line = new Line2D(start, end);
		if (line.length <= 0 || line.length < options.minLineLength || supportVotes < segmentThreshold) return;
		segments.push({
			line: line,
			supportVotes: supportVotes,
			candidateVotes: candidateVotes,
			candidateRho: candidate.rho,
			candidateTheta: candidate.theta
		});
	}

	/**
		Merges colinear fragments that belong to the same underlying candidate line.
	**/
	static function mergeProbabilisticSegments(segments:Array<ProbabilisticSegment>, options:ProbabilisticHoughLineOptions):Array<Line2D> {
		var merged:Array<ProbabilisticSegment> = [];
		for (segment in segments) {
			var matched = false;
			for (existing in merged) {
				if (!probabilisticSegmentsShouldMerge(existing, segment, options)) continue;
				existing.line = longestSpan(existing.line, segment.line);
				existing.supportVotes = Math.max(existing.supportVotes, segment.supportVotes);
				existing.candidateVotes = Math.max(existing.candidateVotes, segment.candidateVotes);
				matched = true;
				break;
			}
			if (!matched) merged.push(segment);
		}
		merged.sort(compareProbabilisticSegments);
		return [for (segment in merged) segment.line];
	}

	/**
		Returns whether two extracted segments are the same physical line and close enough to merge.
	**/
	static function probabilisticSegmentsShouldMerge(lhs:ProbabilisticSegment, rhs:ProbabilisticSegment, options:ProbabilisticHoughLineOptions):Bool {
		var anglePadding = Math.max(options.thetaResolution * 2, Math.PI / 90);
		var rhoPadding = Math.max(options.rhoResolution * 2, 0.75);
		if (angleDifference(lhs.candidateTheta, rhs.candidateTheta) > anglePadding) return false;
		if (Math.abs(lhs.candidateRho - rhs.candidateRho) > rhoPadding) return false;

		var reference = lhs.line.length >= rhs.line.length ? lhs.line : rhs.line;
		if (reference.length <= 0) return false;
		var axisX = (reference.end.x - reference.start.x) / reference.length;
		var axisY = (reference.end.y - reference.start.y) / reference.length;
		var origin = reference.start;

		for (point in [lhs.line.start, lhs.line.end, rhs.line.start, rhs.line.end]) {
			var offset = Math.abs((point.x - origin.x) * -axisY + (point.y - origin.y) * axisX);
			if (offset > 0.500001) return false;
		}

		var lhsStart = projectionOnAxis(lhs.line.start, origin, axisX, axisY);
		var lhsEnd = projectionOnAxis(lhs.line.end, origin, axisX, axisY);
		var rhsStart = projectionOnAxis(rhs.line.start, origin, axisX, axisY);
		var rhsEnd = projectionOnAxis(rhs.line.end, origin, axisX, axisY);
		var lhsMin = Math.min(lhsStart, lhsEnd);
		var lhsMax = Math.max(lhsStart, lhsEnd);
		var rhsMin = Math.min(rhsStart, rhsEnd);
		var rhsMax = Math.max(rhsStart, rhsEnd);
		var gap = lhsMax < rhsMin ? rhsMin - lhsMax : (rhsMax < lhsMin ? lhsMin - rhsMax : 0.0);
		return gap <= Math.max(1.0, options.maxLineGap + 1.0);
	}

	/**
		Builds the smallest segment that covers both input segments when they are colinear.
	**/
	static function longestSpan(lhs:Line2D, rhs:Line2D):Line2D {
		var reference = lhs.length >= rhs.length ? lhs : rhs;
		if (reference.length <= 0) return lhs;
		var axisX = (reference.end.x - reference.start.x) / reference.length;
		var axisY = (reference.end.y - reference.start.y) / reference.length;
		var origin = reference.start;
		var minProjection = projectionOnAxis(lhs.start, origin, axisX, axisY);
		var maxProjection = minProjection;
		for (point in [lhs.end, rhs.start, rhs.end]) {
			var projection = projectionOnAxis(point, origin, axisX, axisY);
			if (projection < minProjection) minProjection = projection;
			if (projection > maxProjection) maxProjection = projection;
		}
		return new Line2D(
			new Point2D(origin.x + axisX * minProjection, origin.y + axisY * minProjection),
			new Point2D(origin.x + axisX * maxProjection, origin.y + axisY * maxProjection)
		);
	}

	/**
		For one radius, fills a center accumulator and reads circle candidates from its peaks.
	**/
	static function accumulateCircleCandidates(source:Image, edgeImage:Image, minRadius:Int, maxRadius:Int, scale:Float, options:HoughCircleOptions, usePerimeterFallback:Bool):Array<HoughCircleCandidate> {
		var accumulatorWidth = Std.int(Math.ceil(source.width / scale));
		var accumulatorHeight = Std.int(Math.ceil(source.height / scale));
		if (accumulatorWidth <= 0 || accumulatorHeight <= 0) return [];

		var candidates:Array<HoughCircleCandidate> = [];
		var threshold = options.centerThreshold > 0 ? options.centerThreshold : 1;
		for (radius in minRadius...maxRadius + 1) {
			var accumulator = new Matrix2D(accumulatorWidth, accumulatorHeight);
			accumulator.fill(0);
			voteCircleCentersFromEdges(source, edgeImage, accumulator, radius, scale, usePerimeterFallback);

			for (x in 0...accumulatorWidth) {
				for (y in 0...accumulatorHeight) {
					var votes = accumulator.get(x, y);
					if (votes < threshold || !isAccumulatorPeak(accumulator, x, y, votes)) continue;
					var centerX = x * scale;
					var centerY = y * scale;
					if (!circleHasEdgeSupport(edgeImage, centerX, centerY, radius, options)) continue;
					candidates.push({circle: new Circle2D(new Point2D(centerX, centerY), radius), votes: votes});
				}
			}
		}
		return candidates;
	}

	/**
		Grayscales circle-detection input and optionally median-filters noise before edge extraction.
	**/
	static function grayscaleCircleInput(image:Image, options:HoughCircleOptions):Image {
		var cannyObject:CannyObject = image.clone().removeView();
		cannyObject = cannyObject.grayscale();
		if (options.blurRadius > 0) {
			var blurred = Vision.medianBlur(cast cannyObject, options.blurRadius * 2 + 1);
			if (imageHasEdges(blurred)) cannyObject = cast blurred;
		}
		return cast cannyObject;
	}

	/**
		Runs the internal Canny-style edge pipeline used by circle detection.
	**/
	static function extractCircleEdgeMap(image:Image, options:HoughCircleOptions):Image {
		var cannyObject:CannyObject = image.clone().removeView();
		cannyObject = cannyObject.applySobelFilters();
		cannyObject = cannyObject.nonMaxSuppression();
		cannyObject = cannyObject.applyHysteresis(normalizeCannyThreshold(options.cannyHighThreshold), normalizeCannyThreshold(options.cannyLowThreshold));
		return cast cannyObject;
	}

	/**
		For each edge pixel, votes for circle centers that could explain that edge at `radius`.

		When `usePerimeterFallback` is false, votes follow the edge gradient direction.
		When true, or when the gradient is too weak, every center on the perimeter is voted.
	**/
	static function voteCircleCentersFromEdges(source:Image, edgeImage:Image, accumulator:Matrix2D, radius:Int, scale:Float, usePerimeterFallback:Bool):Void {
		for (x in 0...edgeImage.width) {
			for (y in 0...edgeImage.height) {
				if (!isEdgePixel(edgeImage.getPixel(x, y))) continue;

				if (usePerimeterFallback) {
					voteCircleCentersOnPerimeter(accumulator, x, y, radius, scale);
					continue;
				}

				var gradientX = source.getSafePixel(x + 1, y).red - source.getSafePixel(x - 1, y).red;
				var gradientY = source.getSafePixel(x, y + 1).red - source.getSafePixel(x, y - 1).red;
				var length = Math.sqrt(gradientX * gradientX + gradientY * gradientY);
				if (length <= 0.0001) {
					voteCircleCentersOnPerimeter(accumulator, x, y, radius, scale);
					continue;
				}

				var directionX = gradientX / length;
				var directionY = gradientY / length;
				incrementCenterVote(accumulator, x - directionX * radius, y - directionY * radius, scale);
				incrementCenterVote(accumulator, x + directionX * radius, y + directionY * radius, scale);
			}
		}
	}

	/**
		Fallback center voting: sample centers on the full circle perimeter around an edge pixel.

		Used when gradient direction is unavailable or the first pass found no circles.
	**/
	static function voteCircleCentersOnPerimeter(accumulator:Matrix2D, edgeX:Int, edgeY:Int, radius:Int, scale:Float):Void {
		var sampleCount = Std.int(Math.max(72, Math.ceil(Math.PI * 2 * Math.max(radius, 1))));
		for (sampleIndex in 0...sampleCount) {
			var angle = (sampleIndex / sampleCount) * Math.PI * 2;
			incrementCenterVote(accumulator, edgeX - Math.cos(angle) * radius, edgeY - Math.sin(angle) * radius, scale);
		}
	}

	/**
		Checks that enough edge pixels exist on the candidate circle perimeter.
	**/
	static function circleHasEdgeSupport(edgeImage:Image, centerX:Float, centerY:Float, radius:Int, options:HoughCircleOptions):Bool {
		var visited = new StringMap<Bool>();
		var support = 0;
		var sampleCount = Std.int(Math.max(72, Math.ceil(Math.PI * 2 * Math.max(radius, 1))));
		var supportThreshold = Math.max(options.centerThreshold, radius * 2);
		for (sampleIndex in 0...sampleCount) {
			var angle = (sampleIndex / sampleCount) * Math.PI * 2;
			var sampleX = Std.int(Math.round(centerX + Math.cos(angle) * radius));
			var sampleY = Std.int(Math.round(centerY + Math.sin(angle) * radius));
			if (sampleX < 0 || sampleX >= edgeImage.width || sampleY < 0 || sampleY >= edgeImage.height) continue;
			var key = sampleX + ':' + sampleY;
			if (visited.exists(key)) continue;
			visited.set(key, true);
			if (isEdgePixel(edgeImage.getPixel(sampleX, sampleY))) support++;
		}
		return support >= supportThreshold;
	}

	/**
		Keeps the strongest non-overlapping circles after accumulator peak extraction.
	**/
	static function suppressCircleDuplicates(candidates:Array<HoughCircleCandidate>, minimumDistance:Float):Array<HoughCircleCandidate> {
		var accepted:Array<HoughCircleCandidate> = [];
		for (candidate in candidates) {
			var duplicate = false;
			for (existing in accepted) {
				var distance = candidate.circle.center.distanceTo(existing.circle.center);
				if (distance <= 1.0 && Math.abs(candidate.circle.radius - existing.circle.radius) <= 1.0) {
					duplicate = true;
					break;
				}
				if (minimumDistance > 0 && distance < minimumDistance) {
					duplicate = true;
					break;
				}
			}
			if (!duplicate) accepted.push(candidate);
		}
		return accepted;
	}

	/** Converts a pixel to an edge vote (binary or intensity-weighted). **/
	static inline function edgeVoteWeight(color:Color, useWeights:Bool):Float {
		var intensity = Math.max(color.red, Math.max(color.green, color.blue));
		if (intensity <= 0) return 0;
		return useWeights ? intensity / 255 : 1.0;
	}

	/** Maps a continuous rho value to a clamped accumulator column index. **/
	static inline function rhoBinIndex(rho:Float, minRho:Float, resolution:Float, rhoBins:Int):Int {
		var index = Std.int(Math.floor(((rho - minRho) / resolution) + 0.000001));
		if (index < 0) return 0;
		return index >= rhoBins ? rhoBins - 1 : index;
	}

	/**
		True when the bin is a strict local maximum, with deterministic tie-breaking.
	**/
	static function isAccumulatorPeak(accumulator:Matrix2D, x:Int, y:Int, votes:Float):Bool {
		for (neighborX in x - 1...x + 2) {
			if (neighborX < 0 || neighborX >= accumulator.width) continue;
			for (neighborY in y - 1...y + 2) {
				if (neighborY < 0 || neighborY >= accumulator.height) continue;
				if (neighborX == x && neighborY == y) continue;
				var neighborVotes = accumulator.get(neighborX, neighborY);
				if (neighborVotes > votes) return false;
				if (neighborVotes == votes && (neighborX < x || (neighborX == x && neighborY < y))) return false;
			}
		}
		return true;
	}

	/** Sorts line candidates by votes, then theta, then rho. **/
	static function compareLineCandidates(lhs:HoughLineCandidate, rhs:HoughLineCandidate):Int {
		if (lhs.votes != rhs.votes) return lhs.votes > rhs.votes ? -1 : 1;
		if (lhs.ray.theta != rhs.ray.theta) return lhs.ray.theta < rhs.ray.theta ? -1 : 1;
		return lhs.ray.rho < rhs.ray.rho ? -1 : (lhs.ray.rho > rhs.ray.rho ? 1 : 0);
	}

	/** Sorts circle candidates by votes, then radius, then center position. **/
	static function compareCircleCandidates(lhs:HoughCircleCandidate, rhs:HoughCircleCandidate):Int {
		if (lhs.votes != rhs.votes) return lhs.votes > rhs.votes ? -1 : 1;
		if (lhs.circle.radius != rhs.circle.radius) return lhs.circle.radius > rhs.circle.radius ? -1 : 1;
		if (lhs.circle.center.y != rhs.circle.center.y) return lhs.circle.center.y < rhs.circle.center.y ? -1 : 1;
		return lhs.circle.center.x < rhs.circle.center.x ? -1 : (lhs.circle.center.x > rhs.circle.center.x ? 1 : 0);
	}

	/** Sorts extracted segments by support votes, candidate strength, and geometry. **/
	static function compareProbabilisticSegments(lhs:ProbabilisticSegment, rhs:ProbabilisticSegment):Int {
		if (lhs.supportVotes != rhs.supportVotes) return lhs.supportVotes > rhs.supportVotes ? -1 : 1;
		if (lhs.candidateVotes != rhs.candidateVotes) return lhs.candidateVotes > rhs.candidateVotes ? -1 : 1;
		if (lhs.line.length != rhs.line.length) return lhs.line.length > rhs.line.length ? -1 : 1;
		if (lhs.line.start.y != rhs.line.start.y) return lhs.line.start.y < rhs.line.start.y ? -1 : 1;
		return lhs.line.start.x < rhs.line.start.x ? -1 : (lhs.line.start.x > rhs.line.start.x ? 1 : 0);
	}

	/** Scalar projection of a point onto a unit axis through `origin`. **/
	static inline function projectionOnAxis(point:Point2D, origin:Point2D, axisX:Float, axisY:Float):Float {
		return (point.x - origin.x) * axisX + (point.y - origin.y) * axisY;
	}

	/** Smallest angular distance between two theta values in `[0, pi/2]`. **/
	static function angleDifference(lhs:Float, rhs:Float):Float {
		var diff = Math.abs(lhs - rhs);
		return diff > Math.PI / 2 ? Math.PI - diff : diff;
	}

	/** Quick scan for any non-black pixel (used before expensive circle passes). **/
	static function imageHasEdges(image:Image):Bool {
		var found = false;
		image.forEachPixel((x, y, color) -> {
			if (!found && isEdgePixel(color)) found = true;
		});
		return found;
	}

	/** Adds one vote to the downscaled center accumulator at the given image-space center. **/
	static inline function incrementCenterVote(accumulator:Matrix2D, centerX:Float, centerY:Float, scale:Float):Void {
		var x = Std.int(Math.round(centerX / scale));
		var y = Std.int(Math.round(centerY / scale));
		if (x < 0 || x >= accumulator.width || y < 0 || y >= accumulator.height) return;
		accumulator.set(x, y, accumulator.get(x, y) + 1);
	}

	/** True when any channel is non-zero (binary edge map convention). **/
	static inline function isEdgePixel(color:Color):Bool {
		return color.red > 0 || color.green > 0 || color.blue > 0;
	}

	/** Normalizes Canny thresholds to `[0, 1]` whether passed as 0–1 or 0–255. **/
	static inline function normalizeCannyThreshold(value:Float):Float {
		if (value <= 0) return 0;
		var normalized = value > 1 ? value / 255 : value;
		return normalized > 1 ? 1 : normalized;
	}
}
