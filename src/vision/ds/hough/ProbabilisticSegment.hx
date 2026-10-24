package vision.ds.hough;

import vision.ds.Line2D;

/**
	An extracted line segment plus the accumulator metadata used to merge colinear fragments.
**/
typedef ProbabilisticSegment = {
	var line:Line2D;
	var supportVotes:Float;
	var candidateVotes:Float;
	var candidateRho:Float;
	var candidateTheta:Float;
}