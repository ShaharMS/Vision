package;

import vision.ds.Image;
import vision.tools.ImageTools;

using vision.Vision;

class Test_vision_Vision_skew {
  public static function main() {
    var start:Float = 0, end:Float = 0, sum:Float = 0, best:Float = Math.POSITIVE_INFINITY, worst:Float = 0;
        var attempts = 2;
        vision.tools.ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png", function(image)
        {
            for (i in 0...attempts)
            {
              /*#if sys
              #else
              vision.tools.ImageTools.addToScreen(image, 50, 50);
              #end*/
                start = haxe.Timer.stamp();
                image.skew(90);
                end = haxe.Timer.stamp();
                if (end - start > worst) worst = end - start;
                if (end - start < best) best = end - start;
                sum += end - start;
            }
            trace("----------vision.Vision.skewImage()----------");
            trace("attempts: " + attempts);
            trace("worst: " + worst);
            trace("best: " + best);
            trace("average: " + sum / attempts);
            trace("------------------------------------------");
        });
  }
}
