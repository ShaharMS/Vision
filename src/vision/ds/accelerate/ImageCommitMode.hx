package vision.ds.accelerate;

/** Determines whether a batch returns a separate image or updates its source. **/
enum ImageCommitMode {
	/** Return a separate image while preserving the source. **/
	NewImage;
	/** Update the source storage. The result must have the original dimensions. **/
	InPlace;
}
