package vision.ds;

enum abstract ImageResizeAlgorithm(Int) from Int to Int {
	var NearestNeighbor;
	var BilinearInterpolation;
	var BicubicInterpolation;
}
