package vision.ds.specifics;

/**
    Importance order of different color channels when using morphology functions (dilation/erosion)
**/
enum abstract ColorImportanceOrder(Int) to Int to Color {

    /**
        When using erosion/dilation, channel importance follows:

        1. Red
        1. Green
        1. Blue
    **/
    var RedGreenBlue = 0xFFFFFEFD;

    /**
        When using erosion/dilation, channel importance follows:

        1. Green
        1. Blue
        1. Red
    **/
    var GreenBlueRed = 0xFFFDFFFE;

    /**
        When using erosion/dilation, channel importance follows:

        1. Blue
        1. Red
        1. Green
    **/
    var BlueRedGreen = 0xFFFEFDFF;
    
    /**
        When using erosion/dilation, channel importance follows:

        1. Blue
        1. Green
        1. Red
    **/
    var BlueGreenRed = 0xFFFDFEFF;

    /**
        When using erosion/dilation, channel importance follows:

        1. Red
        1. Blue
        1. Green
    **/
    var RedBlueGreen = 0xFFFFFDFE;

    /**
        When using erosion/dilation, channel importance follows:

        1. Green
        1. Red
        1. Blue
    **/
    var GreenRedBlue = 0xFFFEFFFD;
}