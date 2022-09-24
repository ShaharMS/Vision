package vision.ds.hough;

/**
    Used for the accumulator array of the hough transform.

    ranges should follow this format:

    - ρ: from `-d` to `d`
    - θ: from `0` to `180`

    (ρ - rho, θ - theta)

    the underlying array will be accesed with `array[rho][theta]`
**/
abstract HoughAccumulator(Array<Array<Int>>) from Array<Array<Int>> to Array<Array<Int>> {
    
    public var rhoMax(get, never):Int;
    
    function get_rhoMax():Int {
        return Std.int(this.length / 2);
    }

    public function new(maxRho:Int) {
        this = [];
        var arrayOfZeros = [for (i in 0...180) 0]; 

        for (i in 0...maxRho * 2) {
            this[i] = arrayOfZeros.copy();
        }
    }

    /**
     * Increments the value of the cell located in `rho`,`theta`.
     * 
     * The `theta` value is not actually the floating value in radians, but the `index` of `theta`.
     */
    public function incrementCell(rho:Float, thetaIndex:Int) {
        this[Std.int(rho) + rhoMax][thetaIndex]++;
    }

    /**
     * Decrements the value of the cell located in `rho`,`theta`.
     * 
     * The `theta` value is not actually the floating value in radians, but the `index` of `theta`.
     */
     public function decrementCell(rho:Float, thetaIndex:Int) {
        this[Std.int(rho) + rhoMax][thetaIndex]--;
    }

    /**
     * Setss the value of the cell located in `rho`,`theta`.
     * 
     * The `theta` value is not actually the floating value in radians, but the `index` of `theta`.
     */
    public function setCell(rho:Float, thetaIndex:Int, value:Int) {
        this[Std.int(rho) + rhoMax][thetaIndex] = value;
    }

    /**
     * Retireves the positions of all the cell containing a value greater than `threshold`.
     * 
     * @param threshold the minimun value of a cell to be considered a maximim, and thus reported.
     * @return an array of `IntPoint2D`s, containing the locations of the cells. `point.x` is `rho`, `point.y` is the theta's index.
     */
    public function getMaximas(threshold:Int):Array<IntPoint2D> {
        var pointArray:Array<IntPoint2D> = [];
        for (x in 0...this.length) {
            for (y in 0...this[x].length) {
                if (this[x][y] >= threshold) pointArray.push(new IntPoint2D(x - rhoMax, y));
            }
        }
        return pointArray;
    }

    public function cellIterator(?threshold:Int = 0) {
        return getMaximas(threshold).iterator();
    }
}