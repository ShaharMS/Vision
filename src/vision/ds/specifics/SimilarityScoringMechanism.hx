package vision.ds.specifics;

enum abstract SimilarityScoringMechanism(Int) to Int { 
    var HIGHEST_COLOR_DIFFERENCE;
    var AVERAGE_COLOR_DIFFERENCE;
    var SUM_BASELINE_OVERSHOOTS;
}