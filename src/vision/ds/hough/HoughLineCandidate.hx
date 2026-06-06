package vision.ds.hough;

import vision.ds.Ray2D;

/**
	A detected line in `(rho, theta)` space before public results are stripped to `Ray2D`.
**/
typedef HoughLineCandidate = {
	var ray:Ray2D;
	var votes:Float;
}