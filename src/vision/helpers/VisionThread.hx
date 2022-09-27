package vision.helpers;

import vision.exceptions.MultithreadFaliure;
import format.png.Reader;
import js.lib.Promise;
#if js
class VisionThread {

    static var COUNT:Int = 0;

    var thread:Promise<Dynamic>;
    var onFailed:Dynamic -> Void;
    var onDone:Void -> Void;
    var count:Int;
    function new(job:Void -> Void) {

        count = COUNT++;
        onFailed = (d:Dynamic) -> {
            throw new MultithreadFaliure(count, d);
        };
        onDone = () -> {trace("done");};
        thread =  new Promise((onDone, onFailed) -> job());
    }

    public static function create(job:Void -> Void) {
        new VisionThread(job);
    }
}
#else
typedef VisionThread = sys.thread.Thread;
#end