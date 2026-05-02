package vision.ds.specifics;

@:structInit
class HoughLineOptions {
	public var rhoResolution:Float = 1;
	public var thetaResolution:Float = Math.PI / 180;
	public var voteThreshold:Int = 100;
	public var minTheta:Float = 0;
	public var maxTheta:Float = Math.PI;
	public var useEdgeValueWeights:Bool = false;

	public function new() {}
}