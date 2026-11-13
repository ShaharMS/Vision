package vision.ds.specifics;

/** The palette quantization method used by `Vision.dither()`. **/
enum abstract DitheringAlgorithm(Int) {
	/** Diffuses RGB quantization error to nearby pixels in left-to-right row order. **/
	var FloydSteinberg;
	/** Applies a repeating 4 by 4 Bayer threshold to each RGB channel. **/
	var Bayer;
}
