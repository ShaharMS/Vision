package vision.ds.hough;

/**
    Used for the accumulator array of the hough transform.

    valuse should be accessed using:
    ```haxe
    accumulator[theta][rho] = value;
    ```
**/
typedef HoughAccumulator = Array<Array<Int>>;