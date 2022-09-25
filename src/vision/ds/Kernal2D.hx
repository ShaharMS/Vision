package vision.ds;

import vision.ds.gaussian.GaussianKernalSize;

enum Kernal2D {

    /**
     * This kernal preserves the image's pixel data.
     * 
     * ```
     * 0  0  0
     * 0  1  0
     * 0  0  0
     * ```
     * 
     * Original:
     * 
     * ![Pre-processed](https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png)
     * 
     * Convolved:
     * 
     * ![Post-processed](https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png)
     */
    Identity;

    /**
     * This kernal applies a nearest-neighbor style blurring to the image.
     * 
     * ```
     * 1  1  1
     * 1  1  1
     * 1  1  1
     * ```
     * 
     * Original:
     * 
     * ![Pre-processed](https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png)
     * 
     * Convolved:
     * 
     * ![Post-processed](https://upload.wikimedia.org/wikipedia/commons/0/04/Vd-Blur2.png)
     */
    BoxBlur;

    /**
     * This kernal is often used to detect changes of surface level in an image.
     * 
     * For a more aggresive kernal, see `RidgeDetectionAggresive`
     * 
     * ```
     * -1  -1  -1
     * -1  +4  -1
     * -1  -1  -1
     * ```
     *
     * Original:
     * 
     * ![Pre-processed](https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png)
     * 
     * Convolved:
     * 
     * ![Post-processed](https://upload.wikimedia.org/wikipedia/commons/2/20/Vd-Rige1.png)
     */
    RidgeDetection;

    /**
     * This kernal is often used to detect changes of surface level in an image.
     * 
     * This kernal is more sensitive to surface changes than its softer counterpart.
     * 
     * ```
     * -1  -1  -1
     * -1  +7  -1
     * -1  -1  -1
     * ```
     *
     * Original:
     * 
     * ![Pre-processed](https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png)
     * 
     * Convolved:
     * 
     * ![Post-processed](https://upload.wikimedia.org/wikipedia/commons/0/0b/Vd-Rige2.png)
     */
    RidgeDetectionAggresive;


     /**
     * This kernal is often used to sharpen, or "deepfry" an image. It boldens 
     * the change in pixel values where colors in the image change dramatically
     * from one pixel to the other.
     * 
     * ```
     * +0  -1  +0
     * -1  +5  -1
     * +0  -1  +0
     * ``` 
     * Original:
     * 
     * ![Pre-processed](https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png)
     * 
     * Convolved:
     * 
     * ![Post-processed](https://upload.wikimedia.org/wikipedia/commons/4/4e/Vd-Sharp.png)
     */
    Sharpen;

     /**
     * Based on the `Gaussian Blur`, this kernal doesnt actually blur the image, but
     * uses a similar filter to slightly sharpen the image, while retaining the image's
     * quality.
     * 
     * ```
     * 1  4  6   4  1
     * 4 16  24  16 4
     * 6 24 -476 24 6
     * 4 16  24  16 4
     * 1  4  6   4  1
     * ```
     * 
     * Original:
     * 
     * ![Pre-processed](https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png)
     * 
     * Convolved:
     * 
     * ![Post-processed](https://upload.wikimedia.org/wikipedia/commons/e/ef/Vd-Unsharp_5x5.png)
     */
    UnsharpMasking;

    /**
     * Makes a 3x3 kernal, following this structure:
     * 
     * |     |   1    |   2    |   3    |
     * |:---:| :---:  | :---:  | :---:  |
     * |  1  |`corner`|` edge `|`corner`|
     * |  2  |` edge` |`center`|` edge `|
     * |  3  |`corner`|` edge `|`corner`|
     * 
     * 
     */
    Assemble3x3(corner:Float, edge:Float, center:Float);

    /**
     * Makes a 5x5 kernal, following this structure:
     * 
     * |     |     1     |     2     |    3    |     4     |     5     |
     * |:---:|   :---:   |   :---:   |  :---:  |   :---:   |   :---:   |
     * |  1  |`farCorner`|`farEdge`  |`edge`   |`farEdge`  |`farCorner`|
     * |&nbsp;||||||
     * |  2  |`farEdge`  |`midCorner`|`midEdge`|`midCorner`|`farEdge`  |
     * |&nbsp;||||||
     * |  3  |`edge`     |`midEdge`  |`center` |`midEdge`  |`edge`     |
     * |&nbsp;||||||
     * |  4  |`farEdge`  |`midCorner`|`midEdge`|`midCorner`|`farEdge`  |
     * |&nbsp;||||||
     * |  5  |`farCorner`|`farEdge`  |`edge`   |`farEdge`  |`farCorner`|
     * 
     * 
     */
    Assemble5x5(farCorner:Float, farEdge:Float, edge:Float, midCorner:Float, midEdge:Float, center:Float);

    /**
     * make a kernal without any special tools.
     * 
     * Usage:
     * 
     *      Custom([
     *          [0, 1, 0],
     *          [0, 1, 0],
     *          [0, 1, 0],
     *      ])
     */
    Custom(kernal:Array<Array<Float>>);

    /**
     * Generates a gaussian kernal of size `size`x`size`, and uses `sigma` for the distribtion factor.
     * 
     * Example of an (approximated) 5x5 gaussian kernal:
     * 
     * ```
     * 1  4  6  4  1
     * 4 16  24 16 4
     * 6 24  36 24 6
     * 4 16  24 16 4
     * 1  4  6  4  1
     * ```
     * 
     * Original:
     * 
     * ![Pre-Processed](https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png)
     * 
     * `GaussianBlur(X3, 1)`, `GaussianBlur(X5, 1)`:
     * 
     * ![Post-Processed](https://upload.wikimedia.org/wikipedia/commons/2/28/Vd-Blur1.png)&nbsp;,&nbsp;![Post-Processed](https://upload.wikimedia.org/wikipedia/commons/0/04/Vd-Blur_Gaussian_5x5.png)
     */
    GaussianBlur(size:GaussianKernalSize, sigma:Float);

}