package vision.ds.hough;

/**
	An edge sample used while voting in the line accumulator.
**/
typedef HoughVotePoint = {
	var x:Float;
	var y:Float;
	var vote:Float;
}