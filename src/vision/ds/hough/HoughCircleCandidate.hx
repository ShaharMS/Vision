package vision.ds.hough;

import vision.ds.Circle2D;

/**
	A detected circle still carrying accumulator votes for ranking and duplicate suppression.
**/
typedef HoughCircleCandidate = {
	var circle:Circle2D;
	var votes:Float;
}