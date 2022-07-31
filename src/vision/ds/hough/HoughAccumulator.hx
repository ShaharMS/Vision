package vision.ds.hough;

import haxe.ds.Map;
import haxe.ds.BalancedTree;

/**
    Used for the accumulator array of the hough transform.

    values should be accessed using:
    ```haxe
    accumulator.get(rho)[0] //thetaIndex;
    accumulator.get(rho)[1] //value;
    accumulator.set(rho, [thetaIndex, value]);
    ```
**/
typedef HoughAccumulator = Map<Array<Float>, Int>