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
        final maxRho = 2 * floor(sqrt(image.width * image.width + image.height * image.height));
        final maxThetaIndex = 360; //calculating using radians is impossible, since array indices are integers.
        var accumulator = new Array2D<Int>(maxThetaIndex, maxRho);

        var calcLine = new Ray2D({x: 0, y: 0}, null, 0);
        image.forEachPixel((x, y, color) -> {
            if (color.red != 255) return;
            calcLine.point.x = x;
            calcLine.point.y = y;
            for (deg in 0...maxThetaIndex) {
                calcLine.degrees = deg;
                final rho = distanceFromPointToRay2D({x: 0, y: 0}, calcLine);
                if (rho < 0 || rho > maxRho)  trace(rho, x, y);
                var thetaIndex = new Point2D(0, 0).degreesFromPointToPoint2D(getClosestPointOnRay2D({x: 0, y: 0}, calcLine));
                if (thetaIndex < 0) thetaIndex = 360 + thetaIndex;
                #if (!target.static) 
                if (accumulator.get(Std.int(thetaIndex), Std.int(rho)) == null) 
                    accumulator.set(Std.int(thetaIndex), Std.int(rho) + maxRho, 1);
                else #end 
                    accumulator.set(Std.int(thetaIndex), Std.int(rho) + maxRho, accumulator.get(Std.int(thetaIndex), Std.int(rho)) + 1);
            }
        });

        return accumulator;
    }

    public static function houghSpaceToImage(space:Array2D<Int>) {
        var image = new Image(space.width, space.height);
        image.forEachPixel((x, y, color) -> {
            image.setPixel(x, y, space.get(x, y) * 1000);
        });
        return image;
    }
}