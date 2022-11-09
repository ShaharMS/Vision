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

package vision.helpers.pixelTriangle.shape;

import vision.ds.Image;
import vision.helpers.pixelTriangle.shape.Triangle;

inline function ellipseFill(image:Image, cx:Float, cy:Float, rx:Float, ry:Float, color:Int):Void {
	final radius = (rx > ry) ? rx : ry;
	final sides = circleError(radius);
	final theta = 2 * Math.PI / sides + 0.01;
	var lastX:Float = cx + rx * Math.cos((sides + 1) * theta);
	var lastY:Float = cy + ry * Math.sin((sides + 1) * theta);
	for (i in 0...sides + 1) {
		final nextX = cx + rx * Math.cos(i * theta);
		final nextY = cy + ry * Math.sin(i * theta);
		triangleFill(image, cx, cy, lastX, lastY, nextX, nextY, color);
		lastX = nextX;
		lastY = nextY;
	}
}

inline function ellipseFillRadialGradient(image:Image, cx:Float, cy:Float, rx:Float, ry:Float, colorIn:Int, colorOut:Int):Void {
	final radius = (rx > ry) ? rx : ry;
	final sides = circleError(radius);
	final theta = 2 * Math.PI / sides + 0.01;
	var lastX:Float = cx + rx * Math.cos((sides + 1) * theta);
	var lastY:Float = cy + ry * Math.sin((sides + 1) * theta);
	for (i in 0...sides + 1) {
		final nextX = cx + rx * Math.cos(i * theta);
		final nextY = cy + ry * Math.sin(i * theta);
		triangleGradientFill(image, cx, cy, colorIn, lastX, lastY, colorOut, nextX, nextY, colorOut);
		lastX = nextX;
		lastY = nextY;
	}
}

inline function quadrantGradientFill(image:Image, cx:Float, cy:Float, rx:Float, ry:Float, rotation:Float, colorIn:Int, colorOut:Int):Void {
	final sides = getSidesDivisible4(rx, ry);
	final theta = 2 * Math.PI / sides + 0.01;
	var lastX:Float = cx + rx * Math.cos((sides + 1) * theta + rotation);
	var lastY:Float = cy + ry * Math.sin((sides + 1) * theta + rotation);
	for (i in 0...Std.int(sides / 4) + 1) {
		final nextX = cx + rx * Math.cos(i * theta + rotation);
		final nextY = cy + ry * Math.sin(i * theta + rotation);
		triangleGradientFill(image, cx, cy, colorIn, lastX, lastY, colorOut, nextX, nextY, colorOut);
		lastX = nextX;
		lastY = nextY;
	}
}

// equation from math.stackexchange from TeM

inline function circleError(radius:Float, targetE:Float = 0.5, minN:Int = 12, maxN:Int = 500):Int {
	final result = Math.ceil(Math.PI / (Math.acos(1 - targetE / radius)));
	return if (result < minN) {
		minN;
	} else if (result > maxN) {
		maxN;
	} else {
		result;
	}
}

inline function getSidesDivisible4(rx:Float, ry:Float, targetError:Float = 0.5):Int {
	final rSmall = (rx > ry) ? ry : rx;
	final noSides = circleError(rSmall, targetError);
	return Math.ceil(noSides / 4) * 4;
}
