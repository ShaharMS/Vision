package;

class Test_vision_Vision_barrelDistortion
{
    public static function main()
    {
        var start:Float = 0, end:Float = 0, sum:Float = 0, best:Float = Math.POSITIVE_INFINITY, worst:Float = 0;
        var attempts = 5;
        vision.tools.ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png", function(image)
        {
            for (i in 0...attempts)
            {
                start = haxe.Timer.stamp();
                vision.Vision.barrelDistortion(image);
                end = haxe.Timer.stamp();
                if (end - start > worst) worst = end - start;
                if (end - start < best) best = end - start;
                sum += end - start;
            }
            trace("----------vision.Vision.barrelDistortion()----------");
            trace("attempts: " + attempts);
            trace("worst: " + worst);
            trace("best: " + best);
            trace("average: " + sum / attempts);
            trace("----------------------------------------------------");
        });
    }
}
        
        