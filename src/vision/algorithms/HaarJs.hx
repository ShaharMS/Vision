package vision.algorithms;

import haxe.extern.EitherType;
import vision.ds.Image;
import vision.ds.ByteArray;
import vision.ds.ArrayAccessVector;
import vision.ds.haar.Feature;
import haxe.ds.Vector;
import haxe.io.UInt8Array;
import haxe.io.Float32Array;

/**
*
* HAAR.js Feature Detection Library based on Viola-Jones / Lienhart et al. Haar Detection algorithm
* modified port of jViolaJones for Java (http://code.google.com/p/jviolajones/) and OpenCV for C++ (https://github.com/opencv/opencv) to JavaScript
*
* https://github.com/foo123/HAAR.js
* @version: @@VERSION@@
*
* Supports parallel "map-reduce" computation both in browser and node using parallel.js library
* https://github.com/adambom/parallel.js (included)
*
**/

// the export object
var HAAR = { VERSION: "@@VERSION@@" };
var Detector:Dynamic;
var Feature:Dynamic;
var proto:String = 'prototype';
var undef = null;

typedef Array32F = Float32Array;
typedef Array8U = UInt8Array;
var Abs = Math.abs;
var Max = Math.max;
var Min = Math.min;
var Floor = Math.floor;
var Round = Math.round;
var Sqrt = Math.sqrt;
var Slice = [].slice;

//
// Private methods for detection
//

// compute grayscale image, integral image (SAT) and squares image (Viola-Jones)
function integralImage(im:ByteArray, w, h/*, selection*/)
{
    var imLen=im.length, count=w*h
        , sum, sum2, i, j, k, y, g
        , gray = new Array8U(count)
        // Viola-Jones
        , integral = new Array32F(count), squares = new Array32F(count)
        // Lienhart et al. extension using tilted features
        , tilted = new Array32F(count)
    ;

    // first row
    j=0; i=0; sum=sum2=0;
    while (j<w)
    {
        // use fixed-point gray-scale transform, close to openCV transform
        // https://github.com/mtschirs/js-objectdetect/issues/3
        // 0,29901123046875  0,58697509765625  0,114013671875 with roundoff
        g = ((4899 * im[i] + 9617 * im[i + 1] + 1868 * im[i + 2]) + 8192) >>> 14;

        g &= 255;
        sum += g;
        sum2 += /*(*/(g*g); //&0xFFFFFFFF) >>> 0;

        // SAT(-1, y) = SAT(x, -1) = SAT(-1, -1) = 0
        // SAT(x, y) = SAT(x, y-1) + SAT(x-1, y) + I(x, y) - SAT(x-1, y-1)  <-- integral image

        // RSAT(-1, y) = RSAT(x, -1) = RSAT(x, -2) = RSAT(-1, -1) = RSAT(-1, -2) = 0
        // RSAT(x, y) = RSAT(x-1, y-1) + RSAT(x+1, y-1) - RSAT(x, y-2) + I(x, y) + I(x, y-1)    <-- rotated(tilted) integral image at 45deg
        gray[j] = g;
        integral[j] = sum;
        squares[j] = sum2;
        tilted[j] = g;

        j++; i+=4;
    }
    // other rows
    k=0; y=1; j=w; i=(w<<2); sum=sum2=0;
    while (i<imLen)
    {
        // use fixed-point gray-scale transform, close to openCV transform
        // https://github.com/mtschirs/js-objectdetect/issues/3
        // 0,29901123046875  0,58697509765625  0,114013671875 with roundoff
        g = ((4899 * im[i] + 9617 * im[i + 1] + 1868 * im[i + 2]) + 8192) >>> 14;

        g &= 255;
        sum += g;
        sum2 += /*(*/(g*g); //&0xFFFFFFFF) >>> 0;

        // SAT(-1, y) = SAT(x, -1) = SAT(-1, -1) = 0
        // SAT(x, y) = SAT(x, y-1) + SAT(x-1, y) + I(x, y) - SAT(x-1, y-1)  <-- integral image

        // RSAT(-1, y) = RSAT(x, -1) = RSAT(x, -2) = RSAT(-1, -1) = RSAT(-1, -2) = 0
        // RSAT(x, y) = RSAT(x-1, y-1) + RSAT(x+1, y-1) - RSAT(x, y-2) + I(x, y) + I(x, y-1)    <-- rotated(tilted) integral image at 45deg
        gray[j] = g;
        integral[j] = integral[j-w] + sum;
        squares[j] = squares[j-w] + sum2;
        tilted[j] = tilted[j+1-w] + (g + gray[j-w]) + ((y>1) ? tilted[j-w-w] : 0) + ((k>0) ? tilted[j-1-w] : 0);

        k++; j++; i+=4; if (k>=w) { k=0; y++; sum=sum2=0; }
    }

    return {gray:gray, integral:integral, squares:squares, tilted:tilted};
}

// compute Canny edges on gray-scale image to speed up detection if possible
function integralCanny(gray, w, h)
{
    var i, j, k, sum:Float, grad_x, grad_y,
        ind0, ind1, ind2, ind_1, ind_2, count=gray.length,
        lowpass = new Array8U(count), canny = new Array32F(count)
    ;

    // first, second rows, last, second-to-last rows
    for (i in 0...w)
    {
        lowpass[i]=0;
        lowpass[i+w]=0;
        lowpass[i+count-w]=0;
        lowpass[i+count-w-w]=0;

        canny[i]=0;
        canny[i+count-w]=0;
    }
    // first, second columns, last, second-to-last columns
    var k = 0;
    for (j in 0...h) {
        lowpass[0+k]=0;
        lowpass[1+k]=0;
        lowpass[w-1+k]=0;
        lowpass[w-2+k]=0;

        canny[0+k]=0;
        canny[w-1+k]=0;

        k += w;
    }
    // gauss lowpass
    for (i in 2...w-2)
    {
        sum=0;
        k = w << 1 - w; //subtract w to start the for loop correctly
        for (j in 2...h - 2)
        {
            k += w;
            ind0 = i+k;
            ind1 = ind0+w;
            ind2 = ind1+w;
            ind_1 = ind0-w;
            ind_2 = ind_1-w;

            // use as simple fixed-point arithmetic as possible (only addition/subtraction and binary shifts)
            // http://stackoverflow.com/questions/11703599/unsigned-32-bit-integers-in-javascript
            // http://stackoverflow.com/questions/6232939/is-there-a-way-to-correctly-multiply-two-32-bit-integers-in-javascript/6422061#6422061
            // http://stackoverflow.com/questions/6798111/bitwise-operations-on-32-bit-unsigned-ints
            // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#%3E%3E%3E_%28Zero-fill_right_shift%29
            sum = /*(*/(0
                    + (gray[ind_2-2] << 1) + (gray[ind_1-2] << 2) + (gray[ind0-2] << 2) + (gray[ind0-2])
                    + (gray[ind1-2] << 2) + (gray[ind2-2] << 1) + (gray[ind_2-1] << 2) + (gray[ind_1-1] << 3)
                    + (gray[ind_1-1]) + (gray[ind0-1] << 4) - (gray[ind0-1] << 2) + (gray[ind1-1] << 3)
                    + (gray[ind1-1]) + (gray[ind2-1] << 2) + (gray[ind_2] << 2) + (gray[ind_2]) + (gray[ind_1] << 4)
                    - (gray[ind_1] << 2) + (gray[ind0] << 4) - (gray[ind0]) + (gray[ind1] << 4) - (gray[ind1] << 2)
                    + (gray[ind2] << 2) + (gray[ind2]) + (gray[ind_2+1] << 2) + (gray[ind_1+1] << 3) + (gray[ind_1+1])
                    + (gray[ind0+1] << 4) - (gray[ind0+1] << 2) + (gray[ind1+1] << 3) + (gray[ind1+1]) + (gray[ind2+1] << 2)
                    + (gray[ind_2+2] << 1) + (gray[ind_1+2] << 2) + (gray[ind0+2] << 2) + (gray[ind0+2])
                    + (gray[ind1+2] << 2) + (gray[ind2+2] << 1)
                    );// &0xFFFFFFFF ) >>> 0;

            lowpass[ind0] = (((Std.int(103*sum + 8192)&0xFFFFFFFF) >>> 14)&0xFF) >>> 0;
        }
    }

    // sobel gradient
    for (i in 1...w - 1)
    {
        //sum=0;
        var k = 0;
        for (j in 1...h-1)
        {
            k += w;
            // compute coords using simple add/subtract arithmetic (faster)
            ind0=k+i;
            ind1=ind0+w;
            ind_1=ind0-w;

            grad_x = ((0
                    - lowpass[ind_1-1]
                    + lowpass[ind_1+1]
                    - lowpass[ind0-1] - lowpass[ind0-1]
                    + lowpass[ind0+1] + lowpass[ind0+1]
                    - lowpass[ind1-1]
                    + lowpass[ind1+1]
                    ))//&0xFFFFFFFF
                    ;
            grad_y = ((0
                    + lowpass[ind_1-1]
                    + lowpass[ind_1] + lowpass[ind_1]
                    + lowpass[ind_1+1]
                    - lowpass[ind1-1]
                    - lowpass[ind1] - lowpass[ind1]
                    - lowpass[ind1+1]
                    ))//&0xFFFFFFFF
                    ;

            //sum += (Abs(grad_x) + Abs(grad_y))&0xFFFFFFFF;
            canny[ind0] = ( Abs(grad_x) + Abs(grad_y) );//&0xFFFFFFFF;
       }
    }

    // integral canny
    // first row
    i=0; sum=0.;
    while (i<w)
    {
        sum += canny[i];
        canny[i] = sum;//&0xFFFFFFFF;
        i++;
    }
    // other rows
    i=w; k=0; sum=0;
    while (i<count)
    {
        sum += canny[i];
        canny[i] = (canny[i-w] + sum);//&0xFFFFFFFF;
        i++; k++; if (k>=w) { k=0; sum=0; }
    }

    return canny;
}

// merge the detected features if needed
function groupRectangles(rects:Array<Feature>, min_neighbors, epsilon)
{
    var rlen = rects.length, ref = new ArrayAccessVector(rlen), feats:Array<Dynamic> = [],
        nb_classes = 0, neighbors, r, found = false, i, j, n, t, ri:Int;
    for(i in 0...rlen) ref[i] = 0;
    for(i in 0...rlen)
    {
        found = false;
        for (j in 0...i)
        {
            if (rects[j].equals(rects[i], epsilon))
            {
                found = true;
                ref[i] = ref[j];
            }
        }

        if (! found)
        {
            ref[i] = nb_classes;
            nb_classes++;
        }
    }

    // merge neighbor classes
    neighbors = new Vector(nb_classes);  r = new ArrayAccessVector<Feature>(nb_classes);
    for(i in 0...nb_classes) { neighbors[i] = 0;  r[i] = ({} : Feature); }
    for(i in 0...rlen) { ri=ref[i]; neighbors[ri]++; r[ri].add(rects[i]); }
    for(i in 0...nb_classes)
    {
        n = neighbors[i];
        if (n >= min_neighbors)
        {
            t=1/(n + n);
            var rri = {
                x: t*(r[i].x * 2 + n),          y: t*(r[i].y * 2 + n),
                width: t*(r[i].width * 2 + n),  height: t*(r[i].height * 2 + n)
            };

            feats.push(rri);
        }
    }

    // filter inside rectangles
    rlen = feats.length;
    for(i in 0...rlen)
    {
        for (j in i+1...rlen)
        {
            if (!feats[i].isInside && feats[i].inside(feats[j])) { feats[i].isInside=true; }
            else if (!feats[j].isInside && feats[j].inside(feats[i])) { feats[j].isInside=true; }
        }
    }
    i = rlen;
    while(--i >= 0)
    {
        if (feats[i].isInside)
        {
            feats.splice(i, 1);
        }
    }

    return feats;
}

// area used as compare func for sorting
function byArea(a, b) { return b.area-a.area; }

// serial index used as compare func for sorting
function byOrder(a, b) { return a.index-b.index; }

/*
splice subarray (not used)
http://stackoverflow.com/questions/1348178/a-better-way-to-splice-an-array-into-an-array-in-javascript
Array.prototype.splice.apply(d[0], [prev, 0].concat(d[1]));
*/

// used for parallel "reduce" computation
function mergeSteps(d:Array<Array<Feature>>)
{
    // concat and sort according to serial ordering
    if (d[1].length != 0) {
        var temp = d[0].concat(d[1]);
        temp.sort(byOrder);
        d[0]=temp;
    }
    return d[0];
}

// used for parallel, asynchronous and/or synchronous computation
function detectSingleStep(self)
{
    var Sqrt = Math.sqrt, ret = [],
        haar = self.haardata, haar_stages = haar.stages, scaledSelection = self.scaledSelection,
        w = self.width, h = self.height,
        selw = scaledSelection.width, selh = scaledSelection.height, imArea=w*h, imArea1=imArea-1,
        sizex = haar.size1, sizey = haar.size2, xstep, ystep, xsize, ysize,
        startx = scaledSelection.x, starty = scaledSelection.y, startty,
        x, y, ty, tyw, tys, sl = haar_stages.length,
        p0, p1, p2, p3, xl, yl, s, t,
        bx1, bx2, by1, by2,
        swh, inv_area, total_x, total_x2, vnorm,
        edges_density, pass, cL = self.cannyLow, cH = self.cannyHigh,

        stage, threshold, trees, tl,
        canny = self.canny, integral = self.integral, squares = self.squares, tilted = self.tilted,
        t, cur_node_ind, where, features, feature, rects, nb_rects, thresholdf,
        rect_sum, kr, r, x1, y1, x2, y2, x3, y3, x4, y4, rw, rh, yw, yh, sum,
        scale = self.scale, increment = self.increment, index = self.i != null ? self.i : 0, doCanny = self.doCannyPruning

    ;

    bx1=0; bx2=w-1; by1=0; by2=imArea-w;

    xsize = ~~(scale * sizex);
    xstep = ~~(xsize * increment);
    ysize = ~~(scale * sizey);
    ystep = ~~(ysize * increment);
    //ysize = xsize; ystep = xstep;
    tyw = ysize*w;
    tys = ystep*w;
    startty = starty*tys;
    xl = selw-xsize;
    yl = selh-ysize;
    swh = xsize*ysize;
    inv_area = 1.0/swh;

    var y = starty - ystep;
    var ty = startty - tys;
    while (y < yl)
    {
        y += ystep;
        ty += tys;
        var x = startx - xstep;
        while (x < xl)
        {
            x += xstep;
            p0 = x-1 + ty-w;    p1 = p0 + xsize;
            p2 = p0 + tyw;    p3 = p2 + xsize;

            // clamp
            p0 = (p0<0) ? 0 : (p0>imArea1) ? imArea1 : p0;
            p1 = (p1<0) ? 0 : (p1>imArea1) ? imArea1 : p1;
            p2 = (p2<0) ? 0 : (p2>imArea1) ? imArea1 : p2;
            p3 = (p3<0) ? 0 : (p3>imArea1) ? imArea1 : p3;

            if (doCanny)
            {
                // avoid overflow
                edges_density = inv_area * (canny[p3] - canny[p2] - canny[p1] + canny[p0]);
                if (edges_density < cL || edges_density > cH) continue;
            }

            // pre-compute some values for speed

            // avoid overflow
            total_x = inv_area * (integral[p3] - integral[p2] - integral[p1] + integral[p0]);
            // avoid overflow
            total_x2 = inv_area * (squares[p3] - squares[p2] - squares[p1] + squares[p0]);

            vnorm = total_x2 - total_x * total_x;
            vnorm = (vnorm > 1) ? Sqrt(vnorm) : /*vnorm*/  1 ;

            pass = true;
            for (s in 0...sl)
            {
                // Viola-Jones HAAR-Stage evaluator
                stage = haar_stages[s];
                threshold = stage.thres;
                trees = stage.trees; tl = trees.length;
                sum=0;

                for (t in 0...tl)
                {
                    //
                    // inline the tree and leaf evaluators to avoid function calls per-loop (faster)
                    //

                    // Viola-Jones HAAR-Tree evaluator
                    features = trees[t].feats;
                    cur_node_ind = 0;
                    while (true)
                    {
                        feature = features[cur_node_ind];

                        // Viola-Jones HAAR-Leaf evaluator
                        rects = feature.rects;
                        nb_rects = rects.length;
                        thresholdf = feature.thres;
                        rect_sum = 0;

                        if (feature.tilt)
                        {
                            // tilted rectangle feature, Lienhart et al. extension
                            for (kr in 0...nb_rects)
                            {
                                r = rects[kr];

                                // this produces better/larger features, possible rounding effects??
                                x1 = x + ~~(scale * r[0]);
                                y1 = (y-1 + ~~(scale * r[1])) * w;
                                x2 = x + ~~(scale * (r[0] + r[2]));
                                y2 = (y-1 + ~~(scale * (r[1] + r[2]))) * w;
                                x3 = x + ~~(scale * (r[0] - r[3]));
                                y3 = (y-1 + ~~(scale * (r[1] + r[3]))) * w;
                                x4 = x + ~~(scale * (r[0] + r[2] - r[3]));
                                y4 = (y-1 + ~~(scale * (r[1] + r[2] + r[3]))) * w;

                                // clamp
                                x1 = (x1<bx1) ? bx1 : (x1>bx2) ? bx2 : x1;
                                x2 = (x2<bx1) ? bx1 : (x2>bx2) ? bx2 : x2;
                                x3 = (x3<bx1) ? bx1 : (x3>bx2) ? bx2 : x3;
                                x4 = (x4<bx1) ? bx1 : (x4>bx2) ? bx2 : x4;
                                y1 = (y1<by1) ? by1 : (y1>by2) ? by2 : y1;
                                y2 = (y2<by1) ? by1 : (y2>by2) ? by2 : y2;
                                y3 = (y3<by1) ? by1 : (y3>by2) ? by2 : y3;
                                y4 = (y4<by1) ? by1 : (y4>by2) ? by2 : y4;

                                // RSAT(x-h+w, y+w+h-1) + RSAT(x, y-1) - RSAT(x-h, y+h-1) - RSAT(x+w, y+w-1)
                                //        x4     y4            x1  y1          x3   y3            x2   y2
                                rect_sum+= r[4] * (tilted[x4 + y4] - tilted[x3 + y3] - tilted[x2 + y2] + tilted[x1 + y1]);
                            }
                        }
                        else
                        {
                            // orthogonal rectangle feature, Viola-Jones original
                            for (kr in 0...nb_rects)
                            {
                                r = rects[kr];

                                // this produces better/larger features, possible rounding effects??
                                x1 = x-1 + ~~(scale * r[0]);
                                x2 = x-1 + ~~(scale * (r[0] + r[2]));
                                y1 = (w) * (y-1 + ~~(scale * r[1]));
                                y2 = (w) * (y-1 + ~~(scale * (r[1] + r[3])));

                                // clamp
                                x1 = (x1<bx1) ? bx1 : (x1>bx2) ? bx2 : x1;
                                x2 = (x2<bx1) ? bx1 : (x2>bx2) ? bx2 : x2;
                                y1 = (y1<by1) ? by1 : (y1>by2) ? by2 : y1;
                                y2 = (y2<by1) ? by1 : (y2>by2) ? by2 : y2;

                                // SAT(x-1, y-1) + SAT(x+w-1, y+h-1) - SAT(x-1, y+h-1) - SAT(x+w-1, y-1)
                                //      x1   y1         x2      y2          x1   y1            x2    y1
                                rect_sum+= r[4] * (integral[x2 + y2]  - integral[x1 + y2] - integral[x2 + y1] + integral[x1 + y1]);
                            }
                        }

                        where = (rect_sum * inv_area < thresholdf * vnorm) ? 0 : 1;
                        // END Viola-Jones HAAR-Leaf evaluator

                        if (where != 0)
                        {
                            if (feature.has_r) { sum += feature.r_val; break; }
                            else { cur_node_ind = feature.r_node; }
                        }
                        else
                        {
                            if (feature.has_l) { sum += feature.l_val; break; }
                            else { cur_node_ind = feature.l_node; }
                        }
                    }
                    // END Viola-Jones HAAR-Tree evaluator

                }
                pass = (sum > threshold) ? true : false;
                // END Viola-Jones HAAR-Stage evaluator

                if (!pass) break;
            }

            if (pass)
            {
                ret.push({
                    index: index,
                    x: x, y: y,
                    width: xsize,  height: ysize
                });
            }
        }
    }

    // return any features found in this step
    return ret;
}

// called when detection ends, calls user-defined callback if any
function detectEnd(self, rects:Array<Feature>, withOnComplete)
{
    var n, ratio;
    for (i in 0...rects.length) rects[i] = new Feature(rects[i]);
    self.objects = groupRectangles(rects, self.min_neighbors, self.epsilon);
    ratio = 1.0 / self.Ratio;
    for (i in 0...self.objects.length) self.objects[i].scale(ratio).round().computeArea();
    // sort according to size
    // (a deterministic way to present results under different cases)
    self.objects.sort(byArea);
    self.Ready = true;
    if (withOnComplete && self.onComplete != null) self.onComplete(self);
}


/**[DOC_MARKDOWN]
*
* #### Detector Methods
*
[/DOC_MARKDOWN]**/

//
//
//
// HAAR Detector Class (with the haar cascade data)
/**[DOC_MARKDOWN]
* __constructor(haardata, Parallel)__
* ```javascript
* new detector(haardata, Parallel);
* ```
*
* __Explanation of parameters__
*
* * _haardata_ : The actual haardata (as generated by haartojs tool), this is specific per feature, openCV haar data can be used.
* * _Parallel_ : Optional, this is the _Parallel_ object, as returned by the _parallel.js_ script (included). It enables HAAR.js to run parallel computations both in browser and node (can be much faster)
[/DOC_MARKDOWN]**/

var Detector = {

    constructor: function(haardata, Parallel) {
        var self = Detector;
        self.haardata = haardata || null;
        self.Ready = false;
        self.doCannyPruning = false;
        self.Canvas = null;
        self.Selection = null;
        self.scaledSelection = null;
        self.objects = null;
        self.TimeInterval = null;
        self.DetectInterval = 30;
        self.Ratio = 0.5;
        self.cannyLow = 20;
        self.cannyHigh = 100;
        self.Parallel= Parallel || null;
        self.onComplete = null;
    },

    haardata: null,
    Canvas: null,
    objects: null,

    Selection: null,
    scaledSelection: null,
    Ratio: 0.5,
    origWidth: 0,
    origHeight: 0,
    width: 0,
    height: 0,

    DetectInterval: 30,
    TimeInterval: null,

    doCannyPruning: false,
    cannyLow: 20,
    cannyHigh: 100,
    canny: null,

    integral: null,
    squares: null,
    tilted: null,

    Parallel: null,
    Ready: false,
    onComplete: null,

    /**[DOC_MARKDOWN]
    * __dispose()__
    * ```javascript
    * detector.dispose();
    * ```
    *
    * Disposes the detector and clears space of data cached
    [/DOC_MARKDOWN]**/
    dispose: function() {
        var self = this;
        if ( self.DetectInterval ) clearTimeout( self.DetectInterval );
        self.DetectInterval = null;
        self.TimeInterval = null;
        self.haardata = null;
        self.Canvas = null;
        self.objects = null;
        self.Selection = null;
        self.scaledSelection = null;
        self.Ratio = null;
        self.origWidth = null;
        self.origHeight = null;
        self.width = null;
        self.height = null;
        self.doCannyPruning = null;
        self.cannyLow = null;
        self.cannyHigh = null;
        self.canny = null;
        self.integral = null;
        self.squares = null;
        self.tilted = null;
        self.Parallel = null;
        self.Ready = null;
        self.onComplete = null;
        return self;
    },

    // clear the image and detector data
    // reload the image to re-compute the needed image data (.image method)
    // and re-set the detector haar data (.cascade method)
    /**[DOC_MARKDOWN]
    * __clearCache()__
    * ```javascript
    * detector.clearCache();
    * ```
    *
    * Clear any cached image data and haardata in case space is an issue. Use image method and cascade method (see below) to re-set image and haar data
    [/DOC_MARKDOWN]**/
    clearCache: function() {
        var self = Detector;
        self.haardata = null;
        self.canny = null;
        self.integral = null;
        self.squares = null;
        self.tilted = null;
        self.Selection = null;
        self.scaledSelection = null;
        return self;
    },

    // set haardata, use same detector with cached data, to detect different feature
    /**[DOC_MARKDOWN]
    * __cascade(haardata)__
    * ```javascript
    * detector.cascade(haardata);
    * ```
    *
    * Allow to use same detector (with its cached image data), to detect different feature on same image, by using another cascade. This way any image pre-processing is done only once
    *
    * __Explanation of parameters__
    *
    * * _haardata_ : The actual haardata (as generated by haartojs tool), this is specific per feature, openCV haar data can be used.
    [/DOC_MARKDOWN]**/
    cascade: function(haardata) {
        Detector.haardata = haardata || null;
        return Detector;
    },

    // set haardata, use same detector with cached data, to detect different feature
    /**[DOC_MARKDOWN]
    * __parallel(Parallel)__
    * ```javascript
    * detector.paralell(Parallel | false);
    * ```
    *
    * Enable/disable parallel processing (passing the Parallel Object or null/false)
    *
    * __Explanation of parameters__
    *
    * * _Parallel_ : The actual Parallel object used in parallel.js (included)
    [/DOC_MARKDOWN]**/
    parallel: function(Parallel) {
        Detector.Parallel = Parallel || null;
        return Detector;
    },

    // set image for detector along with scaling (and an optional canvas, eg for node)
    /**[DOC_MARKDOWN]
    * __image(ImageOrVideoOrCanvas, scale, CanvasClass)__
    * ```javascript
    * detector.image(ImageOrVideoOrCanvas, scale, CanvasClass);
    * ```
    *
    * __Explanation of parameters__
    *
    * * _ImageOrVideoOrCanvas_ : an actual Image or Video element or Canvas Object (in this case they are equivalent).
    * * _scale_ : The percent of scaling from the original image, so detection proceeds faster on a smaller image (default __1.0__ ). __NOTE__ scaling might alter the detection results sometimes, if having problems opt towards 1 (slower)
    * * _CanvasClass_ : This is optional and used only when running in node (passing the node-canvas object).
    [/DOC_MARKDOWN]**/
    image: function(image:Image, scale, canvas) {
        var self = Detector;
        if (image != null)
        {
            var ctx, imdata, integralImg, sw, sh;

            var r = self.Ratio = (undef == scale) ? 1.0 : scale;
            self.Ready = false;

            // compute image data now, once per image change
            imdata = image.toColorByteArrayAndData();
            Detector.width = imdata.width;
            Detector.height = imdata.height;
            integralImg = integralImage(imdata.data, imdata.width, imdata.height/*, self.scaledSelection*/);
            self.integral = integralImg.integral;
            self.squares = integralImg.squares;
            self.tilted = integralImg.tilted;
            self.canny = integralCanny(integralImg.gray, imdata.width, imdata.height/*, self.scaledSelection.width, self.scaledSelection.height*/);

            integralImg.gray = null;
            integralImg.integral = null;
            integralImg.squares = null;
            integralImg.tilted = null;
            integralImg = null;
        }
        return self;
    },

    // detector set detection interval
    /**[DOC_MARKDOWN]
    * __interval(detectionInterval)__
    * ```javascript
    * detector.interval(detectionInterval);
    * ```
    *
    * __Explanation of parameters__
    *
    * * _detectionInterval_ : interval to run the detection asynchronously (if not parallel) in  microseconds (default __30__).
    [/DOC_MARKDOWN]**/
    interval: function(it) {
        if (it>0) this.DetectInterval = it;
        return this;
    },

    // customize canny prunning thresholds for best results
    /**[DOC_MARKDOWN]
    * __cannyThreshold({low: lowThreshold, high: highThreshold})__
    * ```javascript
    * detector.cannyThreshold({low: lowThreshold, high: highThreshold});
    * ```
    *
    * Set the thresholds when Canny Pruning is used, for extra fine-tuning.
    * Canny Pruning detects the number/density of edges in a given region. A region with too few or too many edges is unlikely to be a feature.
    * Default values work fine in most cases, however depending on image size and the specific feature, some fine tuning could be needed
    *
    * __Explanation of parameters__
    *
    * * _low_ : (Optional) The low threshold (default __20__ ).
    * * _high_ : (Optional) The high threshold (default __100__ ).
    [/DOC_MARKDOWN]**/
    cannyThreshold: function(thres:{low:Null<Float>, high:Null<Float>}) {
        (thres && undef!=thres.low) && (this.cannyLow = thres.low);
        (thres && undef!=thres.high) && (this.cannyHigh = thres.high);
        return this;
    },

    // set custom detection region as selection
    /**[DOC_MARKDOWN]
    * __select|selection('auto'|object|feature|x [,y, width, height])__
    * ```javascript
    * detector.selection('auto'|object|feature|x [,y, width, height]);
    * ```
    *
    * Allow to set a custom region in the image to confine the detection process only in that region (eg detect nose while face already detected)
    *
    * __Explanation of parameters__
    *
    * * _1st parameter_ : This can be any string, which sets the whole image as the selection, or an object ie: {x:10, y:'auto', width:100, height:'auto'} (every param set as 'auto' will take the default image value) or a detection rectangle/feature, or a x coordinate (along with rest coordinates).
    * * _y_ : (Optional) the selection start y coordinate, can be an actual value or 'auto' (y=0)
    * * _width_ : (Optional) the selection width, can be an actual value or 'auto' (width=image.width)
    * * _height_ : (Optional) the selection height, can be an actual value or 'auto' (height=image.height)
    *
    * The actual selection rectangle/feature is available as this.Selection or detector.Selection
    [/DOC_MARKDOWN]**/
    select: function(x:EitherType<String, EitherType<Int, Feature>>, ?y = 0, ?width, ?height) {
        if (x is String) {
            Detector.Selection = {x:0, y: 0, width: width, height: height}
        } else if (x is Feature) {
            Detector.Selection = x;
        } else {
            Detector.Selection = {x: x, y: y, width: width, height: height}
        }
        return Detector;
    },

    // detector on complete callback
    /**[DOC_MARKDOWN]
    * __complete(callback)__
    * ```javascript
    * detector.complete(callback);
    * ```
    *
    * Set the callback handler when detection completes (for parallel and asynchronous detection)
    *
    * __Explanation of parameters__
    *
    * * _callback_ : The user-defined callback function (will be called within the detectors scope, the value of 'this' will be the detector instance).
    [/DOC_MARKDOWN]**/
    complete: function(callback) {
        this.onComplete = callback || null;
        return this;
    },

    // Detector detect method to start detection
    /**[DOC_MARKDOWN]
    * __detect(baseScale, scale_inc, increment, min_neighbors, epsilon, doCannyPruning)__
    * ```javascript
    * detector.detect(baseScale, scale_inc, increment, min_neighbors, epsilon, doCannyPruning);
    * ```
    *
    * __Explanation of parameters__ ([JViolaJones Parameters](http://code.google.com/p/jviolajones/wiki/Parameters))
    *
    * * *baseScale* : The initial ratio between the window size and the Haar classifier size (default __1__ ).
    * * *scale_inc* : The scale increment of the window size, at each step (default __1.25__ ).
    * * *increment* : The shift of the window at each sub-step, in terms of percentage of the window size (default __0.5__ ).
    * * *min_neighbors* : The minimum numbers of similar rectangles needed for the region to be considered as a feature (avoid noise) (default __1__ )
    * * *epsilon*   : Epsilon value that determines similarity between detected rectangles. `0` means identical (default __0.2__ )
    * * *doCannyPruning* : enable Canny Pruning to pre-detect regions unlikely to contain features, in order to speed up the execution (optional default __false__ ).
    [/DOC_MARKDOWN]**/
    detect: function(baseScale, scale_inc, increment, min_neighbors, epsilon, doCannyPruning) {
        var self = this;
        var haardata = self.haardata,
            sizex = haardata.size1, sizey = haardata.size2,
            selection, scaledSelection,
            width = self.width, height = self.height,
            origWidth = self.origWidth, origHeight = self.origHeight,
            maxScale, scale,
            integral = self.integral, squares = self.squares, tilted = self.tilted, canny = self.canny,
            cannyLow = self.cannyLow, cannyHigh = self.cannyHigh
        ;

        if (!self.Selection) self.Selection = new Feature(0, 0, origWidth, origHeight);
        selection = self.Selection;
        selection.x = ('auto'==selection.x) ? 0 : selection.x;
        selection.y = ('auto'==selection.y) ? 0 : selection.y;
        selection.width = ('auto'==selection.width) ? origWidth : selection.width;
        selection.height = ('auto'==selection.height) ? origHeight : selection.height;
        scaledSelection = self.scaledSelection = selection.clone().scale(self.Ratio).round();

        baseScale = (undef == baseScale) ? 1.0 : baseScale;
        scale_inc = (undef == scale_inc) ? 1.25 : scale_inc;
        increment = (undef == increment) ? 0.5 : increment;
        min_neighbors = (undef == min_neighbors) ? 1 : min_neighbors;
        epsilon = (typeof epsilon == 'undefined') ? 0.2 : epsilon;
        doCannyPruning = (typeof doCannyPruning == 'undefined') ? false : doCannyPruning;

        maxScale = self.maxScale = Min(scaledSelection.width/sizex, scaledSelection.height/sizey);
        scale = self.scale = baseScale;
        self.min_neighbors = min_neighbors;
        self.scale_inc = scale_inc;
        self.increment = increment;
        self.epsilon = epsilon;
        self.doCannyPruning = doCannyPruning;
        self.Ready = false;

        // needs parallel.js library (included)
        var parallel = self.Parallel;
        if (parallel && parallel.isSupported())
        {
            var data=[], sc, i=0;

            for (sc=baseScale; sc<=maxScale; sc*=scale_inc)
            {
                data.push({
                    haardata : haardata,

                    width : width,
                    height : height,
                    scaledSelection : {x:scaledSelection.x, y:scaledSelection.y, width:scaledSelection.width, height:scaledSelection.height},

                    integral : integral,
                    squares : squares,
                    tilted : tilted,

                    doCannyPruning : doCannyPruning,
                    canny : (doCannyPruning) ? canny : null,
                    cannyLow : cannyLow,
                    cannyHigh : cannyHigh,

                    maxScale : maxScale,
                    min_neighbors : min_neighbors,
                    epsilon: epsilon,
                    scale_inc : scale_inc,
                    increment : increment,
                    scale : sc, // current scale to check
                    i : i++ // serial ordering
                });
            }

            // needs parallel.js library (included)
            // parallelize the detection, using map-reduce
            // should also work in Nodejs (using child processes)
            new parallel(data, {synchronous: false})
                .require( byOrder, detectSingleStep, mergeSteps )
                .map( detectSingleStep ).reduce( mergeSteps )
                .then( function(rects){ detectEnd(self, rects, true); } )
            ;
        }
        else
        {
            // else detect asynchronously using fixed intervals
            var rects = [],
                detectAsync = function() {
                    if (self.scale <= self.maxScale)
                    {
                        rects = rects.concat( detectSingleStep(self) );
                        // increase scale
                        self.scale *= self.scale_inc;
                        self.TimeInterval = setTimeout(detectAsync, self.DetectInterval);
                    }
                    else
                    {
                        clearTimeout( self.TimeInterval );
                        detectEnd(self, rects, true);
                    }
                }
            ;

            self.TimeInterval = setTimeout(detectAsync, self.DetectInterval);
        }
        return self;
    },

    /**[DOC_MARKDOWN]
    * __detectSync(baseScale, scale_inc, increment, min_neighbors, doCannyPruning)__
    * ```javascript
    * var features = detector.detectSync(baseScale, scale_inc, increment, min_neighbors, doCannyPruning);
    * ```
    *
    * Run detector synchronously in one step, instead of parallel or asynchronously. Can be useful when immediate results are needed. Due to massive amount of processing the UI thread may be blocked.
    *
    * __Explanation of parameters__ (similar to *detect* method)
    *
    [/DOC_MARKDOWN]**/
    detectSync: function(baseScale, scale_inc, increment, min_neighbors, epsilon, doCannyPruning) {
        var self = this, maxScale,
            sizex = self.haardata.size1, sizey = self.haardata.size2;

        if (!self.Selection) self.Selection = new Feature(0, 0, self.origWidth, self.origHeight);
        self.Selection.x = ('auto'==self.Selection.x) ? 0 : self.Selection.x;
        self.Selection.y = ('auto'==self.Selection.y) ? 0 : self.Selection.y;
        self.Selection.width = ('auto'==self.Selection.width) ? self.origWidth : self.Selection.width;
        self.Selection.height = ('auto'==self.Selection.height) ? self.origHeight : self.Selection.height;
        self.scaledSelection = self.Selection.clone().scale(self.Ratio).round();

        baseScale = (typeof baseScale == 'undefined') ? 1.0 : baseScale;
        scale_inc = (typeof scale_inc == 'undefined') ? 1.25 : scale_inc;
        increment = (typeof increment == 'undefined') ? 0.5 : increment;
        min_neighbors = (typeof min_neighbors == 'undefined') ? 1 : min_neighbors;
        self.epsilon = (typeof epsilon == 'undefined') ? 0.2 : epsilon;
        self.doCannyPruning = (typeof doCannyPruning == 'undefined') ? false : doCannyPruning;

        maxScale = self.maxScale = Min(self.scaledSelection.width/sizex, self.scaledSelection.height/sizey);
        self.scale = baseScale;
        self.min_neighbors = min_neighbors;
        self.scale_inc = scale_inc;
        self.increment = increment;
        self.Ready = false;

        // detect synchronously
        var rects = [];
        // detection loop
        while (self.scale <= maxScale)
        {
            rects = rects.concat( detectSingleStep(self) );
            // increase scale
            self.scale *= scale_inc;
        }

        detectEnd(self, rects, false);

        // return results
        return self.objects;
    }

};
// aliases
Detector[proto].selection = Detector[proto].select;

//
//
//
// Feature/Rectangle Class  (arguably better than generic Object)
Feature = HAAR.Feature = function(x, y, w, h, i) {
    this.data(x, y, w, h, i);
};
Feature.groupRectangles = groupRectangles;
Feature[proto] = {

    constructor: Feature,

    index: 0,
    x: 0,
    y: 0,
    width: 0,
    height: 0,
    area: 0,

    isInside: false,

    data: function(x, y, w, h, i) {
        var self = this;
        if (x && (x instanceof Feature))
        {
            self.copy(x);
        }
        else if (x && (x instanceof Object))
        {
            self.x = x.x || 0;
            self.y = x.y || 0;
            self.width = x.width || 0;
            self.height = x.height || 0;
            self.index = x.index || 0;
            self.area = x.area || 0;
            self.isInside = x.isInside || false;
        }
        else
        {
            self.x = x || 0;
            self.y = y || 0;
            self.width = w || 0;
            self.height = h || 0;
            self.index = i || 0;
            self.area = 0;
            self.isInside = false;
        }

        return self;
    },

    add: function (f) {
        var self = this;
        self.x += f.x;
        self.y += f.y;
        self.width += f.width;
        self.height += f.height;
        return self;
    },

    scale: function(s) {
        var self = this;
        self.x *= s;
        self.y *= s;
        self.width *= s;
        self.height *= s;
        return self;
    },

    round: function() {
        var self = this;
        self.x = ~~(self.x+0.5);
        self.y = ~~(self.y+0.5);
        self.width = ~~(self.width+0.5);
        self.height = ~~(self.height+0.5);
        return self;
    },

    computeArea: function() {
        var self = this;
        self.area = self.width*self.height;
        return self.area;
    },

    inside: function(f, eps) {
        if (null == eps) eps = 0.1;
        if (0 > eps) eps = 0;
        var dx = f.width * eps, dy = f.height * eps;
        return (this.x >= f.x - dx) &&
            (this.y >= f.y - dy) &&
            (this.x + this.width <= f.x + f.width + dx) &&
            (this.y + this.height <= f.y + f.height + dy);
    },

    contains: function(f, eps) {
        return f.inside(this, null == eps ? 0.1 : eps);
    },

    equals: function(f, eps) {
        if (null == eps) eps = 0.2;
        if (0 > eps) eps = 0;
        var delta = eps * (Min(this.width, f.width) + Min(this.height, f.height)) * 0.5;
        return Abs(this.x - f.x) <= delta &&
            Abs(this.y - f.y) <= delta &&
            Abs(this.x + this.width - f.x - f.width) <= delta &&
            Abs(this.y + this.height - f.y - f.height) <= delta;
    },

    clone: function() {
        var self = this, f = new Feature();
        f.x = self.x;
        f.y = self.y;
        f.width = self.width;
        f.height = self.height;
        f.index = self.index;
        f.area = self.area;
        f.isInside = self.isInside;
        return f;
    },

    copy: function(f) {
        var self = this;
        if ( f && (f instanceof Feature) )
        {
            self.x = f.x;
            self.y = f.y;
            self.width = f.width;
            self.height = f.height;
            self.index = f.index;
            self.area = f.area;
            self.isInside = f.isInside;
        }
        return self;
    },

    toString: function() {
        return ['[ x:', this.x, 'y:', this.y, 'width:', this.width, 'height:', this.height, ']'].join(' ');
    }
};