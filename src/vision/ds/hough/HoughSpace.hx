package vision.ds.hough;

@:structInit
class HoughSpace {
    
    /**
        The Hough space is a 2D array of ints.
        the accumulator is that array.
    **/
    public var accumulator(default, null):Array<Array<Int>>;

    /**
        This isn't really the acculator, but its used to visualize the Hough space.
        the reason this and the accumulator are separate is because the accumulator's value
        is more "predictable" - represented as Ints and not colors.
    **/
    public var image(default, null):Image;

    public function new(accumulator:Array<Array<Int>>, image:Image) {
        this.accumulator = accumulator;
        this.image = image;
    }
}