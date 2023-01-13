package;

import vision.ds.Image;
import vision.tools.ImageTools;
import vision.ds.Color;

using vision.Vision;

class Test_vision_Vision_skew {
  public static function main() {
    {
    var start:Float = 0, end:Float = 0, sum:Float = 0, best:Float = Math.POSITIVE_INFINITY, worst:Float = 0;
        var attempts = 2;
      var angles:Array<Float> = [90, -90.62, 50]; // more values
      var angler:Float = 90;
        vision.tools.ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png", function(image)
        {
            for (i in 0...attempts)
            {
              /*#if sys
              #else
              vision.tools.ImageTools.addToScreen(image, 50, 50);
              #end*/
              angler = angles[i];
                start = haxe.Timer.stamp();
                image.skew(angler/*, true*/);
                end = haxe.Timer.stamp();
                if (end - start > worst) worst = end - start;
                if (end - start < best) best = end - start;
                sum += end - start;
              printImage(image);
            }
            trace("----------vision.Vision.skewImage()----------");
            trace("attempts: " + attempts);
            trace("worst: " + worst);
            trace("best: " + best);
            trace("average: " + sum / attempts);
            trace("------------------------------------------");
        });
    }
    //trace('-----------------------------');
    {
    var start:Float = 0, end:Float = 0, sum:Float = 0, best:Float = Math.POSITIVE_INFINITY, worst:Float = 0;
        var attempts = 2;
      var angles:Array<Float> = [90, -90.62, 50]; // more values
      var angler:Float = 90;
        vision.tools.ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png", function(image)
        {
            for (i in 0...attempts)
            {
              /*#if sys
              #else
              vision.tools.ImageTools.addToScreen(image, 50, 50);
              #end*/
              angler = angles[i];
                start = haxe.Timer.stamp();
                image.skewFloat(angler);
                end = haxe.Timer.stamp();
                if (end - start > worst) worst = end - start;
                if (end - start < best) best = end - start;
                sum += end - start;
		//printAll(image, 3, angler);
              printImage(image);
            }
            trace("----------vision.Vision.skewFloatImage()----------");
            trace("attempts: " + attempts);
            trace("worst: " + worst);
            trace("best: " + best);
            trace("average: " + sum / attempts);
            trace("------------------------------------------");
        });
    }
	  {
    var start:Float = 0, end:Float = 0, sum:Float = 0, best:Float = Math.POSITIVE_INFINITY, worst:Float = 0;
        var attempts = 2;
      var angles:Array<Float> = [90, -90.62, 50]; // more values
      var angler:Float = 90;
        vision.tools.ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png", function(image)
        {
            for (i in 0...attempts)
            {
              /*#if sys
              #else
              vision.tools.ImageTools.addToScreen(image, 50, 50);
              #end*/
              angler = angles[i];
                start = haxe.Timer.stamp();
		ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Reduced_Speed_Blank.svg/192px-Reduced_Speed_Blank.svg.png", function(second) {
			image.stampSkewed(Std.int(image.width / 2), Std.int(image.height / 2), second, angler);
		});
                end = haxe.Timer.stamp();
                if (end - start > worst) worst = end - start;
                if (end - start < best) best = end - start;
                sum += end - start;
		printAll(image, 4, angler);
              printImage(image);
            }
            trace("----------vision.Vision.stampSkewedImage()----------");
            trace("attempts: " + attempts);
            trace("worst: " + worst);
            trace("best: " + best);
            trace("average: " + sum / attempts);
            trace("------------------------------------------");
        });
	  }
  }
  static function printImage(i) { 
    trace('passed!');
  }
	static function printAll(image:Image, max:Int = 3, angler:Float) {
		var ee:Int = 0;
		image.forEachRotatedFloatingPixelInView(function(x:Float, y:Float, color:Color) {
			    if((ee % max) == 0)
				    trace('pixel ($x, $y, ${color.toString()})');
			    ee += 1;
		    }, angler);
	}
}
