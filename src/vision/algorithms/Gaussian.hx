package vision.algorithms;

class Gaussian {
    
    public static function create5x5Kernal(sigma:Float):Array<Array<Float>> {
        var r, s = 2.0 * sigma * sigma;
        var kernal:Array<Array<Float>> = [[],[],[],[],[],[]];
        // sum is for normalization
        var sum = 0.0;
        
        // generating 5x5 kernel
        for (x in -2...3) {
            for (y in -2...3) {
                r = Math.sqrt(x * x + y * y);
                kernal[x + 2][y + 2] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
                sum += kernal[x + 2][y + 2];
            }
        }
    
        // normalising the Kernel
        for (i in 0...5) {
            for (j in 0...5) {
                kernal[i][j] /= sum;
            }
        }
        return kernal;
    }

}