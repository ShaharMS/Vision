package vision.ds.specifics;

@:structInit
class PointTransformationPair {
    
    public var from:Point2D;
    public var to:Point2D;

    public function new(from:Point2D, to:Point2D) {
        this.from = from;
        this.to = to;
    }
}