package vision.ds.hough;

@:structInit
class HoughSpace {
	/**
		The Hough space is a 2D array of `Int`.
		The accumulator is that array.
	**/
	public var accumulator(default, null):HoughAccumulator;

	/**
		This isn't really the accumulator, but it is used to visualize the Hough space.
		the reason this and the accumulator are separate is because the accumulator's value
		is more "predictable" - represented as `Int` and not colors.
	**/
	public var image(default, null):Image;

	/**
		The "maximums" of the Hough space:

		when a certain point in the accumulator is greater than a given value,
		the point is considered a maximum, and the value is added to the maximums array.
	**/
	public var maximums:Array<IntPoint2D>;

	/**
		The rays detected from the accumulator.

		Those are defined only when using the ~~`getHoughSpaceWithRays`~~ method.

		@see ~~getHoughSpaceWithRays()~~
	**/
	public var rays:Array<Ray2D>;

	public function new(accumulator:HoughAccumulator, image:Image) {
		this.accumulator = accumulator;
		this.image = image;
	}
}
