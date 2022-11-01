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

package vision.heplers.pixelTriangle.pixelPlus;

import vision.ds.Image;
import vision.ds.Color;
import vision.helpers.pixelTriangle.pixelPlus.ChannelHelp;
import vision.helpers.pixelTriangle.pixelPlus.PixelsTransform;

inline function alphaBlendImage(imageTarget:Image, imageSource:Image, xTarget:Float, yTarget:Float, xSource:Float, ySource:Float, w:Float, h:Float) {
	pixelsTransform(imageTarget, imageSource, alphaBlend, xTarget, yTarget, xSource, ySource, w, h);
}

/**
	provides alpha channel blend which is commumative
**/
inline function alphaBlend(lhs:Color, rhs:Color):Color {
	var a1:Float = channelFloat(lhs.alpha);
	var r1:Float = channelFloat(lhs.red);
	var g1:Float = channelFloat(lhs.green);
	var b1:Float = channelFloat(lhs.blue);
	var a2:Float = channelFloat(rhs.alpha);
	var r2:Float = channelFloat(rhs.red);
	var g2:Float = channelFloat(rhs.green);
	var b2:Float = channelFloat(rhs.blue);
	var a3 = a1 * (1 - a2);
	var r = colBlendFunc(r1, r2, a3, a2);
	var g = colBlendFunc(g1, g2, a3, a2);
	var b = colBlendFunc(b1, b2, a3, a2);
	var a = alphaBlendFunc(a3, a2);
	return Color.fromRGBA(r, g, b, a);
}
