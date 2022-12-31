package vision.algorithms;

import vision.ds.Point2D;
import vision.ds.Ray2D;
import vision.ds.Array2D;
import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools.*;
using vision.tools.MathTools;
class Hough {
    public static function generateHoughSpace(image:Image):Array2D<Int> {
        final maxRho = floor(distanceBetweenPoints({x: 0, y: 0}, {x: image.width, y: image.height}));
        final maxThetaIndex = 360; //calculating using radians is impossible, since array indices are integers.
        var accumulator = new Array2D<Int>(maxThetaIndex, maxRho);
        trace(maxThetaIndex, maxRho);


        var calcLine = new Ray2D({x: 0, y: 0}, null, 0);
        image.forEachPixel((x, y, color) -> {
            if (color.red != 255) return;
            calcLine.point.x = x;
            calcLine.point.y = y;
            for (deg in 0...maxThetaIndex) {
                calcLine.degrees = deg;
                final rho = abs(distanceFromPointToRay2D({x: 0, y: 0}, calcLine));
                var thetaIndex = new Point2D(0, 0).degreesFromPointToPoint2D(getClosestPointOnRay2D({x: 0, y: 0}, calcLine));
                if (thetaIndex < 0) thetaIndex = 360 + thetaIndex;
                final val = accumulator.get(Std.int(thetaIndex), Std.int(rho));
                accumulator.set(Std.int(thetaIndex), Std.int(rho), (val == null ? 0 : val) + 1);
            }
        });

        return accumulator;
    }

    public static function extractLocalMaximas(space:Array2D<Int>):Array2D<Int> {
        for (x in 0...space.width) {
            for (y in 0...space.height) {
                final value = space.get(x, y);
                final neighbors = [space.get(x-1, y-1), space.get(x+0, y-1), space.get(x+1, y-1),
                                   space.get(x-1, 0), space.get(x+1, 0),
                                   space.get(x-1, y+1), space.get(x+0, y+1), space.get(x+1, y+1)];
                for (i in 0...neighbors.length) {
                    if (neighbors[i] > value) {
                        space.set(x, y, 0);
                    }
                    // else {
                    //     switch i {
                    //         case 0: space.set(x - 1, y - 1, 0);
                    //         case 1: space.set(x - 1, y, 0);
                    //         case 2: space.set(x - 1, y + 1, 0);
                    //         case 3: space.set(x, y - 1, 0);
                    //         case 4: space.set(x, y + 1, 0);
                    //         case 5: space.set(x + 1, y - 1, 0);
                    //         case 6: space.set(x + 1, y, 0);
                    //         case 7: space.set(x + 1, y + 1, 0);
                    //     }
                    // }
                }
            }
        }
        return space;
    }

    public static function houghSpaceToImage(space:Array2D<Int>) {
        var image = new Image(space.width, space.height);
        image.forEachPixel((x, y, color) -> {
            image.setPixel(x, y, space.get(x, y) * 1000);
        });
        return image;
    }
}