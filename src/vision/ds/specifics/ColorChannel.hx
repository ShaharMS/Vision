package vision.ds.specifics;

enum abstract ColorChannel(Int) {
    
    /**
    	The red channel in the RGB color model.

        When used as a color filter, produces a grayscale image where 
        the red channel determines the brightness of a pixel.
    **/
    var RED = 0xFF0000;

    /**
    	The green channel in the RGB color model.

        When used as a color filter, produces a grayscale image where 
        the green channel determines the brightness of a pixel.
    **/
    var GREEN = 0x00FF00;

    /**
    	The blue channel in the RGB color model.

        When used as a color filter, produces a grayscale image where 
        the blue channel determines the brightness of a pixel.
    **/
    var BLUE = 0x0000FF;

    /**
    	The alpha channel in the ARGB color model.

        When used as a color filter, produces a grayscale image where 
        the more transparent the pixel, the brighter it is.
    **/
    var ALPHA = 0xFF000000;

    /**
    	The cyan channel in the CYMK color model.

        When used as a color filter, produces a grayscale image where 
        the cyan channel determines the brightness of a pixel.
    **/
    var CYAN = 0x00FFFF;

    /**
        The magenta channel in the CYMK color model.

        When used as a color filter, produces a grayscale image where
        the magenta channel determines the brightness of a pixel.
    **/
    var MAGENTA = 0xFF00FF;

    /**
        The yellow channel in the CYMK color model.

        When used as a color filter, produces a grayscale image where
        the yellow channel determines the brightness of a pixel.
    **/
    var YELLOW = 0xFFFF00;

    /**
    	The degree of hue in the HSV color model.

        When used as a color filter, produces a colorful image where the
        saturation and value channels are ignored.
    **/
    var HUE = 1;

    /**
    	The saturation channel in the HSV color model.

        When used as a color filter, produces a grayscale image where
        the saturation amount determines the brightness of a pixel.
    **/
    var SATURATION = 2;

    /**
    	The brightness (aka value) channel in the HSV color model.

        When used as a color filter, produces a grayscale image where
        the brightness amount reflects in the lightness of a pixel.
    **/
    var BRIGHTNESS = 3;
}