package vision.ds.accelerate;

@:noCompletion
enum abstract ImageOperation(Int) to Int {
	var Invert = 1;
	var SimpleGrayscale = 2;
	var BlackAndWhite = 3;
	var Grayscale = 4;
}
