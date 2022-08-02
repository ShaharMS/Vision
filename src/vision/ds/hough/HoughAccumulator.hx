package vision.ds.hough;

import haxe.ds.Map;
import haxe.ds.BalancedTree;

/**
    Used for the accumulator array of the hough transform.
**/
typedef HoughAccumulator = Array<Array<Int>>