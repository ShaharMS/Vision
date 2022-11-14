/*
	MIT License
	Copyright (c) 2022 Nanjizal ( Justin L Mills )
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
 */

package vision.helpers.pixelTriangle.pixelPlus;

import vision.ds.Image;
import vision.ds.Color;

// Pixeltransform
inline function pixelsTransform(imageTarget:Image, imageSource:Image, transformFunc:(colorTarget:Color, colorSource:Color) -> Color, xTarget:Float,
		yTarget:Float, xSource:Float, ySource:Float, w:Float, h:Float) {
	var p = Std.int(xSource);
	final xx = p;
	var q = Std.int(ySource);
	final dx = Std.int(xTarget) - p;
	final dy = Std.int(yTarget) - q;
	final maxX = Std.int(xSource + w);
	final maxY = Std.int(ySource + h);
	var xPos:Int;
	var yPos:Int;
	while (true) {
		xPos = p + dx;
		yPos = q + dy;
		imageTarget.setPixel(xPos, yPos, transformFunc(imageTarget.getPixel(xPos, yPos), imageSource.getPixel(p, q)));
		p++;
		if (p > maxX) {
			p = xx;
			q++;
		}
		if (q > maxY) break;
	}
}
