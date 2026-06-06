package vision.ds.harris;

import vision.ds.IntPoint2D;

/**
	A corner peak still carrying its Harris response score for ranking and spacing filters.
**/
typedef HarrisCornerCandidate = {
	var point:IntPoint2D;
	var score:Float;
}