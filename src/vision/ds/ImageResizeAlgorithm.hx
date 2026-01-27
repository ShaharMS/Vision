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
	    Bilinear Interpolation. The most reliable method for general resizing purposes. Yields the "least lossless" result.
	**/
	var BilinearInterpolation;
	/**
	    Bicubic Interpolation. Higher quality resizing, typically slower than bilinear.
	**/
	var BicubicInterpolation;
	/**
	    Catmull-Rom Interpolation. A sharper bicubic variant.
	**/
	var CatmullRomInterpolation;
	/**
	    Mitchell-Netravali Interpolation. Balanced sharpness with fewer ringing artifacts.
	**/
	var MitchellNetravaliInterpolation;
	/**
	    Lanczos Interpolation. High-quality windowed-sinc resampling.
	**/
	var LanczosInterpolation;
}
