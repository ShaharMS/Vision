package vision.ds.specifics;

@:structInit
class ProbabilisticHoughLineOptions extends HoughLineOptions {
	public var candidateThreshold:Int = 100;
	public var minLineLength:Float = 0;
	public var maxLineGap:Float = 0;

	public function new() {
		super();
	}
}