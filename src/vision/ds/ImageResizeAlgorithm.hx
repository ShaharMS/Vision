package vision.ds;

/**
    The resize algorithm to use when changing the size of images.
**/
enum abstract ImageResizeAlgorithm(Int) from Int to Int {
	/**
	    Nearest-Neighbor resizing. Works best for pixel art/resizing by powers of 2.
	**/
	var NearestNeighbor;
	/**
	    Bilinear Interpolation. The most reliable method for general resizing purposes. yields the "least lossless" result.
	**/
	var BilinearInterpolation;
	/**
	    Unimplemented.
	**/
	var BicubicInterpolation;
}
