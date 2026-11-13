package vision.ds;

/** A template match returned by `Vision.find()`. **/
@:structInit
class ImageMatch {
	/** The rectangle covered by the template in source image coordinates. **/
	public final bounds:Rectangle;
	/** Match quality between 0 and 1, with 1 being the highest. **/
	public final score:Float;
}
