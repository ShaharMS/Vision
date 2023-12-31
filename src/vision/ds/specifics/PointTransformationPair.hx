package vision.ds.specifics;

@:structInit
class PointTransformationPair {
    
    var from:IntPoint2D;
    var to:IntPoint2D;

    public function new(from:IntPoint2D, to:IntPoint2D) {
        this.from = from;
        this.to = to;
    }
}