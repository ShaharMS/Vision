package vision.ds.specifics;

enum abstract ImageExpansionMode(Int) {
	/**
		Does not change image size.
	**/
	var SAME_SIZE;
	/**
		Expands the image when the transformation matrix pushes pixels out of bounds.
	**/
	var EXPAND;
	/**
		Shrinks the image when the transformation matrix does not reach image bounds
	**/
	var SHRINK;
	/**
		A combination of `EXPAND` and `SHRINK`, Changes image size when the 
		transformation matrix pushes pixels out of bounds, or does not reach them.
	**/
	var RESIZE;
}