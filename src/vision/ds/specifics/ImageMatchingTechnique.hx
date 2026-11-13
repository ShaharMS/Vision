package vision.ds.specifics;

/** Selects how `Vision.find()` evaluates candidate positions and scores matches. **/
enum abstract ImageMatchingTechnique(Int) {
	/** Reports only identical RGBA regions, each with a score of 1. **/
	var Exact;
	/** Reports similarity as one minus the mean absolute RGBA difference divided by 255. **/
	var ColorDifference;
	/**
		Reports zero-normalized RGB correlation mapped from [-1, 1] to [0, 1].
		Fully transparent template pixels are skipped. Flat patches use color difference.
	**/
	var NormalizedCorrelation;
}
