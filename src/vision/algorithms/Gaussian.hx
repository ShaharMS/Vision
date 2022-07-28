package vision.algorithms;

import vision.exceptions.InvalidGaussianKernalSize;

class Gaussian {

    public static function create1x1Kernal(sigma:Float):Array<Array<Float>> {
        return [[1]];
    }
    
    public static function create3x3Kernal(sigma:Float):Array<Array<Float>> {
        var r, s = 2.0 * sigma * sigma;
        var kernal:Array<Array<Float>> = [[],[],[],[]];
        // sum is for normalization
        var sum = 0.0;
        
        // generating 3x3 kernel
        for (x in -1...2) {
            for (y in -1...2) {
                r = Math.sqrt(x * x + y * y);
                kernal[x + 1][y + 1] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
                sum += kernal[x + 1][y + 1];
            }
        }
    
        // normalising the Kernel
        for (i in 0...3) {
            for (j in 0...3) {
                kernal[i][j] /= sum;
            }
        }
        return kernal;
    }

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

    public static function create7x7Kernal(sigma:Float):Array<Array<Float>> {
        var r, s = 2.0 * sigma * sigma;
        var kernal:Array<Array<Float>> = [[],[],[],[],[],[],[],[]];
        // sum is for normalization
        var sum = 0.0;
        
        // generating 7x7 kernel
        for (x in -3...4) {
            for (y in -3...4) {
                r = Math.sqrt(x * x + y * y);
                kernal[x + 3][y + 3] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
                sum += kernal[x + 3][y + 3];
            }
        }
    
        // normalising the Kernel
        for (i in 0...7) {
            for (j in 0...7) {
                kernal[i][j] /= sum;
            }
        }
        return kernal;
    }

    public static function create9x9Kernal(sigma:Float):Array<Array<Float>> {
        var r, s = 2.0 * sigma * sigma;
        var kernal:Array<Array<Float>> = [[],[],[],[],[],[],[],[],[],[]];
        // sum is for normalization
        var sum = 0.0;
        
        // generating 9x9 kernel
        for (x in -4...5) {
            for (y in -4...5) {
                r = Math.sqrt(x * x + y * y);
                kernal[x + 4][y + 4] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
                sum += kernal[x + 4][y + 4];
            }
        }
    
        // normalising the Kernel
        for (i in 0...9) {
            for (j in 0...9) {
                kernal[i][j] /= sum;
            }
        }
        return kernal;
    }

    public static function createKernalOfSize(size:Int, sigma:Float) {
        if (size % 2 == 0) throw new InvalidGaussianKernalSize(size);
        var r, s = 2.0 * sigma * sigma, sum = 0.;
        var kernal:Array<Array<Float>> = [];
        for (i in 0...size) {
            kernal[i] = [];
        }
        //get the average of the parameter size, rounded down
        var avg = Std.int((size - 1) / 2);

        //generate the kernal
        for (x in -avg...avg + 1) {
            for (y in -avg...avg + 1) {
                r = Math.sqrt(x * x + y * y);
                kernal[x + avg][y + avg] = (Math.exp(-(r * r) / s)) / (Math.PI * s);
                sum += kernal[x + avg][y + avg];
            }
        }

        //normalise the kernal
        for (i in 0...size) {
            for (j in 0...size) {
                kernal[i][j] /= sum;
            }
        }

        return kernal;
    }

}